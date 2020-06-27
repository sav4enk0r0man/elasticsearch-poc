output "kibana_fip" {
  description = "Kibana instance fip"
  value = "${openstack_networking_floatingip_v2.kibana_fip.*.address}"
}

output "kibana_network" {
  description = "Kibana instance network"
  value = "${openstack_compute_instance_v2.kibana_instance.*.network}"
}
