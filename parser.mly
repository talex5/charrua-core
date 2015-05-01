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

%{
  type statement =
    | Range of Ipaddr.V4.t * Ipaddr.V4.t
    | Dhcp_option of Dhcp.dhcp_option
    | Hw_eth of string
    | Fixed_addr of Ipaddr.V4.t

  let choke s =
    raise (Config.Error s)
%}

%token <Ipaddr.V4.t> IP
%token <string> MACADDR
%token <string> STRING
%token DOMAINNAME
%token DOMAINNAMESERVERS
%token EOF
%token ETHERNET
%token FIXEDADDRESS
%token HARDWARE
%token HOST
%token LBRACKET
%token NETMASK
%token OPTION
%token RANGE
%token RBRACKET
%token ROUTERS
%token SCOLON
%token SUBNET
%token WORD

%start <Config.t> main
%%

main:
| s = statement; ss = statements; sub = subnet; subs = subnets; EOF {
  let statements = s :: ss in
  let subnets = sub :: subs in
  (* Now extract the options from the statements *)
  let options = List.map (function
      | Dhcp_option o -> o
      | _ -> choke "Only dhcp options are allowed in the global section")
      statements
  in
  Config.{ subnets; options }
}

statements:
  | (* empty *) { [] }
  | s = statement; ss = statements { s :: (List.rev ss) }

statement:
  | OPTION; DOMAINNAME; v = STRING; SCOLON { Dhcp_option (Dhcp.Domain_name v)}
  | OPTION; DOMAINNAMESERVERS; v = IP; SCOLON { Dhcp_option (Dhcp.Dns_servers [v]) }
  | OPTION; ROUTERS; v = IP; SCOLON { Dhcp_option (Dhcp.Routers [v]) }
  | RANGE; v1 = IP; v2 = IP; SCOLON { Range (v1, v2) }
  | HARDWARE; ETHERNET; mac = MACADDR; SCOLON { Hw_eth mac }
  | FIXEDADDRESS; v = IP; SCOLON { Fixed_addr v }

subnets:
  | (* empty *) { [] }
  | sub = subnet; subs = subnets { sub :: (List.rev subs) }

subnet:
| SUBNET; ip = IP; NETMASK; mask = IP; LBRACKET; ss = statements; hosts; RBRACKET {
  let statements = ss in
  let network = Ipaddr.V4.Prefix.of_netmask mask ip in
  (* Catch statements that don't make sense in a subnet *)
  let () = List.iter (function
      | Hw_eth _ | Fixed_addr _ ->
        choke "`hardware` and `fixed-address` belong to `host` context, not subnet"
      | _ -> ())
      statements
  in
  (* First find the range statement, XXX ignoring if multiple *)
  let range = try
      List.find (function
          | Range _ -> true
          | _ -> false)
        statements |> (function
          | Range (v1, v2) -> (v1, v2)
          | _ -> choke "Internal error 1, report this with the config file")
    with Not_found ->
      choke ("Missing `range` statement for subnet " ^ (Ipaddr.V4.to_string ip))
  in
  let options = List.filter (function
      | Dhcp_option _ -> true
      | _ -> false)
      statements |> List.map (function
      | Dhcp_option o -> o
      | _ -> choke "Internal error 2, report this with the config file")
  in
  Config.{ network; range; options }
}

hosts:
  | (* empty *) { }
  | host; hosts { }

host:
  | HOST; WORD; LBRACKET; statements; RBRACKET { }
