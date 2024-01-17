resource "aws_db_subnet_group" "main" {
  name       = "${name}-${var.env}-sg"
  subnet_ids = var.subnets
  tags = merge(var.tags, {Name: "${env}-${component}" })
}

resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "APP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.allow_app_cidr
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, { Name : "${env}-${component}-sg" })
}

  resource "aws_launch_template" "main" {
    name_prefix   = "${name}-${var.env}"
    image_id      = data.aws_ami.ami.id
    instance_type = var.instance_type
    tags = merge(var.tags, { Name : "${env}-${component}-lt" })
  }
resource "aws_lb_target_group" "main" {
  name        = "${var.env}-${var.name}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id


  tags =merge(var.tags, { Name : "${env}-${component}-tg" })
}

  resource "aws_autoscaling_group" "main" {
    availability_zones = var.azs
    desired_capacity   = var.desired_capacity
    max_size           = var.max_size
    min_size           = var.min_size
    vpc_zone_identifier = var.subnets


    tags = merge(var.tags, { Name : "${env}-${component}" })
}


resource "aws_lb_target_group" "main" {
  name        = "${var.env}-${var.name}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  tags =merge(var.tags, { Name : "${env}-${component}-tg" })
}
