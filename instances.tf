#  INSTANCES #
resource "aws_instance" "web1" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-1a.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  private_ip             = "172.31.1.21"
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
EOF

  tags = local.common_tags

}

resource "aws_instance" "web2" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-1b.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  private_ip             = "172.31.2.22"
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
EOF

  tags = local.common_tags

}

resource "aws_instance" "web3" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-1b.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  private_ip             = "172.31.2.23"
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
EOF

  tags = local.common_tags

}

# app instances

resource "aws_instance" "app1" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-1a.id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  private_ip             = "172.31.101.21"
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
EOF

  tags = local.common_tags

}

resource "aws_instance" "app2" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-1b.id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  private_ip             = "172.31.102.22"
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
EOF

  tags = local.common_tags

}

resource "aws_instance" "app3" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-1b.id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  private_ip             = "172.31.102.23"
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
EOF

  tags = local.common_tags

}

# db instance

resource "aws_instance" "db" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app-1a.id
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  private_ip             = "172.31.101.99"
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
EOF

  tags = local.common_tags

}