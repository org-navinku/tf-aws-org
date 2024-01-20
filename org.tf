provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_organizations_organization" "example_org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]
  feature_set = "ALL"
}

resource "aws_organizations_account" "prod_account" {
  name      = "Prod"
  email     = "navinkumar_kc@outlook.com"
  role_name = "OrganizationAccountAccessRole"

  tags = {
    Environment = "Production"
  }

  # Associate with the "dev" organizational unit
  parent_id = aws_organizations_organizational_unit.prod.id

  # Ignore changes to role_name because there is no AWS Organizations API for reading it
  lifecycle {
    ignore_changes = [role_name]
  }
}

resource "aws_organizations_account" "dev_account" {
  name      = "Dev"
  email     = "navinkumar_az@outlook.com"
  role_name = "OrganizationAccountAccessRole"

  tags = {
    Environment = "Development"
  }

  # Associate with the "dev" organizational unit
  parent_id = aws_organizations_organizational_unit.dev.id

  # Ignore changes to role_name because there is no AWS Organizations API for reading it
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Create organizational units
resource "aws_organizations_organizational_unit" "prod" {
  name      = "prod"
  parent_id = aws_organizations_organization.example_org.roots[0].id # Root of the organization
}

resource "aws_organizations_organizational_unit" "dev" {
  name      = "dev"
  parent_id = aws_organizations_organization.example_org.roots[0].id # Root of the organization
}

# resource "aws_organizations_organizational_unit" "qa" {
#   name      = "qa"
#   parent_id = aws_organizations_organization.example_org.roots[0].id # Root of the organization
# }

# resource "aws_organizations_organizational_unit" "uat" {
#   name      = "UAT"
#   parent_id = aws_organizations_organization.example_org.roots[0].id # Root of the organization
# }

# Enable Service Control Policy (SCP) type for the root
resource "null_resource" "enable_scp_type" {
  provisioner "local-exec" {
    command = <<-EOT
      $rootId = "${aws_organizations_organization.example_org.roots[0].id}"
      $command = "aws organizations enable-policy-type --root-id `$rootId --policy-type SERVICE_CONTROL_POLICY"
      Invoke-Expression $command
    EOT

    interpreter = ["powershell.exe", "-Command"]
  }

  # Trigger the provisioner after the Terraform configuration is applied
  depends_on = [aws_organizations_organization.example_org]
}

# aws_organizations_policy

resource "aws_organizations_policy" "example" {
  name        = "example"
  description = "example"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


output "policy_id" {
  value = aws_organizations_policy.example.id
}

output "root_id" {
  value = aws_organizations_organization.example_org.roots[0].id
}

output "ou-prod_id" {
  value = aws_organizations_organizational_unit.prod.id
}

output "ou-dev_id" {
  value = aws_organizations_organizational_unit.dev.id
}