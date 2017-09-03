resource "aws_key_pair" "deployer" {
  key_name   = "icpd-key"
  public_key = "${ file(var.mypublickey) }"
}
