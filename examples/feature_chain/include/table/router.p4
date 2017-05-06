/*
* Forward a packet in the 3rd layer
*/

action set_nhop(nhop_ipv4, port) {
    modify_field(meta.nhop_ipv4, nhop_ipv4);
    modify_field(standard_metadata.egress_spec, port);
    add_to_field(ipv4.ttl, -1);
}

table ipv4_lpm {
    reads {
        ipv4.dst_addr : lpm;
    }
    actions {
        set_nhop;
    }
    size: 1024;
}

action set_dmac(dmac) {
    modify_field(ethernet.dst_addr, dmac);
    modify_field(meta.packet_category, FORWARD_PACKET);
}

table forward {
    reads {
        meta.nhop_ipv4 : exact;
    }
    actions {
        set_dmac;
    }
    size: 512;
}

action handle_forward(smac) {
    modify_field(ethernet.src_addr, smac);
}

action handle_fake() {
    drop();
}

action handle_denied() {
    drop();
}

action handle_unknown() {
    drop();
}

table send_frame {
    reads {
        meta.packet_category : exact;
        standard_metadata.egress_spec : ternary;
    }
    actions {
        handle_forward;
        handle_fake;
        handle_denied;
        handle_unknown;
    }
}
