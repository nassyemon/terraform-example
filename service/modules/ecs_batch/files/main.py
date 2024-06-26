import boto3

from const import (
    lambda_name,
    app_container_name,
    command,
    task_definition_family,
    batch_cluster_name,
    batch_cluster_arn,
    security_group_ids,
    subnet_ids
)
from get_lastest_task_definition import get_lastest_task_definition
from get_ecs_console_url import get_ecs_console_url

client = boto3.client('ecs')

def handler(event, context):
    try:
        task_definition= get_lastest_task_definition(task_definition_family)
        task_definition_arn = task_definition["taskDefinitionArn"]
        message = f"Invoking {lambda_name} with command = {command}"
        print(f"batch_cluster_arn={batch_cluster_arn}")
        print(f"task_definition_arn={task_definition_arn}")
        print(f"security_group_ids={security_group_ids}")
        print(f"subnet_ids={subnet_ids}")
        result = client.run_task(
            cluster=batch_cluster_arn,
            taskDefinition=task_definition_arn,
            launchType="FARGATE",
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': subnet_ids,
                    'securityGroups': security_group_ids,
                    'assignPublicIp': "DISABLED"
                }
            },
            overrides={
                'containerOverrides': [{
                    'name': app_container_name,
                    'command': command,
                }],
            }
        )
        print(f"Successfully run ecs task: {task_definition_arn}")
        print(result)
        console_url = get_ecs_console_url(batch_cluster_name, result)
        return { 
            'success': 1,
            'console_url' : console_url
        }
    except Exception as e:
        print(type(e))
        print(e.args)
        print(e)
        print("Failed to execute {lambda_name}")
        return {
            'error': str(e)
        }
