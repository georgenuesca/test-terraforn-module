// This is an AWS provider block
provider "aws" {
    region = "us-east-1"
    version = "~>3.14.1"
}

// required tags
// Define values for the lab environment's required tags
locals {
  tags = {
    ResourceOwner = var.user_id
    Name          = var.Name
    BusinessUnit  = "HPE-TERRAFORM"
    EndDate       = var.EndDate
    Lab           = "Lab 2"
  }
}

// This is an AWS resource block that creates an EC2 instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_latest.id
  instance_type = "t2.${var.size}"

  // Tag the instance with some metadata
  tags          = local.tags
  volume_tags   = local.tags
}

////////////////////////////////////////////////////////////////////////////////
// This queries AMIs that match the given criteria below. It is a more
// advanced concept, so you can safely ignore it during Lab 1.
//
// The AMI can also be queried manually by running:
// $ aws ec2 describe-images --owners self amazon --filters "Name=virtualization-type,Values=hvm" "Name=name,Values=amzn-ami-hvm-*" --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output tetx
////////////////////////////////////////////////////////////////////////////////
data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "name" {
  description = "First and last name of lab participant."
  type        = string
}

variable "email" {
  description = "Email address of the lab participant"
  type        = string
}
