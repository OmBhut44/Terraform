terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }

    # Configure the Remote Backend -> it is done in s3.tf and dynamodb.tf files because we have created s3 bucket and dynamodb table there
  backend "remote" {
    bucket = "om-tf-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "om-tf-state-table"
  }
}

# mere terraform  remote backend use karega om-tf-state-bucket s3 bucket ko aur om-tf-state-table dynamodb table ko taaki mera terraform state file waha store ho jaye aur lock bhi ho jaye taaki multiple log ek sath same state file ko modify na kar paye.