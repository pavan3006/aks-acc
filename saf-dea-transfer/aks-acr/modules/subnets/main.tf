locals {
  parameters_body = {
    location = {
      value = var.location
    },
    existingVNETName = {
      value = var.virtual_network_name
    },
    networkSecurityGroupId = {
      value = var.network_security_group_id
    }
    subnets = {
      value = var.subnets
    },
  }
}
resource "azurerm_resource_group_template_deployment" "this" {
  name                = "terraform-vnet-subnets"
  resource_group_name = var.resource_group_name
  template_content    = file("${path.module}/templates/arm/subnets.json")
  parameters_content  = jsonencode(local.parameters_body)
  deployment_mode     = "Incremental"
}
