# Azure Hub & Spoke Network Architecture

[![CI](https://github.com/dwoitzik/terraform-azurerm-hub-spoke/actions/workflows/tf-linter.yml/badge.svg)](https://github.com/dwoitzik/terraform-azurerm-hub-spoke/actions/workflows/tf-linter.yml)

> **Status: v0.1.0 — pre-1.0.** CI runs `terraform fmt`, `validate`, and `tflint` on every push, but this has never been through `terraform plan`/`apply` against a real Azure subscription. That proves syntax, not that it works. Reaching 1.0 needs a real plan-and-apply pass, which needs the operator (an Azure subscription, credentials, and someone watching the apply).

A clean, production-ready Infrastructure as Code (IaC) template to deploy a standard Hub-and-Spoke network topology in Microsoft Azure using Terraform.

This repository provides the foundational network components, establishing isolated Spoke VNets connected via bidirectional VNet peering to a central Hub — ready for workload deployment in minutes.

```
                        ┌─────────────────┐
                        │   vnet-hub      │
                        │  (Shared Svcs)  │
                        └────────┬────────┘
                    ┌────────────┴────────────┐
                    │    VNet Peering (↔)     │
           ┌────────┴────────┐       ┌────────┴────────┐
           │  vnet-spoke-01  │       │  vnet-spoke-02  │
           │  (Workload A)   │       │  (Workload B)   │
           └─────────────────┘       └─────────────────┘
```

## 🚀 Features

- **Centralized Hub** — Dedicated Virtual Network for shared services (Firewall, DNS, Bastion)
- **Isolated Spokes** — Two pre-configured Spoke VNets for workload segmentation
- **Bidirectional Peering** — Automated Hub ↔ Spoke peerings with forwarded traffic enabled
- **`allow_forwarded_traffic = true`** — Hub-routed traffic works out of the box
- **Zero-Trust NSGs** — Pre-hardened, audit-ready subnet-level traffic controls on every spoke
- **Centralized Private DNS Zones** — Cross-subnet Private Endpoint DNS resolution wired up out of the box, with a DINE-policy-safe `lifecycle.ignore_changes` block so Terraform state doesn't fight Azure Policy remediation
- **Clean variable structure** — Customize via `terraform.tfvars` without touching core logic

## 🛠️ Prerequisites

- Terraform `>= 1.5.0`
- Azure CLI (`az login`)
- An active Azure Subscription
- Contributor rights on the target Subscription or Resource Group

## 📖 Usage

**1. Clone the repository**

```bash
git clone https://github.com/dwoitzik/terraform-azurerm-hub-spoke.git
cd terraform-azurerm-hub-spoke
```

**2. Configure your variables**

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your environment values:

```hcl
rg_name         = "rg-network-core"
location        = "westeurope"
hub_vnet_cidr   = ["10.0.0.0/16"]
spoke1_vnet_cidr = ["10.1.0.0/16"]
spoke2_vnet_cidr = ["10.2.0.0/16"]
```

**3. Deploy**

```bash
terraform init
terraform plan
terraform apply
```

## 📁 Repository Structure

```
.
├── main.tf                  # VNets & peerings
├── nsg.tf                   # Zero-Trust NSGs & spoke subnets
├── dns.tf                   # Centralized Private DNS zones
├── variables.tf             # Input variable definitions
├── outputs.tf               # VNet IDs & names
├── terraform.tfvars.example # Example configuration
└── README.md
```

## ⚠️ Known Limitations

This template deliberately keeps scope minimal:

- No Azure Firewall — traffic between Spokes is not inspected (pair with [azure-firewall-forced-tunneling](https://github.com/dwoitzik/azure-firewall-forced-tunneling) for that)
- `use_remote_gateways` is not set — VPN/ExpressRoute traffic will not route through a Hub Gateway by default

---

## 📖 Deep Dive

Read the full technical breakdown — Zero-Trust NSGs, DINE-policy bypass logic, and centralized Private DNS explained step by step:

**[Hub & Spoke with Zero-Trust NSGs and Private DNS →](https://woitzik.dev/blog/azure-terraform-hub-spoke-zero-trust)**

Regulated environments (ISO 27001, NIS2, KRITIS) tend to hit the same three walls: centralized Private DNS zones fighting Azure Policy's `DeployIfNotExists` remediation, DINE-policy state drift, and subnet-level NSGs that actually hold up in an audit. All three are included here, not bolted on separately.

---

## 📄 License

MIT — free to use, modify, and distribute.

*Built by [David Woitzik](https://woitzik.dev) · [LinkedIn](https://linkedin.com/in/david-woitzik)*
