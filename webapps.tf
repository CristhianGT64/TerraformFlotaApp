
resource "azurerm_service_plan" "sp" {
    name                = "sp-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name            = "B1"
    os_type             = "Linux"
    tags                = var.tags
}


// Back office

resource "azurerm_linux_web_app" "backoffice_ui" {
    name                = "backofficeui-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id     = azurerm_service_plan.sp.id

    site_config {
        always_on = true
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
        }
    }

    app_settings = {
        WEBSITES_PORT = "80"
    }
    tags = var.tags
    
}

resource "azurerm_linux_web_app" "backofficeapi" {
    name                = "backofficeapi-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id     = azurerm_service_plan.sp.id

    site_config {
        always_on = true
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
        }
    }

    app_settings = {
        WEBSITES_PORT = "80"
    }
    tags = var.tags
    
}

// Front office

resource "azurerm_linux_web_app" "frontofficeui" {
    name                = "frontofficeui-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id     = azurerm_service_plan.sp.id

    site_config {
        always_on = true
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
        }
    }

    app_settings = {
        WEBSITES_PORT = "80"
    }
    tags = var.tags
    
}

resource "azurerm_linux_web_app" "frontofficeapi" {
    name                = "frontofficeapi-${var.project}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    service_plan_id     = azurerm_service_plan.sp.id

    site_config {
        always_on = true
        application_stack {
            docker_registry_url = "https://index.docker.io"
            docker_image_name = "nginx:latest"
        }
    }

    app_settings = {
        WEBSITES_PORT = "80"
    }
    tags = var.tags
    
}