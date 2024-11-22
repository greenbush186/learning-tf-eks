import boto3
import argparse

from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

def empty_and_delete_bucket(bucket_name, region='ap-southeast-2'):
    s3 = boto3.client('s3', region_name=region)
    s3_resource = boto3.resource('s3', region_name=region)
    
    try:
        # Check if the bucket exists
        buckets = s3.list_buckets()['Buckets']
        if bucket_name not in [bucket['Name'] for bucket in buckets]:
            print(f"Bucket '{bucket_name}' does not exist.")
            return
        
        # Get the bucket
        bucket = s3_resource.Bucket(bucket_name)
        
        # Delete all objects (including versioned objects)
        print(f"Emptying bucket '{bucket_name}'...")
        bucket.object_versions.delete()
        print(f"All objects and versions deleted from bucket '{bucket_name}'.")

        # Delete the bucket
        print(f"Deleting bucket '{bucket_name}'...")
        bucket.delete()
        print(f"Bucket '{bucket_name}' deleted successfully.")
    
    except NoCredentialsError:
        print("Error: No AWS credentials found.")
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials.")
    except ClientError as e:
        print(f"Client error: {e.response['Error']['Message']}")

def delete_dynamodb_table(table_name, region='ap-southeast-2'):
    # Initialize the DynamoDB client
    dynamodb = boto3.client('dynamodb', region_name=region)

    try:
        # Check if the table exists
        existing_tables = dynamodb.list_tables()['TableNames']
        if table_name not in existing_tables:
            print(f"Table '{table_name}' does not exist.")
            return

        # Delete the table
        print(f"Deleting DynamoDB table '{table_name}'...")
        dynamodb.delete_table(TableName=table_name)

        # Wait for the table to be deleted
        waiter = dynamodb.get_waiter('table_not_exists')
        waiter.wait(TableName=table_name)
        print(f"DynamoDB table '{table_name}' deleted successfully.")

    except NoCredentialsError:
        print("Error: No AWS credentials found.")
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials.")
    except ClientError as e:
        print(f"Client error: {e.response['Error']['Message']}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check if an S3 bucket exists, and create it with versioning if it does not.")
    parser.add_argument("bucket_name", help="The name of the S3 bucket to empty and delete.")
    parser.add_argument("table_name", help="The name of the DynamoDB table to delete.")
    parser.add_argument("--region", default="ap-southeast-2", help="The AWS region for the bucket and dynomodb table. Default is 'ap-southeast-2'.")
      
    args = parser.parse_args()
    # print(args.bucket_name)
    empty_and_delete_bucket(args.bucket_name, args.region)
    delete_dynamodb_table(args.table_name, args.region)