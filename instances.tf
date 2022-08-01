#  INSTANCES #
resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-subnets[(count.index % var.vpc_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  private_ip             = var.web_instance_private_ip[count.index]
  key_name               = var.aws_key_pair

  user_data = <<EOF
#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
docker version
sudo docker run -d -p 80:80 -p 443:443 -h web1 benpiper/mtwa:web
# sudo docker run -d -p 80:80 -p 443:443 -h web1 -e APPSERVER=" https://app.jaybeedev.xyz:8443" benpiper/mtwa:web 
EOF

  tags = local.common_tags

}


# app instances

resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-subnets[(count.index % var.vpc_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  private_ip             = var.app_instance_private_ip[count.index]
  key_name               = var.aws_key_pair

  user_data = <<EOF
#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
docker version
sudo docker run -d -h app1 -p 8080:8080 -p 8443:8443 benpiper/mtwa:app
EOF

  tags = local.common_tags

}

# db instance

resource "aws_instance" "db" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-subnets[1].id
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  private_ip             = "172.32.102.99"
  key_name               = var.aws_key_pair

  user_data = <<EOF
#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
docker version
sudo docker run -d -h db -p 3306:3306 benpiper/mtwa-db
EOF

  tags = local.common_tags

}