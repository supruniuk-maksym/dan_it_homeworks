import boto3

# Define the tag key and value to filter EC2 instances
TAG_KEY = "Name"  # The key of the tag
TAG_VALUE = "pblc_max"  # The value of the tag

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Get all running EC2 instances that have the specified tag
    response = ec2.describe_instances(
        Filters=[
            {"Name": f"tag:{TAG_KEY}", "Values": [TAG_VALUE]},  # Filter by tag
            {"Name": "instance-state-name", "Values": ["running"]}  # Only running instances
        ]
    )

    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])  # Collect instance IDs

    if instance_ids:
        print(f"Stopped instances: {instance_ids}")
        ec2.stop_instances(InstanceIds=instance_ids)  # Stop the filtered instances
    else:
        print("No running instances found with the specified tag.")

