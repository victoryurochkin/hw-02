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
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }

  network_interface {
    subnet_id = var.existing_subnet_id
    nat       = var.vms_resources["web"].nat
  }

  metadata = var.metadata

  scheduling_policy {
    preemptible = var.vms_resources["web"].preemptible
  }
}

resource "yandex_compute_instance" "platform_db" {
  folder_id   = var.folder_id
  name        = local.vm_db_instance_name
  hostname    = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone        = var.zone

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }

  network_interface {
    subnet_id = var.existing_subnet_id
    nat       = var.vms_resources["db"].nat
  }

  metadata = var.metadata

  scheduling_policy {
    preemptible = var.vms_resources["db"].preemptible
  }
}
