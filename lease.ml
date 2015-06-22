(*
 * Copyright (c) 2015 Christiano F. Haesbaert <haesbaert@haesbaert.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Sexplib.Conv
open Sexplib.Std

(* Lease (dhcp bindings) operations *)
type lease = {
  tm_start   : float;
  tm_end     : float;
  addr       : Ipaddr.V4.t;
  client_id  : Dhcp.chaddr;
  hostname   : string;
} with sexp

type leases = (Dhcp.chaddr, lease) Hashtbl.t
let empty () = Hashtbl.create 50
let lookup client_id leases =
  try Some (Hashtbl.find leases client_id) with Not_found -> None
let replace client_id lease leases = Hashtbl.replace leases client_id lease
(* Beware! This is an online state *)
let expired lease = lease.tm_end >= lease.tm_start
let to_list leases =
  Hashtbl.fold (fun _ v acc -> v :: acc ) leases []
let to_string x = Sexplib.Sexp.to_string_hum (sexp_of_lease x)

let addr_in_range addr range =
  let (low_ip, high_ip) = range in
  let low_32 = (Ipaddr.V4.to_int32 low_ip) in
  let high_32 = Ipaddr.V4.to_int32 high_ip in
  let addr_32 = Ipaddr.V4.to_int32 addr in
  addr_32 >= low_32 && addr_32 <= high_32

let of_addr addr leases =
  List.filter (fun l -> l.addr = addr) (to_list leases)

let addr_allocated addr leases =
  match (of_addr addr leases) with
  | [] -> false
  | _ -> true

let addr_available addr leases =
  match (of_addr addr leases) with
  | [] -> true
  | leases -> List.exists (fun l -> not (expired l)) leases

(*
 * We try to use the last 4 bytes of the mac address as a hint for the ip
 * address, if that fails, we try a linear search.
 *)
let get_usable_addr id range leases =
  let open Dhcp in
  let (low_ip, high_ip) = range in
  let low_32 = (Ipaddr.V4.to_int32 low_ip) in
  let high_32 = Ipaddr.V4.to_int32 high_ip in
  if (Int32.compare low_32 high_32) >= 0 then
    invalid_arg "invalid range, must be (low * high)";
  let hint_ip =
    let v = match id with
      | Cliid s -> Int32.of_int 1805 (* XXX who cares *)
      | Hwaddr hw ->
        let s = Bytes.sub (Macaddr.to_bytes hw) 2 4 in
        let b0 = Int32.shift_left (Char.code s.[3] |> Int32.of_int) 0 in
        let b1 = Int32.shift_left (Char.code s.[2] |> Int32.of_int) 8 in
        let b2 = Int32.shift_left (Char.code s.[1] |> Int32.of_int) 16 in
        let b3 = Int32.shift_left (Char.code s.[0] |> Int32.of_int) 24 in
        Int32.zero |> Int32.logor b0 |> Int32.logor b1 |>
        Int32.logor b2 |> Int32.logor b3
    in
    Int32.rem v (Int32.sub (Int32.succ high_32) low_32) |>
    Int32.add low_32 |>
    Ipaddr.V4.of_int32
  in
  let rec linear_loop off f =
    let ip = Ipaddr.V4.of_int32 (Int32.add low_32 off) in
    if f ip then
      Some ip
    else if off = high_32 then
      None
    else
      linear_loop (Int32.succ off) f
  in
  if not (addr_allocated hint_ip leases) then
    Some hint_ip
  else match linear_loop Int32.zero (fun a -> not (addr_allocated a leases)) with
    | Some ip -> Some ip
    | None -> linear_loop Int32.zero (fun a -> addr_available a leases)
