resource "aws_s3_bucket" "mlflow_bucket" {
  bucket = "mlflow-bucket-test-1012-seniorproj" # Change this to your desired bucket name

  tags = {
    Name = "mlflow_test"
  }
}

resource "aws_s3_bucket_ownership_controls" "mlflow_bucket_ownership" {
  bucket = aws_s3_bucket.mlflow_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "mlflow_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.mlflow_bucket_ownership]

  bucket = aws_s3_bucket.mlflow_bucket.id
  acl    = "private"
}