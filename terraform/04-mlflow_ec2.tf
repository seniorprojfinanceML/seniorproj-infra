data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_security_group" "mlflow_test_sg" {
  name        = "mlflow_test_sg"
  description = "Example security group that allows SSH and TCP port 5000"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP Port 5000"
    from_port   = 5000
    to_port     = 5000
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
    Name = "mlflow_test"
  }
}

resource "aws_network_interface" "mlflow_nic" {
  subnet_id       = tolist(data.aws_subnets.default.ids)[0]
  security_groups = [aws_security_group.mlflow_test_sg.id]
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0a481e6d13af82399" # Example AMI ID, you'll need to replace it with an actual AMI available in your region
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.mlflow_nic.id
    device_index         = 0
  }

  tags = {
    Name = "mlflow_test"
  }

  key_name = aws_key_pair.my_key_pair.key_name
}