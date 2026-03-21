#!/usr/bin/env bash
set -euo pipefail

ORG="${1:-}"

if ! command -v sf >/dev/null 2>&1; then
  echo "Salesforce CLI (sf) is not installed or not on PATH." >&2
  exit 1
fi

if ! sf data360 man >/dev/null 2>&1; then
  echo "The community 'sf data360' runtime is not available." >&2
  echo "Run bash ~/.claude/skills/sf-datacloud/scripts/bootstrap-plugin.sh first." >&2
  exit 1
fi

echo "✓ sf data360 runtime detected"

if [[ -n "${ORG}" ]]; then
  if sf org display -o "${ORG}" >/dev/null 2>&1; then
    echo "✓ org alias '${ORG}' is authenticated"
  else
    echo "Org alias '${ORG}' is not authenticated." >&2
    exit 1
  fi

  if sf data360 doctor -o "${ORG}" 2>/dev/null >/dev/null; then
    echo "✓ sf data360 doctor completed for '${ORG}'"
  else
    echo "! sf data360 doctor did not complete cleanly for '${ORG}'. Check org access and Data Cloud provisioning." >&2
    exit 1
  fi
fi

echo "Verification complete."
