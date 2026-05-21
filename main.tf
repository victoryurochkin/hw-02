data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "platform" {
  folder_id   = var.folder_id
  name        = "develop"
  hostname    = "develop"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = var.existing_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_public_root_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}
