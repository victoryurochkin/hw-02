# ------------------------------------------------------------
# Active VM variables
# ------------------------------------------------------------

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

variable "vm_web_name_prefix" {
  type        = string
  description = "Prefix for web VM name"
  default     = ""
}

variable "vm_web_name_suffix" {
  type        = string
  description = "Suffix for web VM name"
  default     = ""
}

variable "vm_db_image_family" {
  type        = string
  description = "Yandex Cloud image family for DB VM"
  default     = "ubuntu-2204-lts"
}

variable "vm_db_name" {
  type        = string
  description = "DB VM name"
  default     = "netology-develop-platform-db"
}

variable "vm_db_hostname" {
  type        = string
  description = "DB VM hostname"
  default     = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type        = string
  description = "DB VM platform ID"
  default     = "standard-v3"
}

variable "vm_db_name_prefix" {
  type        = string
  description = "Prefix for DB VM name"
  default     = "netology-"
}

variable "vm_db_env" {
  type        = string
  description = "Environment name for DB VM"
  default     = "develop"
}

variable "vm_db_platform" {
  type        = string
  description = "Platform name part for DB VM"
  default     = "platform"
}

variable "vm_db_role" {
  type        = string
  description = "Role name part for DB VM"
  default     = "db"
}

# ------------------------------------------------------------
# Task 6: common map(object) variable for VM resources
# ------------------------------------------------------------

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    nat           = bool
    preemptible   = bool
  }))

  description = "Resources configuration for all virtual machines"

  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      hdd_size      = 10
      hdd_type      = "network-hdd"
      nat           = true
      preemptible   = true
    }

    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-hdd"
      nat           = true
      preemptible   = true
    }
  }
}

# ------------------------------------------------------------
# Task 6: common metadata variable for all VMs
# ------------------------------------------------------------

variable "metadata" {
  type        = map(string)
  description = "Common metadata for all virtual machines"
}

# ------------------------------------------------------------
# Deprecated variables after task 6.
# These variables are no longer used because resources configuration
# was moved to var.vms_resources.
# ------------------------------------------------------------

# variable "vm_web_cores" {
#   type        = number
#   description = "Web VM CPU cores"
#   default     = 2
# }

# variable "vm_web_memory" {
#   type        = number
#   description = "Web VM RAM size in GB"
#   default     = 2
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   description = "Web VM guaranteed vCPU performance fraction"
#   default     = 5
# }

# variable "vm_web_disk_size" {
#   type        = number
#   description = "Web VM boot disk size in GB"
#   default     = 10
# }

# variable "vm_web_disk_type" {
#   type        = string
#   description = "Web VM boot disk type"
#   default     = "network-hdd"
# }

# variable "vm_web_nat" {
#   type        = bool
#   description = "Enable public NAT IP for web VM"
#   default     = true
# }

# variable "vm_web_preemptible" {
#   type        = bool
#   description = "Enable preemptible mode for web VM"
#   default     = true
# }

# variable "vm_db_cores" {
#   type        = number
#   description = "DB VM CPU cores"
#   default     = 2
# }

# variable "vm_db_memory" {
#   type        = number
#   description = "DB VM RAM size in GB"
#   default     = 2
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   description = "DB VM guaranteed vCPU performance fraction"
#   default     = 20
# }

# variable "vm_db_disk_size" {
#   type        = number
#   description = "DB VM boot disk size in GB"
#   default     = 10
# }

# variable "vm_db_disk_type" {
#   type        = string
#   description = "DB VM boot disk type"
#   default     = "network-hdd"
# }

# variable "vm_db_nat" {
#   type        = bool
#   description = "Enable public NAT IP for DB VM"
#   default     = true
# }

# variable "vm_db_preemptible" {
#   type        = bool
#   description = "Enable preemptible mode for DB VM"
#   default     = true
# }
