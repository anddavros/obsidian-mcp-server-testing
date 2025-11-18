#!/bin/bash
# Analyze all MCP tools

echo "=== Tool Implementation Analysis ==="
echo ""

echo "## 1. Tool List and Structure"
echo ""
echo "All tools:"
ls -d src/mcp-server/tools/*/ | xargs -n1 basename

echo ""
echo "## 2. Tool File Sizes"
echo ""
for tool in src/mcp-server/tools/*/; do
    toolname=$(basename "$tool")
    logic_lines=$(wc -l "$tool/logic.ts" 2>/dev/null | awk '{print $1}')
    reg_lines=$(wc -l "$tool/registration.ts" 2>/dev/null | awk '{print $1}')
    index_lines=$(wc -l "$tool/index.ts" 2>/dev/null | awk '{print $1}')
    total=$((logic_lines + reg_lines + index_lines))
    echo "$toolname: logic=$logic_lines, registration=$reg_lines, index=$index_lines, total=$total"
done

echo ""
echo "## 3. Input Schema Analysis"
echo ""
echo "Tools with Zod schemas:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    schema_count=$(grep -c "Schema.*=.*z\\.object" "$tool" 2>/dev/null || echo "0")
    if [ "$schema_count" -gt 0 ]; then
        echo "$toolname: $schema_count schema(s)"
    fi
done

echo ""
echo "## 4. Error Handling Patterns"
echo ""
echo "McpError throws per tool:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    throws=$(grep -c "throw new McpError" "$tool" 2>/dev/null || echo "0")
    echo "$toolname: $throws throws"
done

echo ""
echo "## 5. Service Method Usage"
echo ""
echo "ObsidianRestApiService method calls:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    calls=$(grep -c "obsidianService\\." "$tool" 2>/dev/null || echo "0")
    echo "$toolname: $calls service calls"
done

echo ""
echo "## 6. Tool Registration Pattern"
echo ""
echo "Registration file exports:"
for tool in src/mcp-server/tools/*/registration.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    exports=$(grep "^export " "$tool" | wc -l)
    echo "$toolname: $exports exports"
done

echo ""
echo "## 7. Documentation Quality"
echo ""
echo "JSDoc blocks in logic files:"
for tool in src/mcp-server/tools/*/logic.ts; do
    toolname=$(dirname "$tool" | xargs basename)
    jsdoc=$(grep -c "^/\\*\\*" "$tool" 2>/dev/null || echo "0")
    echo "$toolname: $jsdoc JSDoc blocks"
done

