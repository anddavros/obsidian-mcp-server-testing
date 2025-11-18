#!/bin/bash
# Analyze project structure

echo "=== Project Structure Analysis ==="
echo ""

echo "## Directory Statistics"
echo ""
find src -type d | wc -l | xargs echo "Total directories:"
find src -type f -name "*.ts" | wc -l | xargs echo "Total TypeScript files:"
find src -type f -name "*.js" | wc -l | xargs echo "Total JavaScript files:"

echo ""
echo "## Top-level Structure"
echo ""
ls -la src/

echo ""
echo "## Line Count by Directory"
echo ""
echo "config/"
find src/config -name "*.ts" -exec wc -l {} + | tail -1
echo ""
echo "mcp-server/"
find src/mcp-server -name "*.ts" -exec wc -l {} + | tail -1
echo ""
echo "services/"
find src/services -name "*.ts" -exec wc -l {} + | tail -1
echo ""
echo "utils/"
find src/utils -name "*.ts" -exec wc -l {} + | tail -1
echo ""
echo "types-global/"
find src/types-global -name "*.ts" -exec wc -l {} + | tail -1

echo ""
echo "## File Size Distribution"
echo ""
echo "Files > 500 lines:"
find src -name "*.ts" -exec wc -l {} + | awk '$1 > 500 {print $2 " (" $1 " lines)"}' | sort -n

echo ""
echo "## Tool Structure"
echo ""
echo "Total tools:"
ls -d src/mcp-server/tools/*/ 2>/dev/null | wc -l

echo ""
echo "Tool directories:"
ls -d src/mcp-server/tools/*/ 2>/dev/null | xargs -n1 basename

echo ""
echo "## Import Analysis"
echo ""
echo "External dependencies imported:"
grep -h "^import.*from ['\"]" src/**/*.ts 2>/dev/null | \
    grep -v "from ['\"]\./" | \
    grep -v "from ['\"]node:" | \
    sed 's/.*from ["'\'']\([^"'\'']*\)["'\''].*/\1/' | \
    sed 's/\/.*//' | \
    sort -u | head -20

