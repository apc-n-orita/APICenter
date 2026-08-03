# Hands-On

This assumes you've completed the environment setup in [README.md](./README.md).

## 1. Check the API Management integration in the portal

You already set `apicenter_apim_resource_ids` and ran `azd up` in environment setup — let's check the result.

1. Build the API Center portal URL (the hostname is already included in the azd outputs)
   ```bash
   echo "https://$(azd env get-value APICENTER_PORTAL_HOSTNAME)"
   ```
2. Open the URL shown
3. Confirm that MCP servers, Agents, and APIs have been automatically pulled in via API Management, in the **Assets** list

This is API Management integration — API Center periodically detects and syncs APIs/Agents on the existing instance.

## 2. Check the Git repository integration in the portal

Now switch the integration target from API Management to a Git repository. Since the Free plan only allows one at a time, empty `apicenter_apim_resource_ids` and set `apicenter_git_repository_urls`.

### 2-1. Issue a GitHub fine-grained PAT

Git repository integration needs a GitHub fine-grained PAT to read your fork. Issue it with **minimum permissions**.

1. Open GitHub's [Settings > Developer settings > Fine-grained tokens](https://github.com/settings/personal-access-tokens/new)
2. **Resource owner**: your own account
3. **Repository access**: **Only select repositories** → select only the repository you forked
4. **Repository permissions**:
   - **Contents**: **Read-only** (nothing else is needed)
5. Generate the token and note down the value (it won't be shown again once you close this screen)

### 2-2. Set the PAT as an azd environment variable

`infra/main.tfvars.json` has `"github_pat": "${GITHUB_PAT}"` — it pulls from the azd environment, not something you edit directly. Set it with `azd env set`:

```bash
azd env set GITHUB_PAT <the fine-grained PAT you issued in 2-1>
```

### 2-3. Update `infra/main.tfvars.json`

| Item                            | Value                                                                         |
| ------------------------------- | ----------------------------------------------------------------------------- |
| `apicenter_git_repository_urls` | `https://github.com/<your account>/<your forked repo name>/tree/main/catalog` |
| `apicenter_apim_resource_ids`   | `""` (set back to empty)                                                      |

```bash
azd up
```

### 2-4. Check in the portal

Confirm in the API Center portal's **Assets** that `SKILL.md` and other files under `catalog/skills` in your forked repository have been pulled in as Skills / MCP servers / Agents.

## 3. Install the catalog locally with APM

Use [APM (Agent Package Manager)](https://microsoft.github.io/apm/) to install both **Skills** and **MCP servers** into your local environment (GitHub Copilot / Claude Code, etc.) in one go: rewrite the placeholders in `apm.yml`, then run `apm install`.

### 3-1. Rewrite the placeholders in `apm.yml`

This repository's `apm.yml` currently looks like this.

```yaml
dependencies:
  apm:
    - <owner>/<repo>/catalog/skills/azure-msdocs
    - <owner>/<repo>/catalog/skills/azure-terraform
    - <owner>/<repo>/catalog/skills/spiritual-engineer
  mcp:
    - name: <mcp-server-name>
      registry: https://<api-center-url>/workspaces/default
```

Set the environment variable so API Center's data-plane API is used as an MCP registry, then check the name with `apm mcp list`. This catalog's `catalog/mcp/microsoft-learn` maps to the **MS Docs MCP** (`io.github.microsoftdocs/mcp-xxxx`) — look for that entry.

```bash
APICENTER_URL="$(azd env get-value APICENTER_NAME).data.$(azd env get-value AZURE_LOCATION).azure-apicenter.ms"
export MCP_REGISTRY_URL="https://${APICENTER_URL}/workspaces/default"

apm mcp list
```

With that name confirmed, rewrite `apm.yml` all at once using it plus your forked repo's info.

```bash
OWNER_REPO="<your account>/<your forked repo name>"
MCP_SERVER_NAME="<the MS Docs MCP server name confirmed via apm mcp list>"

sed -i \
  -e "s#<owner>/<repo>#${OWNER_REPO}#g" \
  -e "s#<mcp-server-name>#${MCP_SERVER_NAME}#" \
  -e "s#<api-center-url>#${APICENTER_URL}#" \
  apm.yml
```

Make sure to replace `OWNER_REPO` and `MCP_SERVER_NAME` with actual values before running this.

### 3-2. Run `apm install`

```bash
apm install
```

Installs the Skill (via Git) and the MCP server (via the API Center registry) declared in `apm.yml`, all at once.

### 3-3. Verify it worked

Confirm that both the Skill and the MCP server are reflected in the config file of your installation target harness (VS Code / Claude Code, etc.).

That completes the flow of distributing Skills and MCP servers registered in API Center to your team via APM.

Thanks for completing the hands-on. Finally, take a look at the [Closing Thoughts in README.md](./README.md#closing-thoughts) as well.
