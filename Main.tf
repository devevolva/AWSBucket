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
resource "aws_s3_bucket" "webCopy" {
  bucket    = "web-copy-test"
  acl       = "private"

  versioning {
    enabled = false
  }
}


###############################################################################
# FILES #######################################################################
resource "aws_s3_bucket_object" "indexHtml" {
  bucket       = "web-copy-test"
  key          = "index.html"
  acl          = "public-read"
  source       = "website\\index.html"
  etag         = "${md5(file("website\\index.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.webCopy"] 
}

resource "aws_s3_bucket_object" "errorHtml" {
  bucket       = "web-copy-test"
  key          = "error.html"
  acl          = "public-read"
  source       = "website\\error.html"
  etag         = "${md5(file("website\\error.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "mainCss" {
  bucket       = "web-copy-test"
  key          = "main.css"
  acl          = "public-read"
  source       = "website\\main.css"
  etag         = "${md5(file("website\\main.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "normalizeCss" {
  bucket       = "web-copy-test"
  key          = "normalize.css"
  acl          = "public-read"
  source       = "website\\normalize.css"
  etag         = "${md5(file("website\\normalize.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.webCopy"]
}

resource "aws_s3_bucket_object" "scriptsJs" {
  bucket       = "web-copy-test"
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