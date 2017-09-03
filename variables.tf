variable "access_key" { default = "ur_accesskey" }
variable "secret_key" { default = "ur_secretkey" }
variable "aws_region" {  default     = "us-east-1" }

# SSH Key
variable "mypublickey" { default = "ur_public_key" }
variable "myprivatekey" { default = "ur_private_key" }

# VPC Details
variable "vpcname" { default = "icpvpc" }
variable "cidr" { default = "192.168.0.0/16" }

# Subnet Details
variable "subnetname" { default = "icpprivsubnet" }
variable "subnet_cidr" {default = "192.168.1.0/24" }

# AMIs details for Ubuntu 16.04 LTS
#variable "aws_amis" { default = "ami-e69d0ff0" }
variable "aws_ami" { default = "ami-cd0f5cb6" }
variable "instance_type" { default = "t2.medium" }
variable "instance_name" { default = "eicp" }
variable "disk_size" { default = 50 }
variable "nodeuserid" { default = "ubuntu" }
variable "icpuser" { default = "admin" }
variable "icppassword" { default = "ibmISgre@t" }

# ICp node count
variable "nodecount" { default = 3 }
