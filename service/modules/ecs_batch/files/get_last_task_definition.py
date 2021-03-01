import boto3

client = boto3.client('ecs')

def get_last_task_definition(task_definition_family):
  print(f"getting task defition for {task_definition_family}")
  try:
    latest_definition = client.describe_task_definition(
      taskDefinition=task_definition_family,
    )
  except Exception as e:
    print("Failed to retrive task defintion")
    raise e
  try:
    arn = latest_definition["taskDefinition"]["taskDefinitionArn"]
    print(f"Arn of latest task definition = {arn}")
    return arn
  except Exception as e:
    print(f"Failed to get taskDefinition.taskDefinitionArn")
    raise e
