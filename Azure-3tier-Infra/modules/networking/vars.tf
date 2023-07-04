variable "resource_group" {
   type             = string
   description      = "Resource group name"
}

variable "location" {
   type             = string
   description      = "Resource group location."
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
