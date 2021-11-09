# example-terragrunt
Small terragrunt example project, with github actions for release.

## Setup

### Introduction

Classic terragrunt example. There is some example about how to:

1. Merge tags together before apply on different environment, check [the parent terragrunt.hcl merge tags](terragrunt.hcl) and [the child terragrunt.hcl tags use](dev-account/us-east-1/prod/s3bucket-example/terragrunt.hcl)
2. Change AWS profile to your need in [terragrunt](bin/terragrunt) file to run locally, or export the variable before
3. Right now, terraform will always download all providers for every modules on every run. It can be solved by downloading all plugins in a previous step & using plugin_cache_dir from terraform.
4. [docker image used for running those workflows](https://github.com/lcysimon/docker-terragrunt)
5. [Github action file](.github/workflows/main.yml) used to automate deployment, it is doing a plan on every push & an apply on all push to master. This looks a bit ugly due to github action not being able to support yaml anchor yet.
6. In the [Github action file](.github/workflows/main.yml) still, the diff is there to have a look at all change at one glance. You should do a bit of parsing there in order for it to be effective.

## How to run locally:

### Plan

`bin/terragrunt run-all plan -lock=false --terragrunt-working-dir dev-account/`

### Apply

`./bin/terragrunt run-all apply --terragrunt-non-interactive --terragrunt-working-dir prod-account/`

#### Format code

`./bin/terragrunt hclfmt`
