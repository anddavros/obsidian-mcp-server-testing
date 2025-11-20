#!/bin/bash

echo "========================================="
echo "Dependency Management Analysis"
echo "========================================="
echo ""

# Navigate to project root
cd "$(dirname "$0")/../.." || exit 1

echo "=== Dependency Counts ==="
echo ""
echo "Production dependencies:"
jq -r '.dependencies | length' package.json
echo ""
echo "Development dependencies:"
jq -r '.devDependencies | length' package.json
echo ""
echo "Total dependencies:"
jq -r '(.dependencies | length) + (.devDependencies | length)' package.json
echo ""

echo "=== Production Dependencies ==="
echo ""
jq -r '.dependencies | keys[]' package.json | sort
echo ""

echo "=== Development Dependencies ==="
echo ""
jq -r '.devDependencies | keys[]' package.json | sort
echo ""

echo "=== Version Constraints ==="
echo ""
echo "Using caret (^) - allows minor/patch updates:"
jq -r '.dependencies + .devDependencies | to_entries[] | select(.value | startswith("^")) | .key' package.json | wc -l
echo ""
echo "Using tilde (~) - allows patch updates only:"
jq -r '.dependencies + .devDependencies | to_entries[] | select(.value | startswith("~")) | .key' package.json | wc -l
echo ""
echo "Exact versions (no prefix):"
jq -r '.dependencies + .devDependencies | to_entries[] | select(.value | test("^[^~^]")) | .key' package.json | wc -l
echo ""

echo "=== Security Audit ==="
echo ""
if [ -f "audit-notes/results/npm-audit.json" ]; then
  echo "Vulnerabilities from previous audit:"
  jq -r '.metadata.vulnerabilities | to_entries[] | "\(.key): \(.value)"' audit-notes/results/npm-audit.json
  echo ""
  echo "Total vulnerabilities:"
  jq -r '.metadata.vulnerabilities.total' audit-notes/results/npm-audit.json
else
  echo "No audit results found. Run: npm audit --json > audit-notes/results/npm-audit.json"
fi
echo ""

echo "=== MCP-Specific Dependencies ==="
echo ""
jq -r '.dependencies | to_entries[] | select(.key | contains("modelcontextprotocol")) | "\(.key): \(.value)"' package.json
echo ""

echo "=== Type Definitions ==="
echo ""
echo "Type packages (@types/*):"
jq -r '.dependencies + .devDependencies | to_entries[] | select(.key | startswith("@types/")) | "\(.key): \(.value)"' package.json
echo ""

echo "=== Potentially Large Dependencies ==="
echo ""
echo "Known large packages found:"
for pkg in "typescript" "typedoc" "openai" "tiktoken" "axios"; do
  if jq -e --arg pkg "$pkg" '.dependencies[$pkg] // .devDependencies[$pkg]' package.json > /dev/null 2>&1; then
    version=$(jq -r --arg pkg "$pkg" '.dependencies[$pkg] // .devDependencies[$pkg]' package.json)
    echo "  $pkg: $version"
  fi
done
echo ""

echo "=== Dependency Freshness ==="
echo ""
echo "Checking if major versions are available (requires internet)..."
echo "(This would require npm outdated, skipping in audit)"
echo ""

echo "=== Peer Dependencies ==="
echo ""
if jq -e '.peerDependencies' package.json > /dev/null 2>&1; then
  jq -r '.peerDependencies | keys[]' package.json
else
  echo "No peer dependencies defined"
fi
echo ""

echo "=== Engine Requirements ==="
echo ""
echo "Node version required:"
jq -r '.engines.node // "Not specified"' package.json
echo ""
echo "npm version required:"
jq -r '.engines.npm // "Not specified"' package.json
echo ""

echo "========================================="
echo "Analysis Complete"
echo "========================================="
