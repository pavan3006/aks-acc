output "subnet_ids" {
  value = { for subnet in jsondecode(azurerm_resource_group_template_deployment.this.output_content)["subnets"]["value"] :
    subnet.name => subnet.id
  }
}

