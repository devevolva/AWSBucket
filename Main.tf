###############################################################################
# 
# S3 BUCKET
#
###############################################################################

###############################################################################
# TERRAFORM ###################################################################
terraform {
  required_version = ">= 0.11.11"
}


###############################################################################
# PROVIDERS ###################################################################
provider "aws" {
    region  = "us-east-1"
    version = "~> 1.56"
}


###############################################################################
# BUCKET ######################################################################
variable "bucketName" {
  description = "Bucket used to hold backup files."
  default = "web-copy-test"
}

resource "aws_s3_bucket" "webCopy" {
  bucket    = "${var.bucketName}"
  acl       = "private"

  versioning {
    enabled = false
  }
}


###############################################################################
# FILES #######################################################################
resource "aws_s3_bucket_object" "indexHtml" {
  bucket       = "${var.bucketName}"
  key          = "index.html"
  acl          = "public-read"
  source       = "website\\index.html"
  etag         = "${md5(file("website\\index.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.webCopy"] 
}

resource "aws_s3_bucket_object" "errorHtml" {
  bucket       = "${var.bucketName}"
  key          = "error.html"
  acl          = "public-read"
  source       = "website\\error.html"
  etag         = "${md5(file("website\\error.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "mainCss" {
  bucket       = "${var.bucketName}"
  key          = "main.css"
  acl          = "public-read"
  source       = "website\\main.css"
  etag         = "${md5(file("website\\main.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "normalizeCss" {
  bucket       = "${var.bucketName}"
  key          = "normalize.css"
  acl          = "public-read"
  source       = "website\\normalize.css"
  etag         = "${md5(file("website\\normalize.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "scriptsJs" {
  bucket       = "${var.bucketName}"
  key          = "scripts.js"
  acl          = "public-read"
  source       = "website\\scripts.js"
  etag         = "${md5(file("website\\scripts.js"))}"
  content_type = "text/javascript"
  depends_on   = ["aws_s3_bucket.webCopy"]
}


###############################################################################
# OTUPUTS #####################################################################
output "bucketARN" {
      value = "${aws_s3_bucket.webCopy.arn}"
  }
output "bucketName" {
      value = "${aws_s3_bucket.webCopy.bucket}"
  }

output "bucketId" {
      value = "${aws_s3_bucket.webCopy.id}"
  }