#include "header.p4"

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
        _drop;
    }
    size: 1024;
}

action set_dmac(dmac) {
    modify_field(ethernet.dstAddr, dmac);
}

table forward {
    reads {
        meta.nhop_ipv4 : exact;
    }
    actions {
        set_dmac;
        _drop;
    }
    size: 512;
}


action rewrite_smac(smac) {
    modify_field(ethernet.src_addr, smac)
}

action handle_normal(smac) {
    rewrite_smac(smac);
}

action handle_faked() {
    drop();
}

action handle_normal() {
    drop();
}

action handle_alert() {
    drop();
}

table send_frame {
    reads {
        security_metadata.packet_category : exact;
        standard_metadata.egress_port : exact;
    }
    actions {
        handle_normal;
        handle_faked;
        handle_unwanted;
        handle_alert;
    }
}
