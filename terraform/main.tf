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

resource "google_compute_address" "default" {
  project      = var.project
  name         = "ip-address"
  address_type = "EXTERNAL"
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
      nat_ip = google_compute_address.default.address
    }
  }

  # Apply allow http(s) firewall rules to the compute instance so that the server will be accesible via the browser
  tags = ["http-server", "https-server"]

  # Try a remote exec so that ssh will be up when we do the following local execs
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("${var.ssh_private_key_file}")
      host        = google_compute_address.default.address
    }

    inline = [
      "echo SSH should now be up!"
    ]
  }

  # Run Ansible initial server setup
  provisioner "local-exec" {
    command = <<-EOT
    ansible-playbook \
    -u root \
    -i '${google_compute_address.default.address},' \
    --private-key ${var.ssh_private_key_file} \
    initial_server_setup.yml
    EOT

    working_dir = "../ansible/"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_FORCE_COLOR       = 1
    }
  }

  # Run Ansible website setup
  provisioner "local-exec" {
    command = <<-EOT
    ansible-playbook \
    -i '${google_compute_address.default.address},' \
    --private-key ${var.ssh_private_key_file} \
    main.yml
    EOT

    working_dir = "../ansible/"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_FORCE_COLOR       = 1
    }
  }

}



output "public_ip" {
  value       = google_compute_address.default.address
  description = "The public IP of the web server"
}


