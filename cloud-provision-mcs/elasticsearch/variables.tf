variable "hostname" {
  description = "Name of elasticsearch host"
  default = "localhost"
}

variable "elasticsearch_keypair" {
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

variable "elasticsearch_volume_type" {
  description = "Host volume type (ceph/ssd)"
  default = "ssd"
}

variable "elasticsearch_volume_size" {
  description = "Default host volume size"
  default = 100
}

variable "fip_network" {
  description = "Floating ip pool name"
  default = "ext-net"
}

variable "elasticsearch_flavor_id" {
  description = "Host flavor id"
  default = "908479b5-1138-46b6-b746-48bf6c24e548" # Standard-4-8-80
}

variable "elasticsearch_image_id" {
  description = "Host image id"
  default = "b228329c-869b-4778-a2db-7bbe5412bd14" # CentOS-7.6-201903
}

variable "network_id" {
  description = "Private network for elasticsearch hosts"
  default = ""
}

variable "subnet_id" {
  description = "Subnet of elasticsearch hosts"
  default = ""
}

variable "provision_commands" {
  description = "Commands run during provisioning"
  default = []
}

variable "elasticsearch_enable" {
  description = "Enable create elasticsearch host"
  default = 0
}
