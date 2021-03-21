variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "port" {
  description = "port number that redis cluster accepts connections"
}

variable "database_subnet_ids" {
  type        = list(any)
  description = "List of ids of database subnet."
}

variable "security_group_ids" {
  type        = list(any)
  description = "List of securty groups that is attatched to redis cluster."
}

variable "cluster_enabled" {
  description = "set true to enable cluster"
}

variable "num_clusters" {
  description = "if cluster_enabled = true num_node_gorups, otherwise number of cache clusters. "
}

variable "replicas_per_node_group" {
  description = "number of replicas per node group. (only effective when cluster_enabled = true)"
  default = null
}

variable "node_type" {
  description = "Example: cache.t3.micro"
}

variable "snapshot_window" {
  description = "Example: 05:20-05:50"
}

variable "maintenance_window" {
  description = "sun:04:00-sun:04:30"
}
