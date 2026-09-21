---
name: Infrastructure Change Request
about: Propose a change to the Terraform landing zone
title: '[LZ] '
labels: infrastructure
---

## Summary
<!-- Provide a clear, one-sentence description of the proposed infrastructure change -->

## Component(s) Affected
- [ ] `hub-network` (Hub VNet, Azure Firewall, Bastion, Gateway)
- [ ] `spoke-network` (Spoke VNets, Subnets, Route Tables, NSGs)
- [ ] `spoke-peering` (Hub-Spoke VNet Peerings)
- [ ] `data-secrets` (Key Vault, Storage Accounts)
- [ ] `observability` (Log Analytics, Diagnostic Settings)
- [ ] `identity` (User-Assigned Managed Identity, RBAC)
- [ ] `governance` (Azure Policies, Policy Assignments)
- [ ] `workload` (App Service Plans, Web Apps)

## Environment(s)
- [ ] `dev`
- [ ] `test`
- [ ] `prod`
- [ ] `hub`

## Acceptance Criteria
<!-- Bullet list specifying definition of done and test criteria -->
- [ ] Terraform configuration passes local `fmt` and `validate`
- [ ] Security scan passes with zero high/critical vulnerabilities
- [ ] `terraform plan` produces expected speculative diff
- [ ] All resources adhere to required tags (`environment`, `managed_by`)

## Additional Context / Architecture Notes
<!-- Attach relevant architectural diagrams, design decisions, or references -->
