# AWS S3 Bucket
***
Terraform v0.11.13 + provider.aws v1.56.0 
<br />
Powershell v5.1.17763.316
***
Create an Amazon Web Services(AWS) Simple Storage Service(S3) bucket to store backup files.

Be sure to replace the bucketName default with your own unique bucket name.

```
variable "bucketName" {
  description = "Bucket used to hold backup files."
  default = "web-copy-test" # Replace with your unique bucket name.
}

```
