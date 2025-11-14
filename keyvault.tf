data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                        = "kv-${var.project}-${var.environment}"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rg.name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    sku_name                    = "standard"
    purge_protection_enabled    = false
    soft_delete_retention_days  = 90
    tags                        = var.tags

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        secret_permissions = [
            "Get",
            "List",
            "Set",
            "Delete",
            "Recover",
            "Backup",
            "Restore"
        ]

        key_permissions = [
            "Get",
            "List",
            "Create",
            "Delete",
            "Recover",
            "Backup",
            "Restore"
        ]
    }
}