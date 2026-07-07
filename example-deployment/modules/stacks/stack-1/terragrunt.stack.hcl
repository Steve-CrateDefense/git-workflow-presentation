unit "module_1" {
  source = "${values.git_url}//example-deployment/modules/units/module_1?ref=$(values.unit_tag)"
  path = "module_1"
}

unit "module_2" {
  source = "${values.git_url}//example-deployment/modules/units/module_2?ref=${values.unit_tag}"
  path = "module_2"
}