variable "resource_group_name" {
  type= string
  description = "This defines the name of the resource group"
}
variable "location" {
  type= string
  description = "This defines the location of the resource group and the resources"
}


variable "network_security_group_rules" {
  type=list(object(
    {
      priority=number
      destination_port_range=string
    }
  ))
  description = "This defines the network security group rules"
}


variable "environment" {
   type=map(object(
   {
      virtual_network_address_space=string      
      subnets=map(object( 
        {       
          subnet_address_prefix=string         
          network_interfaces=list(object(
          {
              name=string
              virtual_machine_name=string
              script_name=string
          }   ))       
        }
          ))           
        }
      ))             
}

variable "storage_account_details" {
    type=map(string)    
}

variable "container_names" {
  type = list(string)
}

variable "blobs" {
    type=map(object( 
    {
       container_name=string
       blob_location=string
    }
    ))
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}
