aws_region                  = "ap-northeast-1"
network_env                 = "development_network"

# csweb
csweb_subdomain             = "dev-webapp"
admweb_health_check_path    = "/__healthcheck"
csweb_alb_ingress_cidrs = ["0.0.0.0/0"]
csweb_ecs_params = {
  task_cpu = 256
  task_memory = 512
  service_desired_count = 1
}

# admweb
admweb_subdomain            = "dev-admin"
admweb_alb_ingress_cidrs = ["0.0.0.0/0"]
csweb_health_check_path     = "/api/__healthcheck"
admweb_ecs_params = {
  task_cpu = 512
  task_memory = 1024
  service_desired_count = 1
}

# batch-general
batch_general_ecs_params = {
  task_cpu = 512
  task_memory = 1024
}