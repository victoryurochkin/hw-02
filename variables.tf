variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "zone" {
  type        = string
  description = "Yandex Cloud availability zone"
  default     = "ru-central1-b"
}

variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud service account key JSON file"
  sensitive   = true
}

variable "existing_subnet_id" {
  type        = string
  description = "Existing Yandex Cloud subnet ID"
  default     = "e2lt5rhm75gtha6stmuh"
}

variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key for VM access"
}

variable "vm_web_image_family" {
  type        = string
  description = "Yandex Cloud image family for web VM"
  default     = "ubuntu-2204-lts"
}

variable "vm_web_name" {
  type        = string
  description = "Web VM name"
  default     = "develop"
}

variable "vm_web_hostname" {
  type        = string
  description = "Web VM hostname"
  default     = "develop"
}

variable "vm_web_platform_id" {
  type        = string
  description = "Web VM platform ID"
  default     = "standard-v1"
}

variable "vm_web_cores" {
  type        = number
  description = "Web VM CPU cores"
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  description = "Web VM RAM size in GB"
  default     = 2
}

variable "vm_web_core_fraction" {
  type        = number
  description = "Web VM guaranteed vCPU performance fraction"
  default     = 5
}

variable "vm_web_disk_size" {
  type        = number
  description = "Web VM boot disk size in GB"
  default     = 10
}

variable "vm_web_disk_type" {
  type        = string
  description = "Web VM boot disk type"
  default     = "network-hdd"
}

variable "vm_web_nat" {
  type        = bool
  description = "Enable public NAT IP for web VM"
  default     = true
}

variable "vm_web_ssh_user" {
  type        = string
  description = "Default SSH user for web VM"
  default     = "ubuntu"
}

variable "vm_web_preemptible" {
  type        = bool
  description = "Enable preemptible mode for web VM"
  default     = true
}
