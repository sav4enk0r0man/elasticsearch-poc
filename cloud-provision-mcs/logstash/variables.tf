variable "hostname" {
  description = "Name of logstash host"
  default = "localhost"
}

variable "logstash_keypair" {
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

variable "logstash_volume_type" {
  description = "Host volume type (ceph/ssd)"
  default = "ssd"
}

variable "logstash_volume_size" {
  description = "Default host volume size"
  default = 50
}

variable "fip_network" {
  description = "Floating ip pool name"
  default = "ext-net"
}

variable "logstash_flavor_id" {
  description = "Host flavor id"
  default = "b7d20f15-82f1-4ed4-a12e-e60277fe955f" # Standard-2-4-50
}

variable "logstash_image_id" {
  description = "Host image id"
  default = "b228329c-869b-4778-a2db-7bbe5412bd14" # CentOS-7.6-201903
}

variable "network_id" {
  description = "Private network for logstash hosts"
  default = ""
}

variable "subnet_id" {
  description = "Subnet of logstash hosts"
  default = ""
}

variable "provision_commands" {
  description = "Commands run during provisioning"
  default = []
}

variable "logstash_enable" {
  description = "Enable create logstash host"
  default = 0
}
