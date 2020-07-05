terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket   = "elasticsearch-poc"
    key      = "terraform.tfstate"
    endpoint = "https://hb.bizmrg.com"
    region   = "RegionOne"

    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
    skip_region_validation = true

    shared_credentials_file = "../.aws/credentials-terraform"
  }
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

# Provisioning logstash node1
module "logstash_node1" {
  source                 = "./logstash"

  hostname               = "logstash1"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  logstash_keypair       = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  logstash_enable        = "${var.enable}"
}

# Provisioning logstash node2
module "logstash_node2" {
  source                 = "./logstash"

  hostname               = "logstash2"
  network_id             = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id              = "${openstack_networking_subnet_v2.elk_subnet.id}"
  logstash_keypair       = "${var.keypair}"
  ssh_dir                = "${var.ssh_dir}"
  ssh_private_key        = "${var.ssh_private_key}"
  logstash_enable        = "${var.enable}"
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

# Provisioning Salt master host
module "salt_master" {
  source                 = "./salt-master"

  hostname                 = "elk-salt-master"
  network_id               = "${openstack_networking_network_v2.elk_network.id}"
  subnet_id                = "${openstack_networking_subnet_v2.elk_subnet.id}"
  salt_master_keypair      = "${var.keypair}"
  ssh_dir                  = "${var.ssh_dir}"
  ssh_private_key          = "${var.ssh_private_key}"
  ansible_provision_prefix = "${var.ansible_provision_prefix}"
  salt_minion_addresess    = [
    "${length(module.elasticsearch_node1.elasticsearch_fip) > 0 ? element("${module.elasticsearch_node1.elasticsearch_fip}", 0) : null}",
    "${length(module.elasticsearch_node2.elasticsearch_fip) > 0 ? element("${module.elasticsearch_node2.elasticsearch_fip}", 0) : null}",
    "${length(module.elasticsearch_node3.elasticsearch_fip) > 0 ? element("${module.elasticsearch_node3.elasticsearch_fip}", 0) : null}",
    "${length(module.logstash_node1.logstash_fip) > 0 ? element("${module.logstash_node1.logstash_fip}", 0) : null}",
    "${length(module.logstash_node2.logstash_fip) > 0 ? element("${module.logstash_node2.logstash_fip}", 0) : null}",
    "${length(module.kibana.kibana_fip) > 0 ? element("${module.kibana.kibana_fip}", 0) : null}",
  ]
  provision_commands       = [
    "sudo rm -rf /srv",
    "sudo git clone ${var.salt_repo} /srv"
  ]
  accept_minion_keys       = "${var.accept_minion_keys}"
  salt_master_enable       = "${var.enable}"
}
