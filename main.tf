# Create a resource group
resource "azurerm_resource_group" "RG" {
  name     = "example-resources"
  location = "centralindia"
}

resource "azurerm_storage_account" "SA" {
  depends_on = [ azurerm_resource_group.RG ]
  name                     = "storageaccount00965"
  resource_group_name      = azurerm_resource_group.RG.name
  location                 = azurerm_resource_group.RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.SA.id
  container_access_type = "private"

  depends_on = [azurerm_storage_account.SA]
}