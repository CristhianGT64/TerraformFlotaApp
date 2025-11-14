// Para guardar imagenes desde Docker

resource "azurerm_container_registry" "acr" {
    name                     = "acr${lower(var.project)}${var.environment}"
    location                 = var.location
    resource_group_name      = azurerm_resource_group.rg.name
    sku                      = "Basic"
    admin_enabled            = true
    tags                     = var.tags
}