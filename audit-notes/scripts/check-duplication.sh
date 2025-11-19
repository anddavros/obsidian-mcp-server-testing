#!/bin/bash

echo "========================================="
echo "Code Duplication Detection"
echo "========================================="
echo ""

# 1. Check for repeated code blocks in tools
echo "=== Tool Implementation Similarity ===" 
echo ""
echo "Common patterns across tool files:"
echo ""

# Check schema definitions
echo "Schema definition patterns:"
grep -r "const.*Schema = z\." src/mcp-server/tools/ --include="*.ts" | wc -l
echo ""

# Check validation patterns
echo "Input validation patterns:"
grep -r "\.parse\|\.safeParse" src/mcp-server/tools/ --include="*.ts" | wc -l
echo ""

# Check error handling patterns
echo "Error handling patterns in tools:"
grep -r "throw new McpError" src/mcp-server/tools/ --include="*.ts" | wc -l
echo ""

# 2. Repeated string literals
echo "=== Repeated String Literals ===" 
echo ""
echo "Most common error messages:"
grep -rho "throw new McpError([^)]*)" src/ --include="*.ts" | sort | uniq -c | sort -rn | head -10
echo ""

# 3. Similar function signatures
echo "=== Similar Function Signatures ===" 
echo ""
echo "Functions by name similarity:"
grep -rh "export async function\|export function" src/ --include="*.ts" | sed 's/(.*//' | sort | uniq -c | sort -rn | head -15
echo ""

# 4. Duplicate imports
echo "=== Import Analysis ===" 
echo ""
echo "Most commonly imported modules:"
grep -rh "^import.*from" src/ --include="*.ts" | sed 's/.*from/from/' | sort | uniq -c | sort -rn | head -15
echo ""

# 5. Repeated validation patterns
echo "=== Validation Patterns ===" 
echo ""
echo "Zod schema usage:"
echo "  z.object: $(grep -rc "z\.object" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  z.string: $(grep -rc "z\.string" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  z.boolean: $(grep -rc "z\.boolean" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  z.enum: $(grep -rc "z\.enum" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  z.array: $(grep -rc "z\.array" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo ""

# 6. DRY violations - repeated logic patterns
echo "=== Potential DRY Violations ===" 
echo ""
echo "File path normalization patterns:"
grep -rc "path\.normalize\|path\.resolve\|path\.join" src/ --include="*.ts" | grep -v ":0$" | sort -t: -k2 -rn | head -5
echo ""
echo "Error context building:"
grep -rc "operationContext\|context:" src/ --include="*.ts" | grep -v ":0$" | sort -t: -k2 -rn | head -5
echo ""

echo "========================================="
echo "Duplication Check Complete"
echo "========================================="
