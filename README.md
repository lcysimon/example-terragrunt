# example-terragrunt
Small terragrunt example project, with github actions for release.

## Setup

### Introduction

Classic terragrunt example. There is some example about how to:

1. Merge tags together before apply on different environment, check [terragrunt.hcl](the parent terragrunt.hcl merge tags) and [accountA/us-east-1/prod/s3bucket-example/terragrunt.hcl](the child terragrunt.hcl tags use)
2. Change AWS profile to your need in [bin/terragrunt](terragrunt) file to run locally
3. Right now, terraform will always download all providers for every modules on every run. It can be solved by downloading all plugins in a previous step & using plugin_cache_dir from terraform
4. [https://github.com/lcysimon/docker-terragrunt](docker image used for running those workflows)

## How to run locally:

### Plan

`bin/terragrunt plan-all -lock=false --terragrunt-working-dir accountA/`

### Apply

`./bin/terragrunt run-all apply --terragrunt-non-interactive --terragrunt-working-dir accountA/`
