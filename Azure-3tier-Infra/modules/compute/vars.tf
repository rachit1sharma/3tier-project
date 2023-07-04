variable "resource_group" {
   type             = string
   description      = "Resource group name"
}

variable "location" {
   type             = string
   description      = "Resource group location."
  }
  
variable "web_host_name"{
    type             = string
    description      = "Host Name for Web VM"
}
variable "web_username" {
    type             = string
    description      = "Username Name for Web VM"
}

variable "app_host_name"{
    type             = string
    description      = "Host Name for App VM"
}
variable "app_username" {
    type             = string
    description      = "Username Name for App VM"
}
