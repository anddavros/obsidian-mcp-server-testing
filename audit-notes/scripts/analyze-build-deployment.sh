#!/bin/bash

echo "========================================="
echo "Build & Deployment Process Analysis"
echo "========================================="
echo ""

# Navigate to project root
cd "$(dirname "$0")/../.." || exit 1

echo "=== Package.json Scripts ==="
echo ""
jq -r '.scripts | to_entries[] | "\(.key): \(.value)"' package.json
echo ""

echo "=== Build Configuration ==="
echo ""
echo "Main entry point:"
jq -r '.main // "Not specified"' package.json
echo ""
echo "Binary configuration:"
jq -r '.bin // "Not specified"' package.json
echo ""
echo "Module type:"
jq -r '.type // "commonjs"' package.json
echo ""
echo "Files included in package:"
jq -r '.files[]? // "All files"' package.json
echo ""

echo "=== TypeScript Configuration ==="
echo ""
if [ -f "tsconfig.json" ]; then
  echo "Target:"
  jq -r '.compilerOptions.target // "Not specified"' tsconfig.json
  echo ""
  echo "Module:"
  jq -r '.compilerOptions.module // "Not specified"' tsconfig.json
  echo ""
  echo "Output directory:"
  jq -r '.compilerOptions.outDir // "Not specified"' tsconfig.json
  echo ""
  echo "Root directory:"
  jq -r '.compilerOptions.rootDir // "Not specified"' tsconfig.json
  echo ""
  echo "Generate declarations:"
  jq -r '.compilerOptions.declaration // false' tsconfig.json
  echo ""
  echo "Strict mode:"
  jq -r '.compilerOptions.strict // false' tsconfig.json
  echo ""
else
  echo "tsconfig.json not found"
fi

echo "=== Build Scripts ==="
echo ""
echo "Available build scripts:"
ls -1 scripts/*.ts 2>/dev/null || echo "No TypeScript scripts found"
echo ""

echo "=== Distribution Directory ==="
echo ""
if [ -d "dist" ]; then
  echo "dist/ exists"
  echo "Size:"
  du -sh dist/ 2>/dev/null
  echo ""
  echo "File count:"
  find dist/ -type f | wc -l
  echo ""
  echo "Structure (first 20 files):"
  find dist/ -type f | head -20
else
  echo "dist/ directory does not exist (not built)"
fi
echo ""

echo "=== CI/CD Configuration ==="
echo ""
if [ -d ".github/workflows" ]; then
  echo "GitHub Actions workflows found:"
  ls -1 .github/workflows/*.yml 2>/dev/null
  echo ""
  for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
      echo "Workflow: $(basename "$workflow")"
      echo "Triggers:"
      grep -A 5 "^on:" "$workflow" | head -10
      echo ""
    fi
  done
else
  echo "No .github/workflows directory found"
fi

echo "=== .gitignore Analysis ==="
echo ""
if [ -f ".gitignore" ]; then
  echo "Build-related patterns:"
  grep -E "dist/|build/|out/|*.js|*.map|*.d.ts" .gitignore | grep -v "^#"
else
  echo ".gitignore not found"
fi
echo ""

echo "=== npm Package Configuration ==="
echo ""
echo "Package name:"
jq -r '.name // "Not specified"' package.json
echo ""
echo "Version:"
jq -r '.version // "Not specified"' package.json
echo ""
echo "License:"
jq -r '.license // "Not specified"' package.json
echo ""
echo "Repository:"
jq -r '.repository.url // "Not specified"' package.json
echo ""
echo "Node engine requirement:"
jq -r '.engines.node // "Not specified"' package.json
echo ""

echo "=== Build Performance Estimate ==="
echo ""
echo "Source files to compile:"
find src/ -name "*.ts" | wc -l
echo ""
echo "Total LOC to compile:"
find src/ -name "*.ts" -exec wc -l {} + | tail -1 | awk '{print $1}'
echo ""
echo "Dependencies to install:"
jq -r '(.dependencies | length) + (.devDependencies | length)' package.json
echo ""

echo "========================================="
echo "Analysis Complete"
echo "========================================="
