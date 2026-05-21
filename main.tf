data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  folder_id   = var.folder_id
  name        = var.vm_web_name
  hostname    = var.vm_web_hostname
  platform_id = var.vm_web_platform_id
  zone        = var.zone

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vm_web_disk_size
      type     = var.vm_web_disk_type
    }
  }

  network_interface {
    subnet_id = var.existing_subnet_id
    nat       = var.vm_web_nat
  }

  metadata = {
    ssh-keys = "${var.vm_web_ssh_user}:${var.vms_ssh_public_root_key}"
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
}
