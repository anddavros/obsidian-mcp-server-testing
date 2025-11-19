#!/bin/bash
# Testing coverage analysis script

echo "=== Testing Coverage Analysis ==="
echo

echo "1. Test File Detection"
echo "   Test files (*.test.ts, *.spec.ts):"
find . -name "*.test.ts" -o -name "*.spec.ts" | wc -l

echo "   Test directories:"
find . -type d -name "test" -o -name "tests" -o -name "__tests__" | wc -l

echo "   Jest configuration:"
find . -name "jest.config.*" -o -name "jest.setup.*" | wc -l

echo "   Vitest configuration:"
find . -name "vitest.config.*" | wc -l

echo

echo "2. Testing Framework Detection"
echo "   Package.json test scripts:"
if [ -f package.json ]; then
  grep -A 5 '"scripts"' package.json | grep -c "test"
else
  echo "   No package.json found"
fi

echo "   Testing dependencies:"
if [ -f package.json ]; then
  grep -E "(jest|vitest|mocha|ava|tap|node-tap)\":" package.json | wc -l
else
  echo "   0"
fi

echo

echo "3. Test Assertions & Mocking"
echo "   expect() calls:"
grep -r "expect(" src --include="*.test.ts" --include="*.spec.ts" 2>/dev/null | wc -l

echo "   describe() blocks:"
grep -r "describe(" src --include="*.test.ts" --include="*.spec.ts" 2>/dev/null | wc -l

echo "   it() / test() blocks:"
grep -rE "(^|\s)(it|test)\(" src --include="*.test.ts" --include="*.spec.ts" 2>/dev/null | wc -l

echo "   Mock usage:"
grep -rE "mock|stub|spy" src --include="*.test.ts" --include="*.spec.ts" 2>/dev/null | wc -l

echo

echo "4. Manual Testing Scripts"
echo "   Scripts directory:"
if [ -d scripts ]; then
  echo "   Found scripts directory"
  ls -1 scripts/*.ts scripts/*.js 2>/dev/null | wc -l
  echo "   script files"
else
  echo "   No scripts directory"
fi

echo

echo "5. Example/Demo Files"
echo "   Example files:"
find . -name "*example*" -o -name "*demo*" | grep -E "\.(ts|js)$" | wc -l

echo

echo "6. Documentation with Examples"
echo "   Code blocks in markdown:"
find . -name "*.md" -exec grep -c '```' {} \; 2>/dev/null | awk '{s+=$1} END {print s}'

echo "   README files:"
find . -name "README*.md" | wc -l

echo

echo "7. Type Testing"
echo "   Type assertion tests:"
grep -r "expectType\|assertType" src --include="*.ts" 2>/dev/null | wc -l

echo

echo "8. Integration Testing Indicators"
echo "   Docker files (for test environments):"
find . -name "Dockerfile*" -o -name "docker-compose*" | wc -l

echo "   Environment test configs:"
find . -name ".env.test" -o -name ".env.testing" | wc -l

echo

echo "=== Test Coverage Configuration ==="
if [ -f package.json ]; then
  echo "Coverage scripts in package.json:"
  grep -A 2 "coverage" package.json | head -5
fi

echo

echo "=== Source File Statistics ==="
echo "Total TypeScript source files:"
find src -name "*.ts" | wc -l

echo "Lines of code in src:"
find src -name "*.ts" -exec wc -l {} \; 2>/dev/null | awk '{s+=$1} END {print s}'

