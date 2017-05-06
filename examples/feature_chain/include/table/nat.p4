/**
* Mapping between <int_ip, int_port> and <ext_ip, ext_port>
*/

action nat_int_to_ext(src_addr, src_port_span) {
    modify_field(ipv4.src_addr, src_addr);
    add_to_field(tcp.src_port, src_port_span);
}

action nat_ext_to_int(dst_addr, dst_port_span) {
    modify_field(ipv4.dst_addr, dst_addr);
    add_to_field(tcp.dst_port, dst_port_span);
}

table nat {
    reads {
        ipv4.src_addr : ternary;
        ipv4.dst_addr : ternary;
        tcp.src_port : ternary;
        tcp.dst_port : ternary;
    }
    actions {
        nat_int_to_ext;
        nat_ext_to_int;
    }
    size : 128;
}
