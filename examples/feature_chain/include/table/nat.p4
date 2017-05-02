#include "null_action.p4"

action nat_int_to_ext(srcAddr, srcPortSpan) {
    modify_field(ipv4.src_addr, srcAddr);
    add_to_field(tcp.src_port, srcPortSpan);
}

action nat_ext_to_int(dstAddr, dstPortSpan) {
    modify_field(ipv4.dst_addr, dstAddr);
    add_to_field(tcp.dst_port, dstPortSpan);
}

table nat {
    reads {
        ipv4.src_addr : ternary;
        ipv4.dst_addr : ternary;
        tcp.src_port : ternary;
        tcp.dst_port : ternary;
    }
    actions {
        nat_hit_int_to_ext;
        nat_hit_ext_to_int;
    }
    size : 128;
}
