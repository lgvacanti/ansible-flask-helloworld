terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)

  project = var.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "website" {
  name         = "website-host"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2004-lts"
    }
  }

  metadata = {
    ssh-keys = format("root:%s", file("${var.ssh_key_file}"))
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

}
