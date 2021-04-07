locals {
  redis_replication_group_id = "${var.project}-${var.env}-redis"
  redundant                  = var.num_clusters > 1 || var.cluster_enabled ? true : false
  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}

# Replication Group
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = local.redis_replication_group_id
  replication_group_description = "Replication group for ${local.redis_replication_group_id}"
  engine                        = "redis"
  engine_version                = "6.x"
  subnet_group_name             = aws_elasticache_subnet_group.redis.id
  parameter_group_name          = aws_elasticache_parameter_group.redis.name
  port                          = var.port
  security_group_ids            = var.security_group_ids
  node_type                     = var.node_type
  number_cache_clusters         = var.cluster_enabled ? null : var.num_clusters
  multi_az_enabled              = local.redundant
  automatic_failover_enabled    = local.redundant
  auto_minor_version_upgrade    = true
  apply_immediately             = true
  snapshot_window               = var.snapshot_window
  maintenance_window            = var.maintenance_window

  dynamic "cluster_mode" {
    for_each = var.cluster_enabled ? ["1"] : []
    content {
      num_node_groups         = var.num_clusters
      replicas_per_node_group = var.replicas_per_node_group
    }
  }

  tags = merge({ Name = local.redis_replication_group_id }, local.tags)

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

# Parameter Group for redis
resource "aws_elasticache_parameter_group" "redis" {
  name        = "${local.redis_replication_group_id}-pg"
  family      = "redis6.x"
  description = "Elastic Cache parameter group for ${local.redis_replication_group_id}"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "min-replicas-to-write"
    value = "2"
  }

  parameter {
    name  = "cluster-enabled"
    value = var.cluster_enabled ? "yes" : "no"
  }
}

# Subnet group for redis
resource "aws_elasticache_subnet_group" "redis" {
  name        = "${local.redis_replication_group_id}-subnet-group"
  description = "subnet group for ${local.redis_replication_group_id}"
  subnet_ids  = var.database_subnet_ids
}
