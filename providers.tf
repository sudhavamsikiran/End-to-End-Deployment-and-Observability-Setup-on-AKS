terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
  client_id = "15b8513f-7511-4bd2-b6cb-a715cfffa248"
  client_secret = "VRm8Q~hoAn~y4YbZeCeFcmNETufOInlEvkb5jaUG"
  tenant_id = "f8279f25-0354-40b1-8283-ed35dc1d1fca"
  subscription_id = "306d594c-0350-4c72-a81e-0c32842d375c"
}