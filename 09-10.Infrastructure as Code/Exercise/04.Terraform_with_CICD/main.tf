terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.90.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "taskboardstoragekris"
    container_name       = "taskboardcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Generate random integer
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "arg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.mssql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.mssql_db.name};User ID=${azurerm_mssql_server.mssql_server.administrator_login};Password=${azurerm_mssql_server.mssql_server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "mssql_db" {
  name           = "${var.sql_database_name}${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "webapp_source_control" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}