import boto3

from const import (
    lambda_name,
    task_definition_family,
    app_repository_name,
    app_repository_url,
    app_image_tag,
    nginx_repository_name,
    nginx_image_tag,
    nginx_repository_url
)

from get_lastest_task_definition import get_lastest_task_definition
from get_latest_commithash_with_tag import get_latest_commithash_with_tag

client = boto3.client('ecs')

def handler(event, context):
    try:
        update_task_definition()
        return { 
            'success': 1,
        }
    except Exception as e:
        print(type(e))
        print(e.args)
        print(e)
        print("Failed to execute {lambda_name}")
        return { 
            'error': str(e),
        }


def update_task_definition():
    # get current task defintiion
    task_definition = get_lastest_task_definition(task_definition_family)
    print("current task_deintion = ")
    print(task_definition)
    current_arn = task_definition['taskDefinitionArn']
    # create new task definition
    app_commithash = get_latest_commithash_with_tag(app_repository_name, app_image_tag)
    nginx_commithash = get_latest_commithash_with_tag(nginx_repository_name, nginx_image_tag)
    print(f"app_commithash with {app_image_tag} = {app_commithash}")
    print(f"nginx_commithash with {nginx_image_tag} = {nginx_commithash}")
    # create new task definition
    new_task_definition = create_new_task_definition(
        task_definition = task_definition,
        app_image = f"{app_repository_url}:{app_commithash}",
        nginx_image = f"{nginx_repository_url}:{nginx_commithash}",
    )
    print("new task_deintion = ")
    print(new_task_definition)
    try:
        result = client.register_task_definition(**new_task_definition)
        print("created new task defintion")
        print(result)
    except Exception as e:
        print("Failed to register new task definition.")
        raise e
    try:
        result = client.deregister_task_definition(taskDefinition=current_arn)
        print("deleted old task defintion")
        print(result)
    except Exception as e:
        print("Failed to 'de'register old task definition.")
        raise e
    return

def create_new_task_definition(
    task_definition,
    app_image,
    nginx_image,
):
    container_definitions = task_definition['containerDefinitions']
    app_container_definition = [*filter(lambda x: x['name'] == 'app', container_definitions)][0]
    nginx_container_definition = [*filter(lambda x: x['name'] == 'nginx', container_definitions)][0]
    other =  [*filter(lambda x: (x['name'] not in ['app', 'nginx']), container_definitions)]
    new_task_definition  = {
        **task_definition,
        'containerDefinitions': [
            {**app_container_definition, 'image': app_image},
            {**nginx_container_definition, 'image': nginx_image},
            *other,
        ]
    }
    del new_task_definition['taskDefinitionArn']
    del new_task_definition['revision']
    del new_task_definition['status']
    del new_task_definition['requiresAttributes']
    del new_task_definition['compatibilities']
    
    return new_task_definition