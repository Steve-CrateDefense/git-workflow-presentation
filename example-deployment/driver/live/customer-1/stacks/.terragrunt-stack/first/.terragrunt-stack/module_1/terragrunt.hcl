terraform {
  # Hard coded version tag
  source = "${values.git_url}//example-deployment/terraform-modules/module_1?ref=main"
}