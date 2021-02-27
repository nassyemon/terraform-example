network_env                 = "development_network"
subdomain_csweb             = "dev-webapp"
csweb_health_check_path     = "/api/__healthcheck"

csweb_ecs_params = {
  task_cpu = 512
  task_memory = 1024
  service_desired_count = 1
}