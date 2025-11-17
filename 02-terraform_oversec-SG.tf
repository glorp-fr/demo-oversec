
##############################################################################################################
#Security Group Net1 Vlan 1
# IN : icmp, SSH
# OUT: icmp, SSH,oversec UDP, iperf, HTTP,HTTPS,FTP
##############################################################################################################
resource "outscale_security_group" "oversec_net1_sn1_sg" {
	description = "Sec group oversec bastion net1 sn1"
	security_group_name = "oversec_net1_sn1_sg"
	net_id =outscale_net.oversec_net1_net.net_id
}

################################
#   IN
################################
resource "outscale_security_group_rule" "oversec_net1_sn1_SSH_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "22"
	to_port_range = "22"
	ip_protocol = "tcp"
	ip_range = "82.142.29.173/32"
}

resource "outscale_security_group_rule" "oversec_net1_sn1_icmp_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "-1"
	to_port_range = "-1"
	ip_protocol = "icmp"
	ip_range = "10.0.0.0/8"
}


################################
#   OUT
################################

resource "outscale_security_group_rule" "oversec_net1_sn1_iperf_out_tcp" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "tcp"
	ip_range = "10.0.0.0/8"
}

resource "outscale_security_group_rule" "oversec_net1_sn1_iperf_out_udp" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "udp"
	ip_range = "10.0.0.0/8"
}
resource "outscale_security_group_rule" "oversec_net1_sn1_icmp_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "-1"
	to_port_range = "-1"
	ip_protocol = "icmp"
	ip_range = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "oversec_net1_sn1_oversec_out1" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "3478"
	to_port_range = "3478"
	ip_protocol = "udp"
	ip_range = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "oversec_net1_sn1_oversec_out2" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "41641"
	to_port_range = "41641"
	ip_protocol = "udp"
	ip_range = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "oversec_net1_sn1_http_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "80"
	to_port_range = "80"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net1_sn1_https_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "443"
	to_port_range = "443"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net1_sn1_ftp_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net1_sn1_sg.security_group_id
	from_port_range = "21"
	to_port_range = "21"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}



##############################################################################################################
#Security Group Net2 Vlan 1
# IN : icmp, SSH
# OUT: icmp, SSH,oversec UDP, iperf, HTTP,HTTPS,FTP
##############################################################################################################

#Security Group Net2 Vlan 1
#IN : icmp, SSH,iperf
#OUT: icmp, SSH,oversec UDP, HTTP,HTTPS,FTP

resource "outscale_security_group" "oversec_net2_sn1_sg" {
	description = "Sec group oversec net2 sn1"
	security_group_name = "oversec_net2_sn1_sg"
	net_id =outscale_net.oversec_net2_net.net_id
}


###############################
#   IN
###############################

resource "outscale_security_group_rule" "oversec_net2_sn1_icmp_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "-1"
	to_port_range = "-1"
	ip_protocol = "icmp"
	ip_range = "10.0.0.0/8"
}

resource "outscale_security_group_rule" "oversec_net2_sn1_iperf_in_tcp" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "tcp"
	ip_range = "10.0.0.0/8"
}

resource "outscale_security_group_rule" "oversec_net2_sn1_iperf_in_udp" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "udp"
	ip_range = "10.0.0.0/8"
}
resource "outscale_security_group_rule" "oversec_net2_sn1_ssh_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "22"
	to_port_range = "22"
	ip_protocol = "tcp"
	ip_range = "10.1.0.0/16"
}

###############################
#   OUT
###############################

resource "outscale_security_group_rule" "oversec_net2_sn1_http_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "80"
	to_port_range = "80"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net2_sn1_https_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "443"
	to_port_range = "443"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net2_sn1_ftp_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net2_sn1_sg.security_group_id
	from_port_range = "21"
	to_port_range = "21"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}


##############################################################################################################
#Security Group Net3 Vlan 1
# IN : icmp, SSH,iperf,HTTP
# OUT: icmp, SSH,oversec UDP, HTTP,HTTPS,FTP
##############################################################################################################


resource "outscale_security_group" "oversec_net3_sn1_sg" {
	description = "Sec group oversec net3 sn1"
	security_group_name = "oversec_net3_sn1_sg"
	net_id =outscale_net.oversec_net3_net.net_id
}

###############################
#   IN
###############################

resource "outscale_security_group_rule" "oversec_net3_sn1_icmp_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "-1"
	to_port_range = "-1"
	ip_protocol = "icmp"
	ip_range = "10.0.0.0/8"
}

resource "outscale_security_group_rule" "oversec_net3_sn1_iperf_in_tcp" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "tcp"
	ip_range = "10.0.0.0/8"
}

resource "outscale_security_group_rule" "oversec_net3_sn1_iperf_in_udp" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "5201"
	to_port_range = "5201"
	ip_protocol = "udp"
	ip_range = "10.0.0.0/8"
}
resource "outscale_security_group_rule" "oversec_net3_sn1_ssh_in" {
	flow = "Inbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "22"
	to_port_range = "22"
	ip_protocol = "tcp"
	ip_range = "10.1.0.0/16"
}


###############################
#   OUT
###############################
resource "outscale_security_group_rule" "oversec_net3_sn1_http_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "80"
	to_port_range = "80"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net3_sn1_https_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "443"
	to_port_range = "443"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
resource "outscale_security_group_rule" "oversec_net3_sn1_ftp_out" {
	flow = "Outbound"
	security_group_id = outscale_security_group.oversec_net3_sn1_sg.security_group_id
	from_port_range = "21"
	to_port_range = "21"
	ip_protocol = "tcp"
	ip_range = "0.0.0.0/0"
}
