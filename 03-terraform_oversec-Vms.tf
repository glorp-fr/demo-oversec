locals {
  trigger = join("-", ["JTT", formatdate("YYYYMMDDhhmmss", timestamp())])
  keypair_name = "kp-oversec"
  # Variables supprimées car non nécessaires avec l'approche conditionnelle
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
# Vérification des images existantes
#
#############################################################################################################################

data "outscale_images" "existing_oversec" {
  filter {
   name = "image_names"
   values = ["*oversec*"]
  }
}

data "outscale_images" "existing_http" {
  filter {
   name = "image_names"
   values = ["*http*"]
  }
}

locals {
  oversec_image_exists = length(data.outscale_images.existing_oversec.images) > 0
  http_image_exists = length(data.outscale_images.existing_http.images) > 0
}


#############################################################################################################################
#
# Lancement de Packer Oversec (uniquement si l'image n'existe pas)
#
#############################################################################################################################

resource "terraform_data" "packer_init_oversec" {
  count = local.oversec_image_exists ? 0 : 1
  input = local.trigger

  provisioner "local-exec" {
    working_dir = "./"
    command = "packer init vm_oversec.pkr.hcl" 
  }
}

resource "terraform_data" "packer_build_oversec" {
  count = local.oversec_image_exists ? 0 : 1
  input = length(terraform_data.packer_init_oversec) > 0 ? terraform_data.packer_init_oversec[0].output : null
  
  provisioner "local-exec" {
    working_dir = "./"
    environment = {
      OUTSCALE_ACCESSKEYID = "${var.access_key_id}"
      OUTSCALE_SECRETKEYID = "${var.secret_key_id}"
    }
    command = "packer build vm_oversec.pkr.hcl" 
  }
}

# Data source pour récupérer l'image oversec (existante ou nouvellement créée)
data "outscale_images" "oversec" {
  filter {
   name = "image_names"
   values = ["*oversec*"]
  }
}


#############################################################################################################################
#
# Lancement de Packer http (uniquement si l'image n'existe pas)
#
#############################################################################################################################

resource "terraform_data" "packer_init_http" {
  count = local.http_image_exists ? 0 : 1
  input = local.trigger

  provisioner "local-exec" {
    working_dir = "./"
    command = "packer init vm_http.pkr.hcl" 
  }
}

resource "terraform_data" "packer_build_http" {
  count = local.http_image_exists ? 0 : 1
  input = length(terraform_data.packer_init_http) > 0 ? terraform_data.packer_init_http[0].output : null
  
  provisioner "local-exec" {
    working_dir = "./"
    environment = {
      OUTSCALE_ACCESSKEYID = "${var.access_key_id}"
      OUTSCALE_SECRETKEYID = "${var.secret_key_id}"
    }
    command = "packer build vm_http.pkr.hcl" 
  }
}

# Data source pour récupérer l'image http (existante ou nouvellement créée)
data "outscale_images" "http" {
  filter {
   name = "image_names"
   values = ["*http*"]
  }
}


#############################################################################################################################
#
# VM NET1 = Client Oversec
#
#############################################################################################################################

resource "outscale_vm" "oversec_net1_sn1_vm1" {
    image_id                 = tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav6.c1r2p2" 
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
      data.outscale_images.oversec
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
# VMs  NET 2 = Oversec Relay
#
#############################################################################################################################

resource "outscale_vm" "oversec_net2_sn1_vm1" {
    image_id                = tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav6.c1r2p2"
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net2_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net2-sn1_Relay"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
      data.outscale_images.oversec
    ] 
}

resource "outscale_vm" "oversec_net2_sn2_vm2" {
    image_id                =  tolist(data.outscale_images.http.images)[0].image_id
    vm_type                  = "tinav6.c1r1p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net2_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net2-sn1_http"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
      data.outscale_images.http
    ] 
}


#############################################################################################################################
#
# VM  NET 3 : Private
#
#############################################################################################################################

resource "outscale_vm" "oversec_net3_sn1_vm1" {
    image_id                =  tolist(data.outscale_images.oversec.images)[0].image_id
    vm_type                  = "tinav6.c1r2p2" 
    keypair_name             = local.keypair_name
    subnet_id = outscale_subnet.oversec_net3_sn1.subnet_id
    security_group_ids = [outscale_security_group.oversec_net3_sn1_sg.security_group_id]
    tags {
        key   = "Name"
        value = "oversec_net3-sn1_private"
    }
    user_data                = base64encode(<<EOF
    <CONFIGURATION>
    EOF
    )
    depends_on = [
      data.outscale_images.oversec
    ] 
}