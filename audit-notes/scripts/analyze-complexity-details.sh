#!/bin/bash

# Detailed Complexity Analysis Script
echo "========================================="
echo "Detailed Code Complexity Analysis"
echo "========================================="
echo ""

# 1. Magic Numbers Detection
echo "=== Magic Numbers ===" 
echo ""
echo "Numeric literals in code (excluding 0, 1, common constants):"
grep -rE "[^a-zA-Z0-9_](2[0-9]+|[3-9][0-9]+|[0-9]{3,})[^a-zA-Z0-9_]" src/ --include="*.ts" | grep -v "node_modules" | head -20
echo ""

# 2. Long Parameter Lists
echo "=== Long Parameter Lists ===" 
echo ""
echo "Functions with many parameters (6+):"
grep -rE "function\s+\w+\s*\([^)]{60,}\)" src/ --include="*.ts" | head -10
echo ""

# 3. Deeply Nested Code
echo "=== Nesting Depth ===" 
echo ""
echo "Deeply nested blocks (3+ levels of indentation):"
grep -rE "^      " src/ --include="*.ts" | wc -l
echo ""
echo "Very deeply nested blocks (4+ levels of indentation):"
grep -rE "^        " src/ --include="*.ts" | wc -l
echo ""

# 4. Function Length Estimation
echo "=== Function Length Metrics ===" 
echo ""
echo "Estimating long functions by examining spacing patterns..."
# Count functions and estimate which are long
for file in $(find src/ -name "*.ts" -type f); do
  # Look for functions followed by many lines
  func_count=$(grep -c "^\s*\(export \)\?async\? function\|^\s*\(export \)\?const.*=.*\(async \)\?(" "$file" 2>/dev/null || echo 0)
  line_count=$(wc -l < "$file")
  if [ "$line_count" -gt 500 ]; then
    avg_per_func=$((line_count / (func_count + 1)))
    echo "$file: $line_count lines, ~$func_count functions, ~$avg_per_func lines/function"
  fi
done
echo ""

# 5. Code Duplication - Similar Function Names
echo "=== Similar Function Patterns ===" 
echo ""
echo "Function naming patterns (potential duplication):"
grep -rho "function [a-z][a-zA-Z0-9]*" src/ --include="*.ts" | sort | uniq -c | sort -rn | head -15
echo ""

# 6. Complexity Keywords
echo "=== Complexity Keywords ===" 
echo ""
echo "Conditional complexity:"
echo "  if statements: $(grep -rc "if\s*(" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  else statements: $(grep -rc "else" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  else if: $(grep -rc "else if" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo "  ternary operators: $(grep -rc "?\s*.*:\s*" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')"
echo ""

# 7. Error Handling Coverage
echo "=== Error Handling Coverage ===" 
echo ""
echo "Functions vs try-catch blocks:"
total_functions=$(grep -rc "function \|=>\|=> {" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')
total_trycatch=$(grep -rc "try\s*{" src/ --include="*.ts" | awk -F: '{sum+=$2} END {print sum}')
echo "  Total functions: $total_functions"
echo "  Total try-catch blocks: $total_trycatch"
echo ""

# 8. Documentation Coverage by File Type
echo "=== Documentation Coverage by Category ===" 
echo ""
echo "Tools directory:"
tools_jsdoc=$(grep -r "/\*\*" src/mcp-server/tools/ --include="*.ts" | wc -l)
tools_funcs=$(grep -r "function \|export async\|export const.*=.*(" src/mcp-server/tools/ --include="*.ts" | wc -l)
echo "  JSDoc comments: $tools_jsdoc"
echo "  Functions: $tools_funcs"
echo ""
echo "Services directory:"
services_jsdoc=$(grep -r "/\*\*" src/services/ --include="*.ts" | wc -l)
services_funcs=$(grep -r "function \|export async\|export const.*=.*(" src/services/ --include="*.ts" | wc -l)
echo "  JSDoc comments: $services_jsdoc"
echo "  Functions: $services_funcs"
echo ""
echo "Utils directory:"
utils_jsdoc=$(grep -r "/\*\*" src/utils/ --include="*.ts" | wc -l)
utils_funcs=$(grep -r "function \|export async\|export const.*=.*(" src/utils/ --include="*.ts" | wc -l)
echo "  JSDoc comments: $utils_jsdoc"
echo "  Functions: $utils_funcs"
echo ""

# 9. Import Complexity by File
echo "=== Import Complexity ===" 
echo ""
echo "Files with most imports:"
for file in $(find src/ -name "*.ts" -type f); do
  count=$(grep -c "^import " "$file")
  if [ "$count" -gt 10 ]; then
    echo "  $file: $count imports"
  fi
done | sort -t: -k2 -rn | head -10
echo ""

# 10. Code Metrics Summary
echo "=== Code Metrics Summary ===" 
echo ""
echo "Complexity-to-Size Ratio:"
total_loc=$(find src/ -name "*.ts" -exec cat {} \; | wc -l)
total_if=$(grep -r "if\s*(" src/ --include="*.ts" | wc -l)
total_func=$(grep -r "function \|async " src/ --include="*.ts" | wc -l)
echo "  Total LOC: $total_loc"
echo "  Total conditionals (if): $total_if"
echo "  Total functions: $total_func"
echo "  Conditionals per 100 LOC: $((total_if * 100 / total_loc))"
echo "  Average LOC per function: $((total_loc / (total_func + 1)))"
echo ""

echo "========================================="
echo "Detailed Analysis Complete"
echo "========================================="
