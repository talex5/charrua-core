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

let some_or_invalid f v = match f v with
  | Some x -> x
  | None -> invalid_arg ("Invalid value " ^ (string_of_int v))

cstruct dhcp {
  uint8_t      op;
  uint8_t      htype;
  uint8_t      hlen;
  uint8_t      hops;
  uint32_t     xid;
  uint16_t     secs;
  uint16_t     flags;
  uint32_t     ciaddr;
  uint32_t     yiaddr;
  uint32_t     siaddr;
  uint32_t     giaddr;
  uint8_t      chaddr[16];
  uint8_t      sname[64];
  uint8_t      file[128];
} as big_endian

cenum op {
  BOOTREQUEST = 1;
  BOOTREPLY   = 2;
} as uint8_t(sexp)

let int_to_op_exn v = some_or_invalid int_to_op v

cenum msgtype {
  DHCPDISCOVER = 1;
  DHCPOFFER;
  DHCPREQUEST;
  DHCPDECLINE;
  DHCPACK;
  DHCPNAK;
  DHCPRELEASE;
  DHCPINFORM;
  DHCPFORCERENEW;
  DHCPLEASEQUERY;
  DHCPLEASEUNASSIGNED;
  DHCPLEASEUNKNOWN;
  DHCPLEASEACTIVE;
  DHCPBULKLEASEQUERY;
  DHCPLEASEQUERYDONE;
} as uint8_t(sexp)

let int_to_msgtype_exn v = some_or_invalid int_to_msgtype v

