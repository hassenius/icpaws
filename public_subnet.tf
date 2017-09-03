resource "aws_subnet" "icp_public_subnet" {
  vpc_id                  = "${aws_vpc.icp_vpc.id}"
  cidr_block              = "${ var.subnet_cidr }"
  map_public_ip_on_launch = true
  availability_zone = "${ var.aws_region }a"
  tags = {
  	Name =  "${ var.subnetname }"
  }
}
