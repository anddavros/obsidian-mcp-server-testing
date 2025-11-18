#!/bin/bash
# Generate a directory tree view

echo "=== Detailed Directory Tree ==="
echo ""

# Function to print tree with indentation
print_tree() {
    local dir="$1"
    local prefix="$2"
    
    # List directories first, then files
    find "$dir" -maxdepth 1 -type d ! -path "$dir" | sort | while read -r d; do
        echo "${prefix}├── $(basename "$d")/"
        print_tree "$d" "${prefix}│   "
    done
    
    find "$dir" -maxdepth 1 -type f | sort | while read -r f; do
        echo "${prefix}├── $(basename "$f")"
    done
}

# Generate tree for src/
echo "src/"
print_tree "src" ""

