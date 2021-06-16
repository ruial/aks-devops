variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "West Europe"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
  description = "Public SSH key for linux nodes"
}

variable "dns_zone" {
  default = "aks.briefbytes.com"
  description = "AKS dns zone"
}
