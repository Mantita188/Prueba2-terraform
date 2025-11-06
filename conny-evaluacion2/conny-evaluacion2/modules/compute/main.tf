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
              
              # Creamos el nuevo archivo index.html "bonito"
              cat > /var/www/html/index.html <<EOT
<html>
<head>
    <title>Evaluacion 2</title>
    <style>
        body { 
            font-family: 'Arial', sans-serif; 
            background-color: #fff0f5; /* Un fondo rosa pálido */
            color: #444; 
            text-align: center; 
            padding-top: 50px; 
        }
        h1 { 
            font-size: 3.5em; /* Título en grande */
            color: #d81b60; /* Un color magenta oscuro */
            margin-bottom: 10px;
        }
        h2 { 
            font-size: 2em; 
            color: #555; 
            margin-top: 0;
        }
        p { 
            font-size: 1.2em; 
            color: #777; 
            margin-top: 40px; 
        }
        .server-id {
            font-size: 1em;
            color: #aaa;
            margin-top: 30px;
        }
        .hearts {
            font-size: 2.5em;
            color: #e74c3c; /* Rojo */
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <h1>Evaluacion 2</h1>
    <h2>Infraestructura como codigo</h2>
    
    <div class="hearts">❤️ ❤️ ❤️</div>
    
    <h2>por Constanza y Arantza</h2>
    
    <p>Docente: Jorge Ramirez</p>
    
    <p class="server-id">(Servidor Web ${count.index + 1})</p>
</body>
</html>
EOT
              EOF

  tags = {
    Name = "proyecto2_c_y_a_web_server_${count.index + 1}"
  }
}