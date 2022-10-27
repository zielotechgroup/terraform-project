terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_subnet" "dev-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "dev-terraform-subnet"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "terraform vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "example-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example-rt"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.example-rt.id
}


resource "aws_instance" "terraform-instance" {
  # us-west-2
  ami           = var.image_id
  instance_type = "t2.micro"

  private_ip = "10.10.1.15"
  subnet_id  = aws_subnet.dev-subnet.id
  key_name= "terraform"

  tags = {
    Name = var.instance-name
  }
}


resource "aws_eip" "my-eip"{
  instance = aws_instance.terraform-instance.id
  vpc      = true
  depends_on = [
    aws_internet_gateway.gw
  ]
}
