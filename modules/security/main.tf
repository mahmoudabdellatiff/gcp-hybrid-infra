resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = var.vpc_id
  project = var.project_id
  allow {
    protocol = "tcp"
    ports = [
      "22"
    ]
  }
  source_ranges = ["${var.my_ip}/32"] //my own machine ip 
  target_tags = [
    "ssh"
  ]
}

resource "google_compute_firewall" "web" {
  name    = "allows-webs-ports"
  network = var.vpc_id
  project = var.project_id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_firewall" "internal" { // for services communication {Private VM accessible via SSH only through public VM acting as bastion}
  name    = "allow-internal"
  network = var.vpc_id
  project = var.project_id
  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80"
    ]
  }

  source_ranges = ["10.1.0.0/24"]

  target_tags = [
    "ssh"
  ]

}

resource "google_compute_firewall" "app" {
  name    = "allow-app"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = ["10.1.0.0/24"]
  target_tags   = ["ssh"]
}
