# Provider
provider "aws" {
  region = "us-east-1"
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Variable for instance names
variable "instance_names" {
  default = ["app-server", "db-server"]
}

# EC2 Instances
resource "aws_instance" "ec2_instances" {
  for_each      = toset(var.instance_names) # loop through instance names
  ami           = data.aws_ami.amazon_linux.id
  security_group = "id of sg"
  instance_type = "t2.micro"

  tags = {
    Name = "${each.key}-${terraform.workspace}" # dynamic name
  }
}
