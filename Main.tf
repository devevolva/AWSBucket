###############################################################################
# 
# S3 BUCKET
#
###############################################################################

# REGION ######################################################################
provider "aws" {
    region = "us-east-1"
}



# BUCKET ######################################################################
resource "aws_s3_bucket" "devevolvawebcopy" {
  bucket    = "devevolvawebcopy"
  acl       = "private"

  versioning {
    enabled = false
  }
}



# FILES #######################################################################
resource "aws_s3_bucket_object" "indexHtml" {
  bucket       = "devevolvawebcopy"
  key          = "index.html"
  acl          = "public-read"
  source       = "website\\index.html"
  etag         = "${md5(file("website\\index.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.devevolvawebcopy"] 
}

resource "aws_s3_bucket_object" "errorHtml" {
  bucket       = "devevolvawebcopy"
  key          = "error.html"
  acl          = "public-read"
  source       = "website\\error.html"
  etag         = "${md5(file("website\\error.html"))}"
  content_type = "text/html"
  depends_on   = ["aws_s3_bucket.devevolvawebcopy"]
}

resource "aws_s3_bucket_object" "mainCss" {
  bucket       = "devevolvawebcopy"
  key          = "main.css"
  acl          = "public-read"
  source       = "website\\main.css"
  etag         = "${md5(file("website\\main.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.devevolvawebcopy"]
}

resource "aws_s3_bucket_object" "normalizeCss" {
  bucket       = "devevolvawebcopy"
  key          = "normalize.css"
  acl          = "public-read"
  source       = "website\\normalize.css"
  etag         = "${md5(file("website\\normalize.css"))}"
  content_type = "text/css"
  depends_on   = ["aws_s3_bucket.devevolvawebcopy"]
}

resource "aws_s3_bucket_object" "scriptsJs" {
  bucket       = "devevolvawebcopy"
  key          = "scripts.js"
  acl          = "public-read"
  source       = "website\\scripts.js"
  etag         = "${md5(file("website\\scripts.js"))}"
  content_type = "text/javascript"
  depends_on   = ["aws_s3_bucket.devevolvawebcopy"]
}



# OTUPUTS #####################################################################
output "bucketARN" {
      value = "${aws_s3_bucket.devevolvawebcopy.arn}"
  }
output "bucketName" {
      value = "${aws_s3_bucket.devevolvawebcopy.bucket}"
  }

output "bucketId" {
      value = "${aws_s3_bucket.devevolvawebcopy.id}"
  }