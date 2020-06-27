terraform {
  required_version = ">= 0.12"
}

provider "openstack" {
  # Use local openrc credentials
}

# ELK private network
resource "openstack_networking_network_v2" "elk_network" {
  name           = "elk_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "elk_subnet" {
  name       = "elk_subnet"
  network_id = openstack_networking_network_v2.elk_network.id
  cidr       = "10.128.0.0/24"
  ip_version = 4
}

# OpenStack virtual router for ELK network
resource "openstack_networking_router_v2" "elk_router" {
  name                = "elk_router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

# Add network interface to ELK network
resource "openstack_networking_router_interface_v2" "elk_router_interface" {
  router_id = openstack_networking_router_v2.elk_router.id
  subnet_id = openstack_networking_subnet_v2.elk_subnet.id
}

# Provisioning elasticsearch node1
module "elasticsearch_node1" {
  source                 = "./elasticsearch"

  hostname               = "elasticsearch1"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  elasticsearch_keypair  = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  elasticsearch_enable   = "${var.enable}"
}

# Provisioning elasticsearch node2
module "elasticsearch_node2" {
  source                 = "./elasticsearch"

  hostname               = "elasticsearch2"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  elasticsearch_keypair  = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  elasticsearch_enable   = "${var.enable}"
}

# Provisioning elasticsearch node3
module "elasticsearch_node3" {
  source                 = "./elasticsearch"

  hostname               = "elasticsearch3"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  elasticsearch_keypair  = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  elasticsearch_enable   = "${var.enable}"
}

# Provisioning kibana host
module "kibana" {
  source                 = "./kibana"

  hostname               = "kibana"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  kibana_keypair         = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  kibana_enable          = "${var.enable}"
}
