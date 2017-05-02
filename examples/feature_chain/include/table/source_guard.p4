#include "null_action.p4"

/**
* Check the consistency between MAC address and ip address
* if consistent, let the packet pass
* otherwise, drop the packet
*/

action sg_mark() {
   modify_field(security_metadata.packet_category, FAKED_PACKET);
}

table ipv4_sg {
    reads {
        ethernet.src_addr : exact;
        ipv4.src_addr : exact;
    }
    actions {
        nop;
        sg_mark;
    }
}
