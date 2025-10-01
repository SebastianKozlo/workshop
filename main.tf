terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-09"
    storage_account_name = "1qstor12"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan-09"
  location            = "westeurope"
  resource_group_name = "rg-09"
  os_type             = "Linux"
  sku_name            = "P0v3"
}


resource "azurerm_linux_web_app" "example" {
  name                = "example-webapp-123123i95u8fhwfdsewdwsa-09"
  location            = "westeurope"
  resource_group_name = "rg-09"
  service_plan_id     = azurerm_service_plan.example.id
  site_config {}
}

  resource "azurerm_storage_account" "example_storage" {
    name                     = "storagea23123234"
    resource_group_name      = "rg-09"
    location                 = "westeurope"
    account_tier             = "Standard"
    account_replication_type = "GRS"

    tags = {
      environment = "staging"
    }
  }

  # MSSQL Server
  resource "azurerm_mssql_server" "example" {
    name                         = "workshop-mssql-server"
    resource_group_name          = "rg-09"
    location                     = "westeurope"
    version                      = "12.0"
    administrator_login          = "sqladminuser"
    administrator_login_password = "P@ssw0rd1234!"
    minimum_tls_version          = "1.2"
  }

  # MSSQL Database
  resource "azurerm_mssql_database" "example" {
    name               = "workshopdb"
    server_id          = azurerm_mssql_server.example.id
    sku_name           = "S0"
    collation          = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb        = 5
  }