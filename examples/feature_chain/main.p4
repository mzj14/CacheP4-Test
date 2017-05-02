
control ingress {
    if (valid(ipv4) and ipv4.ttl > 0) {
        apply(ipv4_sg);
        if (valid(tcp)) {
            apply(ipv4_tcp_acl);
            apply(nat);
            apply(ipv4_lpm);
            apply(forward);
        }
    }
}

control egress {
    // rewrite source ethernet address
    apply(send_frame);
}
