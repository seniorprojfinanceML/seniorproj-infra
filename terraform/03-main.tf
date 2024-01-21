provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "cap_aws_sg" {
  name = "postgresql-rds-sg"

  ingress {
    from_port = 5432
    to_port   = 5432
    # from_port   = 0
    # to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    # from_port   = 0
    # to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "seniorproj_db" {
  identifier              = "maindb-seniorproj"
  engine                  = "postgres"
  engine_version          = "14.7"
  instance_class          = "db.t3.micro"
  db_name                 = "seniorproj_maindb"
  username                = var.db_username
  password                = var.db_password
  allocated_storage       = 20
  storage_type            = "gp2"
  publicly_accessible     = true
  backup_retention_period = 2
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.cap_aws_sg.id]

  tags = {
    Name = "seniorproj_db"
  }
}
