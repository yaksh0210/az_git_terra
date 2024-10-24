provider "azurerm" {
  subscription_id                 = "664b6097-19f2-42a3-be95-a4a6b4069f6b"
  resource_provider_registrations = "none"
  features {}
}

# resource "azurerm_resource_group" "rg" {
#     name = "first-terrra-resource"
#     location = "southeastasia" 
# }

data "azurerm_resource_group" "rg" {
  name = "sa1_test_eic_YakshRawal"
}

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southeastasia"
  resource_group_name = data.azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "frontendsubnet" {
  name                 = "frontendsubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "mypubip" {
  name                = "mypubip"
  location            = "southeastasia"
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}



resource "azurerm_network_interface" "newnetinter" {
  name                = "newnetinter"
  location            = "southeastasia"
  resource_group_name = data.azurerm_resource_group.rg.name


  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypubip.id
  }

}



resource "azurerm_windows_virtual_machine" "myvm" {
  name                  = "myvm"
  location              = "southeastasia"
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.newnetinter.id]
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  admin_password        = "admin@1234"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
} 