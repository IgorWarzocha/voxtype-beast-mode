#!/bin/bash
# voxtype-beast-mode/scripts/cleanup-template.sh

INPUT=$(cat)
# The full system prompt is passed as the first argument
SYSTEM_PROMPT=$1

# --- CONFIGURATION ---

# OPTION 1: Gemini 2.5 Flash (DEFAULT - Cloud/Beast Mode)
# Requires running the gemini-cli proxy
API_URL="http://192.168.0.113:8000/v1/chat/completions"
API_KEY="VerysecretKey"
MODEL="gemini_cli/gemini-2.5-flash"

# OPTION 2: Local LM Studio (Local/Privacy Mode)
# Uncomment the lines below to use local Qwen/Llama models
# API_URL="http://localhost:1234/v1/chat/completions"
# API_KEY="lm-studio"
# MODEL="qwen3-4b-instruct-2507"

# ---------------------

# --- GUARDRAIL LOGIC ---
# If input is too short, don't waste an API call.
# xargs flattens the output to a single line automatically.
WORD_COUNT=$(echo "$INPUT" | wc -w)
if [ "$WORD_COUNT" -le 15 ]; then
    echo "$INPUT" | xargs
    exit 0
fi
# -----------------------

MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  JSON_PAYLOAD=$(jq -n \
    --arg model "$MODEL" \
    --arg sys_content "$SYSTEM_PROMPT" \
    --arg user_content "$INPUT" \
    '{
      model: $model,
      messages: [
        {role: "system", content: $sys_content},
        {role: "user", content: $user_content}
      ]
    }')

  RESPONSE=$(curl -s --max-time 15 "$API_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "$JSON_PAYLOAD")

  CLEANED=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty' 2>/dev/null)

  if [ -n "$CLEANED" ] && [ "$CLEANED" != "null" ]; then
    # FLATTENER: Replace newlines with spaces to prevent "Enter" submission.
    # Also strip carriage returns.
    # This ensures the output is a single block of text.
    FLATTENED=$(echo "$CLEANED" | tr -d '\r' | tr '\n' ' ' | sed 's/  */ /g')
    
    # SAFETY DELAY: Wait 1.0s to ensure user has released hotkeys (Super/Ctrl)
    # before typing begins. This prevents triggering shortcuts.
    sleep 1.0
    
    echo "$FLATTENED"
    exit 0
  fi

  RETRY_COUNT=$((RETRY_COUNT + 1))
  [ $RETRY_COUNT -lt $MAX_RETRIES ] && sleep 1
done
