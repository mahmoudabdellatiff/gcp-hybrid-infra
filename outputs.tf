output "public_vm_ip" {
  value = module.compute.public_vm_ip
}

output "private_vm_ip" {
  value = module.compute.private_vm_ip
}

output "vpc_name" {
  value = "production-vpc"
}

output "uptime_check_id" {
  value = module.monitoring.uptime_check_id
}
