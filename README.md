# Azure Hub & Spoke Network Architecture (Base Edition)

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
- **Clean variable structure** — Customize via `terraform.tfvars` without touching core logic

## 🛠️ Prerequisites

- Terraform `>= 1.5.0`
- Azure CLI (`az login`)
- An active Azure Subscription
- Contributor rights on the target Subscription or Resource Group

## 📖 Usage

**1. Clone the repository**

```bash
git clone https://github.com/dwoitzik/azure-network-hub-spoke.git
cd azure-network-hub-spoke
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
├── variables.tf             # Input variable definitions
├── outputs.tf               # VNet IDs & names
├── terraform.tfvars.example # Example configuration
└── README.md
```

## ⚠️ Known Limitations (Base Edition)

This template deliberately keeps scope minimal. The following are **not included** and will require manual configuration or the Enterprise Edition:

- No NSGs — Spoke VNets are isolated from each other via peering, but no subnet-level traffic filtering is applied
- No Azure Firewall — traffic between Spokes is not inspected
- No centralized Private DNS Zones — Private Endpoint DNS resolution across Spokes requires additional configuration
- `use_remote_gateways` is not set — VPN/ExpressRoute traffic will not route through a Hub Gateway by default

---

## 📖 Deep Dive

Read the full technical breakdown — Zero-Trust NSGs, DINE-policy bypass logic, and centralized Private DNS explained step by step:

**[Enterprise Hub & Spoke with Zero-Trust NSGs and Private DNS →](https://woitzik.dev/blog/azure-terraform-hub-spoke-zero-trust)**

---

## 🔒 Need Enterprise-Grade Security & DNS Integration?

The base architecture covers standard deployments. But in regulated environments (ISO 27001, NIS2, KRITIS), you will quickly run into:

- **Centralized Private DNS Zones** — cross-subscription Private Endpoint DNS resolution conflicts with Azure Policy (`DeployIfNotExists`)
- **DINE-policy bypass logic** — without it, Terraform state drifts constantly against Azure Policy remediation tasks
- **Zero-Trust NSG rulesets** — pre-hardened, audit-ready subnet-level controls

Getting these right from scratch takes a senior engineer days, not hours.

👉 **[Get the Enterprise Hub & Spoke Edition →](https://woitzik-cloud.lemonsqueezy.com/checkout/buy/e8caa68b-bc22-489e-b453-2ea28bd28eb0)**
Includes full source for centralized Private Link DNS injection, DINE-policy bypass logic, and pre-hardened NSG rulesets. Audit-ready on day one.

---

## 📄 License

MIT — free to use, modify, and distribute.

*Built by [David Woitzik](https://woitzik.dev) · [LinkedIn](https://linkedin.com/in/david-woitzik)*
