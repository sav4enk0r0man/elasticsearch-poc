variable "hostname" {
  description = "Name of kibana host"
  default = "localhost"
}

variable "kibana_keypair" {
  description = "MCS ssh keypair name"
  default = ""
}

variable "ssh_dir" {
  description = "SSH keys dir"
  default = "~/.ssh"
}

variable "ssh_private_key" {
  description = "SSH private key file name"
  default = "id_rsa"
}

variable "ssh_user" {
  description = "SSH username"
  default = "centos"
}

variable "kibana_volume_type" {
  description = "Host volume type (ceph/ssd)"
  default = "ssd"
}

variable "kibana_volume_size" {
  description = "Default host volume size"
  default = 50
}

variable "fip_network" {
  description = "Floating ip pool name"
  default = "ext-net"
}

variable "kibana_flavor_id" {
  description = "Host flavor id"
  default = "bf714720-78da-4271-ab7d-0cf5e2613f14" # Standard-2-8-50
}

variable "kibana_image_id" {
  description = "Host image id"
  default = "b228329c-869b-4778-a2db-7bbe5412bd14" # CentOS-7.6-201903
}

variable "network_id" {
  description = "Private network for kibana hosts"
  default = ""
}

variable "subnet_id" {
  description = "Subnet of kibana hosts"
  default = ""
}

variable "provision_commands" {
  description = "Commands run during provisioning"
  default = []
}

variable "kibana_enable" {
  description = "Enable create kibana host"
  default = 0
}
