#!/usr/bin/env bash
#
# Transport Systems Lab - Bibliography Update Script
#
# Usage:
#   ./bib_update.sh              # Normal run (uses cache)
#   ./bib_update.sh --no-cache   # Clear cache before running
#   ./bib_update.sh --regenerate # Regenerate citations without refetching sources

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env.local if it exists
if [ -f "$SCRIPT_DIR/.env.local" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env.local" | xargs)
fi

# Handle command line arguments
if [ "$1" = "--no-cache" ]; then
    echo "Clearing cache..."
    rm -rf "$SCRIPT_DIR/_cite/.cache/"*
    echo "Cache cleared."
fi

# Pass arguments to Python script
python "$SCRIPT_DIR/_cite/cite.py" "$@"
