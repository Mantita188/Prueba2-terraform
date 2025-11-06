data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "proyecto2_c_y_a_web_server" {
  count = 2

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.web_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Servidor Web ${count.index + 1} de Proyecto 2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "proyecto2_c_y_a_web_server_${count.index + 1}"
  }
}