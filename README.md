# Terraform ICP SoftLayer

These TerraForm example templates uses the [AWS Provider](https://www.terraform.io/docs/providers/aws/) to provision networks and servers in AWS
and [TerraForm Module ICP Deploy](https://github.com/ibm-cloud-architecture/terraform-module-icp-deploy) to deploy [IBM Cloud Private](https://www.ibm.com/cloud-computing/products/ibm-cloud-private/) on them.


### Pre-requisits

* Working version of [Terraform](https://www.terraform.io/downloads.html)
* AWS Credentials

### Get it working

1. Clone this repository
2. Edit the [variables.tf](variables.tf) file inserting your own credentials, setting the relevant region and AMI details you desire
3. Pull down the required Terraform providers and modules `terraform init`
4. Review terraform execution plan `terraform plan`
5. Apply the terraform template `terraform apply`

