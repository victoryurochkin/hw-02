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
  default     = "ru-central1-a"
}

variable "existing_subnet_id" {
  type        = string
  description = "Existing Yandex Cloud subnet ID"
}

variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key for VM access"
}

variable "yc_token" {
  type        = string
  description = "Yandex Cloud IAM token"
  sensitive   = true
}

variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud service account key JSON file"
  sensitive   = true
}
