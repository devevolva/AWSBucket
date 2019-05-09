# AWS S3 Bucket
***
Terraform v0.11.13 + provider.aws v1.56.0 
<br />
Powershell v5.1.17763.316
***
Create an Amazon Web Services(AWS) Simple Storage Service(S3) bucket to store backup files.

Be sure to replace the bucket attribute, and any references to it, with your own unique bucket name.

'''
###############################################################################
# BUCKET ######################################################################
resource "aws_s3_bucket" "webCopy" {
  bucket    = "web-copy-test" # Replace with your unique name.
  acl       = "private"

  versioning {
    enabled = false
  }
}
'''