# Create network port for logstash node
resource "openstack_networking_port_v2" "logstash_port" {
  count          = var.logstash_enable
  name           = "${var.hostname}_port"
  network_id     = var.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = var.subnet_id
    ip_address = ""
  }

  lifecycle {
    ignore_changes = [
      dns_assignment,
      network_id
    ]
  }
}

# Create floating ip for logstash instance
resource "openstack_networking_floatingip_v2" "logstash_fip" {
  count = var.logstash_enable
  pool  = var.fip_network
}

# Associate a floating IP to a instance port
resource "openstack_networking_floatingip_associate_v2" "logstash_fip" {
  count       = var.logstash_enable
  floating_ip = openstack_networking_floatingip_v2.logstash_fip[count.index].address
  port_id     = openstack_networking_port_v2.logstash_port[count.index].id

  lifecycle {
    ignore_changes = [
      port_id
    ]
  }
}

resource "openstack_compute_floatingip_associate_v2" "logstash_fip" {
  count       = var.logstash_enable
  floating_ip = openstack_networking_floatingip_v2.logstash_fip[count.index].address
  instance_id = openstack_compute_instance_v2.logstash_instance[count.index].id
}

# Create volume for logstash instance
resource "openstack_blockstorage_volume_v2" "logstash_volume" {
  count       = var.logstash_enable
  name        = "${var.hostname}-volume"
  volume_type = var.logstash_volume_type
  size        = var.logstash_volume_size
  image_id    = var.logstash_image_id
}

# Create security groups for logstash instance port
resource "openstack_networking_secgroup_v2" "logstash_secgroup" {
  count       = var.logstash_enable
  name        = "security_group_${var.hostname}"
  description = "Security group for ${var.hostname}"
}

# Create security rule: allow access to 22 port for any
resource "openstack_networking_secgroup_rule_v2" "logstash_rule_in_22" {
  count             = var.logstash_enable
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.logstash_secgroup[count.index].id
}

# Create security rule: allow icmp for any
resource "openstack_networking_secgroup_rule_v2" "logstash_rule_in_icmp" {
  count             = var.logstash_enable
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.logstash_secgroup[count.index].id
}

# Associate a security group to logstash instance port
resource "openstack_networking_port_secgroup_associate_v2" "logstash_secgroup_accociate" {
  count              = var.logstash_enable
  port_id            = openstack_networking_port_v2.logstash_port[count.index].id
  security_group_ids = [
    openstack_networking_secgroup_v2.logstash_secgroup[count.index].id,
  ]
  lifecycle {
    ignore_changes = [
      port_id,
      all_security_group_ids
    ]
  }
}

# Create logstash instance
resource "openstack_compute_instance_v2" "logstash_instance" {
  count             = var.logstash_enable
  name              = var.hostname
  flavor_id         = var.logstash_flavor_id
  key_pair          = var.logstash_keypair
  config_drive      = true

  security_groups = [
    "default",
    "security_group_${var.hostname}"
  ]

  block_device {
    uuid                  = openstack_blockstorage_volume_v2.logstash_volume[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    uuid = var.network_id
    port = openstack_networking_port_v2.logstash_port[count.index].id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.logstash_fip[count.index].address
      user        = var.ssh_user
      timeout     = "120s"
      private_key = file("${var.ssh_dir}/${var.ssh_private_key}")
      agent       = false
    }
    inline = [
      // update packages
      "sudo yum update -y",
    ]
  }
}

# Init logstash host
resource "null_resource" "logstash_exec" {
  count         = var.logstash_enable

  triggers = {
    trigger = "${tostring(openstack_compute_instance_v2.logstash_instance[count.index].id)}"
  }

  connection {
    type        = "ssh"
    host        = openstack_networking_floatingip_v2.logstash_fip[count.index].address
    user        = var.ssh_user
    timeout     = "120s"
    private_key = file("${var.ssh_dir}/${var.ssh_private_key}")
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      // install packages
      "sudo yum install epel-release vim telnet traceroute tcpdump htop mc -y",
    ]
  }

  provisioner "remote-exec" {
    // provisioning commands
    inline = var.provision_commands
  }

  depends_on = [
    openstack_compute_instance_v2.logstash_instance
  ]
}
