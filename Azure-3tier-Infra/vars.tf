variable "resource_group" {
   type             = string
   description      = "Resource group name"

   validation {
     condition      = length(var.resource_group) > 4 
     error_message  = "Resource group name must be gretter than 4 chracter."
  }
}

variable "location" {
   type             = string
   description      = "Resource group location."
   validation {
     condition      = lower(var.location) == var.location
     error_message  = "Location should be all lowercase."
  }

}

variable "tags" {
    type=any
}

variable "vnetcidr" {
    type             = any
    description      = "CIDR for Vnet"
}
variable "websubnetcidr" {
    type             = any
    description      = "CIDR for WebVnet"
}
variable "appsubnetcidr" {
    type             = any
    description      = "CIDR for AppVnet"
}
variable "dbsubnetcidr" {
    type             = any
    description      = "CIDR for DBVnet"
}
variable "web_host_name"{
    type             = string
    description      = "Host Name for Web VM"
}
variable "web_username" {
    type             = string
    description      = "Username Name for Web VM"
}
variable "web_os_password" {
    type             = string
    description      = "Password Name for Web VM"
}
variable "app_host_name"{
    type             = string
    description      = "Host Name for App VM"
}
variable "app_username" {
    type             = string
    description      = "Username Name for App VM"
}
variable "app_os_password" {
    type             = string
    description      = "Password for App VM"
}
variable "primary_database" {
    type             = string
    description      = "Primary Database Name"
}
variable "primary_database_admin" {
    type             = string
    description      = "Primary Database Admin Name"
}
variable "primary_database_password" {
    type             = string
    description      = "Primary Database Password"
}
variable "primary_database_version" {
    type             = string
    description      = "Primary Database Version"
}




