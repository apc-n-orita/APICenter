---
name: azure-msdocs
description: Whenever a question or task related to Azure, Entra ID, or Microsoft Foundry comes up, always consult the official documentation via the microsoft-learn MCP (microsoft_docs_search / microsoft_docs_fetch / microsoft_code_sample_search) before answering or implementing.
---

# Azure / Entra ID / Microsoft Foundry — MS Docs Reference Rule

For work involving Azure, Entra ID, or Microsoft Foundry, do not rely on your own training data —
always check the latest official documentation with the `microsoft-learn` MCP tools before answering or implementing.

## Mandatory Reference Triggers

If any of the following topics are involved, **always look it up via MCP first** before answering:

- Azure services in general (App Service / Functions / Logic Apps / APIM / Key Vault, etc.)
- Entra ID (formerly Azure AD) — authentication/authorization, App Registration, App Role, Conditional Access, PIM, etc.
- Microsoft Foundry (agents, project creation, deployment)
- .NET / Azure SDK API signatures and code samples
- Azure CLI / Terraform AzureRM provider options and flags

## Choosing the Right Tool

| Tool                           | Purpose                                                                                            |
| ------------------------------ | -------------------------------------------------------------------------------------------------- |
| `microsoft_docs_search`        | Quickly get conceptual explanations, tutorials, or an overview of configuration steps              |
| `microsoft_docs_fetch`         | When the full text of a specific page is needed (long step-by-step tutorials, detailed references) |
| `microsoft_code_sample_search` | Checking API signatures, getting official code samples, resolving errors                           |

## Tips for Effective Search Queries

- Include the version (e.g., `Azure Functions Python v2`, `.NET 8`)
- Include the task context (e.g., `quickstart`, `tutorial`, `configure`)
- Include the platform (e.g., `Linux`, `Windows`, `Standard`)
- Avoid overly broad queries (prefer `Azure Functions Python v2 Easy Auth Entra ID` over just `Azure Functions`)

---

## ⚠️ Microsoft Foundry: New (Foundry) vs Classic (Hub-based) Caution

Foundry currently has **two coexisting portal experiences**. Mixing them up leads to referencing outdated sources, so they must always be distinguished.

|                          | Foundry (New)                                  | Foundry Classic (Hub-based)                                                  |
| ------------------------ | ---------------------------------------------- | ---------------------------------------------------------------------------- |
| Also known as            | Microsoft Foundry, new Foundry                 | Azure AI Foundry Classic, old Hub                                            |
| Resource structure       | Foundry Resource → Foundry Project             | Hub → Hub-based Project                                                      |
| New feature availability | ✅ New agent/model features are only here      | ❌ No new features are added                                                 |
| Prompt Flow              | ❌ Not supported                               | ✅ Supported                                                                 |
| Agent visibility         | Agents created in New are not shown in Classic | Same in reverse                                                              |
| Recommendation           | **Use this for new work**                      | Only for migrating existing Hub environments or when Prompt Flow is required |

**When looking up MS Docs**, be careful not to accidentally reference old Hub-based documentation.
When searching, use keywords like `Microsoft Foundry project` or `Foundry resource`, and treat any documentation
premised on `Hub`, `Azure AI Studio`, or `Hub-based project` as outdated information.

Official portal: https://ai.azure.com (you can switch between New / Classic using the toggle in the top right)
