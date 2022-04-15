##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "vpc_webapp" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "webapp_igw" {
  vpc_id = aws_vpc.vpc_webapp.id

  tags = local.common_tags
}

resource "aws_subnet" "web-1a" {
  cidr_block              = var.vpc_subnets_cidr_block[0]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = local.common_tags
}

resource "aws_subnet" "web-1b" {
  cidr_block              = var.vpc_subnets_cidr_block[1]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

resource "aws_subnet" "app-1a" {
  cidr_block              = var.vpc_subnets_cidr_block[2]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = local.common_tags
}

resource "aws_subnet" "app-1b" {
  cidr_block              = var.vpc_subnets_cidr_block[3]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "webapp-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block       = "0.0.0.0/0"
    ipv6_cidr_blocks = ["::/0"]
    gateway_id       = aws_internet_gateway.webapp_igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-web-1a" {
  subnet_id      = aws_subnet.web-1a.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_route_table_association" "rta-web-1b" {
  subnet_id      = aws_subnet.web-1b.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_route_table_association" "rta-app-1a" {
  subnet_id      = aws_subnet.app-1a.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_route_table_association" "rta-app-1b" {
  subnet_id      = aws_subnet.app-1b.id
  route_table_id = aws_route_table.webapp-rt.id
}


# SECURITY GROUPS #

# Webapp security group 
resource "aws_security_group" "web-sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.vpc_webapp.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 81 access from VPC
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # SSH access from MyIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["165.225.117.61/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

# App security group 
resource "aws_security_group" "app-sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.vpc_webapp.id

  # Port 8080,8443 access from web-1a
  ingress {
    from_port   = 8080
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_subnets_cidr_block[0]]
  }

  # Port 8080,8443 access from web-1b
  ingress {
    from_port   = 8080
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_subnets_cidr_block[1]]
  }

  # SSH access from MyIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["165.225.117.61/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

# DB security group 
resource "aws_security_group" "db-sg" {
  name   = "db-sg"
  vpc_id = aws_vpc.vpc_webapp.id

  # Port 3306 access from app-1a
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_subnets_cidr_block[2]]
  }

  # Port 3306 access from app-1b
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_subnets_cidr_block[3]]
  }

  # SSH access from MyIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["165.225.117.61/32"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}