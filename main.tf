resource "aws_security_group" "AlbSg" {
  description = "Allow Https traffic"
  name = var.alb_sg_name
  tags = {
    Name = var.alb_sg_name
    Project = "RP"
  }
  vpc_id = var.vpc-id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow Https"
    from_port = 443
    protocol = "tcp"
    to_port = 443
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow Https"
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
}

resource "aws_security_group" "PrivateEcsSg" {
  description = "Private SG for containers"
  name = var.private_ecs_sg_name
  tags = {
    Project = "RP"
    Name = var.private_ecs_sg_name
  }
  vpc_id = var.vpc-id
  ingress {
    security_groups = [
      aws_security_group.AlbSg.id
    ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow outbound"
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

}

resource "aws_security_group" "RDS-Sg" {
  description = "Private SG for DB"
  name = var.rds_sg_name
  tags = {
    Project = "RP"
    Name = var.rds_sg_name
  }
  vpc_id = var.vpc-id
  count = length(var.app_subnets)
  dynamic "ingress" {
    for_each = var.app_subnets
    content {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
}