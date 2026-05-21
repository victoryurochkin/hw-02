output "vm_name" {
  description = "VM name"
  value       = yandex_compute_instance.platform.name
}

output "vm_external_ip" {
  description = "VM external IP address"
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "vm_internal_ip" {
  description = "VM internal IP address"
  value       = yandex_compute_instance.platform.network_interface[0].ip_address
}

output "ssh_command" {
  description = "SSH connection command"
  value       = "ssh ubuntu@${yandex_compute_instance.platform.network_interface[0].nat_ip_address}"
}
