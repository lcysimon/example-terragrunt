# Include root terragrunt.hcl file, expose all variables so we can reference
# them in the inputs
include "root" {
  path = find_in_parent_folders()
  expose = true
}

# Indicate where to source the terraform module from.
terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/s3-bucket/aws?version=2.10.0"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  # Get bucket name as a combination of previous variables
  bucket = lower("mybucket-${include.root.inputs.account_name}-${include.root.inputs.aws_region}")
  tags = include.root.locals.default_tags
}
