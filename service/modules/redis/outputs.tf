output "endpoint_address" {
  value = (
    aws_elasticache_replication_group.redis.cluster_enabled ?
    aws_elasticache_replication_group.redis.configuration_endpoint_address :
    aws_elasticache_replication_group.redis.primary_endpoint_address
  )
}

output "cluster_enabled" {
  value = aws_elasticache_replication_group.redis.cluster_enabled
}