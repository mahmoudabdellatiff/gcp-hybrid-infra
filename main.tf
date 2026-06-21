provider "google" {
  project = var.project_id
  region = var.region
}
module "network" {
  source = "./modules/network/"
  project_id = var.project_id 
  region = var.region
}
module "security" {
  source = "./modules/security/"
  project_id = var.project_id 
  vpc_id = module.network.vpc_id
  my_ip = var.my_ip
}

module "compute" {
  source = "./modules/compute/"
  project_id = var.project_id
  zone = var.zone
  public_subnet_id = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  ssh_pub_key = var.ssh_pub_key
  
}

module "monitoring" {
  source = "./modules/monitoring/"
  project_id = var.project_id
  public_vm_ip = module.compute.public_vm_ip
  alert_email = var.alert_email
}
