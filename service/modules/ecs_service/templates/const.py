from json import loads

lambda_name = loads('${lambda_name}')
task_definition_family = loads('${task_definition_family}')
app_repository_name = loads('${app_repository_name}')
app_repository_url = loads('${app_repository_url}')
app_image_tag = loads('${app_image_tag}')
nginx_repository_name = loads('${nginx_repository_name}')
nginx_repository_url = loads('${nginx_repository_url}')
nginx_image_tag = loads('${nginx_image_tag}')
service_name = loads('${service_name}')
service_cluster_arn = loads('${service_cluster_arn}')