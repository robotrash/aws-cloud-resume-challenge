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
    bucket = aws_s3_bucket.gjd_crc_prod_bucket.id
    source = "../website"
    key = "new_object_key"
}