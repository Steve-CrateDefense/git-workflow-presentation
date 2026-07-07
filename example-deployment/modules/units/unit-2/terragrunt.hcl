terraform {
  # Hard coded version tag
  source = "${values.git_url}//example-deployment/terraform-modules/module_2?ref=main"
}

inputs = {
    value = values.value
}