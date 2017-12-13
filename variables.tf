####### AWS Access and Region Details #############################
variable "access_key" { default = "____INSERT YOUR OWN_________" }
variable "secret_key" { default = "____INSERT YOUR OWN_________" }
variable "aws_region" {  
  default  = "eu-west-1" 
  description = "One of us-east-2, us-east-1, us-west-1, us-west-2, ap-south-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-northeast-1, ca-central-1, eu-central-1, eu-west-1, eu-west-2, sa-east-1"
}


####### AWS Deployment Details ####################################
# SSH Key
variable "key_name" { 
  default = "____INSERT YOUR OWN_________" 
  description = "Name of the EC2 key pair"
}
variable "privatekey" { default = "~/.ssh/id_rsa" }
variable "ssh_user" { 
  default = "ubuntu"
  description = "Most Ubuntu AMIs use Ubuntu as the default user. Normally safe to leave"
}

# VPC Details
variable "vpcname" { default = "icpvpc" }
variable "cidr" { default = "10.10.0.0/16" }

# Subnet Details
variable "subnetname" { default = "	icpsubnet" }
variable "subnet_cidr" {default = "10.10.0.0/24" }

# EC2 instances
variable "master" {
  type = "map"
  default = {
    nodes     = "1"
    type      = "t2.xlarge"
    ami       = "" // Leave blank to let terraform search for Ubuntu 16.04 ami. NOT RECOMMENDED FOR PRODUCTION
    disk      = "100" //GB
  }
}
variable "proxy" {
  type = "map"
  default = {
    nodes     = "1"
    type      = "t2.small"
    ami       = "" // Leave blank to let terraform search for Ubuntu 16.04 ami. NOT RECOMMENDED FOR PRODUCTION
    disk      = "25" //GB
  }
}
variable "worker" {
  type = "map"
  default = {
    nodes     = "2"
    type      = "t2.medium"
    ami       = "" // Leave blank to let terraform search for Ubuntu 16.04 ami. NOT RECOMMENDED FOR PRODUCTION
    disk      = "100" //GB
  }
}

variable "instance_name" { default = "myicp" }
variable "icppassword" { default = "MySecretP4ssw0RD" }


