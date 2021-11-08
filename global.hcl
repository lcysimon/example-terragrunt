# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
    global_tags = {
      "git_repository": "https://github.com/lcysimon/example-terragrunt"
    }
}
