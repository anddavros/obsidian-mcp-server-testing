#!/bin/bash

echo "========================================="
echo "Git & Version Control Practices Analysis"
echo "========================================="
echo ""

# Navigate to project root
cd "$(dirname "$0")/../.." || exit 1

echo "=== Repository Statistics ==="
echo ""
echo "Total commits:"
git log --all --oneline | wc -l
echo ""
echo "Contributors:"
git log --format="%an" | sort | uniq | wc -l
echo ""
echo "Top contributors:"
git log --format="%an" | sort | uniq -c | sort -rn | head -5
echo ""

echo "=== Branches ==="
echo ""
echo "Local branches:"
git branch | wc -l
echo ""
echo "All branches:"
git branch -a
echo ""

echo "=== Tags ==="
echo ""
echo "Total tags:"
git tag | wc -l
echo ""
if [ "$(git tag | wc -l)" -gt 0 ]; then
  echo "Recent tags:"
  git tag -l | tail -10
else
  echo "No tags found"
fi
echo ""

echo "=== Commit Message Analysis ==="
echo ""
echo "Total commits:"
git log --all --format="%s" | wc -l
echo ""
echo "Conventional commits (feat|fix|docs|etc):"
git log --all --format="%s" | grep -E "^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert):" | wc -l
echo ""
echo "Conventional commit percentage:"
total=$(git log --all --format="%s" | wc -l)
conventional=$(git log --all --format="%s" | grep -E "^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert):" | wc -l)
if [ "$total" -gt 0 ]; then
  percentage=$((conventional * 100 / total))
  echo "$percentage%"
fi
echo ""

echo "=== Commit Type Breakdown ==="
for type in feat fix docs style refactor test chore perf ci build; do
  count=$(git log --all --format="%s" | grep -E "^$type:" | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "$type: $count"
  fi
done
echo ""

echo "=== Code Churn ==="
echo ""
git log --all --numstat --format="" | awk '{files++; added+=$1; removed+=$2} END {print "Files changed:", files; print "Lines added:", added; print "Lines removed:", removed}'
echo ""

echo "=== Most Changed Files ==="
echo ""
git log --all --pretty=format: --name-only | grep -v "^$" | sort | uniq -c | sort -rn | head -15
echo ""

echo "=== Recent Activity ==="
echo ""
echo "Last 10 commits:"
git log --oneline -10
echo ""

echo "=== Release Version History ==="
echo ""
echo "Version-related commits:"
git log --all --pretty=format:"%h %ad %s" --date=short --grep="version\|release\|bump" | head -10
echo ""

echo "=== Current Version ==="
echo ""
if [ -f "package.json" ]; then
  echo "package.json version:"
  jq -r '.version' package.json
else
  echo "No package.json found"
fi
echo ""

echo "=== .gitignore Analysis ==="
echo ""
if [ -f ".gitignore" ]; then
  echo "Lines in .gitignore:"
  wc -l < .gitignore
  echo ""
  echo "Unique patterns:"
  grep -v "^#" .gitignore | grep -v "^$" | wc -l
else
  echo "No .gitignore found"
fi
echo ""

echo "=== .gitattributes ==="
echo ""
if [ -f ".gitattributes" ]; then
  echo "Lines in .gitattributes:"
  wc -l < .gitattributes
else
  echo "No .gitattributes file found"
fi
echo ""

echo "=== Commit Frequency ==="
echo ""
echo "Commits by month (last 12 months):"
git log --all --since="1 year ago" --format="%ad" --date=format:"%Y-%m" | sort | uniq -c | tail -12
echo ""

echo "========================================="
echo "Analysis Complete"
echo "========================================="