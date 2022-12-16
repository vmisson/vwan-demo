locals {
  virtual_hub_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-hub"
    }),
    var.virtual_hub_tags,
  )
  virtual_hub_fw_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-hub"
    }),
    var.virtual_hub_tags,
  )
}

resource "azurerm_virtual_hub" "virtual-hub" {
  name                = var.virtual_hub_name
  resource_group_name = var.virtual_hub_resource_group_name
  location            = var.virtual_hub_location
  virtual_wan_id      = var.virtual_hub_virtual_wan_id
  address_prefix      = var.virtual_hub_address_prefix
  sku                 = var.virtual_hub_sku
  dynamic "route" {
    for_each = var.virtual_hub_static_route
    content {
      address_prefixes    = lookup(route.value, "virtual_hub_route_address_prefixes", null)
      next_hop_ip_address = lookup(route.value, "virtual_hub_route_nexnext_hop_ip_address", null)
    }
  }
  tags = local.virtual_hub_tags
}

resource "azurerm_firewall" "firewall" {
  count               = var.virtual_hub_secured ? 1 : 0
  name                = var.virtual_hub_fw_name
  resource_group_name = var.virtual_hub_fw_resource_group_name
  location            = var.virtual_hub_fw_location
  threat_intel_mode   = null
  sku_name            = var.virtual_hub_fw_sku_name
  sku_tier            = var.virtual_hub_fw_sku_tier
  firewall_policy_id  = var.virtual_hub_fw_policy_id
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.virtual-hub.id
  }
  zones = var.virtual_hub_fw_zones
  tags  = var.virtual_hub_fw_tags
}

resource "azurerm_monitor_diagnostic_setting" "default" {
  count                          = (var.virtual_hub_fw_log_analytics_workspace_id == null) || (var.virtual_hub_secured == false) ? 0 : 1
  name                           = split("/", var.virtual_hub_fw_log_analytics_workspace_id)[8]
  target_resource_id             = azurerm_firewall.firewall.*.id[0]
  log_analytics_workspace_id     = var.virtual_hub_fw_log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 90
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 90
    }
  }
  log {
    category = "AZFWApplicationRule"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWDnsQuery"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWFqdnResolveFailure"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWIdpsSignature"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNatRule"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNatRuleAggregation"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNetworkRule"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWNetworkRuleAggregation"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "AZFWThreatIntel"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = true
      days    = 90
    }
  }
}