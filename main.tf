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

resource "aws_security_group" "AlbEcsSg" {
  description = "Allow Https to from ALB"
  name = var.alb_ecs_sg_name
  tags = {
    Name = var.alb_ecs_sg_name
    Project = "RP"
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
resource "aws_security_group" "PrivateEcsSg" {
  description = "Private SG for containers"
  name = var.private_ecs_sg_name
  tags = {
    Project = "RP"
    Name = "RP-ECS-Private-SG"
  }
  vpc_id = var.vpc-id
  ingress {
    security_groups = [
      aws_security_group.AlbEcsSg.id
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
  ingress {
    cidr_blocks = [
      "192.168.11.0/24"
    ]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
  }
  ingress {
    cidr_blocks = [
      "192.168.8.0/24"
    ]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
  }
  ingress {
    security_groups = [aws_security_group.PrivateEcsSg.id]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
  }
  ingress  {
    security_groups  = [aws_security_group.AlbEcsSg.id]
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
  }
}