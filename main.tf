//////////////////////////////////////////////
// Main para proyecto de Terraform     //
//////////////////////////////////////////////

provider "azurerm" {
    subscription_id = var.subscription_id
    features {
        resource_group { 
            prevent_deletion_if_contains_resources = false 
        }
    }
}

resource "azurerm_resource_group" "rg" {
    name = "rg-${var.project}-${var.environment}"
    location = var.location
    tags = var.tags
    
}

//////////////////////////////////////////////
//////////////////////////////////////////////
