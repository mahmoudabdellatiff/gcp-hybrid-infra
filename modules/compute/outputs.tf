output "public_vm_ip" {
  value = google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip
}

output "private_vm_ip" {
  value = google_compute_instance.private_vm.network_interface[0].network_ip
}
