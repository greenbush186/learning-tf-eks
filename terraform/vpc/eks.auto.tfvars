cluster_name = "eksdemo1"
cluster_version = "1.31"
cluster_endpoint_private_access = false
cluster_endpoint_public_access = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # 0.0.0.0/0
cluster_service_ipv4_cidr = "172.20.0.0/16"

cluster_provide_public_node_group = false
cluster_provide_private_node_group = true