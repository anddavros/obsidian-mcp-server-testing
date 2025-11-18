#!/bin/bash
# Analyze module boundaries and imports

echo "=== Module Boundary Analysis ==="
echo ""

echo "## 1. Config Module Imports"
echo "Files that import from config/:"
grep -r "from.*['\"].*config" src/ --include="*.ts" | grep -v "\.config" | cut -d: -f1 | sort -u | wc -l | xargs echo "Count:"

echo ""
echo "## 2. MCP Server Module Dependencies"
echo "mcp-server/ imports from:"
grep -rh "^import.*from ['\"]\.\./" src/mcp-server/ --include="*.ts" | \
    sed 's/.*from ["'\'']\.\.\([^"'\'']*\)["'\''].*/\1/' | \
    sed 's/\/.*//' | \
    sort | uniq -c | sort -rn

echo ""
echo "## 3. Services Module Dependencies"
echo "services/ imports from:"
grep -rh "^import.*from ['\"]\.\./" src/services/ --include="*.ts" | \
    sed 's/.*from ["'\'']\.\.\([^"'\'']*\)["'\''].*/\1/' | \
    sed 's/\/.*//' | \
    sort | uniq -c | sort -rn

echo ""
echo "## 4. Cross-Module Import Count"
echo ""
echo "config → other modules:"
grep -r "from.*['\"]\.\./" src/config/ --include="*.ts" 2>/dev/null | wc -l

echo "mcp-server → other modules:"
grep -r "from.*['\"]\.\./" src/mcp-server/ --include="*.ts" | wc -l

echo "services → other modules:"
grep -r "from.*['\"]\.\./" src/services/ --include="*.ts" | wc -l

echo "utils → other modules:"
grep -r "from.*['\"]\.\.\./" src/utils/ --include="*.ts" | wc -l

echo "types-global → other modules:"
grep -r "from.*['\"]\.\./" src/types-global/ --include="*.ts" 2>/dev/null | wc -l

echo ""
echo "## 5. Tool Consistency Check"
echo "Checking if all tools follow index/logic/registration pattern:"
for tool in src/mcp-server/tools/*/; do
    toolname=$(basename "$tool")
    has_index=$([ -f "$tool/index.ts" ] && echo "✓" || echo "✗")
    has_logic=$([ -f "$tool/logic.ts" ] && echo "✓" || echo "✗")
    has_reg=$([ -f "$tool/registration.ts" ] && echo "✓" || echo "✗")
    echo "$toolname: index[$has_index] logic[$has_logic] registration[$has_reg]"
done

echo ""
echo "## 6. Barrel File Usage"
echo "Number of index.ts files:"
find src -name "index.ts" | wc -l

echo ""
echo "Barrel files and their locations:"
find src -name "index.ts" -type f | sed 's|src/||'

