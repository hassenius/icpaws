resource "aws_internet_gateway" "icp_gw" {
  vpc_id = "${aws_vpc.icp_vpc.id}"
  tags {
        Name = "InternetGateway"
    }
}
