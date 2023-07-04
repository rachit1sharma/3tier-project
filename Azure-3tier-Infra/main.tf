terraform {
  required_providers {
    azurerm                            = {
      source                           = "hashicorp/azurerm"
      version                          = "=2.46.0"
    }
  }
  
  backend "azurerm" {
        subscription_id      = "xxx"
        resource_group_name  = var.resource_group
        storage_account_name = "xxx"
        container_name       = "tfstate-stg"
        key                  = "TF/Stg/terraform.tfstate"
    } 
    
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {purge_soft_delete_on_destroy = true}
  }
  subscription_id                      = ""
  skip_provider_registration           = "true" 

}

module "resourcegroup" {
  source         = "./modules/resourcegroup"
  name           = var.name
  location       = var.location
}

module "networking" {
  source         = "./modules/networking"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
}

module "securitygroup" {
  source         = "./modules/securitygroup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name 
  web_subnet_id  = module.networking.websubnet_id
  app_subnet_id  = module.networking.appsubnet_id
  db_subnet_id   = module.networking.dbsubnet_id
}

module "compute" {
  source         = "./modules/compute"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  web_subnet_id = module.networking.websubnet_id
  app_subnet_id = module.networking.appsubnet_id
  web_host_name = var.web_host_name
  web_username = var.web_username
  app_host_name = var.app_host_name
  app_username = var.app_username
}

module "database" {
  source = "./modules/database"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  primary_database = var.primary_database
  primary_database_version = var.primary_database_version
  primary_database_admin = var.primary_database_admin
  primary_database_password = var.primary_database_password
}
