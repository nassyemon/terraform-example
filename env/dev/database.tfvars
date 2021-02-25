rds_name = "rdsdev"

rds_username = "takanashi"

rds_appdb_name = "appdb"
rds_appdb_username = "appdbuser"

rds_instance_params = {
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  storage_class      = "gp2"
  multi_az           = false
  backup_window      = "05:20-05:50"
  maintenance_window = "sun:04:00-sun:04:30"
}
