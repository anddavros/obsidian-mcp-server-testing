#!/bin/bash

echo "========================================="
echo "Configuration Management Analysis"
echo "========================================="
echo ""

# 1. Environment Variables Defined
echo "=== Environment Variables ===" 
echo ""
echo "Checking src/config/index.ts for environment variables..."
grep -E "^\s*(MCP_|OBSIDIAN_|OAUTH_|NODE_ENV|LOGS_DIR)" src/config/index.ts | grep -v "//" | wc -l
echo ""

# 2. Zod Schema Fields
echo "=== Zod Schema Fields ===" 
echo ""
echo "Environment variables in Zod schema:"
grep -E "^\s+[A-Z_]+:" src/config/index.ts | sed 's/:.*//' | sed 's/^\s*//' | head -20
echo ""

# 3. Required vs Optional
echo "=== Required vs Optional Variables ===" 
echo ""
echo "Optional variables (.optional()):"
grep ".optional()" src/config/index.ts | wc -l
echo ""
echo "Required variables (no .optional() or .default()):"
# This is approximate
grep -E "^\s+[A-Z_]+:" src/config/index.ts | grep -v ".optional()" | grep -v ".default(" | wc -l
echo ""

# 4. Default Values
echo "=== Default Values ===" 
echo ""
echo "Variables with defaults (.default()):"
grep ".default(" src/config/index.ts | wc -l
echo ""
echo "Default values:"
grep -o ".default([^)]*)" src/config/index.ts | head -15
echo ""

# 5. Validation Rules
echo "=== Validation Rules ===" 
echo ""
echo "String validations:"
grep "z.string()" src/config/index.ts | wc -l
echo ""
echo "Number validations:"
grep "z.coerce.number()" src/config/index.ts | wc -l
echo ""
echo "Enum validations:"
grep "z.enum(" src/config/index.ts | wc -l
echo ""
echo "URL validations:"
grep ".url()" src/config/index.ts | wc -l
echo ""
echo "Min length validations:"
grep ".min(" src/config/index.ts | wc -l
echo ""

# 6. Configuration Documentation
echo "=== Configuration Documentation ===" 
echo ""
echo "Environment variables documented in README.md:"
grep -c "MCP_\|OBSIDIAN_\|OAUTH_" README.md
echo ""

# 7. .env Files
echo "=== .env Files ===" 
echo ""
if [ -f ".env.example" ]; then
  echo ".env.example: EXISTS"
  echo "  Lines: $(wc -l < .env.example)"
else
  echo ".env.example: MISSING"
fi
echo ""
if [ -f ".env" ]; then
  echo ".env: EXISTS (should be in .gitignore)"
else
  echo ".env: Not present (expected - user creates)"
fi
echo ""

# 8. .gitignore Check
echo "=== .gitignore Configuration ===" 
echo ""
if [ -f ".gitignore" ]; then
  echo ".env in .gitignore:"
  grep -c "^\.env$\|^\.env " .gitignore
  echo ""
  echo "Logs in .gitignore:"
  grep -c "^logs/\|^logs$\|/logs/" .gitignore
else
  echo ".gitignore: NOT FOUND"
fi
echo ""

# 9. Configuration Error Handling
echo "=== Error Handling ===" 
echo ""
echo "Error messages in config:"
grep "Error\|throw" src/config/index.ts | wc -l
echo ""

# 10. Configuration Usage
echo "=== Configuration Usage in Codebase ===" 
echo ""
echo "Files importing config:"
grep -r "from.*config" src/ --include="*.ts" | grep -v "config/index.ts" | wc -l
echo ""
echo "Top config consumers:"
grep -r "from.*config" src/ --include="*.ts" | grep -v "config/index.ts" | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
echo ""

echo "========================================="
echo "Analysis Complete"
echo "========================================="
