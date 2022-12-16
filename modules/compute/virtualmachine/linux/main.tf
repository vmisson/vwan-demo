locals {
  virtualmachine_linux_tags = merge(
    tomap({
      ManagedBy = "terraform/virtualmachine-linux"
    }),
    var.virtualmachine_linux_tags,
  )
}

locals {
  admin_password                      = var.admin_password == "" ? random_password.password.result : var.admin_password
  storage_account_resource_group_name = var.storage_account_resource_group_name == "" ? var.resource_group_name : var.storage_account_resource_group_name
}

data "template_file" "cloud-init" {
  template = file("${path.module}/cloud-init.tpl")
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

resource "azurerm_network_interface" "network-interface" {
  name                = "${var.vm_name}ni01"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = local.virtualmachine_linux_tags

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux-virtual-machine" {
  name                = var.vm_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = local.virtualmachine_linux_tags

  size = var.vm_size
  zone = var.zone

  network_interface_ids = [azurerm_network_interface.network-interface.id]

  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = local.admin_password

  boot_diagnostics {
    storage_account_uri = var.storage_account_blob_endpoint
  }

  os_disk {
    name                 = "${var.vm_name}od01"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = var.run_bootstrap == true ? base64encode(data.template_file.cloud-init.rendered) : null
}
