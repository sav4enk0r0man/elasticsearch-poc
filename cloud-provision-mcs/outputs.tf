###############################################################################
# Elasticsearch hosts outputs
###############################################################################
output "elasticsearch_node1_fip" {
  description = "Elasticsearch node1 fip"
  value = "${module.elasticsearch_node1.elasticsearch_fip}"
}

output "elasticsearch_node1_network" {
  description = "Elasticsearch network"
  value = "${module.elasticsearch_node1.elasticsearch_network}"
}

output "elasticsearch_node2_fip" {
  description = "Elasticsearch node2 fip"
  value = "${module.elasticsearch_node2.elasticsearch_fip}"
}

output "elasticsearch_node2_network" {
  description = "Elasticsearch network"
  value = "${module.elasticsearch_node2.elasticsearch_network}"
}

output "elasticsearch_node3_fip" {
  description = "Elasticsearch node3 fip"
  value = "${module.elasticsearch_node3.elasticsearch_fip}"
}

output "elasticsearch_node3_network" {
  description = "Elasticsearch network"
  value = "${module.elasticsearch_node3.elasticsearch_network}"
}

###############################################################################
# Kibana outputs
###############################################################################

output "kibana_fip" {
  description = "Kibana fip"
  value = "${module.kibana.kibana_fip}"
}

output "kibana_network" {
  description = "Kibana network"
  value = "${module.kibana.kibana_network}"
}
