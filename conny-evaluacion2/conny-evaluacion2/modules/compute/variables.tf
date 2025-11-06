variable "private_subnet_ids" {
  description = "Lista de IDs de subredes privadas para las instancias"
  type        = list(string)
}

variable "web_sg_id" {
  description = "ID del security group para los web servers"
  type        = string
}