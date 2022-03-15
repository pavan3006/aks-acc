### Terraform gitHub documentation [link](https://github.com/terraform-aws-modules)

### Usage
<!--- BEGIN_USAGE --->
## Usage example
```hcl
provider "azurerm" {
  #version = "~>2.0"
  features {}
}


# Source code to test 
module "aks" {
  source                         = "../"
  aks_name                       = "surus-ak"
  log_analytics_workspace_id     = "/subscriptions/30894d90-8b4c-4637-a72f-90738cb51ef7/resourcegroups/app_infra/providers/microsoft.operationalinsights/workspaces/aksloganalytics"
  addons                         = true
  vnet_subnet_id                  = "/subscriptions/30894d90-8b4c-4637-a72f-90738cb51ef7/resourceGroups/dumpling_app_infra/providers/Microsoft.Network/virtualNetworks/surus-dumpling-vnet/subnets/subnet2"
  rg_name                        = "app_infra"
  rg_location                    = "West Europe"
  dns_prefix                     = "basic"
  agent_name                     = "aksnodepool1"
  node_count                     = "3"
  node_type                      = "Standard_DS3_v2"
  node_os_disk_size              = "30"
  max_pods                       = "50"
  min_count                      = "20"
  #os_type                        = "Linux"
  os_disk_size_gb                = "30"
  enable_auto_scaling            = "true"
  #aks_version                   = "1.18.14"
  network_plugin                 = "azure"
  private_cluster_enabled        = "true"
  sku_tier                       = "Paid"
  network_policy                 = "calico"
  # dns_service_ip                 = var.net_profile_dns_service_ip
  # docker_bridge_cidr             = var.net_profile_docker_bridge_cidr
  # outbound_type                  = var.net_profile_outbound_type
  # pod_cidr                       = var.net_profile_pod_cidr
  # service_cidr                   = 
}



```
<!--- END_USAGE --->

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| azurerm | >= 2.56.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.56.0, < 3.0.0 |

## Modules

No Modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | (Required) The prefix for the resources created in the specified Azure Resource Group | `string` | n/a | yes |
| resource\_group\_name | The resource group name to be imported | `string` | n/a | yes |
| agents\_availability\_zones | (Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created. | `list(string)` | `null` | no |
| agents\_count | The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes. | `number` | `2` | no |
| agents\_labels | (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| agents\_max\_count | Maximum number of nodes in a pool | `number` | `null` | no |
| agents\_max\_pods | (Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created. | `number` | `null` | no |
| agents\_min\_count | Minimum number of nodes in a pool | `number` | `null` | no |
| agents\_pool\_name | The default Azure AKS agentpool (nodepool) name. | `string` | `"nodepool"` | no |
| agents\_size | The default virtual machine size for the Kubernetes agents | `string` | `"Standard_D2s_v3"` | no |
| agents\_tags | (Optional) A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| agents\_type | (Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| cluster\_log\_analytics\_workspace\_name | (Optional) The name of the Analytics workspace | `string` | `null` | no |
| cluster\_name | (Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns\_prefix if it is set) | `string` | `null` | no |
| enable\_auto\_scaling | Enable node pool autoscaling | `bool` | `false` | no |
| enable\_azure\_policy | Enable Azure Policy Addon. | `bool` | `false` | no |
| enable\_host\_encryption | Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli | `bool` | `false` | no |
| enable\_http\_application\_routing | Enable HTTP Application Routing Addon (forces recreation). | `bool` | `false` | no |
| enable\_kube\_dashboard | Enable Kubernetes Dashboard. | `bool` | `false` | no |
| enable\_log\_analytics\_workspace | Enable the creation of azurerm\_log\_analytics\_workspace and azurerm\_log\_analytics\_solution or not | `bool` | `true` | no |
| enable\_node\_public\_ip | (Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false. | `bool` | `false` | no |
| enable\_role\_based\_access\_control | Enable Role Based Access Control. | `bool` | `false` | no |
| kubernetes\_version | Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region | `string` | `null` | no |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| net\_profile\_dns\_service\_ip | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | `string` | `null` | no |
| net\_profile\_docker\_bridge\_cidr | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created. | `string` | `null` | no |
| net\_profile\_outbound\_type | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer. | `string` | `"loadBalancer"` | no |
| net\_profile\_pod\_cidr | (Optional) The CIDR to use for pod IP addresses. This field can only be set when network\_plugin is set to kubenet. Changing this forces a new resource to be created. | `string` | `null` | no |
| net\_profile\_service\_cidr | (Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | `string` | `null` | no |
| network\_plugin | Network plugin to use for networking. | `string` | `"kubenet"` | no |
| network\_policy | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created. | `string` | `null` | no |
| orchestrator\_version | Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region | `string` | `null` | no |
| os\_disk\_size\_gb | Disk size of nodes in GBs. | `number` | `50` | no |
| private\_cluster\_enabled | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet. | `bool` | `false` | no |
| rbac\_aad\_admin\_group\_object\_ids | Object ID of groups with admin access. | `list(string)` | `null` | no |
| rbac\_aad\_client\_app\_id | The Client ID of an Azure Active Directory Application. | `string` | `null` | no |
| rbac\_aad\_managed | Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. | `bool` | `false` | no |
| rbac\_aad\_server\_app\_id | The Server ID of an Azure Active Directory Application. | `string` | `null` | no |
| rbac\_aad\_server\_app\_secret | The Server Secret of an Azure Active Directory Application. | `string` | `null` | no |
| sku\_tier | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid | `string` | `"Free"` | no |
| tags | Any tags that should be present on the Virtual Network resources | `map(string)` | `{}` | no |
| vnet\_subnet\_id | (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_client\_certificate | n/a |
| admin\_client\_key | n/a |
| admin\_cluster\_ca\_certificate | n/a |
| admin\_host | n/a |
| admin\_password | n/a |
| admin\_username | n/a |
| aks\_id | n/a |
| client\_certificate | n/a |
| client\_key | n/a |
| cluster\_ca\_certificate | n/a |
| host | n/a |
| http\_application\_routing\_zone\_name | n/a |
| kube\_config\_raw | n/a |
| kubelet\_identity | n/a |
| location | n/a |
| node\_resource\_group | n/a |
| password | n/a |
| system\_assigned\_identity | n/a |
| username | n/a |

<!--- END_TF_DOCS --->
