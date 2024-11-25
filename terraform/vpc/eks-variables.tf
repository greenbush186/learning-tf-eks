variable cluster_name {
    type        = string
    description = "EKS Cluster Name"
}

variable cluster_version {
    type        = string
    description = "EKS Cluster Version"
}

variable cluster_endpoint_private_access {
    type        = bool
    description = "EKS Cluster Endpoint Private Access"
}

variable cluster_endpoint_public_access {
    type        = bool
    description = "EKS Cluster Endpoint Public Access"
}

variable cluster_endpoint_public_access_cidrs {
    type        = list(string)
    description = "EKS Cluster Endpoint Public Access CIDRs"
}

variable cluster_service_ipv4_cidr {
    type        = string
    description = "EKS Cluster Service IPv4 CIDR"
}