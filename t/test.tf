

data "template_file" "example" {
template = file("../policies/Deploy-Diagnostics-policySetDefinition.json")
  vars = {
    subscriptionID = "stuff"
  }
}

output test {
    value = jsonencode(data.template_file.example.rendered)
}

terraform {
  required_version = ">= 0.12.1"
}
