import boto3

from const import (
    lambda_name,
    task_definition_family,
    service_name,
    service_cluster_arn,
)
from get_lastest_task_definition import get_lastest_task_definition

client = boto3.client('ecs')

def handler(event, context):
    try:
        update_service()
        return { 
            'success': 1,
        }
    except Exception as e:
        print(type(e))
        print(e.args)
        print(e)
        print("Failed to execute {lambda_name}")
        return {
            'error': str(e)
        }

def update_service():
    try:
      task_definition= get_lastest_task_definition(task_definition_family)
      task_definition_arn = task_definition["taskDefinitionArn"]
      result = client.update_service(
        service = service_name,
        cluster = service_cluster_arn,
        taskDefinition=task_definition_arn
      )
      print("updated service.")
      print(result)
    except Exception as e:
        print(type(e))
        print(e.args)
        print(e)
        print("Failed to update service.")
        raise e
    return