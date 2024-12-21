
#Creating my VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "Ben_Main_VPC" })
}
# Creating my Public Subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # Ensure instances in these subnets receive public IPs
  map_public_ip_on_launch = true
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs) # Create one subnet for each CIDR block
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index] # Use the current CIDR block
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# Data to fetch availability zones
data "aws_availability_zones" "available" {}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

# Add a route to the Internet Gateway
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table to Public Subnets
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# All security Groups

# Security Group for ALB:
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "ALB_security_group"
  tags = {
    Name = "Terraform ALB SG"
  }

  # Allow inbound HTTPS traffic from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic from ALB
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for EC2 Instances:
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "ec2_sg"
  tags = {
    Name = "Terraform EC2 SG"
  }

  # Allow all outbound traffic out of the EC2 instances
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for allowing traffic on port 80, you don't need the source_security_group_id here.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or leave this blank if traffic is controlled through another rule
  }
}

# To allow traffic from the ALB to the EC2 instances on port 80:
resource "aws_security_group_rule" "alb_to_ec2" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}


# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
}

# ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    path                = "/" # Adjust this if your app uses a different health check endpoint
    protocol            = "HTTP"
    interval            = 30 # Health check interval in seconds
    timeout             = 5  # Time to wait for a response
    healthy_threshold   = 2  # Number of successful checks to mark as healthy
    unhealthy_threshold = 2  # Number of failed checks to mark as unhealthy
  }
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  # Ensure EC2 instances use the 'ec2_sg' security group
  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id] # Specify the security group here
  }
  # user_data = base64encode(<<-EOF
  #             #!/bin/bash
  #             sudo yum update -y
  #             sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  #             sudo yum install -y httpd
  #             sudo systemctl enable httpd
  #             sudo systemctl start httpd
  #             echo "Hello from the ASG created by Ben Ahoure from Downtown Dallas!" > /var/www/html/index.html
  #             EOF
  # )
  user_data = base64encode(file("${path.module}/user-data.sh"))
}

# Auto Scaling Group

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = aws_launch_template.web_launch_template.latest_version
  }

  tag {
    key                 = "Name"
    value               = "ben-server-template"
    propagate_at_launch = true
  }
}
