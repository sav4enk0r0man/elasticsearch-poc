output "elasticsearch_fip" {
  description = "Elasticsearch instance fip"
  value = "${openstack_networking_floatingip_v2.elasticsearch_fip.*.address}"
}

output "elasticsearch_network" {
  description = "Elasticsearch instance network"
  value = "${openstack_compute_instance_v2.elasticsearch_instance.*.network}"
}
