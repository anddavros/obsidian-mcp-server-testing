#!/bin/bash
# Analyze service layer architecture

echo "=== Service Layer Analysis ==="
echo ""

echo "## 1. Service File Structure"
echo ""
echo "Main service file:"
wc -l src/services/obsidianRestAPI/service.ts

echo ""
echo "Method files:"
wc -l src/services/obsidianRestAPI/methods/*.ts

echo ""
echo "Vault cache service:"
wc -l src/services/obsidianRestAPI/vaultCache/service.ts

echo ""
echo "## 2. Service Methods Count"
echo ""
echo "Public methods in ObsidianRestApiService:"
grep "^  async " src/services/obsidianRestAPI/service.ts | wc -l

echo ""
echo "Methods by category:"
for method_file in src/services/obsidianRestAPI/methods/*.ts; do
    filename=$(basename "$method_file")
    count=$(grep -c "^export async function" "$method_file" 2>/dev/null || echo "0")
    echo "$filename: $count functions"
done

echo ""
echo "## 3. Error Handling Patterns"
echo ""
echo "McpError throws in service:"
grep -c "throw new McpError" src/services/obsidianRestAPI/service.ts

echo ""
echo "ErrorHandler.tryCatch usage:"
grep -c "ErrorHandler.tryCatch" src/services/obsidianRestAPI/service.ts

echo ""
echo "## 4. HTTP Client Configuration"
echo ""
echo "Axios instance configuration:"
grep -A 10 "axios.create" src/services/obsidianRestAPI/service.ts

echo ""
echo "## 5. Cache Service Analysis"
echo ""
echo "Cache public methods:"
grep "^  public " src/services/obsidianRestAPI/vaultCache/service.ts | wc -l

echo ""
echo "Cache interface:"
grep "^  public " src/services/obsidianRestAPI/vaultCache/service.ts | sed 's/^ *//'

echo ""
echo "## 6. Service Dependencies"
echo ""
echo "Imports in service.ts:"
grep "^import" src/services/obsidianRestAPI/service.ts | head -15

