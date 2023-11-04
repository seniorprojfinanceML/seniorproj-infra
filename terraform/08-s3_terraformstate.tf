resource "aws_s3_bucket" "terraform_state" {
 bucket = "terraform-up-and-running-state"
 # Prevent accidental deletion of this S3 bucket
 lifecycle {
 prevent_destroy = true
 }
}
