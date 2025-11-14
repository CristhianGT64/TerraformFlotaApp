
resource "azurerm_databricks_workspace" "databricks" {
    name                        = "databricks-${var.project}-${var.environment}"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rg.name
    sku                         = "standard"
    tags                        = var.tags
    managed_resource_group_name = "databricks-rg-${var.project}-${var.environment}"
}