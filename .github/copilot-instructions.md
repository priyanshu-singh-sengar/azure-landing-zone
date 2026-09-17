# Copilot Instructions for This Repository

This repository contains Terraform for an Azure hub-spoke landing zone. When generating or suggesting HCL in this repo, follow these conventions:

## Provider & Version Pinning

- Use the `azurerm` provider, pinned via `~>` constraint in the root `terraform` block — do not introduce a second provider version constraint in a module.
- Do not hardcode a provider block inside any module — modules inherit the provider from the root.

## Naming Conventions

- Resource group names: `rg-<scope>-<environment>` (e.g. `rg-spoke-dev`, `rg-hub-landingzone`)
- VNets: `vnet-<scope>-<environment>` (e.g. `vnet-spoke-prod`)
- NSGs: `nsg-<environment>-<subnet-purpose>`
- Key Vaults / Storage Accounts: must be globally unique — suffix with a short deterministic hash, not a random value, so plans stay stable across runs.

## Module Structure

- Every module has exactly three files: `main.tf`, `variables.tf`, `outputs.tf`.
- Every variable requires a `description`.
- Prefer `for_each` over `count` for anything keyed by a meaningful identifier (environment name, subnet name) rather than a numeric index.
- Never use `count` or `for_each` conditioned on a value that is unknown until apply (e.g. an attribute of a resource created earlier in the same plan) — use a plain boolean variable instead.

## Tagging

- Every taggable resource must include at minimum: `environment` and `managed_by = "terraform"`.

## Secrets

- Never hardcode secrets, connection strings, or credentials in `.tf` files.
- Any secret-shaped value must come from a Key Vault data source or a variable with no committed default.

## Lifecycle & Safety

- Core shared infrastructure (hub resource group, hub VNet) must carry `lifecycle { prevent_destroy = true }`.
- Outputs exposing subnet IDs, connection details, or anything sensitive must be marked `sensitive = true`.

Suggestions that violate these conventions should be revised before acceptance, not merged as-is.
