variable "project_id" {
  type = string
}
variable "public_vm_ip" {
  type        = string
  description = "public ip of the nginx vm to monitor"
}
variable "alert_email" {
  type        = string
  description = "email alert"
}
