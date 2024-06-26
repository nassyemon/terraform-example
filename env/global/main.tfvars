aws_vpc_tags_name = "vpc"

aws_vpc_cidr_prd = "172.30.0.0/16"

# # 3-AZs
# availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
# webapp_subnet_cidrs_prd = ["172.30.0.0/23", "172.30.2.0/23", "172.30.4.0/23"]
# database_subnet_cidrs_prd = ["172.30.8.0/23", "172.30.10.0/23", "172.30.12.0/23"]
# public_subnet_cidrs_prd = ["172.30.16.0/22", "172.30.20.0/22", "172.30.24.0/22"]

availability_zones        = ["ap-northeast-1a", "ap-northeast-1c"]
webapp_subnet_cidrs_prd   = ["172.30.0.0/23", "172.30.2.0/23"]
database_subnet_cidrs_prd = ["172.30.8.0/23", "172.30.10.0/23"]
public_subnet_cidrs_prd   = ["172.30.16.0/22", "172.30.20.0/22"]

csweb_app_repository_name    = "csweb_app"
csweb_nginx_repository_name  = "csweb_nginx"
admweb_app_repository_name   = "admweb_app"
admweb_nginx_repository_name = "admweb_nginx"
migrate_app_repository_name  = "migrate_app"

external_operator_users_prd = ["takanashi"]
operation_server_username   = "ubuntu"

developer_email_addresses = [
  "takanashi1986@gmail.com",
  "takanashi.tmi@gmail.com"
]

# cognito_email_address_local_development = "no-reply-local-dev@takanashi.xyz"
# cognito_email_display_name_local_development = "no-reply"