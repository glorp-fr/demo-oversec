terraform {
  required_providers {
    outscale = {
      source = "outscale/outscale"
      version = "1.2.1"
    }
  }
}  

provider "outscale" {
  access_key_id = var.access_key_id
  secret_key_id = var.secret_key_id
  region = var.region
}

output "path" { value= path.module}



##############################################################################################################################
#
# NET 1 : Client Oversec
#
##############################################################################################################################

resource "outscale_net" "oversec_net1_net" {
    ip_range = "10.1.0.0/16"
    tags {
        key="Name"
        value="oversec_net1_Client"
    }
}

resource "outscale_subnet" "oversec_net1_sn1" {
    net_id = outscale_net.oversec_net1_net.net_id
    ip_range = "10.1.1.0/24"
    tags {
        key="Name"
        value="oversec_net1_sn1"
    }
}

#Internet service
resource "outscale_internet_service" "oversec_net1_www" {
	tags {
	key="Name"
	value="oversec_net1_www"
  }
}

resource "outscale_internet_service_link" "oversec_net1_www_link" {
  internet_service_id = outscale_internet_service.oversec_net1_www.internet_service_id
  net_id = outscale_net.oversec_net1_net.net_id
}

resource "outscale_route_table" "oversec_net1_sn1_rt" {
  net_id = outscale_net.oversec_net1_net.net_id
  tags {
    key="Name"
    value="oversec_net1_sn1_rt"
  }
}

resource "outscale_route" "oversec_net1_rt_def" {
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.oversec_net1_sn1_rt.route_table_id
  gateway_id = outscale_internet_service.oversec_net1_www.internet_service_id
}

resource "outscale_route_table_link" "oversec_net1_rtl" {
    subnet_id      = outscale_subnet.oversec_net1_sn1.subnet_id
    route_table_id = outscale_route_table.oversec_net1_sn1_rt.route_table_id
}

#############################################################################################################################
#
# NET 2 Site prod publique
#
##############################################################################################################################

#Création du NET
resource "outscale_net" "oversec_net2_net" {
    ip_range = "10.2.0.0/16"
    tags {
        key="Name"
        value="oversec_net2_Prod_Public"
    }
}

#Création des subnets
resource "outscale_subnet" "oversec_net2_sn1" {
    net_id = outscale_net.oversec_net2_net.net_id
    ip_range = "10.2.1.0/24"
    tags {
        key="Name"
        value="oversec_net2_public"
    }
}

resource "outscale_subnet" "oversec_net2_sn2" {
    net_id = outscale_net.oversec_net2_net.net_id
    ip_range = "10.2.2.0/24"
    tags {
        key="Name"
        value="oversec_net2_private"
    }
}

#Création Service internet
resource "outscale_internet_service" "oversec_net2_www" {
	tags {
	key="Name"
	value="oversec_net2_www"
  }
}

#Attachement duu service internet au Net
resource "outscale_internet_service_link" "oversec_net2_www_link" {
  internet_service_id = outscale_internet_service.oversec_net2_www.internet_service_id
  net_id = outscale_net.oversec_net2_net.net_id
  
}


# Création table de routage subnet public
resource "outscale_route_table" "oversec_net2_sn1_rt" {
  net_id = outscale_net.oversec_net2_net.net_id
  tags {
    key="Name"
    value="oversec_net2_sn1_rt_public"
  }
}
#Création route par défaut vers service internet
resource "outscale_route" "oversec_net2_rt_def" {
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
  gateway_id = outscale_nat_service.oversec_net2_nat.nat_service_id
  depends_on = [
    terraform_data.oversec_net2_www_link
  ]
}
#Attachement table de routage à subnet public
resource "outscale_route_table_link" "oversec_net2_rtl" {
    subnet_id      = outscale_subnet.oversec_net2_sn1.subnet_id
    route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
}


#IP PUBLIQUE pour nat gateway
resource "outscale_public_ip" "oversec_ip_net2_nat"{
	tags {
	key="Name"
	value="oversec_ip_net2_nat"
  }
}


#NAT GATEWAY
resource "outscale_nat_service" "oversec_net2_nat" {
  subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
  public_ip_id = outscale_public_ip.oversec_ip_net2_nat.public_ip_id
}

#Table de routage
resource "outscale_route_table" "oversec_net2_sn2_rt" {
  net_id = outscale_net.oversec_net2_net.net_id
  tags {
    key="Name"
    value="oversec_net2_sn1_rt_private"
  }
}

#Route par défaut
resource "outscale_route" "oversec_net2_rt_def_priv" {
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
  gateway_id = outscale_nat_service.oversec_net2_nat.nat_service_id
}

#Attachement route table à subnet private
resource "outscale_route_table_link" "oversec_net2_priv_rtl" {
    subnet_id      = outscale_subnet.oversec_net2_sn2.subnet_id
    route_table_id = outscale_route_table.oversec_net2_sn2_rt.route_table_id
}

#############################################################################################################################
#
# NET 3 SIte de production déconnecté
#
##############################################################################################################################

resource "outscale_net" "oversec_net3_net" {
    ip_range = "10.3.0.0/16"
    tags {
        key="Name"
        value="oversec_net3_net_Private"
    }
}

resource "outscale_subnet" "oversec_net3_sn1" {
    net_id = outscale_net.oversec_net3_net.net_id
    ip_range = "10.3.1.0/24"
    tags {
        key="Name"
        value="oversec_net3_sn1_private"
    }
}

#Table de routage
resource "outscale_route_table" "oversec_net3_sn1_rt" {
  net_id = outscale_net.oversec_net3_net.net_id
  tags {
    key="Name"
    value="oversec_net3_sn1_rt_private"
  }
}


