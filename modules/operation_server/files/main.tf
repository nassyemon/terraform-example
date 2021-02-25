provider mysql {
  endpoint = local.endpoint
  username = local.root_username
  password = data.aws_secretsmanager_secret_version.root_password_secrets.secret_string
}

# db
resource mysql_database appdb {
  name = local.appdb_name
  default_character_set = "utf8"
  default_collation     = "utf8_general_ci"
}

# role
# resource mysql_role appdb_admin {
#   name = local.appdb_admin_role
# }

# resource mysql_grant appdb_user {
#   role       = mysql_role.appdb_admin.name
#   database   = mysql_database.appdb.name
#   table      = "*"
#   privileges = ["ALL"]
# }

# user appdb_user
resource mysql_user appdb_user {
  user               = local.appdb_username
  host               = "%"
  plaintext_password = random_password.appdb_user_password.result
}

resource mysql_grant appdb_user {
  user     = mysql_user.appdb_user.user
  host     = mysql_user.appdb_user.host
  database = mysql_database.appdb.name
  # roles    = [mysql_role.appdb_admin.name]
  table      = "*"
  privileges = ["ALL"]
}

# create password
resource random_password appdb_user_password {
  length           = 16
  special          = true
  override_special = "_%@"
}
