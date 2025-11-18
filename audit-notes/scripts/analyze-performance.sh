#!/bin/bash
# Performance analysis script

echo "=== Performance Analysis ==="
echo

echo "1. Cache Implementation Analysis"
echo "   VaultCacheService usage:"
grep -r "vaultCache\|VaultCacheService" src --include="*.ts" | wc -l

echo "   Cache refresh patterns:"
grep -r "refreshCache\|updateCache" src --include="*.ts" | wc -l

echo "   Incremental refresh logic:"
grep -r "mtime\|lastModified" src --include="*.ts" | wc -l

echo

echo "2. Async Patterns"
echo "   async/await usage:"
grep -r "async " src --include="*.ts" | wc -l

echo "   Promise.all usage (parallel):"
grep -r "Promise\.all" src --include="*.ts" | wc -l

echo "   Sequential await patterns:"
grep -r "await.*await" src --include="*.ts" | wc -l

echo

echo "3. Retry Logic & Backoff"
echo "   retryWithDelay usage:"
grep -r "retryWithDelay" src --include="*.ts" | wc -l

echo "   Retry configurations:"
grep -r "maxRetries\|retryDelay" src --include="*.ts" | wc -l

echo

echo "4. API Call Optimization"
echo "   Axios request configurations:"
grep -r "timeout\|maxRedirects" src --include="*.ts" | wc -l

echo "   HTTP connection pooling:"
grep -r "httpsAgent\|httpAgent" src --include="*.ts" | wc -l

echo

echo "5. Memory Management"
echo "   Map/Set usage (potential memory leaks):"
grep -r "new Map\|new Set" src --include="*.ts" | wc -l

echo "   Cleanup/dispose patterns:"
grep -r "dispose\|cleanup\|clear\|delete" src --include="*.ts" | wc -l

echo "   Timer/interval cleanup:"
grep -r "clearInterval\|clearTimeout" src --include="*.ts" | wc -l

echo

echo "6. Resource Pooling"
echo "   Connection reuse:"
grep -r "keepAlive" src --include="*.ts" | wc -l

echo "   Instance reuse (singletons):"
grep -r "getInstance\|static instance" src --include="*.ts" | wc -l

echo

echo "7. Large Data Handling"
echo "   Stream usage:"
grep -r "createReadStream\|createWriteStream" src --include="*.ts" | wc -l

echo "   Buffer operations:"
grep -r "Buffer\." src --include="*.ts" | wc -l

echo "   String size limits:"
grep -r "maxSize\|maxLength" src --include="*.ts" | wc -l

echo

echo "8. Search Optimization"
echo "   Search timeout configuration:"
grep -r "SEARCH_TIMEOUT\|searchTimeout" src --include="*.ts" | wc -l

echo "   Search result limiting:"
grep -r "limit\|maxResults" src --include="*.ts" | wc -l

echo

echo "=== Performance Metrics by File ==="
echo
echo "Largest service files (potential optimization targets):"
find src/services -name "*.ts" -type f -exec wc -l {} + | sort -rn | head -10

echo
echo "Most complex tool files:"
find src/mcp-server/tools -name "logic.ts" -type f -exec wc -l {} + | sort -rn | head -5

