

locals {
  trigger = join("-", ["JTT", formatdate("YYYYMMDDhhmmss", timestamp())])
  packer_init = terraform_data.packer_init.output
  omi_delete = terraform_data.packer_build.output
  keypair_name = "kp-oversec"
}


#############################################################################################################################
#
# Keypair
#
#############################################################################################################################

resource "tls_private_key" "kp-oversec" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "kp-oversec" {
  filename        = "${path.module}/kp-oversec.pem"
  content         = tls_private_key.kp-oversec.private_key_pem
  file_permission = "0600"
}

resource "outscale_keypair" "kp-oversec" {
  keypair_name = "kp-oversec"
  public_key = tls_private_key.kp-oversec.public_key_openssh
}


#############################################################################################################################
#
# Lancement de Packer
#
#############################################################################################################################


resource "terraform_data" "packer_init" {
  input =  local.trigger

  provisioner "local-exec" {
    working_dir = "./"
    command = "packer init vm_debian12_Jaouen.pkr.hcl" 
  }
}


resource "terraform_data" "packer_build" {
  input = local.packer_init
  
  provisioner "local-exec" {
    working_dir = "./"
    environment = {
    OUTSCALE_ACCESSKEYID = "${var.access_key_id}"
    OUTSCALE_SECRETKEYID = "${var.secret_key_id}"

    }
    command = "packer build vm_debian12_Jaouen.pkr.hcl" 
  
  }
}


data "outscale_images" "oversec" {
  filter {
   name = "image_names"
   values = ["*oversec*"]
  }
  depends_on = [
    terraform_data.packer_build
  ]
}







#############################################################################################################################
#
# VM BASTION
#
#############################################################################################################################

 

resource "outscale_vm" "oversec_net1_sn1_vm1" {
    #image_id                = "ami-8be8ac39"
    image_id                 = tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav6.c4r4p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net1_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net1_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net1-sn1_vm1"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
    terraform_data.packer_build
    ] 
}

resource "outscale_public_ip" "oversec_net1_sn1_vm1_ip"{
	tags {
	key="Name"
	value="oversec_net1_sn1_vm1_ip"
  }
}

resource "outscale_public_ip_link" "oversec_net1_sn1_vm1_ipl" {
    vm_id     = outscale_vm.oversec_net1_sn1_vm1.vm_id
    public_ip = outscale_public_ip.oversec_net1_sn1_vm1_ip.public_ip
}




#############################################################################################################################
#
# VMs  NET 2
#
#############################################################################################################################


resource "outscale_vm" "oversec_net2_sn1_vm1" {
    #image_id                 = "ami-8be8ac39"
    image_id                = tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav5.c4r4p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net2_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net2-sn1_vm1"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
    terraform_data.packer_build
    ] 
}

resource "outscale_vm" "oversec_net2_sn1_vm2" {
    #image_id                 = "ami-8be8ac39"
    image_id                =  tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav5.c1r1p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net2_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net2-sn1_vm2"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
    terraform_data.packer_build
    ] 
}



#############################################################################################################################
#
# VM  NET 3
#
#############################################################################################################################

resource "outscale_vm" "oversec_net3_sn1_vm1" {
    #image_id                 = "ami-8be8ac39"
    image_id                =  tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav5.c3r4p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net3_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net3_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net3-sn1_vm1"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
    terraform_data.packer_build
    ] 
}


#resource "terraform_data" "omi_delete" {
#  input =  local.trigger

#  provisioner "local-exec" {
#    working_dir = "./"
#    command = "curl https://fcu.${var.region}.outscale.com --user ${var.access_key_id}:${var.secret_key_id} --aws-sigv4 'aws:amz' --data-urlencode 'Version=2016-09-15' --data-urlencode 'Action=DeregisterImage' --data-urlencode 'ImageId=${tolist(data.outscale_images.oversec.images)[0].image_id}'"
#  }
#    depends_on = [
#    outscale_vm.oversec_net3_sn1_vm1
#    ] 
#}
