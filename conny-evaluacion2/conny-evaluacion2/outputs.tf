output "alb_dns_url" {
  description = "URL publica del Balanceador de Carga para ver el sitio web."
  value       = aws_lb.proyecto2_c_y_a_alb.dns_name
}

output "s3_bucket_name" {
  description = "Nombre de tu bucket S3."
  value       = aws_s3_bucket.proyecto2_c_y_a_s3_bucket.bucket
}

output "rds_database_endpoint" {
  description = "Endpoint (host) de la base de datos RDS para conectar DBeaver."
  value       = aws_db_instance.proyecto2_c_y_a_db.address
}