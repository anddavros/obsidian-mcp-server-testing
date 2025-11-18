#!/bin/bash
# Error handling and resilience analysis script

echo "=== Error Handling & Resilience Analysis ==="
echo

echo "1. Error Handling Patterns"
echo "   McpError usage:"
grep -r "throw new McpError" src --include="*.ts" | wc -l

echo "   Total catch blocks:"
grep -r "} catch" src --include="*.ts" | wc -l

echo "   Error type checks:"
grep -r "instanceof Error" src --include="*.ts" | wc -l

echo "   McpError type checks:"
grep -r "instanceof McpError" src --include="*.ts" | wc -l

echo

echo "2. Logging Coverage"
echo "   logger.error calls:"
grep -r "logger\.error" src --include="*.ts" | wc -l

echo "   logger.warning calls:"
grep -r "logger\.warning" src --include="*.ts" | wc -l

echo "   logger.info calls:"
grep -r "logger\.info" src --include="*.ts" | wc -l

echo "   logger.debug calls:"
grep -r "logger\.debug" src --include="*.ts" | wc -l

echo "   logger.crit/fatal calls:"
grep -rE "logger\.(crit|fatal|alert|emerg)" src --include="*.ts" | wc -l

echo

echo "3. Graceful Degradation"
echo "   Fallback patterns (try-catch with fallback):"
grep -rA 5 "} catch" src --include="*.ts" | grep -c "fallback\|default\|alternative"

echo "   Optional chaining usage:"
grep -r "\?\." src --include="*.ts" | wc -l

echo "   Nullish coalescing:"
grep -r "??" src --include="*.ts" | wc -l

echo

echo "4. Timeout & Abort Handling"
echo "   Timeout configurations:"
grep -r "timeout" src --include="*.ts" | wc -l

echo "   AbortController usage:"
grep -r "AbortController\|AbortSignal" src --include="*.ts" | wc -l

echo

echo "5. Shutdown & Cleanup"
echo "   Graceful shutdown handlers:"
grep -r "SIGTERM\|SIGINT\|gracefulShutdown" src --include="*.ts" | wc -l

echo "   Cleanup/dispose patterns:"
grep -rE "cleanup|dispose|close|stop" src --include="*.ts" | wc -l

echo "   Finally blocks:"
grep -r "} finally" src --include="*.ts" | wc -l

echo

echo "6. Resilience Patterns"
echo "   Retry logic:"
grep -r "retryWithDelay\|retry" src --include="*.ts" | wc -l

echo "   Circuit breaker references:"
grep -r "circuit\|breaker" src --include="*.ts" | wc -l

echo "   Fallback cache usage:"
grep -r "cache.*fallback\|fallback.*cache" src --include="*.ts" | wc -l

echo

echo "7. Error Context & Debugging"
echo "   RequestContext propagation:"
grep -r "RequestContext" src --include="*.ts" | wc -l

echo "   Error details/metadata:"
grep -r "error\.details\|error\.context" src --include="*.ts" | wc -l

echo "   Stack trace usage:"
grep -r "error\.stack\|stack:" src --include="*.ts" | wc -l

echo

echo "8. Validation & Preconditions"
echo "   Zod validation (safe parse):"
grep -r "\.safeParse\|\.parse" src --include="*.ts" | wc -l

echo "   Null/undefined checks:"
grep -rE "if \(!.*\)|if \(.*===.*null\)|if \(.*===.*undefined\)" src --include="*.ts" | wc -l

echo "   Type guards:"
grep -r "typeof.*===\|instanceof" src --include="*.ts" | wc -l

echo

echo "=== Error Type Distribution ==="
echo
echo "By BaseErrorCode:"
grep -r "BaseErrorCode\." src --include="*.ts" | sed 's/.*BaseErrorCode\.\([A-Z_]*\).*/\1/' | sort | uniq -c | sort -rn

