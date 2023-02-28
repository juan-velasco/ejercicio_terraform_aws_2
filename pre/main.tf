terraform {

  # No se permiten variables en la configuración del backend (se debe copiar tal cual)
  # ¡IMPORTANTE! La key debe cambiar para cada módulo o sobreescribirá otro estado provocando un error.
  backend "s3" {
    bucket         = "curso-terraform-state"
    dynamodb_table = "curso-terraform-locks"
    encrypt        = true
    key            = "pre/terraform.tfstate"
    profile        = "default"
    region         = "eu-west-3"
  }
}

# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "vpc-curso" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "vpc-curso-aws"
  }
}

resource "aws_subnet" "subred-curso-aws" {
  vpc_id            = aws_vpc.vpc-curso.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "vpc-curso-aws"
  }
}

resource "aws_network_interface" "nic-curso" {
  subnet_id   = aws_subnet.subred-curso-aws.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_nic_curso_aws"
  }
}

resource "aws_instance" "instancia-curso-aws" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic-curso.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

# resource "aws_internet_gateway" "gw-curso" {
#   vpc_id = aws_vpc.vpc-curso.id
# }

# resource "aws_eip" "curso-aws" {
#   instance = aws_instance.instancia-curso-aws.id
#   vpc      = true
# }