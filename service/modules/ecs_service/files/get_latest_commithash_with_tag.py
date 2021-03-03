import boto3

client = boto3.client('ecr')

def get_latest_commithash_with_tag(repository_name, image_tag):
    try:
        latest_images = client.describe_images(
            repositoryName=repository_name,
            imageIds=[{'imageTag': image_tag }],
        )
        image_details = latest_images['imageDetails']
        if len(latest_images) < 1:
            print(f"Image with tag {image_tag} not found")
            return None
        latest_image_detail = image_details[0]
        latest_image_tags = [
            tags for image_detail in image_details
            if len(tags:=get_image_tag_other_than(image_detail, image_tag)) > 0
        ]
        print (latest_image_tags)
        if len(latest_image_tags) < 1:
            print(f"No other image with tag than {image_tag} found.")
            return None
        return latest_image_tags[0][0]
    except Exception as e:
        print("Failed to get latest image commithash.")
        print(type(e))
        print(e.args)
        print(e)
        return None


def get_image_tag_other_than(image_detail, image_tag):
    return [*filter(lambda x: x != image_tag, image_detail['imageTags'])]