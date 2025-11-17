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
# NET 1
#
##############################################################################################################################

resource "outscale_net" "oversec_net1_net" {
    ip_range = "10.1.0.0/16"
    tags {
        key="Name"
        value="oversec_net1_net"
    }
    tags {
        key="ocs.fcu.enable_lan_security_groups"
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


resource "outscale_public_ip" "oversec_ip_net1_nat"{
	tags {
	key="Name"
	value="oversec_ip_net1_nat"
  }
}


resource "outscale_nat_service" "oversec_net1_nat" {
  subnet_id = outscale_subnet.oversec_net1_sn1.subnet_id
  public_ip_id = outscale_public_ip.oversec_ip_net1_nat.public_ip_id
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
# NET 2
#
##############################################################################################################################



resource "outscale_net" "oversec_net2_net" {
    ip_range = "10.2.0.0/16"
    tags {
        key="Name"
        value="oversec_net2_net"
    }
    tags {
        key="ocs.fcu.enable_lan_security_groups"
    }
}


resource "outscale_subnet" "oversec_net2_sn1" {
    net_id = outscale_net.oversec_net2_net.net_id
    ip_range = "10.2.1.0/24"
    tags {
        key="Name"
        value="oversec_net2_sn1"
    }
}

resource "outscale_internet_service" "oversec_net2_www" {
	tags {
	key="Name"
	value="oversec_net2_www"
  }
}

resource "outscale_internet_service_link" "oversec_net2_www_link" {
  internet_service_id = outscale_internet_service.oversec_net2_www.internet_service_id
  net_id = outscale_net.oversec_net2_net.net_id
}

resource "outscale_public_ip" "oversec_ip_net2_nat"{
	tags {
	key="Name"
	value="oversec_ip_net2_nat"
  }
}


resource "outscale_nat_service" "oversec_net2_nat" {
  subnet_id = outscale_subnet.oversec_net2_sn1.subnet_id
  public_ip_id = outscale_public_ip.oversec_ip_net2_nat.public_ip_id
}


resource "outscale_route_table" "oversec_net2_sn1_rt" {
  net_id = outscale_net.oversec_net2_net.net_id
  tags {
    key="Name"
    value="oversec_net2_sn1_rt"
  }
}

resource "outscale_route" "oversec_net2_rt_def" {
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
  gateway_id = outscale_nat_service.oversec_net2_nat.nat_service_id
}

resource "outscale_route_table_link" "oversec_net2_rtl" {
    subnet_id      = outscale_subnet.oversec_net2_sn1.subnet_id
    route_table_id = outscale_route_table.oversec_net2_sn1_rt.route_table_id
}

#############################################################################################################################
#
# NET 3
#
##############################################################################################################################



resource "outscale_net" "oversec_net3_net" {
    ip_range = "10.3.0.0/16"
    tags {
        key="Name"
        value="oversec_net3_net"
    }
    tags {
        key="ocs.fcu.enable_lan_security_groups"
    }
}



resource "outscale_subnet" "oversec_net3_sn1" {
    net_id = outscale_net.oversec_net3_net.net_id
    ip_range = "10.3.1.0/24"
    tags {
        key="Name"
        value="oversec_net3_sn1"
    }
}





resource "outscale_internet_service" "oversec_net3_www" {
	tags {
	key="Name"
	value="oversec_net3_www"
  }
}


resource "outscale_public_ip" "oversec_ip_net3_nat"{
	tags {
	key="Name"
	value="oversec_ip_net3_nat"
  }
}





resource "outscale_internet_service_link" "oversec_net3_www_link" {
  internet_service_id = outscale_internet_service.oversec_net3_www.internet_service_id
  net_id = outscale_net.oversec_net3_net.net_id
}




resource "outscale_nat_service" "oversec_net3_nat" {
  subnet_id = outscale_subnet.oversec_net3_sn1.subnet_id
  public_ip_id = outscale_public_ip.oversec_ip_net3_nat.public_ip_id
}




resource "outscale_route_table" "oversec_net3_sn1_rt" {
  net_id = outscale_net.oversec_net3_net.net_id
  tags {
    key="Name"
    value="oversec_net3_sn1_rt"
  }
}


 

resource "outscale_route" "oversec_net3_rt_def" {
  destination_ip_range = "0.0.0.0/0"
  route_table_id = outscale_route_table.oversec_net3_sn1_rt.route_table_id
  gateway_id = outscale_nat_service.oversec_net3_nat.nat_service_id
}







resource "outscale_route_table_link" "oversec_net3_rtl" {
    subnet_id      = outscale_subnet.oversec_net3_sn1.subnet_id
    route_table_id = outscale_route_table.oversec_net3_sn1_rt.route_table_id
}



