resource "aws_vpc" "icp_vpc" {
  cidr_block = "${ var.cidr }"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${ var.vpcname }"
  }
}

resource "aws_internet_gateway" "icp_gw" {
  vpc_id = "${aws_vpc.icp_vpc.id}"
  tags {
        Name = "InternetGateway"
    }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.icp_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.icp_gw.id}"
}

resource "aws_subnet" "icp_public_subnet" {
  vpc_id                  = "${aws_vpc.icp_vpc.id}"
  cidr_block              = "${ var.subnet_cidr }"
  map_public_ip_on_launch = true
  availability_zone = "${ var.aws_region }a"
  tags = {
  	Name =  "${ var.subnetname }"
  }
}

/* Default security group */
resource "aws_security_group" "default" {
  name = "icp_default_sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.icp_vpc.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${ var.cidr }"]
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags {
    Name = "${ var.vpcname }"
  }
}
