locals {
  version_vars = read_terragrunt_config(find_in_parent_folders("versions.hcl"))
  global_vars = read_terragrunt_config(find_in_parent_folders("values.hcl"))
  config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
}

stack "first" {
  source = "/stacks/second?ref=main"
  #source = "${local.global_vars.locals.git_url}//example-deployment/stacks/first?ref=${local.version_vars.locals.customer_1_version}"
  path = "first"

  values = {
    unit_tag = local.version_vars.locals.customer_1_version
    git_fqdn = local.global_vars.locals.git_url
    customer_input = local.config.locals.customer_input
  }
}