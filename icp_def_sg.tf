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

