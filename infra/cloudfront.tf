locals {
    s3_origin_id = aws_s3_bucket.gjd_crc_prod_bucket.bucket_regional_domain_name
}

resource "aws_cloudfront_origin_access_control" "crc_cf_oac" {
    name = local.s3_origin_id
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "crc_prod_cfdist" {
    origin {
        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_control.crc_cf_oac.id
        }
      domain_name = local.s3_origin_id
      origin_id = local.s3_origin_id
    }
    
    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    default_cache_behavior {
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id
        viewer_protocol_policy = "https-only"
        compress = true
    }

    viewer_certificate {
      cloudfront_default_certificate = true
    }

    restrictions {
        geo_restriction {
          restriction_type = "none"
          locations = []
        }
    }
}