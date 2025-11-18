#!/bin/bash
# Script to analyze circular dependencies found by madge

echo "=== Circular Dependency Analysis ==="
echo ""
echo "Analyzing imports in circular dependency chains..."
echo ""

# Analysis 1: logger.ts <-> requestContext.ts
echo "1. logger.ts <-> requestContext.ts"
echo "   logger.ts imports:"
grep "^import.*from.*requestContext" src/utils/internal/logger.ts || echo "   (none found)"
echo "   requestContext.ts imports:"
grep "^import.*from.*logger" src/utils/internal/requestContext.ts || echo "   (none found)"
echo ""

# Analysis 2: utils/index.ts chain
echo "2. utils/index.ts re-export chain"
grep "^export.*from" src/utils/index.ts | head -10
echo ""

# Analysis 3: errorHandler circular
echo "3. errorHandler.ts imports:"
grep "^import" src/utils/internal/errorHandler.ts | head -10
echo ""

# Analysis 4: tokenCounter circular
echo "4. tokenCounter.ts imports:"
grep "^import" src/utils/metrics/tokenCounter.ts | head -10
echo ""

# Analysis 5: vaultCache circular
echo "5. vaultCache imports:"
grep "^import" src/services/obsidianRestAPI/vaultCache/service.ts | head -10
echo ""
