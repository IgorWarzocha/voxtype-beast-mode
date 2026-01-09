#!/bin/bash
# voxtype-beast-mode/scripts/cleanup-coding.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Read the RFC-optimized prompt from the prompts directory (relative to scripts/)
PROMPT=$(cat "$SCRIPT_DIR/../prompts/system_coder_rfc.md")
"$SCRIPT_DIR/cleanup-template.sh" "$PROMPT"
