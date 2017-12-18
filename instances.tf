## Search for a default Ubuntu image to allow this option
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "icpmaster" {
  count         = "${var.master["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.master["ami"] != "" ? var.master["ami"] : data.aws_ami.ubuntu.id }"
  instance_type = "${var.master["type"]}"
  subnet_id     = "${aws_subnet.icp_public_subnet.id}"
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]
  
  root_block_device {
    volume_size = "${var.master["disk"]}"
  }
  tags { 
    Name = "${format("${var.instance_name}-master%1d", count.index + 1) }" 
  }
  user_data = <<EOF
#!/bin/bash
echo "${format("${var.instance_name}-master%1d", count.index + 1)}" > /etc/hostname
hostname ${format("${var.instance_name}-master%1d", count.index + 1)}
EOF
}


resource "aws_instance" "icpproxy" {
  count         = "${var.proxy["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.proxy["ami"] != "" ? var.proxy["ami"] : data.aws_ami.ubuntu.id }"
  instance_type = "${var.proxy["type"]}"
  subnet_id     = "${aws_subnet.icp_public_subnet.id}"
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]
  
  root_block_device {
    volume_size = "${var.proxy["disk"]}"
  }
  tags { 
    Name = "${format("${var.instance_name}-proxy%1d", count.index + 1) }" 
  }
  user_data = <<EOF
#!/bin/bash
echo "${format("${var.instance_name}-proxy%1d", count.index + 1)}" > /etc/hostname
hostname ${format("${var.instance_name}-proxy%1d", count.index + 1)}
EOF
}

resource "aws_instance" "icpnodes" {
  count         = "${var.worker["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.worker["ami"] != "" ? var.worker["ami"] : data.aws_ami.ubuntu.id }"
  instance_type = "${var.worker["type"]}"
  subnet_id     = "${aws_subnet.icp_public_subnet.id}"
  vpc_security_group_ids = [ "${aws_security_group.default.id}" ]
  
  root_block_device {
    volume_size = "${var.worker["disk"]}"
  }
  tags { 
    Name = "${format("${var.instance_name}-worker%01d", count.index + 1) }" 
  }
  user_data = <<EOF
#!/bin/bash
echo "${format("${var.instance_name}-worker%1d", count.index + 1)}" > /etc/hostname
hostname ${format("${var.instance_name}-worker%1d", count.index + 1)}
EOF
}


module "icpprovision" {
    source = "github.com/ibm-cloud-architecture/terraform-module-icp-deploy.git?ref=1.0.0"
    icp-master = ["${aws_instance.icpmaster.public_ip}"]
    icp-worker = ["${aws_instance.icpnodes.*.public_ip}"]
    icp-proxy = ["${aws_instance.icpproxy.*.public_ip}"]
    
    icp-version = "ibmcom/icp-inception:2.1.0"

    /* Workaround for terraform issue #10857
     When this is fixed, we can work this out autmatically */
    cluster_size  = "${var.master["nodes"] + var.worker["nodes"] + var.proxy["nodes"]}"

    icp_configuration = {
      "network_cidr"              = "192.168.0.0/16"
      "service_cluster_ip_range"  = "172.16.0.1/24"
      "default_admin_password"    = "${var.icppassword}"
    }

    # We will let terraform generate a new ssh keypair 
    # for boot master to communicate with worker and proxy nodes
    # during ICP deployment
    generate_key = true
    
    # SSH user and key for terraform to connect to newly created SoftLayer resources
    # ssh_key is the private key corresponding to the public keyname specified in var.key_name
    ssh_user  = "ubuntu"
    ssh_key   = "${var.privatekey}"
    
} 

