locals {
  hub_virtual_network = {
    "lab" = {
      resource_id   = "/subscriptions/049118e2-4814-401b-a34d-a67a35abc5a9/resourceGroups/AZRWEULABRG0001/providers/Microsoft.Network/virtualNetworks/azrweulabvn0001"
      dns_servers   = ["10.221.194.212"]
      vwanhub_id    = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/virtualHubs/changeme"
      vwanhub_fw_id = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/azureFirewalls/chnageme"
    },
    "westeurope" = {
      resource_id   = "/subscriptions/7a883164-75f4-4413-adb1-2e37388e30ed/resourceGroups/AZRWEUINFRG0001/providers/Microsoft.Network/virtualNetworks/azrweuinfvn0001"
      dns_servers   = ["10.221.194.212"]
      vwanhub_id    = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/virtualHubs/azrweuvwanhub0001"
      vwanhub_fw_id = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/azureFirewalls/azrweuvwanfw0001"
    },
    "northeurope" = {
      resource_id   = "/subscriptions/7a883164-75f4-4413-adb1-2e37388e30ed/resourceGroups/azrneuinfrg0001/providers/Microsoft.Network/virtualNetworks/AZRNEUINFVN0001"
      dns_servers   = ["10.233.0.214"]
      vwanhub_id    = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/virtualHubs/azrneuvwanhub0001"
      vwanhub_fw_id = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/azureFirewalls/azrneuvwanfw0001"
    },
    "eastus2" = {
      resource_id   = "/subscriptions/28911b56-8db3-4a91-a4a1-42a948693d85/resourceGroups/AZREUSINFRG0001/providers/Microsoft.Network/virtualNetworks/AZREUSINFVN0001"
      dns_servers   = ["10.59.0.143"]
      vwanhub_id    = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/virtualHubs/azreusvwanhub0001"
      vwanhub_fw_id = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/azureFirewalls/azreusvwanfw0001"
    },
    "southeastasia" = {
      resource_id   = "/subscriptions/7458ed99-dacf-43ef-81a3-6f02912e75fa/resourceGroups/AZRSASINFRG0001/providers/Microsoft.Network/virtualNetworks/AZRSASINFVN0001"
      dns_servers   = ["10.88.128.80"]
      vwanhub_id    = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/virtualHubs/azrsasvwanhub0001"
      vwanhub_fw_id = "/subscriptions/8d21bc38-6be5-4983-baa2-e859067b5faf/resourceGroups/vwan/providers/Microsoft.Network/azureFirewalls/azrsasvwanfw0001"
    }
  }
  remote_virtual_network_id        = local.hub_virtual_network[var.virtual_network_location]["resource_id"]
  hub_virtual_network_subscription = split("/", local.remote_virtual_network_id)[2]
  hub_resource_group_name          = split("/", local.remote_virtual_network_id)[4]
  hub_virtual_network_name         = split("/", local.remote_virtual_network_id)[8]
  address_dns_servers              = local.hub_virtual_network[var.virtual_network_location]["dns_servers"]
  location                         = var.virtual_network_location == "lab" ? "westeurope" : var.virtual_network_location
  vwan_hub                         = local.hub_virtual_network[var.virtual_network_location]["vwanhub_id"]
  vwan_hub_firewall                = local.hub_virtual_network[var.virtual_network_location]["vwanhub_fw_id"]
}

module "virtual-network" {
  source                              = "../virtual-network"
  virtual_network_name                = var.virtual_network_name
  virtual_network_location            = local.location
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_address_space       = var.virtual_network_address_space
  virtual_network_address_dns_servers = coalescelist(var.virtual_network_address_dns_servers, local.address_dns_servers)
  virtual_network_tags                = var.virtual_network_tags
  virtual_network_peering             = var.vwan_peering
}

module "subnet" {
  source = "../subnet"

  for_each                                              = var.subnet
  subnet_name                                           = each.key
  subnet_resource_group_name                            = var.virtual_network_resource_group_name
  subnet_virtual_network_name                           = module.virtual-network.name
  subnet_address_prefixes                               = each.value.address_prefixes
  subnet_virtual_network_location                       = local.location
  subnet_delegation                                     = each.value.delegation
  subnet_nsg                                            = coalesce(each.value.nsg_anr_managed, false) # Needed as subnet module don't have default value for this
  subnet_enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  subnet_service_endpoints                              = each.value.service_endpoints
}

module "virtual-network-peering-spoke" {
  count                                               = var.virtual_network_peering_with_inf && !var.vwan_peering ? 1 : 0
  source                                              = "../virtual-network-peering"
  virtual_network_peering_resource_group_name         = var.virtual_network_resource_group_name
  virtual_network_peering_virtual_network_name        = module.virtual-network.name
  virtual_network_peering_name                        = var.peering_name
  virtual_network_peering_remote_virtual_network_name = local.hub_virtual_network_name
  virtual_network_peering_remote_virtual_network_id   = local.remote_virtual_network_id
  virtual_network_peering_use_remote_gateways         = true
  virtual_network_peering_allow_forwarded_traffic     = var.peering_allow_forwarded_traffic
}

module "virtual-network-peering-hub" {
  count = var.virtual_network_peering_with_inf && !var.vwan_peering ? 1 : 0
  providers = {
    azurerm = azurerm.hub
  }

  source                                              = "../virtual-network-peering"
  virtual_network_peering_resource_group_name         = local.hub_resource_group_name
  virtual_network_peering_virtual_network_name        = local.hub_virtual_network_name
  virtual_network_peering_remote_virtual_network_name = var.virtual_network_name
  virtual_network_peering_name                        = var.remote_peering_name
  virtual_network_peering_remote_virtual_network_id   = module.virtual-network.id
  virtual_network_peering_allow_gateway_transit       = true
  virtual_network_peering_allow_forwarded_traffic     = var.remote_peering_allow_forwarded_traffic
}

module "vwan-network-peering" {
  count = var.vwan_peering ? 1 : 0
  providers = {
    azurerm = azurerm.vwan
  }

  source        = "../vwanhub-vnet-connections"
  spoke_vnet_id = module.virtual-network.id
  vwan_hub_id   = local.vwan_hub
  routing       = var.routing
}

resource "random_id" "rng" {
  count = var.virtual_network_locked ? 1 : 0
  keepers = {
    first = timestamp()
  }
  byte_length = 8
}

resource "azurerm_management_lock" "management-lock" {
  count = var.virtual_network_locked ? 1 : 0
  depends_on = [
    module.virtual-network,
    module.subnet
  ]

  name       = "automatic lock ${random_id.rng[0].hex}"
  scope      = module.virtual-network.id
  lock_level = "ReadOnly"
  notes      = "Automatic lock managed by the Cloud Platform using Terraform/network"
}  