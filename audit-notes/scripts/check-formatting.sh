#!/bin/bash
# Check code formatting excluding audit notes

echo "=== Checking Source Code Formatting ==="
echo ""

# Check only source files (exclude audit-notes and docs)
npx prettier --check "src/**/*.{ts,js}" "scripts/**/*.ts" "*.json" --ignore-path .gitignore 2>&1 | tee audit-notes/results/prettier-source-only.txt

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ All source files are properly formatted"
else
    echo ""
    echo "❌ Found formatting issues in source files"
fi

exit $EXIT_CODE
