


##############################################################################################################################
#
# NET 1 - NET 2
#
##############################################################################################################################

resource "outscale_net_peering" "peering_net1-net2" {
    accepter_net_id = outscale_net.oversec_net1_net.net_id
    source_net_id   = outscale_net.oversec_net2_net.net_id
}

resource "outscale_net_peering_acceptation" "net_peering_acceptation01" {
    net_peering_id = outscale_net_peering.peering_net1-net2.net_peering_id
}


### A CORRIGER
#resource "outscale_route" "oversec_net2_rt_net1" {
#  destination_ip_range = outscale_net_peering.peering_net1-net2.accepter_net.ip_range
#  route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
#  gateway_id = outscale_net_peering.peering_net1-net2.net_peering_id
#}

#resource "outscale_route" "oversec_net1_rt_net2" {
#  destination_ip_range = outscale_net_peering.peering_net1-net2.source_net.ip_range
#  route_table_id = outscale_route_table.oversec_net1_sn1_rt.route_table_id
#  gateway_id = outscale_net_peering.peering_net1-net2.net_peering_id
#}






##############################################################################################################################
#
# NET 1 - NET 3
#
##############################################################################################################################

resource "outscale_net_peering" "peering_net1-net3" {
    accepter_net_id = outscale_net.oversec_net1_net.net_id
    source_net_id   = outscale_net.oversec_net3_net.net_id
}


resource "outscale_net_peering_acceptation" "net_peering_acceptation02" {
    net_peering_id = outscale_net_peering.peering_net1-net3.net_peering_id
}

### A CORRIGER
#resource "outscale_route" "oversec_net3_rt_net1" {
#  destination_ip_range = outscale_net_peering.peering_net1-net3.accepter_net.ip_range
#  route_table_id = outscale_route_table.oversec_net3_sn1_rt.route_table_id
#  gateway_id = outscale_net_peering.peering_net1-net3.nnet_peering_id
#}

#resource "outscale_route" "oversec_net1_rt_net3" {
#  destination_ip_range = outscale_net_peering.peering_net1-net3.source_net.ip_range
#  route_table_id = outscale_route_table.oversec_net1_sn1_rt.route_table_id
#}
