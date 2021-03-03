import boto3

client = boto3.client('ecs')

def get_lastest_task_definition(task_definition_family):
  print(f"getting task defition for {task_definition_family}")
  try:
    latest_definition = client.describe_task_definition(
      taskDefinition=task_definition_family,
    )
  except Exception as e:
    print("Failed to retrive task defintion")
    raise e
  try:
    task_definition = latest_definition["taskDefinition"]
    print(f"Latest task definition = {task_definition}")
    return task_definition
  except Exception as e:
    print(f"Failed to get taskDefinition")
    raise e
