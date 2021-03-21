rds_name = "rdsdev"

rds_username = "takanashi"

rds_appdb_name     = "appdb"
rds_appdb_username = "appdbuser"

rds_instance_params = {
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  storage_class      = "gp2"
  multi_az           = false
  backup_window      = "05:20-05:50"
  maintenance_window = "sun:04:00-sun:04:30"
}

redis_cluster_params = {
  node_type               = "cache.t3.micro"
  num_clusters            = 1
  replicas_per_node_group = 0 # only valid when cluster_mode = true
  cluster_enabled         = false
  snapshot_window         = "05:00-06:00"
  maintenance_window      = "sun:04:00-sun:05:00"
}