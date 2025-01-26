

module "resource-group" {
    source = "./modules/general/resourcegroup"
    resource_group_name = var.resource_group_name
    location = var.location
}   

module "network" {
   source="./modules/networking/vnet"
   resource_group_name = var.resource_group_name
   location = var.location
   network_security_group_rules = var.network_security_group_rules
   subnet_details = local.subnet_details
   virtual_network_details = local.virtual_network_details
   network_interface_details = local.network_interface_details
   depends_on = [ module.resource-group ]
}


module "virtual-machines" {    
    source="./modules/compute/virtualMachines"
    resource_group_name=var.resource_group_name
    location=var.location
    virtual_machine_details = local.virtual_machine_details
    network_interface_details = local.network_interface_details
    storage_account_name = module.storage-account.storage_account_name
    container_name = "scripts"
    depends_on = [ module.network,module.storage-account ]
}

module "storage-account" {
    source = "./modules/storage/azurestorage"
    resource_group_name = var.resource_group_name
    location = var.location
    storage_account_details = var.storage_account_details
    container_names = var.container_names
    blobs = var.blobs
    depends_on = [ module.resource-group ]
}

# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }
  linux_profile {
    admin_username = "linuxadmin"

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}


