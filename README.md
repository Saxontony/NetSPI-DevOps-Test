# NetSPI - DevOps Screening Test

# Number 1 - 10 represents answers to this test and which resource and file was implemented to solve this

Through AWS console, provision an Elastic IP. Assign a tag “Project” with value “NetSPI_EIP” to it. Once it's available, write a Terraform code to implement following infrastructure resources:
1. 
                Created an Elastic IP
                "Tag": 
                    "Key": “Project”
                    "Value": “NetSPI_EIP” 

                Allocated: 54.235.138.246
                Allocation ID: eipalloc-020a23a6c96df045e

-   _S3 bucket with private access permissions_
2. Created via file s3.tf

-   _EFS volume_
3. Created via file efs.tf

-   _An EC2 instance with SSH access_
4. Created via file ec2.tf

-   _All required resources like VPC, Subnets, Security Groups etc. to provision above mentioned resources_
5. created via file network-sg.tf


### These resources should fulfil following requirements:
- _An elastic IP provisioned in the step #1 should be assigned to the provisioned EC2 instance for its public IP_
6. done on resource "aws_eip_association.eip-association" via file ec2.tf

- _An EFS volume should be mounted on the EC2 instance at /data/test while it boots up_
7. done on  resource "null_resource.configure_nfs" via file efs.tf


- _One should be able to write data to mounted EFS volume_
8. policy to write data  to EFS Volume is created on resource "aws_efs_file_system_policy.policy" via file policy&role.tf
   also attached on role through resource "aws_iam_policy_attachment.efs_write_policy"  

- _One should be able to write data to the provisioned S3 bucket (No AWS credentials should be stored/set on the EC2 instance)_
9. policy for s3 to write data is on resource "aws_iam_role_policy.s3_policy" via file policy&role.tf
   It is assigned to a role on resource "aws_iam_role.ec2_role"
   Its attached on the ec2 instance profile resource "aws_iam_instance_profile.ec2_profile"

- _Terraform should display S3 Bucket ID, EFS volume ID, EC2 instance ID, Security Group ID, Subnet ID as part of output generated by Terraform apply command_
10. via file outputs.tf

_ terraform init
- terraform apply --auto-approve 
will enable everything