cenum option_code {
  PAD = 0;
  SUBNET_MASK = 1;
  TIME_OFFSET = 2;
  ROUTERS = 3;
  TIME_SERVERS = 4;
  NAME_SERVERS = 5;
  DNS_SERVERS = 6;
  LOG_SERVERS = 7;
  COOKIE_SERVERS = 8;
  LPR_SERVERS = 9;
  IMPRESS_SERVERS = 10;
  RSCLOCATION_SERVERS = 11;
  HOSTNAME = 12;
  BOOTFILE_SIZE = 13;
  MERIT_DUMPFILE = 14;
  DOMAIN_NAME = 15;
  SWAP_SERVER = 16;
  ROOT_PATH = 17;
  EXTENSION_PATH = 18;
  IPFORWARDING = 19;
  NLSR = 20;
  POLICY_FILTERS = 21;
  MAX_DATAGRAM = 22;
  DEFAULT_IP_TTL = 23;
  PMTU_AGEING_TIMO = 24;
  PMTU_PLATEAU_TABLE = 25;
  INTERFACE_MTU = 26;
  ALL_SUBNETS_LOCAL = 27;
  BROADCAST_ADDR = 28;
  PERFORM_MASK_DISCOVERY = 29;
  MASK_SUPPLIER = 30;
  PERFORM_ROUTER_DISC = 31;
  ROUTER_SOL_ADDR = 32;
  STATIC_ROUTES = 33;
  TRAILER_ENCAPSULATION = 34;
  ARP_CACHE_TIMO = 35;
  ETHERNET_ENCAPSULATION = 36;
  TCP_DEFAULT_TTL = 37;
  TCP_KEEPALIVE_INTERVAL = 38;
  TCP_KEEPALIVE_GARBAGE = 39;
  NIS_DOMAIN = 40;
  NIS_SERVERS = 41;
  NTP_SERVERS = 42;
  VENDOR_SPECIFIC = 43;
  NETBIOS_NAME_SERVERS = 44;
  NETBIOS_DATAGRAM_DISTRIB_SERVERS = 45;
  NETBIOS_NODE = 46;
  NETBIOS_SCOPE = 47;
  XWINDOW_FONT_SERVERS = 48;
  XWINDOW_DISPLAY_MANAGERS = 49;
  REQUEST_IP = 50;
  IP_LEASE_TIME = 51;
  OPTION_OVERLOAD = 52;
  MESSAGE_TYPE = 53;
  SERVER_IDENTIFIER = 54;
  PARAMETER_REQUESTS = 55;
  MESSAGE = 56;
  MAX_MESSAGE = 57;
  RENEWAL_T1 = 58;
  REBINDING_T2 = 59;
  VENDOR_CLASS_ID = 60;
  CLIENT_ID = 61;
  NETWARE_IP_DOMAIN = 62;
  NETWARE_IP_OPTION = 63;
  NIS_PLUS_DOMAIN = 64;
  NIS_PLUS_SERVERS = 65;
  TFTP_SERVER_NAME = 66;
  BOOTFILE_NAME = 67;
  MOBILE_IP_HOME_AGENT = 68;
  SMTP_SERVERS = 69;
  POP3_SERVERS = 70;
  NNTP_SERVERS = 71;
  WWW_SERVERS = 72;
  FINGER_SERVERS = 73;
  IRC_SERVERS = 74;
  STREETTALK_SERVERS = 75;
  STREETTALK_DA = 76;
  USER_CLASS = 77;
  DIRECTORY_AGENT = 78;
  SERVICE_SCOPE = 79;
  RAPID_COMMIT = 80;
  CLIENT_FQDN = 81;
  RELAY_AGENT_INFORMATION = 82;
  ISNS = 83;
  UNASSIGNED_84 = 84;
  NDS_SERVERS = 85;
  NDS_TREE_NAME = 86;
  NDS_CONTEXT = 87;
  BCMCS_CONTROLLER_DOMAIN_NAME_LIST = 88;
  BCMCS_CONTROLLER_IPV4_ADDR = 89;
  AUTHENTICATION = 90;
  CLIENT_LAST_TRANSACTION_TIME = 91;
  ASSOCIATED_IP = 92;
  CLIENT_SYSTEM = 93;
  CLIENT_NDI = 94;
  LDAP = 95;
  UNASSIGNED_96 = 96;
  UUID_GUID = 97;
  USER_AUTH = 98;
  GEOCONF_CIVIC = 99;
  PCODE = 100;
  TCODE = 101;
  UNASSIGNED_102 = 102;
  UNASSIGNED_103 = 103;
  UNASSIGNED_104 = 104;
  UNASSIGNED_105 = 105;
  UNASSIGNED_106 = 106;
  UNASSIGNED_107 = 107;
  UNASSIGNED_108 = 108;
  UNASSIGNED_109 = 109;
  UNASSIGNED_110 = 110;
  UNASSIGNED_111 = 111;
  NETINFO_ADDRESS = 112;
  NETINFO_TAG = 113;
  URL = 114;
  UNASSIGNED_115 = 115;
  AUTO_CONFIG = 116;
  NAME_SERVICE_SEARCH = 117;
  SUBNET_SELECTION = 118;
  DOMAIN_SEARCH = 119;
  SIP_SERVERS = 120;
  CLASSLESS_STATIC_ROUTE = 121;
  CCC = 122;
  GEOCONF = 123;
  VI_VENDOR_CLASS = 124;
  VI_VENDOR_INFO = 125;
  UNASSIGNED_126 = 126;
  UNASSIGNED_127 = 127;
  PXE_128 = 128;
  PXE_129 = 129;
  PXE_130 = 130;
  PXE_131 = 131;
  PXE_132 = 132;
  PXE_133 = 133;
  PXE_134 = 134;
  PXE_135 = 135;
  PANA_AGENT = 136;
  V4_LOST = 137;
  CAPWAP_AC_V4 = 138;
  IPV4_ADDRESS_MOS = 139;
  IPV4_FQDN_MOS = 140;
  SIP_UA_DOMAINS = 141;
  IPV4_ADDRESS_ANDSF = 142;
  UNASSIGNED_143 = 143;
  GEOLOCK = 144;
  FORCENEW_NONCE_CAPABLE = 145;
  RDNSS_SELECTION = 146;
  UNASSIGNED_147 = 147;
  UNASSIGNED_148 = 148;
  UNASSIGNED_149 = 149;
  MISC_150 = 150;
  STATUS_CODE = 151;
  ABSOLUTE_TIME = 152;
  START_TIME_OF_STATE = 153;
  QUERY_START_TIME = 154;
  QUERY_END_TIME = 155;
  DHCP_STATE = 156;
  DATA_SOURCE = 157;
  V4_PCP_SERVER = 158;
  V4_PORTPARAMS = 159;
  DHCP_CAPTIVE_PORTAL = 160;
  UNASSIGNED_161 = 161;
  UNASSIGNED_162 = 162;
  UNASSIGNED_163 = 163;
  UNASSIGNED_164 = 164;
  UNASSIGNED_165 = 165;
  UNASSIGNED_166 = 166;
  UNASSIGNED_167 = 167;
  UNASSIGNED_168 = 168;
  UNASSIGNED_169 = 169;
  UNASSIGNED_170 = 170;
  UNASSIGNED_171 = 171;
  UNASSIGNED_172 = 172;
  UNASSIGNED_173 = 173;
  UNASSIGNED_174 = 174;
  ETHERBOOT_175 = 175;
  IP_TELEFONE = 176;
  ETHERBOOT_177 = 177;
  UNASSIGNED_178 = 178;
  UNASSIGNED_179 = 179;
  UNASSIGNED_180 = 180;
  UNASSIGNED_181 = 181;
  UNASSIGNED_182 = 182;
  UNASSIGNED_183 = 183;
  UNASSIGNED_184 = 184;
  UNASSIGNED_185 = 185;
  UNASSIGNED_186 = 186;
  UNASSIGNED_187 = 187;
  UNASSIGNED_188 = 188;
  UNASSIGNED_189 = 189;
  UNASSIGNED_190 = 190;
  UNASSIGNED_191 = 191;
  UNASSIGNED_192 = 192;
  UNASSIGNED_193 = 193;
  UNASSIGNED_194 = 194;
  UNASSIGNED_195 = 195;
  UNASSIGNED_196 = 196;
  UNASSIGNED_197 = 197;
  UNASSIGNED_198 = 198;
  UNASSIGNED_199 = 199;
  UNASSIGNED_200 = 200;
  UNASSIGNED_201 = 201;
  UNASSIGNED_202 = 202;
  UNASSIGNED_203 = 203;
  UNASSIGNED_204 = 204;
  UNASSIGNED_205 = 205;
  UNASSIGNED_206 = 206;
  UNASSIGNED_207 = 207;
  PXE_LINUX = 208;
  CONFIGURATION_FILE = 209;
  PATH_PREFIX = 210;
  REBOOT_TIME = 211;
  OPTION_6RD = 212;
  V4_ACCESS_DOMAIN = 213;
  UNASSIGNED_214 = 214;
  UNASSIGNED_215 = 215;
  UNASSIGNED_216 = 216;
  UNASSIGNED_217 = 217;
  UNASSIGNED_218 = 218;
  UNASSIGNED_219 = 219;
  SUBNET_ALLOCATION = 220;
  VIRTUAL_SUBNET_SELECTION = 221;
  UNASSIGNED_222 = 222;
  UNASSIGNED_223 = 223;
  RESERVED_224 = 224;
  RESERVED_225 = 225;
  RESERVED_226 = 226;
  RESERVED_227 = 227;
  RESERVED_228 = 228;
  RESERVED_229 = 229;
  RESERVED_230 = 230;
  RESERVED_231 = 231;
  RESERVED_232 = 232;
  RESERVED_233 = 233;
  RESERVED_234 = 234;
  RESERVED_235 = 235;
  RESERVED_236 = 236;
  RESERVED_237 = 237;
  RESERVED_238 = 238;
  RESERVED_239 = 239;
  RESERVED_240 = 240;
  RESERVED_241 = 241;
  RESERVED_242 = 242;
  RESERVED_243 = 243;
  RESERVED_244 = 244;
  RESERVED_245 = 245;
  RESERVED_246 = 246;
  RESERVED_247 = 247;
  RESERVED_248 = 248;
  RESERVED_249 = 249;
  RESERVED_250 = 250;
  RESERVED_251 = 251;
  WEB_PROXY_AUTO_DISC = 252;
  RESERVED_253 = 253;
  RESERVED_254 = 254;
  END = 255;
} as uint8_t(sexp)

