output "logstash_fip" {
  description = "logstash instance fip"
  value = "${openstack_networking_floatingip_v2.logstash_fip.*.address}"
}

output "logstash_network" {
  description = "logstash instance network"
  value = "${openstack_compute_instance_v2.logstash_instance.*.network}"
}
