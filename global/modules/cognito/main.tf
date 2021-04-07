locals {
  identity_pool_name = "${var.user_pool_name}-identity-pool"
  # from_email_address = "${var.email_display_name} <${var.email_address}>"
  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}

resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
  # ユーザー確認を行う際にEmail or 電話で自動検証を行うための設定。Emailを指定。
  auto_verified_attributes = [
    "email",
  ]

  sms_authentication_message = " 認証コードは {####} です。"
  mfa_configuration          = "OFF"

  admin_create_user_config {
    allow_admin_create_user_only = false

    invite_message_template {
      email_subject = "仮パスワード発行のお知らせ"
      email_message = "ログインIDは{username}、仮パスワードは {####} です。"
      sms_message   = "ログインIDは{username}、仮パスワードは {####} です。"
    }
  }

  alias_attributes = []

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    # from_email_address    = local.from_email_address
    # source_arn            = var.email_idnetity_arn
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  # schemas
  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
  }

  schema {
    attribute_data_type = "String"
    name                = "name"
    required            = true
    mutable             = false
    string_attribute_constraints {
      max_length = "32"
      min_length = "4"
    }
  }

  username_configuration {
    case_sensitive = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = " パスコード送付のお知らせ"
    email_message        = " パスコードは {####} です。"
    sms_message          = " パスコードは {####} です。"
  }

  tags = merge({ Name = var.user_pool_name }, local.tags)
  
  lifecycle {
    ignore_changes = [
      schema     ### AWS doesn't allow schema updates, so every build will re-create the user pool unless we ignore this bit
    ]
  }
}

resource "aws_cognito_user_pool_client" "web_client" {
  name = "${var.user_pool_name}-web-client"
  
  allowed_oauth_flows                  = []
  allowed_oauth_flows_user_pool_client = false
  allowed_oauth_scopes                 = []
  callback_urls                        = []

  explicit_auth_flows = [
    # "ALLOW_REFRESH_TOKEN_AUTH",
    "USER_PASSWORD_AUTH",
  ]
  logout_urls                   = []
  prevent_user_existence_errors = "ENABLED"

  read_attributes = [
    "email",
    "name",
    "phone_number",
  ]

  refresh_token_validity       = 30
  supported_identity_providers = []
  user_pool_id                 = aws_cognito_user_pool.user_pool.id

  write_attributes = [
    "email",
    "name",
    "phone_number",
  ]
}

resource "aws_cognito_identity_pool" "user_pool" {
  identity_pool_name               =  local.identity_pool_name
  
  allow_unauthenticated_identities = false

  openid_connect_provider_arns     = []
  saml_provider_arns               = []
  supported_login_providers        = {}
  tags = merge({
    Name = local.identity_pool_name,
    UserPool = var.user_pool_name,
  }, local.tags)

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.web_client.id
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
    server_side_token_check = true
  }
}

