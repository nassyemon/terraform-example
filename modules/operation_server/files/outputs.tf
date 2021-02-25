output appdb_user_password_hash {
  value = sha256("${random_password.appdb_user_password.result}${local.appdb_name}")
}
