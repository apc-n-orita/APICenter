---
name: azure-terraform
description: Whenever work involves building or changing Azure resources with Terraform (azurerm/azapi providers), always consult both the terraform MCP (provider/module documentation) and the microsoft-learn MCP (official Azure documentation) before implementing.
---

# Azure Terraform — MCP Reference Rule

When creating, changing, or reviewing Azure resources with Terraform, do not rely on memory —
always check the latest information using a combination of the `terraform` MCP and the `microsoft-learn` MCP before implementing.
The `azurerm` / `azapi` providers in particular receive breaking changes frequently, so argument names, required fields,
and default values must always be verified via MCP.

## Mandatory Reference Triggers

In the following cases, **always check both MCPs before implementing**:

- Writing a new `azurerm_*` / `azapi_*` resource block, or changing arguments in an existing block
- Adding or updating a Terraform module (including official registry modules such as `Azure/*`)
- Changing provider version constraints (`required_providers`)
- Design decisions involving Azure-side specifications (supported SKUs, region constraints, naming conventions, RBAC role names, etc.)
- Investigating the cause of an unfamiliar error during plan/apply

## Choosing the Right MCP

| MCP / Tool                                                                             | Purpose                                                                                    |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `terraform` MCP: `search_providers` / `get_provider_details`                           | Check the official schema for a specific azurerm/azapi resource/attribute                  |
| `terraform` MCP: `get_latest_provider_version`                                         | Check the version constraint to write in `required_providers`                              |
| `terraform` MCP: `search_modules` / `get_module_details` / `get_latest_module_version` | Check input/output specs of official/community modules (e.g., `Azure/naming/azurerm`)      |
| `terraform` MCP: `search_policies` / `get_policy_details`                              | Check requirements when Sentinel policies are involved (only when using HCP Terraform)     |
| `microsoft-learn` MCP: `microsoft_docs_search`                                         | Overview of the Azure resource's own specs, limits, pricing model, and best practices      |
| `microsoft-learn` MCP: `microsoft_docs_fetch`                                          | When full tutorial text or quota tables and other detailed info are needed                 |
| `microsoft-learn` MCP: `microsoft_code_sample_search`                                  | Reference implementation for mapping ARM/Bicep configuration values to Terraform arguments |

Cloud/Enterprise-related tools (HCP Terraform operations such as `list_workspaces` / `create_run`) should only be used
when there is an explicit instruction to use HCP Terraform, and not for regular IaC implementation work.

## Implementation Flow

1. Use `search_providers` → `get_provider_details` from the `terraform` MCP to check the official schema (required arguments, types, default values, deprecation warnings) for the target resource/attribute.
2. Verify Azure-side constraints (naming conventions, region support, SKUs, RBAC, network requirements, etc.) with `microsoft_docs_search` from the `microsoft-learn` MCP.
3. When using an official module, check the input/output variables and version with `search_modules` / `get_module_details` before writing the `module` block.
4. After implementing, verify that the `terraform plan` diff does not contradict the specs confirmed via MCP.

## Tips for Search Queries

- terraform MCP: Be precise about the resource type (e.g., specify `azurerm_api_management_api` rather than just `azurerm_api_management`)
- microsoft-learn MCP: Include version, platform, and task context (e.g., `Azure API Management Standard v2 tier limits`)
- When a provider major version upgrade is involved (e.g., azurerm 3.x → 4.x), check both MCPs for breaking changes

---

## ⚠️ Caution When Terraforming Microsoft Foundry-related Resources

Foundry has **two coexisting portal experiences**, and the actual resource types used in Terraform differ between them.
Mixing them up will result in building a configuration premised on the old Hub, so they must always be distinguished
(note that there is no dedicated resource like `azurerm_ai_foundry` — both reuse existing generic resources).

|                          | Foundry (New)                                                                                                  | Foundry Classic (Hub-based)                     |
| ------------------------ | -------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| Also known as            | Microsoft Foundry, new Foundry                                                                                 | Azure AI Foundry Classic, old Hub               |
| AzureRM implementation   | `azurerm_cognitive_account` (core management features only; connections, capability hosts, etc. not supported) | `azurerm_machine_learning_workspace`            |
| AzAPI implementation     | `azapi_resource` (supports the full control plane, including preview features)                                 | `azapi_resource`                                |
| New feature availability | ✅ New agent/model features are only here                                                                      | ❌ No new features are added                    |
| Recommendation           | **Use this for new work**                                                                                      | Only when migrating an existing Hub environment |

Reference implementation: [Foundry Samples (Terraform)](https://github.com/microsoft-foundry/foundry-samples/tree/main/infrastructure/infrastructure-setup-terraform),
Azure Verified Module [`avm-ptn-aiml-ai-foundry`](https://registry.terraform.io/modules/Azure/avm-ptn-aiml-ai-foundry/azurerm/latest).

**When looking things up via the microsoft-learn MCP**, be careful not to accidentally reference old Hub-based documentation.
When searching, use keywords like `Microsoft Foundry project` or `Foundry resource`, and treat any documentation
premised on `Hub`, `Azure AI Studio`, or `Hub-based project` as outdated information.
When looking up resource schemas via the `terraform` MCP as well, make explicit whether you are targeting
`azurerm_cognitive_account` (Foundry New) or `azurerm_machine_learning_workspace` (Hub) before calling
`search_providers` / `get_provider_details`. Also confirm before implementing that if fine-grained control plane
settings such as connections or capability hosts are needed, the AzAPI Provider (`azapi_resource`) is required
instead of AzureRM.
