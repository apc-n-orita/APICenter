# Hands-On

This assumes you've completed the environment setup in [README.md](./README.md).

## 1. Check the API Management integration in the portal

Since you already set `apicenter_apim_resource_ids` and ran `azd up` during environment setup, let's start by checking the result of this integration.

1. Build the API Center portal URL (the hostname is already included in the azd outputs)
   ```bash
   echo "https://$(azd env get-value APICENTER_PORTAL_HOSTNAME)"
   ```
2. Open the URL shown
3. Confirm that MCP servers, Agents, and APIs have been automatically pulled in via API Management, in the **Assets** list

This is "API Management integration" — a feature where API Center periodically detects and syncs the APIs/Agents on an existing API Management instance.

## 2. Check the Git repository integration in the portal

Next, switch the integration target from API Management to a Git repository. Since the API Center Free plan only allows one platform integration at a time, empty out `apicenter_apim_resource_ids` and set `apicenter_git_repository_urls`.

### 2-1. Issue a GitHub fine-grained PAT

Git repository integration needs a GitHub Personal Access Token (fine-grained) to read your forked repository. Issue it with **the minimum permissions necessary**.

1. Open GitHub's [Settings > Developer settings > Fine-grained tokens](https://github.com/settings/personal-access-tokens/new)
2. **Resource owner**: your own account
3. **Repository access**: **Only select repositories** → select only the repository you forked
4. **Repository permissions**:
   - **Contents**: **Read-only** (nothing else is needed)
5. Generate the token and note down the value (it won't be shown again once you close this screen)

### 2-2. Update `infra/main.tfvars.json`

| Item                            | Value                                                                         |
| ------------------------------- | ----------------------------------------------------------------------------- |
| `apicenter_git_repository_urls` | `https://github.com/<your account>/<your forked repo name>/tree/main/catalog` |
| `github_pat`                    | The fine-grained PAT you issued in 2-1                                        |
| `apicenter_apim_resource_ids`   | `""` (set back to empty)                                                      |

```bash
azd up
```

### 2-3. Check in the portal

Confirm in the API Center portal's **Assets** that `SKILL.md` and other files under `catalog/skills` in your forked repository have been pulled in as Skills / MCP servers / Agents.

## 3. Install the catalog locally with APM

Use [APM (Agent Package Manager)](https://microsoft.github.io/apm/) to install both the **Skills** and **MCP servers** registered in API Center into your local development environment (Github Copilot / Claude Code, etc.) in one go. The process is: "rewrite the placeholders in `apm.yml`" → "run `apm install`."

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

First, set the environment variable so that API Center's data-plane API is used as an MCP registry, then check the proper name of the MCP server using `apm mcp list`.

```bash
APICENTER_URL="$(azd env get-value APICENTER_NAME).data.$(azd env get-value AZURE_LOCATION).azure-apicenter.ms"
export MCP_REGISTRY_URL="https://${APICENTER_URL}/workspaces/default"

apm mcp list
```

Once you've confirmed the MCP server name shown in the list, use that value together with your forked repository's information to rewrite `apm.yml` all at once.

```bash
OWNER_REPO="<your account>/<your forked repo name>"
MCP_SERVER_NAME="<the MCP server name confirmed via apm mcp list>"

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

This installs both the Skill (via Git) and the MCP server (via the API Center registry) declared in `apm.yml`, all at once.

### 3-3. Verify it worked

Confirm that both the Skill and the MCP server are reflected in the config file of your installation target harness (VS Code / Claude Code, etc.).

This completes the whole flow of distributing both Skills and MCP servers registered in API Center to your entire team via APM.

Thanks for completing the hands-on. Finally, take a look at the [Closing Thoughts in README.md](./README.md#closing-thoughts) as well.
