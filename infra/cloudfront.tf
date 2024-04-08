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
        origin_access_control_id = aws_cloudfront_origin_access_control.crc_cf_oac.id
        domain_name = local.s3_origin_id
        origin_id = local.s3_origin_id
    }
    aliases = [ "resume.robotra.sh","www.resume.robotra.sh" ]
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

    /*viewer_certificate {
      cloudfront_default_certificate = true
    }*/

    viewer_certificate {
        acm_certificate_arn = "${aws_acm_certificate.crc_ssl_cert.arn}"
        minimum_protocol_version = "TLSv1.2_2021"
        ssl_support_method = "sni-only"
    }

    restrictions {
        geo_restriction {
          restriction_type = "none"
          locations = []
        }
    }

    depends_on = [ aws_acm_certificate.crc_ssl_cert ]
}

