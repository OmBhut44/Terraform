resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "om-tf-state-table"
#   billing_mode   = "PROVISIONED" # ek bar bana ke rakh dia fir pure month uska bill aa raha hai 
  billing_mode   = "PAY_PER_REQUEST" # this will give the bill per month 
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S" # S means string
  }
  
  tags = {
    Name        = "om-tf-state-table" 
  }
}