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
  [ "$runtimeHint" != "docker" ] && { echo "skip: $f (runtimeHint=$runtimeHint)"; continue; }

  title=$(jq -r '.name' "$f")
  API=$(az apic api list --service-name "$SVC" --resource-group "$RG" --query "[?title=='$title'].name" -o tsv)
  [ -z "$API" ] && { echo "warn: $f (title=$title) not found"; continue; }

  EXPECTED=$(jq -S -f "$REPO_ROOT/scripts/lib/server-json-to-arm.jq" "$f")

  ACTUAL=$(az rest --method get --url "https://management.azure.com/subscriptions/$SUB/resourceGroups/$RG/providers/Microsoft.ApiCenter/services/$SVC/workspaces/default/apis/$API?api-version=2024-06-01-preview" \
    | jq -S '{properties:(.properties|{title,kind,description,summary,lifecycleStage,packages:[.packages[]|{registry_name,name,version,runtime_hint,transport,runtime_arguments,package_arguments,environment_variables:[(.environment_variables//[])[]|{name,is_required:(.is_required//false),is_secret:(.is_secret//false),format:(.format//"string")}]}]})}')

  if diff <(echo "$EXPECTED") <(echo "$ACTUAL") > /dev/null; then
    echo "OK: $f ($API) はAPI Centerと一致"
  else
    echo "NG: $f ($API) はAPI Centerと不一致"
    diff <(echo "$EXPECTED") <(echo "$ACTUAL")
  fi
done
