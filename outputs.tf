output "aws_instance_public_dns" {
  value = aws_lb.web-lb.dns_name
}