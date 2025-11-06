data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  name = "proyecto2-c-y-a-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags   = { Name = "proyecto2-c-y-a-subred-publica" }
  private_subnet_tags  = { Name = "proyecto2-c-y-a-subred-privada" }
  public_route_table_tags  = { Name = "proyecto2-c-y-a-rtb-publica" }
  private_route_table_tags = { Name = "proyecto2-c-y-a-rtb-privada" }
  nat_gateway_tags     = { Name = "proyecto2-c-y-a-nat-gateway" }
  tags                 = { Name = "proyecto2-c-y-a-vpc" }
}

resource "aws_security_group" "proyecto2_c_y_a_alb_sg" {
  name        = "proyecto2-c-y-a-alb-sg"
  description = "Permite trafico HTTP desde internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "proyecto2_c_y_a_alb_sg" }
}

resource "aws_security_group" "proyecto2_c_y_a_web_sg" {
  name        = "proyecto2-c-y-a-web-sg"
  description = "Permite HTTP desde el ALB y SSH desde mi IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.proyecto2_c_y_a_alb_sg.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.my_ip]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "proyecto2_c_y_a_web_sg" }
}

resource "aws_security_group" "proyecto2_c_y_a_db_sg" {
  name        = "proyecto2-c-y-a-db-sg"
  description = "Permite MySQL desde los servidores web Y mi IP (para validar)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.proyecto2_c_y_a_web_sg.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [var.my_ip]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "proyecto2_c_y_a_db_sg" }
}