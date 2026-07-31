#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <subscription-id> <resource-group> <api-center-service-name>" >&2
  exit 1
fi

SUB="$1"
RG="$2"
SVC="$3"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for f in "$REPO_ROOT"/catalog/mcp/*/server.json; do
  runtimeHint=$(jq -r '.packages[0].runtimeHint // empty' "$f")
  title=$(jq -r '.name' "$f")

  if [ "$runtimeHint" != "docker" ]; then
    echo "skip: $f (runtimeHint=$runtimeHint)"
    continue
  fi

  API=$(az apic api list --service-name "$SVC" --resource-group "$RG" \
    --query "[?title=='$title'].name" -o tsv)

  if [ -z "$API" ]; then
    echo "warn: $f (title=$title) not found in API Center. skip."
    continue
  fi

  echo "update: $f -> API=$API"

  BODY=$(jq -f "$REPO_ROOT/scripts/lib/server-json-to-arm.jq" "$f")

  az rest --method put \
    --url "https://management.azure.com/subscriptions/$SUB/resourceGroups/$RG/providers/Microsoft.ApiCenter/services/$SVC/workspaces/default/apis/$API?api-version=2024-06-01-preview" \
    --body "$BODY" -o none && echo "  -> OK"
done
