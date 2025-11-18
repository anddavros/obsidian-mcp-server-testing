#!/bin/bash
# Analyze TypeScript type system and Zod schemas

echo "=== Type System Analysis ==="
echo ""

echo "## 1. TypeScript Configuration"
echo ""
echo "tsconfig.json:"
cat tsconfig.json
echo ""

echo "## 2. Zod Schema Usage"
echo ""
echo "Files using Zod:"
grep -r "from ['\"]zod['\"]" src/ --include="*.ts" | wc -l | xargs echo "Total files:"

echo ""
echo "Zod schema locations:"
grep -r "z\." src/ --include="*.ts" | cut -d: -f1 | sort -u

echo ""
echo "## 3. Interface Definitions"
echo ""
echo "Total interface definitions:"
grep -r "^export interface" src/ --include="*.ts" | wc -l

echo ""
echo "Interfaces by file:"
grep -r "^export interface" src/ --include="*.ts" | cut -d: -f1 | sort | uniq -c | sort -rn | head -20

echo ""
echo "## 4. Type Definitions"
echo ""
echo "Total type definitions:"
grep -r "^export type" src/ --include="*.ts" | wc -l

echo ""
echo "Types by file:"
grep -r "^export type" src/ --include="*.ts" | cut -d: -f1 | sort | uniq -c | sort -rn | head -20

echo ""
echo "## 5. Enum Definitions"
echo ""
echo "Total enum definitions:"
grep -r "^export enum" src/ --include="*.ts" | wc -l

echo ""
echo "## 6. Type Safety Indicators"
echo ""
echo "Usage of 'any' type:"
grep -r ": any" src/ --include="*.ts" | wc -l

echo ""
echo "Usage of 'unknown' type:"
grep -r ": unknown" src/ --include="*.ts" | wc -l

echo ""
echo "Usage of '!' (non-null assertion):"
grep -r "!\\." src/ --include="*.ts" | wc -l

echo ""
echo "Usage of 'as' type assertions:"
grep -r " as " src/ --include="*.ts" | wc -l

