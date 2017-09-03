resource "aws_instance" "icpnodes" {
  count = "${ var.nodecount }"
  ami = "${ var.aws_ami }"
  instance_type = "${ var.instance_type }"
  subnet_id = "${ aws_subnet.icp_public_subnet.id }"
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]
  key_name = "icpd-key"
  root_block_device {
        volume_size = "${var.disk_size}"
  }
  tags { Name = "${format("${var.instance_name}node_%01d", count.index + 1) }" }
  user_data = <<EOF
#!/bin/bash
if grep -q -i ubuntu /etc/*release
then
  sudo apt-get -y install unzip
else
  sudo yum -y install unzip
fi
EOF
}

resource "aws_instance" "icpmaster" {
  ami = "${ var.aws_ami }"
  instance_type = "${ var.instance_type }"
  subnet_id = "${ aws_subnet.icp_public_subnet.id }"
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]
  key_name = "icpd-key"
  root_block_device {
        volume_size = "${var.disk_size}"
  }
  tags { Name = "${format("${var.instance_name}master") }" }
  user_data = <<EOF
#!/bin/bash
if grep -q -i ubuntu /etc/*release
then
  sudo apt-get -y install unzip
else
  sudo yum -y install unzip
fi
EOF

#copies the file from terraform machine and copies to EndPoint /tmp directory
  provisioner "file" {
      source = "${var.myprivatekey}"
      destination = "/tmp/icpsshkey"
      connection {
              type = "ssh"
              user = "${ var.nodeuserid }"
              private_key = "${file(var.myprivatekey)}"
       }
  }
  provisioner "file" {
      source = "./icpinst.zip"
      destination = "/tmp/icpinst.zip"
      connection {
              type = "ssh"
              user = "${ var.nodeuserid }"
              private_key = "${file(var.myprivatekey)}"
       }
  }
  provisioner "file" {
      source = "ibm-cloud-private-installer-1.2.0.tar.gz"
      destination = "/tmp/ibm-cloud-private-installer-1.2.0.tar.gz"
      #source = "./IBM_CLOUD_PRIVATE_1.2.1_INSTALLER.tar.gz"
      #destination = "/tmp/IBM_CLOUD_PRIVATE_1.2.1_INSTALLER.tar.gz"
      connection {
              type = "ssh"
              user = "${ var.nodeuserid }"
              private_key = "${file(var.myprivatekey)}"
       }
  }
  provisioner "file" {
      source = "ibm-cloud-private-x86_64-1.2.0.tar.gz"
      destination = "/tmp/ibm-cloud-private-x86_64-1.2.0.tar.gz"
      #source = "./IBM_CLOUD_PRIVATE_1.2.1_LNX_DOCKE.tar.gz"
      #destination = "/tmp/IBM_CLOUD_PRIVATE_1.2.1_LNX_DOCKE.tar.gz"
      connection {
              type = "ssh"
              user = "${ var.nodeuserid }"
              private_key = "${file(var.myprivatekey)}"
       }
  }
#Executes the script on EndPoint
  provisioner "remote-exec" {
      inline = [
                  "echo '${join(",", aws_instance.icpnodes.*.private_ip)}' > /tmp/test.txt",
                  "echo '${join(",", aws_instance.icpnodes.*.private_dns)}' > /tmp/test1.txt",
                  "echo ${aws_instance.icpmaster.private_ip} > /tmp/masterip.txt",
                  "mkdir -p /tmp/icpinstall; cd /tmp/icpinstall; unzip -q ../icpinst.zip; chmod 755 *; sudo ./masterinstall.sh ${ var.icpuser } ${ var.icppassword } ${ var.nodeuserid }",
                  "./postinstall.sh ${ var.nodeuserid }",
                  "sudo docker run -e LICENSE=accept --net=host -v /usr/local/bin:/data ibmcom/kubernetes:v1.6.1-ee cp /kubectl /data"
        ]
        connection {
                type = "ssh"
                user = "${ var.nodeuserid }"
                private_key = "${file(var.myprivatekey)}"
       }
  }
}

output "address" {
  value = "${aws_instance.icpmaster.public_ip.dns}"
}

output "ICpURL" {
  value = "http://${aws_instance.icpmaster.public_ip.dns}:8443"
}
