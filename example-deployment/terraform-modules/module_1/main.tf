resource "terraform_data" "echo" {
  triggers_replace = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "printf '\\033[32;1mModule_1 executed, remote value: ${var.value}.\\033[0m\\n'"
  }
}