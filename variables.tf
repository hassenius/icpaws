variable "access_key" { default = "xxxxxxx" }
variable "secret_key" { default = "xxxxxx" }
variable "aws_region" {  default     = "xxxxxxx" }

# SSH Key
variable "mypublickey" { default = "xxxxxxx" }
variable "myprivatekey" { default = "xxxxxxx" }

# VPC Details
variable "vpcname" { default = "xxxxxxx" }
variable "cidr" { default = "xxxxxxx" }

# Subnet Details
variable "subnetname" { default = "xxxxxxx" }
variable "subnet_cidr" {default = "xxxxxxx" }

# AMIs details for Ubuntu 16.04 LTS
variable "aws_ami" { default = "xxxxxxx" }
variable "instance_type" { default = "xxxxxxx" }
variable "instance_name" { default = "xxxxxxx" }
variable "disk_size" { default = xxxxxxx }
variable "nodeuserid" { default = "xxxxxxx" }
variable "icpuser" { default = "xxxxxxx" }
variable "icppassword" { default = "ixxxxxxx" }

# ICp node count other master node. If number is 3, four nodes will be created
variable "nodecount" { default = xxxxxxx }
