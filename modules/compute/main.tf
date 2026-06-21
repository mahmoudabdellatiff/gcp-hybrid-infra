# public VM
resource "google_compute_instance" "public_vm" {
  name         = "public-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  project = var.project_id

  metadata = {
    ssh-keys = "mahmoud:${file("~/.ssh/GCPINFR.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.public_subnet_id
    access_config {} // external ip {public ip}
  }

  tags = ["ssh", "web", "public"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e
    apt update
    apt install nginx -y
    systemctl start nginx
    systemctl enable nginx
  EOF
}

# private VM
resource "google_compute_instance" "private_vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  project = var.project_id

  metadata = {
    ssh-keys = "mahmoud:${file("~/.ssh/GCPINFR.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.private_subnet_id
  }

  tags = ["ssh"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e
    apt update
    apt install nginx -y
  EOF
}
