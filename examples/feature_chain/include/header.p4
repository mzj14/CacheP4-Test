/**
 * Ethernet header type.
 */
header_type ethernet_t {
    fields {
        dst_addr : 48;
        src_addr : 48;
        eth_type : 16;
    }
}

header ethernet_t ethernet;

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
        proto : 8;
        checksum : 16;
        src_addr : 32;
        dst_addr: 32;
    }
}

header ipv4_t ipv4;

/**
 * TCP header type.
 */
header_type tcp_t {
    fields {
        src_port : 16;
        dst_port : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 4;
        flags : 8;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
    }
}

header tcp_t tcp;

/**
* Security metadata type
*/

#define NORMAL_PACKET 0 // packet that correctly forwarded according to NAT
#define FAKE_PACKET 1 // packet whose mac address is not corresponding to the ip address
#define DENIED_PACKET 2 // packet that is real but should not be processed by the switch

header_type security_metadata_t {
    fields {
        packet_category : 2;
    }
}

header security_metadata_t security_metadata;
