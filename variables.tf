variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "me-central1"
}

variable "zone" {
  type    = string
  default = "me-central1-a"
}

variable "my_ip" {
  type        = string
  description = "Your home IP for SSH access"
}

variable "ssh_pub_key" {
  type        = string
  description = "SSH public key content"
}

variable "alert_email" {
  type = string 
  description = "email for monitoring alerts"
}
