
output "ip_bastion" {
    value = outscale_vm.oversec_net1_sn1_vm1.public_ip
}

output "ip_sn2_vm1" {
    value = outscale_vm.oversec_net2_sn1_vm1.private_ip
}

output "ip_sn2_vm2" {
    value = outscale_vm.oversec_net2_sn1_vm2.private_ip
}
output "ip_sn3_vm1" {
    value = outscale_vm.oversec_net3_sn1_vm1.private_ip
}