let int_to_option_code_exn v = some_or_invalid int_to_option_code v

type htype =
  | Ethernet_10mb
  | Other with sexp

type flags =
  | Broadcast
  | Unicast with sexp

type client_id =
  | Hwaddr of Macaddr.t
  | Id of string with sexp

type dhcp_option =
  | Subnet_mask of Ipaddr.V4.t              (* code 1 *)
  | Time_offset of int32                    (* code 2 *)
  | Routers of Ipaddr.V4.t list             (* code 3 *)
  | Time_servers of Ipaddr.V4.t list        (* code 4 *)
  | Name_servers of Ipaddr.V4.t list        (* code 5 *)
  | Dns_servers of Ipaddr.V4.t list         (* code 6 *)
  | Log_servers of Ipaddr.V4.t list         (* code 7 *)
  | Cookie_servers of Ipaddr.V4.t list      (* code 8 *)
  | Lpr_servers of Ipaddr.V4.t list         (* code 9 *)
  | Impress_servers of Ipaddr.V4.t list     (* code 10 *)
  | Rsclocation_servers of Ipaddr.V4.t list (* code 11 *)
  | Hostname of string                      (* code 12 *)
  | Bootfile_size of int                    (* code 13 *)
  | Merit_dumpfile of string                (* code 14 *)
  | Domain_name of string                   (* code 15 *)
  | Swap_server of Ipaddr.V4.t              (* code 16 *)
  | Root_path of string                     (* code 17 *)
  | Extension_path of string                (* code 18 *)
  | Ipforwarding of bool                    (* code 19 *)
  | Nlsr of bool                            (* code 20 *)
  | Policy_filters of Ipaddr.V4.Prefix.t list (* code 21 *)
  | Max_datagram of int                     (* code 22 *)
  | Default_ip_ttl of int                   (* code 23 *)
  | Pmtu_ageing_timo of int32               (* code 24 *)
  | Pmtu_plateau_table of int list          (* code 25 *)
  | Interface_mtu of int                    (* code 26 *)
  | All_subnets_local of bool               (* code 27 *)
  | Broadcast_addr of Ipaddr.V4.t           (* code 28 *)
  | Perform_mask_discovery of bool          (* code 29 *)
  | Mask_supplier of bool                   (* code 30 *)
  | Perform_router_disc of bool             (* code 31 *)
  | Router_sol_addr of Ipaddr.V4.t          (* code 32 *)
  | Static_routes of (Ipaddr.V4.t * Ipaddr.V4.t) list (* code 33 *)
  | Trailer_encapsulation of bool           (* code 34 *)
  | Arp_cache_timo of int32                 (* code 35 *)
  | Ethernet_encapsulation of bool          (* code 36 *)
  | Tcp_default_ttl of int                  (* code 37 *)
  | Tcp_keepalive_interval of int32         (* code 38 *)
  | Tcp_keepalive_garbage of int            (* code 39 *)
  | Nis_domain of string                    (* code 40 *)
  | Nis_servers of Ipaddr.V4.t list         (* code 41 *)
  | Ntp_servers of Ipaddr.V4.t list         (* code 42 *)
  | Vendor_specific of string               (* code 43 *)
  | Netbios_name_servers of Ipaddr.V4.t list(* code 44 *)
  | Netbios_datagram_distrib_servers of Ipaddr.V4.t list (* code 45 *)
  | Netbios_node of int                     (* code 46 *)
  | Netbios_scope of string                 (* code 47 *)
  | Xwindow_font_servers of Ipaddr.V4.t list(* code 48 *)
  | Xwindow_display_managers of Ipaddr.V4.t list (* code 49 *)
  | Request_ip of Ipaddr.V4.t               (* code 50 *)
  | Ip_lease_time of int32                  (* code 51 *)
  | Option_overload of int                  (* code 52 *)
  | Message_type of msgtype                 (* code 53 *)
  | Server_identifier of Ipaddr.V4.t        (* code 54 *)
  | Parameter_requests of option_code list  (* code 55 *)
  | Message of string                       (* code 56 *)
  | Max_message of int                      (* code 57 *)
  | Renewal_t1 of int32                     (* code 58 *)
  | Rebinding_t2 of int32                   (* code 59 *)
  | Vendor_class_id of string               (* code 60 *)
  | Client_id of client_id                  (* code 61 *)
  | Nis_plus_domain of string               (* code 64 *)
  | Nis_plus_servers of Ipaddr.V4.t list    (* code 65 *)
  | Tftp_server_name of string              (* code 66 *)
  | Bootfile_name of string                 (* code 67 *)
  | Mobile_ip_home_agent of Ipaddr.V4.t list(* code 68 *)
  | Smtp_servers of Ipaddr.V4.t list        (* code 69 *)
  | Pop3_servers of Ipaddr.V4.t list        (* code 70 *)
  | Nntp_servers of Ipaddr.V4.t list        (* code 71 *)
  | Www_servers of Ipaddr.V4.t list         (* code 72 *)
  | Finger_servers of Ipaddr.V4.t list      (* code 73 *)
  | Irc_servers of Ipaddr.V4.t list         (* code 74 *)
  | Streettalk_servers of Ipaddr.V4.t list  (* code 75 *)
  | Streettalk_da of Ipaddr.V4.t list       (* code 76 *)
  | Domain_search of string                 (* code 119 *)
  | Web_proxy_auto_disc of string           (* code 252 *)
  | Unknown
  with sexp

