##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

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

resource "aws_subnet" "web-subnets" {
  count                   = var.vpc_subnet_count # add count to instances
  cidr_block              = var.web_subnets_cidr_block[count.index]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}

resource "aws_subnet" "app-subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.app_subnets_cidr_block[count.index]
  vpc_id                  = aws_vpc.vpc_webapp.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}


# ROUTING #
resource "aws_route_table" "webapp-rt" {
  vpc_id = aws_vpc.vpc_webapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp_igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-web-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.web-subnets[count.index].id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_route_table_association" "rta-app-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.app-subnets[count.index].id
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
    cidr_blocks = ["0.0.0.0/0"]
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
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Port 8080,8443 access from web-1b
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # SSH access from MyIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = [var.app_subnets_cidr_block[1]]
  }

  # Port 3306 access from app-1b
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.app_subnets_cidr_block[0]]
  }

  # SSH access from MyIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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