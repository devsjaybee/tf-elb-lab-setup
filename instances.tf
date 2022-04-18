#  INSTANCES #
resource "aws_instance" "web1" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-1a.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
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