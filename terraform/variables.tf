variable "location" {
  type        = string
  description = "Azure Region for the deployment"
  default     = "westeurope"
}

variable "rg_name" {
  type        = string
  description = "Name of the Resource Group"
  default     = "rg-network-hub-spoke-base"
}

variable "hub_vnet_cidr" {
  type        = list(string)
  description = "CIDR block for the Hub VNet"
  default     = ["10.0.0.0/16"]
}

variable "spoke1_vnet_cidr" {
  type        = list(string)
  description = "CIDR block for Spoke 1 VNet"
  default     = ["10.1.0.0/16"]
}

variable "spoke2_vnet_cidr" {
  type        = list(string)
  description = "CIDR block for Spoke 2 VNet"
  default     = ["10.2.0.0/16"]
}

variable "environment" {
  type        = string
  description = "The environment name (e.g., dev, test, prod)."
}

variable "tags" {
  type        = map(string)
  description = "Standard tags to apply to all resources."
  default     = {}
}
