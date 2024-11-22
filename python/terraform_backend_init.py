import boto3
import argparse

from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

def check_or_create_bucket(bucket_name, region='ap-southeast-2'):
    # Initialize the S3 client
    s3_client = boto3.client('s3', region_name=region)
    
    try:
        # Check if the bucket exists
        response = s3_client.list_buckets()
        buckets = [bucket['Name'] for bucket in response['Buckets']]
        
        if bucket_name in buckets:
            print(f"Bucket '{bucket_name}' already exists.")
        else:
            # Create the bucket
            if region == 'us-east-1':
                s3_client.create_bucket(Bucket=bucket_name)
            else:
                s3_client.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': region}
                )
            print(f"Bucket '{bucket_name}' created successfully.")
        
            # Enable versioning
            s3_client.put_bucket_versioning(
                Bucket=bucket_name,
                VersioningConfiguration={'Status': 'Enabled'}
            )
            print(f"Versioning enabled for bucket '{bucket_name}'.")
    
    except NoCredentialsError:
        print("Error: No AWS credentials found.")
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials.")
    except ClientError as e:
        print(f"Client error: {e}")

def check_or_create_dynamodb_table(table_name, region='ap-southeast-2'):
    # Initialize the DynamoDB client
    dynamodb = boto3.client('dynamodb', region_name=region)
    
    try:
        # Check if the table exists
        existing_tables = dynamodb.list_tables()['TableNames']
        if table_name in existing_tables:
            print(f"DynamoDB table '{table_name}' already exists.")
        else:
            # Create the table
            response = dynamodb.create_table(
                TableName=table_name,
                KeySchema=[
                    {
                        'AttributeName': 'LockID',
                        'KeyType': 'HASH'  # Partition key
                    }
                ],
                AttributeDefinitions=[
                    {
                        'AttributeName': 'LockID',
                        'AttributeType': 'S'  # String
                    }
                ],
                BillingMode='PAY_PER_REQUEST',
            )
            print(f"DynamoDB table '{table_name}' is being created.")
            # Wait for the table to become active
            dynamodb.get_waiter('table_exists').wait(TableName=table_name)
            print(f"DynamoDB table '{table_name}' created successfully.")
    
    except NoCredentialsError:
        print("Error: No AWS credentials found.")
    except PartialCredentialsError:
        print("Error: Incomplete AWS credentials.")
    except ClientError as e:
        print(f"Client error: {e.response['Error']['Message']}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check if an S3 bucket exists, and create it with versioning if it does not.")
    parser.add_argument("bucket_name", help="The name of the S3 bucket to check or create.")
    parser.add_argument("table_name", help="The name of the DynamoDB table to check or create.")
    parser.add_argument("--region", default="ap-southeast-2", help="The AWS region for the bucket and dynomodb table. Default is 'ap-southeast-2'.")
      
    args = parser.parse_args()
    # print(args.bucket_name)
    check_or_create_bucket(args.bucket_name, args.region)
    check_or_create_dynamodb_table(args.table_name, args.region)