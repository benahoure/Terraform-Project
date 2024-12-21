output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

# output "asg_instances" {
#   value = aws_autoscaling_group.asg.instances
# }
