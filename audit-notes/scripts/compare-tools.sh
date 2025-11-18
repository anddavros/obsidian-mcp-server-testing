#!/bin/bash
# Compare tool implementations for consistency

echo "=== Tool Consistency Comparison ==="
echo ""

echo "## 1. Schema Export Pattern"
echo ""
echo "Checking for consistent schema exports:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    has_schema=$(grep -c "export const.*InputSchema" "$tool" || echo "0")
    has_type=$(grep -c "export type.*Input = z.infer" "$tool" || echo "0")
    echo "$toolname: schema=$has_schema, type=$has_type"
done

echo ""
echo "## 2. Response Interface Pattern"
echo ""
echo "Checking for response interfaces:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    has_response=$(grep -c "export interface.*Response" "$tool" || echo "0")
    echo "$toolname: $has_response response interface(s)"
done

echo ""
echo "## 3. Process Function Pattern"
echo ""
echo "Checking for main process function:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    has_process=$(grep -c "export const process" "$tool" || echo "0")
    echo "$toolname: $has_process process function(s)"
done

echo ""
echo "## 4. Retry Logic Usage"
echo ""
echo "retryWithDelay usage per tool:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    retries=$(grep -c "retryWithDelay" "$tool" || echo "0")
    echo "$toolname: $retries retry calls"
done

echo ""
echo "## 5. Cache Integration"
echo ""
echo "VaultCacheService usage:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    cache_usage=$(grep -c "vaultCacheService" "$tool" || echo "0")
    echo "$toolname: $cache_usage cache references"
done

echo ""
echo "## 6. Logger Usage"
echo ""
echo "Logger calls per tool:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    debug=$(grep -c "logger.debug" "$tool" || echo "0")
    info=$(grep -c "logger.info" "$tool" || echo "0")
    error=$(grep -c "logger.error" "$tool" || echo "0")
    total=$((debug + info + error))
    echo "$toolname: debug=$debug, info=$info, error=$error, total=$total"
done

