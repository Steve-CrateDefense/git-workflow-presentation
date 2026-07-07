resource "terraform_data" "echo" {
  triggers_replace = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "printf '\\033[33;1mModule_2 executed, remote value: ${var.value}.\\033[0m\\n'"
  }
}