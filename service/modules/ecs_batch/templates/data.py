from json import loads

lambda_name = loads('${lambda_name}')
command = loads('${command}')
app_container_name = loads('${app_container_name}')
task_definition_family = loads('${task_definition_family}')
batch_cluster_name = loads('${batch_cluster_name}')
batch_cluster_arn = loads('${batch_cluster_arn}')
security_group_ids = loads('${security_group_ids}')
subnet_ids = loads('${subnet_ids}')