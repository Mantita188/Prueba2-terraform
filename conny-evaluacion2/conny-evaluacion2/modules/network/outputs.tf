output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}
output "alb_sg_id" {
  value = aws_security_group.proyecto2_c_y_a_alb_sg.id
}
output "web_sg_id" {
  value = aws_security_group.proyecto2_c_y_a_web_sg.id
}
output "db_sg_id" {
  value = aws_security_group.proyecto2_c_y_a_db_sg.id
}