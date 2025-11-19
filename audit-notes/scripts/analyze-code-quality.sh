#!/bin/bash

# Code Quality Metrics Analysis Script
# Analyzes code complexity, duplication, naming, comments, and maintainability

OUTPUT_DIR="audit-notes/results"
mkdir -p "$OUTPUT_DIR"

echo "========================================="
echo "Code Quality Metrics Analysis"
echo "========================================="
echo ""

# 1. Function and Class Counts
echo "=== Code Structure ==="
echo ""
echo "Function Declarations:"
grep -r "function " src/ --include="*.ts" | wc -l
echo ""
echo "Arrow Functions:"
grep -r "=>" src/ --include="*.ts" | wc -l
echo ""
echo "Class Declarations:"
grep -r "^export class\|^class " src/ --include="*.ts" | wc -l
echo ""
echo "Interface Declarations:"
grep -r "^export interface\|^interface " src/ --include="*.ts" | wc -l
echo ""
echo "Type Aliases:"
grep -r "^export type\|^type " src/ --include="*.ts" | wc -l
echo ""

# 2. File Size Metrics
echo "=== File Size Metrics ==="
echo ""
echo "Largest TypeScript Files (by line count):"
find src/ -name "*.ts" -exec wc -l {} \; | sort -rn | head -20
echo ""

# 3. Function Complexity Indicators
echo "=== Complexity Indicators ==="
echo ""
echo "Functions with 'if' statements:"
grep -r "if\s*(" src/ --include="*.ts" | wc -l
echo ""
echo "Switch statements:"
grep -r "switch\s*(" src/ --include="*.ts" | wc -l
echo ""
echo "Try-catch blocks:"
grep -r "try\s*{" src/ --include="*.ts" | wc -l
echo ""
echo "Nested loops (for...for, while...while):"
grep -A 20 "for\s*(" src/ --include="*.ts" | grep "for\s*(" | wc -l
echo ""

# 4. Code Duplication Indicators
echo "=== Code Duplication Analysis ==="
echo ""
echo "Checking for duplicated error messages..."
grep -rho "throw new.*Error(.*)" src/ --include="*.ts" | sort | uniq -c | sort -rn | head -10
echo ""
echo "Checking for duplicated string patterns..."
grep -rho '"[^"]\{30,\}"' src/ --include="*.ts" | sort | uniq -c | sort -rn | head -10
echo ""

# 5. Naming Convention Analysis
echo "=== Naming Conventions ==="
echo ""
echo "PascalCase classes/interfaces:"
grep -rE "^export (class|interface) [A-Z][a-zA-Z0-9]*" src/ --include="*.ts" | wc -l
echo ""
echo "camelCase functions:"
grep -rE "function [a-z][a-zA-Z0-9]*\(" src/ --include="*.ts" | wc -l
echo ""
echo "UPPER_CASE constants:"
grep -rE "const [A-Z_]+ =" src/ --include="*.ts" | wc -l
echo ""
echo "Potential naming issues (single letter vars outside loops):"
grep -rE "\b[a-z]\s*=" src/ --include="*.ts" | grep -v "for\s*(" | wc -l
echo ""

# 6. Comment Analysis
echo "=== Comment Coverage ==="
echo ""
echo "JSDoc comments (/** ... */):"
grep -r "/\*\*" src/ --include="*.ts" | wc -l
echo ""
echo "Single-line comments (//):"
grep -r "//" src/ --include="*.ts" | wc -l
echo ""
echo "Multi-line comments (/* ... */):"
grep -r "/\*[^*]" src/ --include="*.ts" | wc -l
echo ""
echo "TODO comments:"
grep -ri "TODO\|FIXME\|XXX\|HACK" src/ --include="*.ts" | wc -l
echo ""

# 7. Import Analysis
echo "=== Import Analysis ==="
echo ""
echo "Total import statements:"
grep -r "^import " src/ --include="*.ts" | wc -l
echo ""
echo "Relative imports (../):"
grep -r "from \"\.\." src/ --include="*.ts" | wc -l
echo ""
echo "Absolute imports:"
grep -r "from \"[^.]" src/ --include="*.ts" | wc -l
echo ""
echo "Wildcard imports (*):"
grep -r "import \*" src/ --include="*.ts" | wc -l
echo ""

# 8. Code Quality Indicators
echo "=== Code Quality Indicators ==="
echo ""
echo "Console.log statements (potential debug code):"
grep -r "console\.log" src/ --include="*.ts" | wc -l
echo ""
echo "Any type usage:"
grep -r ":\s*any" src/ --include="*.ts" | wc -l
echo ""
echo "Type assertions (as keyword):"
grep -r "\s*as\s*" src/ --include="*.ts" | wc -l
echo ""
echo "Non-null assertions (!):"
grep -r "!\." src/ --include="*.ts" | wc -l
echo ""
echo "Optional chaining (?.):"
grep -r "?\." src/ --include="*.ts" | wc -l
echo ""
echo "Nullish coalescing (??):"
grep -r "??" src/ --include="*.ts" | wc -l
echo ""

# 9. Function Length Analysis
echo "=== Function Length Analysis ==="
echo ""
echo "Analyzing function lengths..."
# This is a simplified check - counts lines between function declarations and closing braces
grep -n "function \|async " src/ --include="*.ts" -r | head -20
echo ""

# 10. Code Maintainability
echo "=== Maintainability Metrics ==="
echo ""
echo "Files with high import count (>15 imports):"
for file in $(find src/ -name "*.ts"); do
  count=$(grep "^import " "$file" | wc -l)
  if [ "$count" -gt 15 ]; then
    echo "$file: $count imports"
  fi
done
echo ""
echo "Files with many exports:"
for file in $(find src/ -name "*.ts"); do
  count=$(grep "^export " "$file" | wc -l)
  if [ "$count" -gt 10 ]; then
    echo "$file: $count exports"
  fi
done
echo ""

# 11. Error Handling Quality
echo "=== Error Handling Patterns ==="
echo ""
echo "Error throwing locations:"
grep -r "throw new" src/ --include="*.ts" | wc -l
echo ""
echo "Error catching locations:"
grep -r "catch\s*(" src/ --include="*.ts" | wc -l
echo ""
echo "Error types used:"
grep -rho "throw new [A-Za-z]*Error" src/ --include="*.ts" | sort | uniq -c | sort -rn
echo ""

# 12. Code Organization
echo "=== Code Organization ==="
echo ""
echo "Total TypeScript files:"
find src/ -name "*.ts" | wc -l
echo ""
echo "Total lines of code:"
find src/ -name "*.ts" -exec cat {} \; | wc -l
echo ""
echo "Average lines per file:"
total_lines=$(find src/ -name "*.ts" -exec cat {} \; | wc -l)
total_files=$(find src/ -name "*.ts" | wc -l)
if [ "$total_files" -gt 0 ]; then
  echo "$((total_lines / total_files))"
fi
echo ""

echo "========================================="
echo "Analysis Complete"
echo "========================================="
