/*terraform {
  backend "s3" {
    bucket = "terraform_devops_terra"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock-dynamo" # DynamoDB table used for state locking, note: first run "day-4-resources-s3-dynamodb-for-statefile" to create s3 and dynamodb resources
    encrypt        = true  # Ensures the state is encrypted at rest in S3.
  }
} */