module "resource_group_name" {
  source = "../azurerm_resource_group"
  rgs    = var.rgdetails
}

module "azurerm_virtual_network" {
  depends_on = [module.resource_group_name]
  source     = "../azurerm_virtual_network"
  vnet       = var.vnetdetails
}
module "azurerm_subnet" {
  depends_on = [module.azurerm_virtual_network]
  source     = "../azurerm_subnet"
  subnet     = var.subnetdetails
}


# module "azurerm_VM_NIC_PIP" {
#   depends_on = [module.resource_group_name, module.azurerm_subnet, ]
#   source     = "../azurerm_VM_NIC_PIP"
#   vms        = var.vmdetails
# }

module "network_security_group" {
  source = "../azurerm_network_security_group"

  depends_on = [
    module.resource_group_name
  ]

  nsgs = var.nsgdetails
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = module.azurerm_subnet.subnet_ids["subnet1"]
  network_security_group_id = module.network_security_group.nsg_ids["frontend_nsg"]
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = module.azurerm_subnet.subnet_ids["subnet2"]
  network_security_group_id = module.network_security_group.nsg_ids["backend_nsg"]
}