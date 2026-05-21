data "yandex_compute_image" "ubuntu_web" {
  family = var.vm_web_image_family
}

data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_db_image_family
}

resource "yandex_compute_instance" "platform" {
  folder_id   = var.folder_id
  name        = local.vm_web_instance_name
  hostname    = local.vm_web_instance_name
  platform_id = var.vm_web_platform_id
  zone        = var.zone

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
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

resource "yandex_compute_instance" "platform_db" {
  folder_id   = var.folder_id
  name        = local.vm_db_instance_name
  hostname    = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone        = var.zone

  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
      size     = var.vm_db_disk_size
      type     = var.vm_db_disk_type
    }
  }

  network_interface {
    subnet_id = var.existing_subnet_id
    nat       = var.vm_db_nat
  }

  metadata = {
    ssh-keys = "${var.vm_db_ssh_user}:${var.vms_ssh_public_root_key}"
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
}
