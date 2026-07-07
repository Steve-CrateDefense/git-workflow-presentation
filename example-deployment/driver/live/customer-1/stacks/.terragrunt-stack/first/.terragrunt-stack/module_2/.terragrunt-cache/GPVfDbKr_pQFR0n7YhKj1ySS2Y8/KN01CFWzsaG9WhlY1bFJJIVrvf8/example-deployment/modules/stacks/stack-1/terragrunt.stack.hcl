unit "module_1" {
  source = "${values.git_url}//example-deployment/modules/units/unit-2?ref=${values.unit_tag}"
  path = "module_1"

  values = {
    git_url = values.git_url
  }
}

unit "module_2" {
  source = "${values.git_url}//example-deployment/modules/units/unit-1?ref=${values.unit_tag}"
  path = "module_2"

  values = {
    git_url = values.git_url
  }
}