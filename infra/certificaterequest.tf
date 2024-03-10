/*resource "aws_acm_certificate" "crc_ssl_cert" {
    domain_name = "resume.robotra.sh"
    validation_method = "DNS"
    key_algorithm = "RSA_2048"
    subject_alternative_names = ["www.resume.robotra.sh"]
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        project = "Cloud Resume Challenge"
    }
}*/