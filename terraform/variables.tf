# Variable definitions

variable "project" {
  description = "GCP project id"
  type        = string
}

variable "credentials" {
  description = "Location of your GCP credentials file, e.g. /home/user/<projectid>.json"
  type        = string
}

variable "ssh_key_file" {
  description = "File that contains the public ssh-key you want to add to the VM instance"
  type        = string
}

variable "ssh_private_key_file" {
  description = "File that contains the private ssh-key corresponding to the public key you want to add to the VM instance"
  type        = string
}