type pkt = {
  srcmac  : Macaddr.t;
  dstmac  : Macaddr.t;
  srcip   : Ipaddr.V4.t;
  dstip   : Ipaddr.V4.t;
  srcport : int;
  dstport : int;
  op      : op;
  htype   : htype;
  hlen    : int;
  hops    : int;
  xid     : int32;
  secs    : int;
  flags   : flags;
  ciaddr  : Ipaddr.V4.t;
  yiaddr  : Ipaddr.V4.t;
  siaddr  : Ipaddr.V4.t;
  giaddr  : Ipaddr.V4.t;
  chaddr  : Macaddr.t;
  sname   : string;
  file    : string;
  options : dhcp_option list;
} with sexp

let client_port = 68
let server_port = 67

let options_of_buf buf buf_len =
  let rec collect_options buf options =
    let code = Cstruct.get_uint8 buf 0 in
    let padding () = collect_options (Cstruct.shift buf 1) options in
    (* Make sure we never shift into an unexisting body *)
    match code with
    | 0 -> padding ()
    | 255 -> options
    | _ -> (* Has len:body, generate the get functions *)
      let len = Cstruct.get_uint8 buf 1 in
      let body = Cstruct.shift buf 2 in
      let bad_len = Printf.sprintf "Malformed len %d in option %d" len code in
      (* discard discards the option from the resulting list *)
      let discard () = collect_options (Cstruct.shift body len) options in
      (* take includes the option in the resulting list *)
      let take op = collect_options (Cstruct.shift body len) (op :: options) in
      let get_8 () = if len <> 1 then invalid_arg bad_len else
          Cstruct.get_uint8 body 0 in
      let get_8_list () =
        let rec loop offset octets =
          if offset = len then octets else
            let octet = Cstruct.get_uint8 body offset in
            loop (succ offset) (octet :: octets)
        in
        if len <= 0 then invalid_arg bad_len else
          List.rev (loop 0 [])
      in
      let get_bool () = match (get_8 ()) with
        | 1 -> true
        | 0 -> false
        | v -> invalid_arg ("invalid value for bool: " ^ string_of_int v)
      in
      let get_16 () = if len <> 2 then invalid_arg bad_len else
          Cstruct.BE.get_uint16 body 0 in
      let get_16_list () =
        let rec loop offset shorts =
          if offset = len then shorts else
            let short = Cstruct.BE.get_uint16 body offset in
            loop ((succ offset) * 2) (short :: shorts)
        in
        if ((len mod 2) <> 0) || len <= 0 then invalid_arg bad_len else
          List.rev (loop 0 [])
      in
      let get_32 () = if len <> 4 then invalid_arg bad_len else
          Cstruct.BE.get_uint32 body 0 in
      let get_32_list ?(min_len=4) () =
        let rec loop offset longs =
          if offset = len then longs else
            let long = Cstruct.BE.get_uint32 body offset in
            loop ((succ offset) * 4) (long :: longs)
        in
        if ((len mod 4) <> 0) || len < min_len then invalid_arg bad_len else
          List.rev (loop 0 [])
      in
      (* Fetch ipv4s from options *)
      let get_ip () = if len <> 4 then invalid_arg bad_len else
          Ipaddr.V4.of_int32 (get_32 ()) in
      let get_ip_list ?(min_len=4) () =
        List.map Ipaddr.V4.of_int32 (get_32_list ~min_len:min_len ())
      in
      let get_ip_tuple_list () =
        let loop ips tuples = match ips with
          | ip1 :: ip2 :: tl -> (ip1, ip2) :: tuples
          | ip :: [] -> invalid_arg bad_len
          | [] -> List.rev tuples
        in
        loop (get_ip_list ~min_len:8 ()) []
      in
      (* Get a list of ip pairs *)
      let get_prefix_list () =
        if ((len mod 8) <> 0) || len <= 0 then
          invalid_arg bad_len
        else
          List.map (function
              | addr, mask -> try
                  Ipaddr.V4.Prefix.of_netmask mask addr
                with
                  Ipaddr.Parse_error (a, b) -> invalid_arg (a ^ ": " ^ b))
            (get_ip_tuple_list ())
      in
      let get_string () =  if len < 1 then invalid_arg bad_len else
          Cstruct.copy body 0 len
      in
      let get_client_id () =  if len < 2 then invalid_arg bad_len else
          let s = Cstruct.copy body 1 (len - 1) in
          if (Cstruct.get_uint8 body 0) = 1 && len = 7 then
            Hwaddr (Macaddr.of_bytes_exn s)
          else
            Id s
      in
      match code with
      | 0 ->   padding ()
      | 1 ->   take (Subnet_mask (get_ip ()))
      | 2 ->   take (Time_offset (get_32 ()))
      | 3 ->   take (Routers (get_ip_list ()))
      | 4 ->   take (Time_servers (get_ip_list ()))
      | 5 ->   take (Name_servers (get_ip_list ()))
      | 6 ->   take (Dns_servers (get_ip_list ()))
      | 7 ->   take (Log_servers (get_ip_list ()))
      | 8 ->   take (Cookie_servers (get_ip_list ()))
      | 9 ->   take (Lpr_servers (get_ip_list ()))
      | 10 ->  take (Impress_servers (get_ip_list ()))
      | 11 ->  take (Rsclocation_servers (get_ip_list ()))
      | 12 ->  take (Hostname (get_string ()))
      | 13 ->  take (Bootfile_size (get_16 ()))
      | 14 ->  take (Merit_dumpfile (get_string ()))
      | 15 ->  take (Domain_name (get_string ()))
      | 16 ->  take (Swap_server (get_ip ()))
      | 17 ->  take (Root_path (get_string ()))
      | 18 ->  take (Extension_path (get_string ()))
      | 19 ->  take (Ipforwarding (get_bool ()))
      | 20 ->  take (Nlsr (get_bool ()))
      | 21 ->  take (Policy_filters (get_prefix_list ()))
      | 22 ->  take (Max_datagram (get_16 ()))
      | 23 ->  take (Default_ip_ttl (get_8 ()))
      | 24 ->  take (Pmtu_ageing_timo (get_32 ()))
      | 25 ->  take (Pmtu_plateau_table (get_16_list ()))
      | 26 ->  take (Interface_mtu (get_16 ()))
      | 27 ->  take (All_subnets_local (get_bool ()))
      | 28 ->  take (Broadcast_addr (get_ip ()))
      | 29 ->  take (Perform_mask_discovery (get_bool ()))
      | 30 ->  take (Mask_supplier (get_bool ()))
      | 31 ->  take (Perform_router_disc (get_bool ()))
      | 32 ->  take (Router_sol_addr (get_ip ()))
      | 33 ->  take (Static_routes (get_ip_tuple_list ()))
      | 34 ->  take (Trailer_encapsulation (get_bool ()))
      | 35 ->  take (Arp_cache_timo (get_32 ()))
      | 36 ->  take (Ethernet_encapsulation (get_bool ()))
      | 37 ->  take (Tcp_default_ttl (get_8 ()))
      | 38 ->  take (Tcp_keepalive_interval (get_32 ()))
      | 39 ->  take (Tcp_keepalive_garbage (get_8 ()))
      | 40 ->  take (Nis_domain (get_string ()))
      | 41 ->  take (Nis_servers (get_ip_list ()))
      | 42 ->  take (Ntp_servers (get_ip_list ()))
      | 43 ->  take (Vendor_specific (get_string ()))
      | 44 ->  take (Netbios_name_servers (get_ip_list ()))
      | 45 ->  take (Netbios_datagram_distrib_servers (get_ip_list ()))
      | 46 ->  take (Netbios_node (get_8 ()))
      | 47 ->  take (Netbios_scope (get_string ()))
      | 48 ->  take (Xwindow_font_servers (get_ip_list ()))
      | 49 ->  take (Xwindow_display_managers (get_ip_list ()))
      | 50 ->  take (Request_ip (get_ip ()))
      | 51 ->  take (Ip_lease_time (get_32 ()))
      | 52 ->  take (Option_overload (get_8 ()))
      | 53 ->  take (Message_type (int_to_msgtype_exn (get_8 ())))
      | 54 ->  take (Server_identifier (get_ip ()))
      | 55 ->  take (Parameter_requests
                       (get_8_list () |>
                        List.map int_to_option_code_exn))
      | 56 ->  take (Message (get_string ()))
      | 57 ->  take (Max_message (get_16 ()))
      | 58 ->  take (Renewal_t1 (get_32 ()))
      | 59 ->  take (Rebinding_t2 (get_32 ()))
      | 60 ->  take (Vendor_class_id (get_string ()))
      | 61 ->  take (Client_id (get_client_id ()))
      | 64 ->  take (Nis_plus_domain (get_string ()))
      | 65 ->  take (Nis_plus_servers (get_ip_list ()))
      | 66 ->  take (Tftp_server_name (get_string ()))
      | 67 ->  take (Bootfile_name (get_string ()))
      | 68 ->  take (Mobile_ip_home_agent (get_ip_list ~min_len:0 ()))
      | 69 ->  take (Smtp_servers (get_ip_list ()))
      | 70 ->  take (Pop3_servers (get_ip_list ()))
      | 71 ->  take (Nntp_servers (get_ip_list ()))
      | 72 ->  take (Www_servers (get_ip_list ()))
      | 73 ->  take (Finger_servers (get_ip_list ()))
      | 74 ->  take (Irc_servers (get_ip_list ()))
      | 75 ->  take (Streettalk_servers (get_ip_list ()))
      | 76 ->  take (Streettalk_da (get_ip_list ()))
      | 119->  take (Domain_search (get_string ()))
      | 252->  take (Web_proxy_auto_disc (get_string ()))
      | code ->
        Dhcp_logger.warn "Unknown option code %d" code;
        discard ()
  in
  (* Extends options if it finds an Option_overload *)
  let extend_options buf options =
    let rec search = function
      | [] -> None
      | opt :: tl -> match opt with
        | Option_overload v -> Some v
        | _ -> search tl
    in
    match search options with
    | None -> options           (* Nothing to do, identity function *)
    | Some v -> match v with
      | 1 -> collect_options (get_dhcp_file buf) options    (* It's in file *)
      | 2 -> collect_options (get_dhcp_sname buf) options   (* It's in sname *)
      | 3 -> collect_options (get_dhcp_file buf) options |> (* OMG both *)
             collect_options (get_dhcp_sname buf)
      | _ -> invalid_arg ("Invalid overload code: " ^ string_of_int v)
  in
  (* Handle a pkt with no options *)
  if buf_len = sizeof_dhcp then
    []
  else
    (* Look for magic cookie *)
    let cookie = Cstruct.BE.get_uint32 buf sizeof_dhcp in
    if cookie <> 0x63825363l then
      invalid_arg "Invalid cookie";
    let options_start = Cstruct.shift buf (sizeof_dhcp + 4) in
    (* Jump over cookie and start options, also extend them if necessary *)
    collect_options options_start [] |>
    extend_options buf |>
    List.rev

let buf_of_options sbuf options =
  let open Cstruct in
  let put_code code buf = set_uint8 buf 0 code; shift buf 1 in
  let put_len len buf = if len > 255 then
      invalid_arg ("option len is too big: " ^ (string_of_int len));
    set_uint8 buf 0 len; shift buf 1
  in
  let put_8 v buf = set_uint8 buf 0 v; shift buf 1 in
  let put_16 v buf = BE.set_uint16 buf 0 v; shift buf 2 in
  let put_32 v buf = BE.set_uint32 buf 0 v; shift buf 4 in
  let put_ip ip buf = put_32 (Ipaddr.V4.to_int32 ip) buf in
  let put_prefix prefix buf =
    put_ip (Ipaddr.V4.Prefix.network prefix) buf |>
    put_ip (Ipaddr.V4.Prefix.netmask prefix)
  in
  let put_ip_tuple tuple buf = match tuple with
    a, b -> put_ip a buf |> put_ip b
  in
  let put_coded_8 code v buf = put_code code buf |> put_len 1 |> put_8 v in
  let put_coded_16 code v buf = put_code code buf |> put_len 2 |> put_16 v in
  let put_coded_32 code v buf = put_code code buf |> put_len 4 |> put_32 v in
  let put_coded_ip code ip buf = put_code code buf |> put_len 4 |> put_ip ip in
  (* let put_coded_prefix code prefix buf = *)
  (*   put_code code buf |> put_len 8 |> put_prefix prefix in *)
  let put_coded_bool code v buf =
    put_coded_8 code (match v with true -> 1 | false -> 0) buf in
  let put_coded_bytes code v buf =
    let len = (Bytes.length v) in
    let buf = put_code code buf |> put_len len in
    blit_from_string v 0 buf 0 len;
    shift buf len
  in
  let put_client_id code v buf =
    let htype, s = match v with
      | Hwaddr mac -> (1, Macaddr.to_bytes mac)
      | Id id -> (0, id)
    in
    let len = String.length s in
    let buf = put_code code buf |> put_len (succ len) |> put_8 htype in
    blit_from_string s 0 buf 0 len;
    shift buf len
  in
  let make_listf f len code l buf =
    let buf = put_code code buf |> put_len (len * (List.length l)) in
    List.fold_left f buf l
  in
  let put_coded_8_list = make_listf (fun buf x -> put_8 x buf) 1 in
  let put_coded_16_list = make_listf (fun buf x -> put_16 x buf) 2 in
  (* let put_coded_32_list = make_listf (fun buf x -> put_32 x buf) 4 in *)
  let put_coded_ip_list = make_listf (fun buf x -> put_ip x buf) 4 in
  let put_coded_prefix_list = make_listf (fun buf x -> put_prefix x buf) 8 in
  let put_coded_ip_tuple_list = make_listf (fun buf x -> put_ip_tuple x buf) 8 in
  let buf_of_option buf option =
    match option with
    | Subnet_mask mask -> put_coded_ip 1 mask buf             (* code 1 *)
    | Time_offset toff -> put_coded_32 2 toff buf             (* code 2 *)
    | Routers ips -> put_coded_ip_list 3 ips buf              (* code 3 *)
    | Time_servers ips -> put_coded_ip_list 4 ips buf         (* code 4 *)
    | Name_servers ips -> put_coded_ip_list 5 ips buf         (* code 5 *)
    | Dns_servers ips -> put_coded_ip_list 6 ips buf          (* code 6 *)
    | Log_servers ips -> put_coded_ip_list 7 ips buf          (* code 7 *)
    | Cookie_servers ips -> put_coded_ip_list 8 ips buf       (* code 8 *)
    | Lpr_servers ips -> put_coded_ip_list 9 ips buf          (* code 9 *)
    | Impress_servers ips -> put_coded_ip_list 10 ips buf     (* code 10 *)
    | Rsclocation_servers ips -> put_coded_ip_list 11 ips buf (* code 11 *)
    | Hostname h -> put_coded_bytes 12 h buf                  (* code 12 *)
    | Bootfile_size bs -> put_coded_16 13 bs buf              (* code 13 *)
    | Merit_dumpfile md -> put_coded_bytes 14 md buf          (* code 14 *)
    | Domain_name dn -> put_coded_bytes 15 dn buf             (* code 15 *)
    | Swap_server ss -> put_coded_ip 16 ss buf                (* code 16 *)
    | Root_path rp -> put_coded_bytes 17 rp buf               (* code 17 *)
    | Extension_path ep -> put_coded_bytes 18 ep buf          (* code 18 *)
    | Ipforwarding b -> put_coded_bool 19 b buf               (* code 19 *)
    | Nlsr b -> put_coded_bool 20 b buf                       (* code 20 *)
    | Policy_filters pf -> put_coded_prefix_list 21 pf buf    (* code 21 *)
    | Max_datagram md -> put_coded_16 22 md buf               (* code 22 *)
    | Default_ip_ttl dit -> put_coded_8 23 dit buf            (* code 23 *)
    | Pmtu_ageing_timo pat -> put_coded_32 24 pat buf         (* code 24 *)
    | Pmtu_plateau_table ppt -> put_coded_16_list 25 ppt buf  (* code 25 *)
    | Interface_mtu im -> put_coded_16 26 im buf              (* code 26 *)
    | All_subnets_local b -> put_coded_bool 27 b buf          (* code 27 *)
    | Broadcast_addr ba -> put_coded_ip 28 ba buf             (* code 28 *)
    | Perform_mask_discovery b -> put_coded_bool 29 b buf     (* code 29 *)
    | Mask_supplier b -> put_coded_bool 30 b buf              (* code 30 *)
    | Perform_router_disc b -> put_coded_bool 31 b buf        (* code 31 *)
    | Router_sol_addr rsa -> put_coded_ip 32 rsa buf          (* code 32 *)
    | Static_routes srs -> put_coded_ip_tuple_list 33 srs buf (* code 33 *)
    | Trailer_encapsulation b -> put_coded_bool 34 b buf      (* code 34 *)
    | Arp_cache_timo act -> put_coded_32 35 act buf           (* code 35 *)
    | Ethernet_encapsulation b -> put_coded_bool 36 b buf     (* code 36 *)
    | Tcp_default_ttl tdt -> put_coded_8 37 tdt buf           (* code 37 *)
    | Tcp_keepalive_interval tki -> put_coded_32 38 tki buf   (* code 38 *)
    | Tcp_keepalive_garbage tkg -> put_coded_8 39 tkg buf     (* code 39 *)
    | Nis_domain nd -> put_coded_bytes 40 nd buf              (* code 40 *)
    | Nis_servers ips -> put_coded_ip_list 41 ips buf         (* code 41 *)
    | Ntp_servers ips -> put_coded_ip_list 42 ips buf         (* code 42 *)
    | Vendor_specific vs -> put_coded_bytes 43 vs buf         (* code 43 *)
    | Netbios_name_servers ips -> put_coded_ip_list 44 ips buf(* code 44 *)
    | Netbios_datagram_distrib_servers ips -> put_coded_ip_list 45 ips buf (* code 45 *)
    | Netbios_node nn -> put_coded_8 46 nn buf                (* code 46 *)
    | Netbios_scope ns -> put_coded_bytes 47 ns buf           (* code 47 *)
    | Xwindow_font_servers ips -> put_coded_ip_list 48 ips buf(* code 48 *)
    | Xwindow_display_managers ips -> put_coded_ip_list 49 ips buf (* code 49 *)
    | Request_ip rip -> put_coded_ip 50 rip buf               (* code 50 *)
    | Ip_lease_time ilt -> put_coded_32 51 ilt buf            (* code 51 *)
    | Option_overload oo -> put_coded_8 52 oo buf             (* code 52 *)
    | Message_type mt -> put_coded_8 53 (msgtype_to_int mt) buf (* code 53 *)
    | Server_identifier si -> put_coded_ip 54 si buf          (* code 54 *)
    | Parameter_requests pr ->
      put_coded_8_list 55
        (List.map option_code_to_int pr) buf  (* code 55 *)
    | Message m -> put_coded_bytes 56 m buf                   (* code 56 *)
    | Max_message mm -> put_coded_16 57 mm buf                (* code 57 *)
    | Renewal_t1 rt -> put_coded_32 58 rt buf                 (* code 58 *)
    | Rebinding_t2 rt -> put_coded_32 59 rt buf               (* code 59 *)
    | Vendor_class_id vci -> put_coded_bytes 60 vci buf       (* code 60 *)
    | Client_id id -> put_client_id 61 id buf                 (* code 61 *)
    | Nis_plus_domain npd -> put_coded_bytes 64 npd buf       (* code 64 *)
    | Nis_plus_servers ips -> put_coded_ip_list 65 ips buf    (* code 65 *)
    | Tftp_server_name tsn -> put_coded_bytes 66 tsn buf      (* code 66 *)
    | Bootfile_name bn -> put_coded_bytes 67 bn buf           (* code 67 *)
    | Mobile_ip_home_agent ips -> put_coded_ip_list 68 ips buf(* code 68 *)
    | Smtp_servers ips -> put_coded_ip_list 69 ips buf        (* code 69 *)
    | Pop3_servers ips -> put_coded_ip_list 70 ips buf        (* code 70 *)
    | Nntp_servers ips -> put_coded_ip_list 71 ips buf        (* code 71 *)
    | Www_servers ips -> put_coded_ip_list 72 ips buf         (* code 72 *)
    | Finger_servers ips -> put_coded_ip_list 73 ips buf      (* code 73 *)
    | Irc_servers ips -> put_coded_ip_list 74 ips buf         (* code 74 *)
    | Streettalk_servers ips -> put_coded_ip_list 75 ips buf  (* code 75 *)
    | Streettalk_da ips -> put_coded_ip_list 76 ips buf       (* code 76 *)
    | Domain_search dsf -> put_coded_bytes 119 dsf buf        (* code 119 *)
    | Web_proxy_auto_disc wpad -> put_coded_bytes 252 wpad buf(* code 252 *)
    | Unknown -> buf
  in
  match options with
  | [] -> sbuf
  | _ ->
    let () = BE.set_uint32 sbuf 0 0x63825363l in       (* put cookie *)
    let sbuf = shift sbuf 4 in
    let ebuf = List.fold_left buf_of_option sbuf options in
    set_uint8 ebuf 0 255; shift ebuf 1

let pkt_of_buf buf len =
  let wrap () =
    let open Wire_structs in
    let open Ipv4_wire in
    let open Printf in
    let min_len = sizeof_dhcp + sizeof_ethernet + sizeof_ipv4 + sizeof_udp in
    if len < min_len then
      invalid_arg (sprintf "packet is too small: %d < %d" len min_len);
    (* Handle ethernet *)
    let srcmac = Macaddr.of_bytes_exn (copy_ethernet_src buf) in
    let dstmac = Macaddr.of_bytes_exn (copy_ethernet_dst buf) in
    let () = if (get_ethernet_ethertype buf) <> 0x0800 then
        invalid_arg (sprintf "packet is not ipv4: %d" (get_ethernet_ethertype buf));
    in
    let buf = Cstruct.shift buf sizeof_ethernet in
    (* Handle IPv4 *)
    let ihl = (get_ipv4_hlen_version buf land 0xf) * 4 in
    let ipcsum = get_ipv4_csum buf in
    let csum = Tcpip_checksum.ones_complement (Cstruct.sub buf 0 ihl) in
    (* Some broken clients don't do ip checksum, accept if they send as zero *)
    let () = if ipcsum <> 0 && csum <> 0 then
        invalid_arg (sprintf "bad ip checksum: 0x%x" ipcsum)
    in
    let () = if (get_ipv4_proto buf) <> 17 then
        invalid_arg (sprintf "packet is not udp: %d" (get_ipv4_proto buf));
    in
    let srcip = Ipaddr.V4.of_int32 (get_ipv4_src buf) in
    let dstip = Ipaddr.V4.of_int32 (get_ipv4_dst buf) in
    let buf = Cstruct.shift buf ihl in
    (* Handle UDP *)
    let srcport = get_udp_source_port buf in
    let dstport = get_udp_dest_port buf in
    let buf = Cstruct.shift buf sizeof_udp in
    (* Get the DHCP stuff *)
    let op = int_to_op_exn (get_dhcp_op buf) in
    let htype = if (get_dhcp_htype buf) = 1 then Ethernet_10mb else Other in
    let hlen = get_dhcp_hlen buf in
    let hops = get_dhcp_hops buf in
    let xid = get_dhcp_xid buf in
    let secs = get_dhcp_secs buf in
    let flags =
      if ((get_dhcp_flags buf) land 0x8000) <> 0 then Broadcast else Unicast
    in
    let ciaddr = Ipaddr.V4.of_int32 (get_dhcp_ciaddr buf) in
    let yiaddr = Ipaddr.V4.of_int32 (get_dhcp_yiaddr buf) in
    let siaddr = Ipaddr.V4.of_int32 (get_dhcp_siaddr buf) in
    let giaddr = Ipaddr.V4.of_int32 (get_dhcp_giaddr buf) in
    let chaddr =
        if htype = Ethernet_10mb && hlen = 6 then
          Macaddr.of_bytes_exn (Bytes.sub (copy_dhcp_chaddr buf) 0 6)
        else
          invalid_arg "Not a mac address."
    in
    let sname = Util.cstruct_copy_normalized copy_dhcp_sname buf in
    let file = Util.cstruct_copy_normalized copy_dhcp_file buf in
    let options = options_of_buf buf len in
    { srcmac; dstmac; srcip; dstip; srcport; dstport;
      op; htype; hlen; hops; xid; secs; flags; ciaddr; yiaddr;
      siaddr; giaddr; chaddr; sname; file; options }
  in
  match (wrap ()) with
  | exception Invalid_argument e -> `Error e
  | pkt -> `Ok pkt

let buf_of_pkt pkt =
  let open Wire_structs in
  let open Ipv4_wire in
  let dhcp = Cstruct.create 2048 in
  set_dhcp_op dhcp (op_to_int pkt.op);
  set_dhcp_htype dhcp
    (if pkt.htype = Ethernet_10mb then
       1
     else
       invalid_arg "Can only build Ethernet_10mb");
  set_dhcp_hlen dhcp pkt.hlen;
  set_dhcp_hops dhcp pkt.hops;
  set_dhcp_xid dhcp pkt.xid;
  set_dhcp_secs dhcp pkt.secs;
  set_dhcp_flags dhcp (if pkt.flags = Broadcast then 0x8000 else 0);
  set_dhcp_ciaddr dhcp (Ipaddr.V4.to_int32 pkt.ciaddr);
  set_dhcp_yiaddr dhcp (Ipaddr.V4.to_int32 pkt.yiaddr);
  set_dhcp_siaddr dhcp (Ipaddr.V4.to_int32 pkt.siaddr);
  set_dhcp_giaddr dhcp (Ipaddr.V4.to_int32 pkt.giaddr);
  set_dhcp_chaddr
    (Util.bytes_extend_if_le (Macaddr.to_bytes pkt.chaddr) 16) 0 dhcp;
  set_dhcp_sname (Util.bytes_extend_if_le pkt.sname 64) 0 dhcp;
  set_dhcp_file (Util.bytes_extend_if_le pkt.file 128) 0 dhcp;
  let options_start = Cstruct.shift dhcp sizeof_dhcp in
  let options_end = buf_of_options options_start pkt.options in
  let partial_len = (Cstruct.len dhcp) - (Cstruct.len options_end) in
  let buf_end =
    if 300 - partial_len > 0 then
      let pad_len = 300 - partial_len in
      let () =
        for i = 0 to pad_len do
          Cstruct.set_uint8 options_end i 0
        done
      in
      Cstruct.shift options_end pad_len
    else
      options_end
  in
  let dhcp = Cstruct.set_len dhcp ((Cstruct.len dhcp) - (Cstruct.len buf_end)) in
  (* Ethernet *)
  let ethernet = Cstruct.create 14 in
  set_ethernet_src (Macaddr.to_bytes pkt.srcmac) 0 ethernet;
  set_ethernet_dst (Macaddr.to_bytes pkt.dstmac) 0 ethernet;
  set_ethernet_ethertype ethernet 0x0800;
  (* IPv4 *)
  let ip = Cstruct.create 20 in
  set_ipv4_hlen_version ip 0x45;
  set_ipv4_tos ip 0;
  set_ipv4_len ip (20 + 8 + (Cstruct.len dhcp)); (* ipv4 + udp + dhcp *)
  set_ipv4_id ip (Random.int 65535);
  set_ipv4_off ip 0;
  set_ipv4_ttl ip 255;
  set_ipv4_proto ip 17; (* UDP *)
  set_ipv4_src ip (Ipaddr.V4.to_int32 pkt.srcip);
  set_ipv4_dst ip (Ipaddr.V4.to_int32 pkt.dstip);
  set_ipv4_csum ip 0;
  let csum = Tcpip_checksum.ones_complement (Cstruct.sub ip 0 sizeof_ipv4) in
  set_ipv4_csum ip csum;
  (* UDP *)
  let udp = Cstruct.create 8 in
  set_udp_source_port udp pkt.srcport;
  set_udp_dest_port udp pkt.dstport;
  set_udp_length udp ((Cstruct.len dhcp) + 8);
  (* UDP checksum pseudo header *)
  let pbuf = Cstruct.create 4 in
  Cstruct.set_uint8 pbuf 0 0;
  Cstruct.set_uint8 pbuf 1 17;
  Cstruct.BE.set_uint16 pbuf 2 ((Cstruct.len udp) + (Cstruct.len dhcp));
  let src_dst = Cstruct.sub ip 12 (2 * 4) in
  set_udp_checksum udp 0;
  let udp_csum = Tcpip_checksum.ones_complement_list (src_dst :: pbuf :: udp :: dhcp :: []) in
  set_udp_checksum udp udp_csum;
  Cstruct.concat (ethernet :: ip :: udp :: dhcp :: [])

let find_option f options = Util.find_map f options

let collect_options f options = match (Util.filter_map f options) with
  | [] -> None
  | l -> Some (List.flatten l)

let client_id_of_pkt pkt = match
    find_option (function Client_id id -> Some id | _ -> None) pkt.options
  with
  | Some id -> id
  | None -> Hwaddr pkt.chaddr

(* string_of_* functions *)
let to_hum f x = Sexplib.Sexp.to_string_hum (f x)
let string_of_client_id = to_hum sexp_of_client_id
let string_of_msgtype = to_hum sexp_of_msgtype
let string_of_pkt = to_hum sexp_of_pkt