data "azurerm_resource_group" "demo" {
    name = "sa1_test_eic_YakshRawal"
}

resource "azurerm_storage_account" "StorageAccountDemo" {
  name                     = "resource123"
  resource_group_name      = data.azurerm_resource_group.demo.name
  location                 = data.azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    name = "azure"
    practical = "demo"
  }
}