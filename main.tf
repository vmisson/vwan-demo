resource "azurerm_marketplace_agreement" "paloaltonetworks" {
  publisher = "paloaltonetworks"
  offer     = "vmseries-flex"
  plan      = "byol"
}

#######################################
# VPN PSK creation
#######################################
resource "random_string" "vpn-psk" {
  length = 32
}