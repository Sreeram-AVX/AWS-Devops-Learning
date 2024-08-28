# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg"
  }
}

# Create a Linux EC2 instance
resource "aws_instance" "linux" {
  ami                   = "ami-066784287e358dad1"  # Amazon Linux 2 AMI ID for us-east-1
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "linux-instance"
  }
}

resource "aws_instance" "linux2" {
  ami                   = "ami-066784287e358dad1"  # Amazon Linux 2 AMI ID for us-east-1
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "linux-instance2"
  }
}
