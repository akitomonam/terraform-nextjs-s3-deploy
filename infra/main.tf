provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "web_hosting_bucket" {
  bucket = "test-deployed-by-terraform"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "web_hosting_bucket_public_access_block" {
  bucket = aws_s3_bucket.web_hosting_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.web_hosting_bucket.id
  policy = data.aws_iam_policy_document.policy_document.json
  depends_on = [
    aws_s3_bucket_public_access_block.web_hosting_bucket_public_access_block,
  ]
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid    = "Statement1"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.web_hosting_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "web_hosting_bucket_config" {
  bucket = aws_s3_bucket.web_hosting_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "../frontend/out"
}

resource "aws_s3_object" "bucket_object" {
  for_each     = module.template_files.files
  bucket       = aws_s3_bucket.web_hosting_bucket.id
  key          = each.key
  source       = each.value.source_path
  content_type = each.value.content_type
  etag         = filemd5(each.value.source_path)
}
