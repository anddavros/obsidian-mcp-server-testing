#!/bin/bash
# Detailed analysis of Zod schemas

echo "=== Zod Schema Detailed Analysis ==="
echo ""

echo "## 1. Environment Variable Schema (config/index.ts)"
echo ""
grep -A 50 "const EnvSchema" src/config/index.ts | head -50

echo ""
echo "## 2. Tool Input Schemas"
echo ""
echo "Tools with input schemas:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    schema_count=$(grep -c "const.*Schema.*=.*z\\.object" "$tool" 2>/dev/null || echo "0")
    if [ "$schema_count" -gt 0 ]; then
        echo "$toolname: $schema_count schema(s)"
    fi
done

echo ""
echo "## 3. Schema Patterns"
echo ""
echo "z.object usage:"
grep -r "z\\.object" src/ --include="*.ts" | wc -l

echo "z.string usage:"
grep -r "z\\.string" src/ --include="*.ts" | wc -l

echo "z.number usage:"
grep -r "z\\.number" src/ --include="*.ts" | wc -l

echo "z.boolean usage:"
grep -r "z\\.boolean" src/ --include="*.ts" | wc -l

echo "z.enum usage:"
grep -r "z\\.enum" src/ --include="*.ts" | wc -l

echo "z.array usage:"
grep -r "z\\.array" src/ --include="*.ts" | wc -l

echo "z.optional usage:"
grep -r "\\.optional()" src/ --include="*.ts" | wc -l

echo "z.default usage:"
grep -r "\\.default(" src/ --include="*.ts" | wc -l

echo ""
echo "## 4. Validation Error Handling"
echo ""
echo "safeParse usage:"
grep -r "safeParse" src/ --include="*.ts" | wc -l

echo "parse usage (direct):"
grep -r "\\.parse(" src/ --include="*.ts" | wc -l

