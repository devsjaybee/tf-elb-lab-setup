#  INSTANCES #
resource "aws_instance" "web1" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-1a.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
 
  user_data = <<EOF
#! /bin/bash
sudo yum update
sudo yum search docker
sudo yum info docker
sudo yum install docker

wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose

sudo systemctl enable docker.service
sudo systemctl start docker.service

EOF

  tags = local.common_tags

}