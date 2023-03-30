#policy for ec2 to write data on EFS

# Creating the AWS EFS System policy to transition files into and out of the file system.
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id
# The EFS System Policy allows clients to mount, read and perform 
# write operations on File system 
# The communication of client and EFS is set using aws:secureTransport Option
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}



#policy for ec2 to write data on s3
resource "aws_iam_policy" "s3_policy" {
  name = "s3_policy"
  path = "/"
  description = "Policy to provide permission to ec2"
#Terraform write up
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy012",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Resource": "${aws_s3_bucket.s3.arn}",
            "Action": [
                "s3:*Object",
                "s3:List*"
                
            ],
        }
    ]
}
POLICY
}

#role assuming policies

resource "aws_iam_role" "ec2_role" {
    name = "ec2_role"
    #Terraform expresssion result to valid JSON syntax
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ] 
    })

}

#attaching roles to the policy
resource "aws_iam_policy_attachment" "efs_policy_role" {
    name = "efs_write_attachment"
    roles = [aws_iam_role.ec2_role.name]
    policy_arn = aws_efs_file_system.efs.arn
}

#attaching roles to the policy
resource "aws_iam_policy_attachment" "s3_policy_role" {
    name = "s3_write_attachment"
    roles = [aws_iam_role.ec2_role.name]
    policy_arn = aws_iam_policy.s3_policy.arn
}

#attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2_profile"
    role = aws_iam_role.ec2_role.name
}

