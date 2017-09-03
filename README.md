# icpaws
This installs IBM Cloud private 1.2.0 to AWS 

**Assumptions**
- Access to AWS ( Need Access Key and Access Secret)
- SSH key (both public and private) to be imported into AWS for AWS keypair ( http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws )
- AWS accey key has sufficient roles to create VPC, Subnet, Keypair, Security Group, EC2 instance...
- IBM Cloud private images are available in the same directory as these files
- Terraform is download and available ( It can be downloaded from https://www.terraform.io/downloads.html )
- The instances can access OS repository when cloned
- Docker Images repository is accessible

**Procedure**
To kick off installing the ICp cluster, edit variables.tf and replace 'xxx..' with appropriate values. The various required values are tabulated below

| Variable Name | Example Value | Description |
| ------------- | ------------- | ----------- |
| access\_key | AEGHIJK | AWS Access Key |
| secret\_key | Tijklmnopqe12345zxseeiee | Secret key to access the AWS account |
| mypublickey | /Users/xxx/.ssh/myawskey.pem.pub | Public Key which is being used to create a key pair in AWS |
| myprivatekey |  /Users/xxx/.ssh/myawskey.pem | Corresposnding private key for the public key used to login to instances |
| vpcname | icpvpc | Name of the VPC that will be created |
| cidr | 192.168.0.0\/16 | CIDR of the vpc address |
| subnetname | 192.168.1.0\/24 | CIDR address of the subnet that will be created|
| subnet\_cidr | datastore1 | VMware Datastore Name |
| aws\_ami | ami\-cd0f5cb6 | AMI id for the template in the region that will be used |
| instance\_type | t2.medium | Instance size |
| instance\_name | eicp | Prefix for the instances |
| disk\_size | 100 | Size of the root partition |
| nodeuserid | ubuntu | UserID to be used to login to the instance |
| icpuser | admin | UserID for ICp to login |
| icppassword | xxxxxxxxx | Password for the ICp user |
| nodecount | 4 | Nodecount other than boot and master node |


- As part of deployment, the script creates a VPC, a keypair, a security group, a subnet and nodecount + 1 nodes with the size mentioned in instance_type.
- Download the files from the git repository to a local filesystem
- Copy IBM Cloud private images to the same directory 
- Updates the certificate too

```
Example:
ibm-cloud-private-installer-1.2.0.tar.gz  ibm-cloud-private-x86_64-1.2.0.tar.gz  icpinst.zip aws.tf awskey.tf vpc.tf public_subnet.tf internet_gateway.tf icp_route.tf icp_def_sg.tf variables.tf instances.tf
```
- Initialize terraform
   terraform init
- Test the temaples
  terraform plan
- Deploy the Product
  terraform apply
- Delete
  terraform destroy -force ( from same directory where apply was run )
  
 ** End **
