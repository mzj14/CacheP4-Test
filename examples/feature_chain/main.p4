/*
*  Control flow that apply different features.
*/

#include "include/header.p4"
#include "include/parser.p4"
#include "include/null_action.p4"
#include "include/table/source_guard.p4"
#include "include/table/acl.p4"
#include "include/table/nat.p4"
#include "include/table/router.p4"

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
    // rewrite source ethernet address
    apply(send_frame);
}
