provider "aws" {
    region = var.aws_region
  
}

module "my_ec2_instance" {
    source = "./ec2"
    instance_name = var.instance_name
    ami_id = var.ami_sample
    instance_type  = var.instance_type
  
}




# terraform apply -var-file=stage.tfvars