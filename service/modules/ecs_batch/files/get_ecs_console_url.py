import os

def get_ecs_console_url(cluster, result):
  try:
    tasks = result['tasks']
    task_arn = tasks[0]['taskArn']
    print(f"task arn = {task_arn}")
    region = os.environ['AWS_REGION']
    task_id = task_arn.split('/').pop()
    query = f"region={region}#/clusters/{cluster}/tasks/{task_id}/details"
    url = f"https://{region}.console.aws.amazon.com/ecs/home?{query}"
    print(url)
    return url
  except Exception as e:
    print("failed to process task result")
    raise e
  return