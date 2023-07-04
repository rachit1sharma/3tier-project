#Creating a Availability set
resource "azurerm_availability_set" "web_availabilty_set" {
  name                = "web_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface" "web-net-interface" {
    name = "web-network"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "web-webserver"
        subnet_id = module.networking.websubnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

#Keyvault Creation
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "keyvault" {
  name                        = VM-Passwords
  location                    = var.location
  resource_group_name         = var.resource_group
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get",
    ]
    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]
    storage_permissions = [
      "get",
    ]
  }
}

#Create KeyVault VM password
resource "random_password" "vmpassword" {
  length = 20
  special = true
}
#Create Key Vault Secret for App VM
resource "azurerm_key_vault_secret" "app-vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault ]
}

#Create Key Vault Secret for Web VM
resource "azurerm_key_vault_secret" "web-vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault ]
}

#Creation of web-vm
resource "azurerm_virtual_machine" "web-vm" {
  name = "web-vm"
  location = var.location
  resource_group_name = var.resource_group
  network_interface_ids = [ azurerm_network_interface.web-net-interface.id ]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  vm_size = "Standard_D2s_v3"
  delete_os_disk_on_termination = true
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name = "web-disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = var.web_host_name
    admin_username = var.web_username
    admin_password = azurerm_key_vault_secret.web-vmpassword.value
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
  
  
  resource "azurerm_availability_set" "app_availabilty_set" {
  name                = "app_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group
 }

resource "azurerm_network_interface" "app-net-interface" {
    name = "app-network"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "app-webserver"
        subnet_id = module.networking.appsubnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

#Creation of APP VM
resource "azurerm_virtual_machine" "app-vm" {
  name = "app-vm"
  location = var.location
  resource_group_name = var.resource_group
  network_interface_ids = [ azurerm_network_interface.app-net-interface.id ]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  vm_size = "Standard_D2s_v3"
  delete_os_disk_on_termination = true
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name = "app-disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = var.app_host_name
    admin_username = var.app_username
    admin_password = azurerm_key_vault_secret.app-vmpassword.value
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

