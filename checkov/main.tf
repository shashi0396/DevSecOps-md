provider "aws" {
  region = "us-east-1"
}

# VULNERABILITY 1: S3 Bucket without versioning, logging, or encryption
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-company-vulnerable-bucket-123"
}

# VULNERABILITY 2: Publicly accessible S3 ACL (Deprecated but heavily flagged)
resource "aws_s3_bucket_acl" "vulnerable_bucket_acl" {
  bucket = aws_s3_bucket.vulnerable_bucket.id
  acl    = "public-read"
}

# VULNERABILITY 3: Security Group leaving SSH open to the entire internet
resource "aws_security_group" "web_sg" {
  name        = "allow_all_ssh"
  # checkov:skip=CKV_AWS_24: "This is a dedicated Bastion host, SSH access from 0.0.0.0/0 is required."
  description = "Allow SSH from anywhere"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  user_data_base64 = "IyEvYmluL2Jhc2gKZWNobyAiSGVsbG8gV29ybGQiID4gL3RtcC9oZWxsby50eHQ="
}

resource "aws_db_instance" "production_database" {
  allocated_storage = 20
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = "admin123"
}