This project creates an Azure network infrastructure using Terraform modules. It provisions:

- Resource Group
- Virtual Network
- Subnets
- Network Security Groups (NSGs)
- NSG associations to subnets
- Parent module wiring for deployment

The structure is designed as reusable Terraform modules, with a root-level parent module that calls each child module.

## Project Structure

```text
RG_Vnet_Subnet_Pipeline/
├── README.md
├── azurerm_network_security_group/
│   ├── main.tf
│   ├── output.tf
│   └── variable.tf
├── azurerm_resource_group/
│   ├── main.tf
│   └── variable.tf
├── azurerm_subnet/
│   ├── main.tf
│   ├── output.tf
│   └── variable.tf
├── azurerm_virtual_network/
│   ├── main.tf
│   └── variable.tf
├── azurerm_VM_NIC_PIP/
│   ├── main.tf
│   └── variable.tf
├── parent_module/
│   ├── main.tf
│   ├── plan.txt
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variable.tf
└── .terraform/   (generated after init)
```

## Architecture

The parent module provisions the following Azure resources:

1. Resource Group
2. Virtual Network with address space `10.0.0.0/16`
3. Two subnets:
   - `frontend_subnet` → `10.0.2.0/24`
   - `backend_subnet` → `10.0.3.0/24`
4. Two NSGs:
   - `frontend-nsg`
   - `backend-nsg`
5. NSG association with each subnet

## Modules Overview

### 1. Resource Group Module
Location: `azurerm_resource_group/`

Creates Azure resource groups using `for_each`.

### 2. Virtual Network Module
Location: `azurerm_virtual_network/`

Creates Azure VNets using details passed from `var.vnetdetails`.

### 3. Subnet Module
Location: `azurerm_subnet/`

Creates subnets inside the VNet.

### 4. NSG Module
Location: `azurerm_network_security_group/`

Creates NSGs and attaches multiple inbound `security_rule` blocks dynamically.

### 5. Parent Module
Location: `parent_module/`

This is the main entry point. It calls child modules and defines Azure associations.

## Prerequisites

Before running this project, ensure you have:

- Azure subscription
- Azure CLI installed and logged in
- Terraform installed
- Appropriate Azure permissions to create RG, VNet, Subnet, NSG and network resources

Login to Azure:

```bash
az login
az account set --subscription "<your-subscription-id-or-name>"
```

## Configuration

The values are defined in `parent_module/terraform.tfvars`.

Example values:

```hcl
rgdetails = {
  rg1 = {
    name     = "rg_sunil"
    location = "Central India"
  }
}

vnetdetails = {
  vnet1 = {
    name                = "vnet_sunil"
    address_space       = ["10.0.0.0/16"]
    location            = "central India"
    resource_group_name = "rg_sunil"
  }
}
```

## Deployment Steps

Go to the parent module folder:

```bash
cd parent_module
```

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Review the plan:

```bash
terraform plan
```

Create resources:

```bash
terraform apply
```

To destroy the infrastructure:

```bash
terraform destroy
```

## Important Notes

- The project uses Terraform provider version `4.81.0` in `parent_module/provider.tf`.
- Azure region naming is case-insensitive, but it is better to keep consistent values like `centralindia` or `Central India`.
- There is a duplicate key in the sample `rgdetails` block in `parent_module/terraform.tfvars`; it should be cleaned up before running Terraform.
- The VM-related module is currently commented out in `parent_module/main.tf`.

## Example Flow

The parent module executes in this order:

1. Create Resource Group
2. Create VNet
3. Create Subnets
4. Create NSGs
5. Associate NSGs with subnets

## Security Rules Included

The `frontend_nsg` allows:

- SSH on port 22
- HTTP on port 80
- HTTPS on port 443

The `backend_nsg` allows:

- SSH on port 22

## Current Status

This repository is a working Terraform example for Azure networking resources and is structured as reusable modules.

## Future Improvement

You can extend this project by:

- enabling VM creation through `azurerm_VM_NIC_PIP`
- adding tags and naming standards
- splitting variables for environment-specific deployment
- adding remote state backend for CI/CD

## Author

This project is prepared for Azure Terraform learning and infrastructure automation practice.
