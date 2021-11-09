# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load global-level variables
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Create a map of all useful tags that can be use in every children easily
  default_tags = merge(
    local.global_vars.locals.global_tags,
    local.account_vars.locals.account_tags,
    local.region_vars.locals.region_tags,
    local.environment_vars.locals.environment_tags,
  )

  # Extract other variables we need for easy access
  account_name = local.account_vars.locals.account_name
  aws_region   = local.region_vars.locals.aws_region
  environment  = local.environment_vars
}

# Generate an AWS provider block
generate "provider" {
  path      = "terragrunt_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile(
    "templates/providers.tf.tpl",
    { "aws_region" : local.aws_region }
  )
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt = true

    # Region as part of bucket name to avoid issue with multiple buckets
    bucket = "terraform-state-${get_aws_account_id()}-${local.aws_region}"
    # Key prefixed with your project name, which should be unique amongs your projects if you with to save all states in the same bucket
    key            = "example-terragrunt/${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.global_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
