resource "google_compute_network" "gcp_vpc" {
  name = "production-vpc"

  auto_create_subnetworks = false
  mtu                     = 1460
  project = var.project_id
}

resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  region        = var.region
  network       = google_compute_network.gcp_vpc.id
  ip_cidr_range = "10.1.0.0/24" // 256 ip 
  project = var.project_id

  log_config {                                    // to store the traffics
    aggregation_interval = "INTERVAL_5_SEC"       // every 5 sec make a log    
    flow_sampling        = 0.5                    // collect the 50% of the traffics {if 1 => all traffics}
    metadata             = "INCLUDE_ALL_METADATA" // add more informations 
  }

}

resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  region                   = var.region
  network                  = google_compute_network.gcp_vpc.id
  ip_cidr_range            = "10.0.2.0/24"
  private_ip_google_access = true // to allow vm communcate with google services without public ip 
  project = var.project_id

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_router" "router" {
  name    = "main-router"
  region  = var.region
  network = google_compute_network.gcp_vpc.id
  project = var.project_id

}

resource "google_compute_router_nat" "nat" { // to enable the vm in private subnet connects to the internet{ one way only }, but the internet can not connects to it 
  name                               = "cloud-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"           // that mean GCP allocate public ip for nat atomaticlly 
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS" // make nat for private subnetwork 
  project = var.project_id

  subnetwork {
    name = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = [
      "ALL_IP_RANGES"
    ]
  }
}


resource "google_compute_route" "internet" { // determine the destination of the traffics. 
  name             = "internet-route"
  network          = google_compute_network.gcp_vpc.id
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway" // the traffics  up from vpc to internet by internet gateway 
  tags = ["public"]
  project = var.project_id
  priority = 1000
}
