output "static_website_dns_name" {
  description = "The DNS name of the static website for access through a browser"
  value       = aws_s3_bucket.static_website.website_domain
}