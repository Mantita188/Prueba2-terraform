module "network" {
  source = "./modules/network"
  my_ip  = var.my_ip
}

module "compute" {
  source = "./modules/compute"

  private_subnet_ids = module.network.private_subnets
  web_sg_id          = module.network.web_sg_id
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "proyecto2_c_y_a_s3_bucket" {
  bucket = "proyecto2-c-y-a-s3-${random_id.bucket_suffix.hex}"
  tags = { Name = "proyecto2_c_y_a_s3_bucket" }
  object_lock_enabled = false
}

resource "aws_s3_bucket_public_access_block" "proyecto2_c_y_a_s3_pab" {
  bucket                  = aws_s3_bucket.proyecto2_c_y_a_s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "proyecto2_c_y_a_s3_ownership" {
  bucket = aws_s3_bucket.proyecto2_c_y_a_s3_bucket.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_acl" "proyecto2_c_y_a_s3_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.proyecto2_c_y_a_s3_pab,
    aws_s3_bucket_ownership_controls.proyecto2_c_y_a_s3_ownership,
  ]
  bucket = aws_s3_bucket.proyecto2_c_y_a_s3_bucket.id
  acl    = "public-read"
}

resource "aws_lb" "proyecto2_c_y_a_alb" {
  name               = "proyecto2-c-y-a-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.network.alb_sg_id]
  subnets            = module.network.public_subnets
  tags               = { Name = "proyecto2_c_y_a_alb" }
}

resource "aws_lb_target_group" "proyecto2_c_y_a_tg" {
  name     = "proyecto2-c-y-a-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
  tags     = { Name = "proyecto2_c_y_a_tg" }
}

resource "aws_lb_listener" "proyecto2_c_y_a_http_listener" {
  load_balancer_arn = aws_lb.proyecto2_c_y_a_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proyecto2_c_y_a_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "proyecto2_c_y_a_web_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.proyecto2_c_y_a_tg.arn
  target_id        = module.compute.instance_ids[count.index]
  port             = 80
}

# --- RECURSOS DE BASE DE DATOS (RDS) ---
resource "aws_db_subnet_group" "proyecto2_c_y_a_db_subnet_group" {
  name       = "proyecto2-c-y-a-db-subnet-group"
  subnet_ids = module.network.private_subnets
  tags = {
    Name = "proyecto2_c_y_a_db_subnet_group"
  }
}

resource "aws_db_instance" "proyecto2_c_y_a_db" {
  # Los identificadores de BD no pueden tener "_"
  identifier           = "proyecto2-c-y-a-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "proyecto2db"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [module.network.db_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.proyecto2_c_y_a_db_subnet_group.name
  publicly_accessible  = true
  skip_final_snapshot  = true
  tags = { Name = "proyecto2_c_y_a_db" }
}
