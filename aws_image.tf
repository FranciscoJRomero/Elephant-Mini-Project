provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0fe653310fa0fae9a"
  instance_type   = "t2.micro"
  key_name = aws_key_pair.auth.id
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo nginx &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 1
  max_size = 1
  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-elephant-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "terraform-elephant-example"
  availability_zones = data.aws_availability_zones.all.names
  security_groups    = [aws_security_group.elb.id]
  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
    # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}

data "aws_availability_zones" "all" {}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "The domain name of the load balancer"
}

resource "aws_key_pair" "auth" {
  key_name   = "Terraform key"
  public_key = file("~/.ssh/id_rsa.pub")
  lifecycle {
    ignore_changes = [public_key]
  }
}
