output "instance_ids" {
  description = "Lista de IDs de las instancias EC2 creadas"
  value       = aws_instance.proyecto2_c_y_a_web_server[*].id
}