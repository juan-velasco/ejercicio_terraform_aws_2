variable "resource_group_location" {
  description = "Resource group location"
  type        = string
  default = "West Europe"
}

variable "vm_ssh_password" {
  description = "SSH Password"
  type        = string
  default = "GeyPzmz56PALS4CxKnG"
  sensitive = true
}