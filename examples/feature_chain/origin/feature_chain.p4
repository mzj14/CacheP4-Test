/**
 * Ethernet header type.
 */
header_type ethernet_t {
    fields {
        dst_addr : 48;
        src_addr : 48;
        ether_type : 16;
    }
}

/**
 * IPv4 header type.
 */
header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        total_len : 16;
        identification : 16;
        flags : 3;
        frag_offset : 13;
        ttl : 8;
        protocol : 8;
        checksum : 16;
        src_addr : 32;
        dst_addr: 32;
    }
}

/**
 * TCP header type.
 */
header_type tcp_t {
    fields {
        src_port : 16;
        dst_port : 16;
        seq_no : 32;
        ack_no : 32;
        data_offset : 4;
        res : 4;
        flags : 8;
        window : 16;
        checksum : 16;
        urgent_ptr : 16;
    }
}

header ethernet_t ethernet;

header ipv4_t ipv4;

field_list ipv4_checksum_list {
        ipv4.version;
        ipv4.ihl;
        ipv4.diffserv;
        ipv4.total_len;
        ipv4.identification;
        ipv4.flags;
        ipv4.frag_offset;
        ipv4.ttl;
        ipv4.protocol;
        ipv4.src_addr;
        ipv4.dst_addr;
}

field_list_calculation ipv4_checksum {
    input {
        ipv4_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}

calculated_field ipv4.checksum  {
    verify ipv4_checksum;
    update ipv4_checksum;
}

header tcp_t tcp;

field_list tcp_checksum_list {
        ipv4.src_addr;
        ipv4.dst_addr;
        8'0;
        ipv4.protocol;
        meta.tcp_length;
        tcp.src_port;
        tcp.dst_port;
        tcp.seq_no;
        tcp.ack_no;
        tcp.data_offset;
        tcp.res;
        tcp.flags;
        tcp.window;
        tcp.urgent_ptr;
        payload;
}

field_list_calculation tcp_checksum {
    input {
        tcp_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}

calculated_field tcp.checksum {
    verify tcp_checksum if(valid(tcp));
    update tcp_checksum if(valid(tcp));
}

#define FORWARD_PACKET 0 // packet that correctly forwarded according to NAT
#define FAKE_PACKET 1 // packet whose mac address is not corresponding to the ip address
#define DENIED_PACKET 2 // packet that is real but should not be processed by the switch
#define UNKNOWN_PACKET 3 // packet that has not been categorized

/**
* metadata type
*/
header_type meta_t {
    fields {
        packet_category : 8; // identify packet category
        nhop_ipv4 : 32;      // IP address for the next hop
        tcp_length : 16;     //
    }
}

metadata meta_t meta;

/*
* Parse all possible header fields.
*/
#define ETH_TYPE_IPv4 0x0800
#define IP_PROTO_TCP 6

parser start {
    set_metadata(meta.packet_category, UNKNOWN_PACKET);
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet);
    return select(latest.ether_type) {
        ETH_TYPE_IPv4 : parse_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return select(ipv4.protocol) {
        IP_PROTO_TCP : parse_tcp;
        default : ingress;
    }
}

parser parse_tcp {
    extract(tcp);
    set_metadata(meta.tcp_length, ipv4.total_len - 20);
    return ingress;
}


/*
* Define common use actions
*/
action nop() {
     no_op();
}

action _drop() {
    drop();
}

/*
* Check the consistency between MAC address and ip address
* if consistent, let the packet pass
* otherwise, drop the packet
*/
action sg_mark() {
   modify_field(meta.packet_category, FAKE_PACKET);
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


/**
* Permit or deny packets according to header fields
*/
action acl_mark() {
   modify_field(meta.packet_category, DENIED_PACKET);
}

table ipv4_tcp_acl {
    reads {
        standard_metadata.ingress_port : exact;
        ipv4.src_addr : ternary;
        ipv4.dst_addr : ternary;
        tcp.src_port  : ternary;
        tcp.dst_port  : ternary;
        tcp.flags     : ternary;
    }
    actions {
        nop;
        acl_mark;
    }
}


/**
* Mapping between <int_ip, int_port> and <ext_ip, ext_port>
*/
action nat_int_to_ext(src_addr, port_span) {
    modify_field(ipv4.src_addr, src_addr);
    add_to_field(tcp.src_port, port_span);
}

action nat_ext_to_int(dst_addr, port_span) {
    modify_field(ipv4.dst_addr, dst_addr);
    subtract_from_field(tcp.dst_port, port_span);
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
    modify_field(meta.packet_category, FORWARD_PACKET);
    modify_field(ethernet.dst_addr, dmac);
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
        standard_metadata.egress_port: ternary;
    }
    actions {
        handle_forward;
        handle_fake;
        handle_denied;
        handle_unknown;
    }
    size: 256;
}

control ingress {
    if (valid(ipv4)) {
        // apply source IP guard feature
        apply(ipv4_sg) {
            hit {
                if (valid(tcp)) {
                    // apply access control feature
                    apply(ipv4_tcp_acl) {
                        hit {
                            // apply NAT feature
                            apply(nat);
                            if (ipv4.ttl > 0) {
                                // set next hop
                                apply(ipv4_lpm);
                                // rewrite dest ethernet address
                                apply(forward);
                            }
                        }
                    }
                }
            }
        }
    }
}

control egress {
    apply(send_frame);
}
