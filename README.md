# API Center Hands-On

A hands-on lab for deploying Azure API Center with Terraform (azd) and experiencing **API Management integration** and **Git repository integration** firsthand.

## Hands-On Overview

Azure API Center is a service that catalogs an organization's APIs, MCP servers, Agents, and Skills in one place. This hands-on builds and verifies two integration methods:

- **API Management integration** — automatically syncs APIs/Agents deployed on an existing API Management instance into the API Center inventory
- **Git repository integration** — automatically syncs `SKILL.md` / `server.json` / `agent.md` files in a GitHub repository into the catalog as Skills, MCP servers, and Agents

You'll also install both Skills and MCP servers registered in the catalog into your local development environment using [APM (Agent Package Manager)](https://microsoft.github.io/apm/).

Detailed steps are in [handson.md](./handson.md). Start with the environment setup below.

## Environment Setup

### Prerequisites

Have the following installed locally:

- [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) (`azd`)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (`az`)
- [APM (Agent Package Manager)](https://microsoft.github.io/apm/)

### Steps

**1. Fork this repository privately**

Fork it under your own account, selecting **Private**. You'll use this fork later in the Git repository integration hands-on.

**2. Deploy [apim-mcp-oauth](https://github.com/apc-n-orita/apim-mcp-oauth) → [a2a-agent-foundry](https://github.com/apc-n-orita/a2a-agent-foundry) in that order**

To experience integrating with an existing API Management instance, first prepare an environment where multiple MCP servers and Agents are already deployed on API Management. These two repositories are designed to share the same API Management instance, so you **must deploy them in this order**.

Once deployed, note down this API Management instance's resource ID (you'll use it in the next step). Scope the query to the resource group `apim-mcp-oauth` was deployed into, in case there are other API Management instances in the subscription.

```bash
az apim list --resource-group <resource group apim-mcp-oauth was deployed into> --query "[].id" -o tsv
```

**3. Fill in `infra/main.tfvars.json` in this forked repository**

Fill in the `<...>` placeholders in `infra/main.tfvars.json`.

| Item | Value |
| --- | --- |
| `resource_group_name` | Name of the existing resource group to deploy into |
| `apicenter_apim_resource_ids` | The API Management resource ID you noted in step 2 |
| `log_analytics_workspace_name` | Name of the existing Log Analytics workspace to send diagnostic logs to (must be in the same resource group as `resource_group_name`) |

Leave `apicenter_git_repository_urls` **empty for now**. On the API Center Free plan, only one "platform integration" (such as Git repository integration or API Management integration) can be enabled at a time, so we'll enable API Management integration only for now (Git repository integration is switched on later, in [handson.md](./handson.md)).

**4. Deploy**

```bash
azd up
```

**5. Configure the API Center portal**

Once deployed, open the API Center instance created in the Azure portal and configure the following (these are preview features that can't be managed via Terraform, so manual setup is required).

- **Enable anonymous access**
  1. From the API Center side menu, open **Consumption > Portal settings**
  2. On the **Access** tab, select **Allow anonymous access**
  3. Select **Confirm and Enable**
- **Configure Contribution**
  1. On the same **Portal settings** page, open the **Contribution** tab
  2. Enter the URL of the repository you forked in step 1
  3. Select **Save + publish**

Environment setup is now complete. Continue with [handson.md](./handson.md).

### Delete Resources

When you're done with the hands-on, remove the resources for this repository:

```bash
azd down
```

If you also want to remove the resources deployed for `apim-mcp-oauth` and `a2a-agent-foundry`, run `azd down` in each of those repositories as well. Since `a2a-agent-foundry` reuses `apim-mcp-oauth`'s API Management instance, tear them down in the **reverse** of the deployment order — `a2a-agent-foundry` first, then `apim-mcp-oauth`.

## Closing Thoughts

The three repositories in this hands-on trace a shape similar to the direction the tarot's Major Arcana moves in — scattered, individual pieces gradually converging into a single circle.

[apim-mcp-oauth](https://github.com/apc-n-orita/apim-mcp-oauth) raised a ward of OAuth, token validation, and role-based authorization, giving each MCP server a clear outline of its own. [a2a-agent-foundry](https://github.com/apc-n-orita/a2a-agent-foundry) built on that foundation and let Agents begin connecting to each other as Agent-to-Agent. And finally, in this repository, APIs and Agents living inside API Management, and Skills living inside a Git repository — assets born in different places, in different contexts — were all gathered into a single API Center catalog, without breaking their boundaries and without forcing them into an undifferentiated mix. Just as the tarot's THE WORLD is a picture of "every element remaining fully itself, all held within one circle," by the time you've passed through these three repositories, a single world — protected, connected, and integrated — should already exist in your hands.

This repository's `catalog/skills` folder includes a skill called [`spiritual-engineer`](./catalog/skills/spiritual-engineer/README.md), which responds by integrating an engineer's perspective with a spiritual one, without separating the two. Give it a try, right in the flow of the `apm install` you just ran in this hands-on. Tarot, numerology, the relationship between IT and spirituality itself, or a design decision you're currently wrestling with — any of these work. Technical accuracy stays intact, while it should also give you a chance to look at the same question from one level deeper.

May the catalog in your hands turn out to be a good place of integration, for both code and soul.
