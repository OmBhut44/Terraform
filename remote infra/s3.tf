resource "aws_s3_bucket" "remote_s3" {
  bucket = "om-tf-state-bucket"

  tags = {
    Name        = "om-tf-state-bucket"
  }
}