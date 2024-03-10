module "template_files" {
  source = "hashicorp/dir/template"
  base_dir = "C:/Users/gregp/OneDrive/Documents/CloudResume/aws-cloud-resume-challenge/website"
}

resource "aws_s3_bucket" "gjd_crc_prod_bucket"{
    bucket = "gjd-crc-prod-bucket"
    tags = {
      project = "Cloud Resume Challenge"
    }
}

resource "aws_s3_bucket_policy" "crc_bucket_policy"{
    bucket = "gjd-crc-prod-bucket"
    policy = data.aws_iam_policy_document.crc_bucket_policy.json
}

data "aws_iam_policy_document" "crc_bucket_policy" {
    version = "2008-10-17"
    #id = "PolicyForCloudFrontPrivateContent"
    statement {
        actions = ["s3:GetObject"]
        effect = "Allow"
        sid = "AllowCloudFrontServicePrincipal"
        principals {
                type = "Service"
                identifiers = ["cloudfront.amazonaws.com"]
        }
        resources = [
            "${aws_s3_bucket.gjd_crc_prod_bucket.arn}/*"
            ]
        condition {
            test = "StringEquals"
            variable = "AWS:SourceArn"
            values = [aws_cloudfront_distribution.crc_prod_cfdist.arn]
        }
    }
}

resource "aws_s3_object" "website_files" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.gjd_crc_prod_bucket.id
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  #etag = each.value.digests.md5
}