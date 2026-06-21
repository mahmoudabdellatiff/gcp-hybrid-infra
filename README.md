# GCP Hybrid Cloud Infrastructure

![Terraform](https://img.shields.io/badge/Terraform-v1.15-purple)
![GCP](https://img.shields.io/badge/GCP-Cloud-blue)
![Status](https://img.shields.io/badge/Status-Active-green)

## Overview
Production-grade infrastructure on Google Cloud Platform built entirely with Terraform, demonstrating security best practices, observability, and hybrid cloud connectivity between on-premises and cloud environments.

## Architecture

```
                    Internet
                       ↓
            [Public VM — Nginx :80]
                       ↓  reverse proxy
            [Private VM — FastAPI :8000]

[Home Server (on-prem)] ←── Tailscale VPN ──→ [GCP VPC]
                                                    ↓
                                         [Private Subnet 10.0.2.0/24]
```

## Components

### Networking
- Custom VPC with isolated public/private subnets
- Cloud NAT — outbound-only internet access for private subnet
- VPC Flow Logs capturing 50% of traffic with full metadata
- Explicit internet route scoped to public-tagged instances only

### Compute
- **Public VM** — Nginx reverse proxy, has public IP
- **Private VM** — FastAPI application, no public IP, fully isolated

### Security
- Bastion host pattern — private VM accessible only via public VM
- SSH restricted to specific IP via firewall rules
- Principle of least privilege across all firewall rules
- Private subnet fully isolated from inbound internet traffic

### Observability
- GCP Uptime Check polling Nginx every 60 seconds
- Alert policy with email notification on 2-minute outage
- VPC Flow Logs for network traffic analysis

### Hybrid Connectivity
- Tailscale VPN tunnel between on-premises server (Debian 13) and GCP VPC
- On-prem server reaches private subnet directly — no public IP needed
- Subnet route advertised via public VM acting as gateway

### Remote State
- Terraform state stored in GCS bucket with versioning enabled
- Enables team collaboration without state conflicts

## Project Structure

```
gcp-infra/
├── main.tf                 # Root module
├── backend.tf              # GCS remote state
├── variables.tf
├── outputs.tf
└── modules/
    ├── network/            # VPC, subnets, NAT, routes
    ├── compute/            # VM instances
    ├── security/           # Firewall rules
    └── monitoring/         # Uptime checks, alerts
```

## Tech Stack
- **IaC** — Terraform v1.15
- **Cloud** — GCP (VPC, Compute Engine, Cloud NAT, Cloud Monitoring, GCS)
- **Web Server** — Nginx reverse proxy
- **Application** — Python FastAPI
- **VPN** — Tailscale (WireGuard-based)
- **OS** — Debian 12
