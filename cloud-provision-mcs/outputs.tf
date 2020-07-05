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

###############################################################################
# Logstash hosts outputs
###############################################################################
output "logstash_node1_fip" {
  description = "Logstash node1 fip"
  value = "${module.logstash_node1.logstash_fip}"
}

output "logstash_node1_network" {
  description = "Logstash network"
  value = "${module.logstash_node1.logstash_network}"
}

output "logstash_node2_fip" {
  description = "Logstash node2 fip"
  value = "${module.logstash_node2.logstash_fip}"
}

output "logstash_node2_network" {
  description = "Logstash network"
  value = "${module.logstash_node2.logstash_network}"
}

###############################################################################
# Salt master outputs
###############################################################################

output "salt_master_fip" {
  description = "Salt master fip"
  value = "${module.salt_master.salt_master_fip}"
}

output "salt_master_network" {
  description = "Salt master network"
  value = "${module.salt_master.salt_master_network}"
}
