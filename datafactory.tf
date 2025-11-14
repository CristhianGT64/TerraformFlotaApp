
resource "azurerm_data_factory" "adf" {
    name                = "adf-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags                = var.tags
}