resource "terraform_data" "echo" {
  triggers_replace = {
    always_run = timestamp()
  }
  # printf colors
  # https://gist.github.com/WestleyK/dc71766b3ce28bb31be54b9ab7709082
  provisioner "local-exec" {
    command = "printf '\\033[36;1mModule_1 executed, remote value: ${var.value}.\\033[0m\\n'"
  }
}