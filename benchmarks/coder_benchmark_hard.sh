#!/bin/bash

# coder_benchmark_hard.sh
# Benchmarking engineering specification mode on local LM Studio models.
# HARD MODE: Multiple reversals, ambiguity, and heavy conversational noise.

API_URL="http://localhost:1234/v1/chat/completions"
MODELS=("qwen3-4b-instruct-2507")
SUMMARY_FILE="coder_benchmark_hard_results.md"

# Clear previous results
echo "# Voxtype Coder Benchmark: HARD MODE" > "$SUMMARY_FILE"
echo "Date: $(date)" >> "$SUMMARY_FILE"
echo "Models: ${MODELS[*]}" >> "$SUMMARY_FILE"
echo "Goal: Stress test intent tracking with ping-pong reversals and heavy noise." >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# The Absolute "No Code" System Prompt with Mandatory Preamble
SYSTEM_PROMPT=$(cat <<'EOF'
<context>
The user is dictating technical requirements and architectural thoughts for an AI coding agent. You are a Senior System Architect.
</context>

<logic_rules>
- MANDATORY PREAMBLE: The response MUST start with one concise sentence that restates the user's intent as an instruction. No labels or prefixes.
- STRICT NO CODE: The response MUST NOT include code blocks, inline code samples, assignments, function definitions, or pseudocode.
- NO TRIPLE BACKTICKS: The response MUST NOT contain markdown code fences.
- FORMAT: After the first sentence, output MUST be hyphen bullets only. No headings, no blank lines.
- TECH TERMS: Use single backticks for technical names.
- NO META-TALK: No explanations.
</logic_rules>

<processing_rules>
- CORRECTIONS: When the user reverses or revises (e.g. "scratch that", "actually", "wait"), you MUST drop the superseded clause. The FINAL instruction in the timeline is the ONLY truth. The user's final decision is ABSOLUTE, even if it seems less safe, less optimal, or "worse".
- NO INVENTION: You MUST NOT add requirements, libraries, or qualities not stated.
- STRICT SCOPE: Include only entities explicitly mentioned.
- POSITIVE REQUIREMENTS ONLY: The output list MUST contain ONLY the features that will be built. Do not list excluded features, rejected ideas, or omitted items. If a feature is not being built, do not list it.
- NO NEGATIVE BULLETS: You MUST NOT output bullet points that describe what is missing, omitted, or excluded. Do not start bullets with "Omit", "Exclude", "Remove", "Do not", or "No". Only describe what exists.
</processing_rules>

<example>
User: "um okay so could you like write a function that calculates the sum of all elements in an array wait scratch that actually make it a function that finds the average of all numbers in a list and it MUST be recursive"

Output:
Develop a recursive function to calculate the arithmetic average of all numbers in a list.
- Implement the core logic using a recursive approach.
- Ensure the function supports tail call optimisation for performance.
- Validate that the input is a non-empty list of numeric values.
</example>

<output_format>
One-sentence intent summary.
Hyphen bullet list of requirements.
</output_format>

<final_checklist>
- This checklist is internal and must not be output.
- I removed filler words and resolved all corrections.
- I did not add any unrequested requirements, libraries, or qualities.
- I did not include any code or code-like snippets.
- I used only hyphen bullets after the first sentence.
- I used backticks only for technical terms already present in the request.
- I did not mention any tool or library that was scratched.
</final_checklist>
EOF
)

# Hard Test Cases
declare -A TESTS
TESTS["level_1_pingpong"]="um so I need a function that filters an array... uh by a property called isActive... wait no scratch that make it filter by the role being exactly admin... actually uh you know what isActive was better stick with that... and um make sure it returns the count not the array"
TESTS["level_2_conflict"]="right so we need a store for the session... um use zustand... wait we need to persist to localstorage... actually uh if we are persisting maybe redux toolkit is better because of the middleware... yeah let's go with redux... oh and make it strict mode"
TESTS["level_3_nested_logic"]="api endpoint for users... um return id and name... if they are an admin include email... wait if they are an admin OR a manager include email... actually uh scratch the manager part just admins get email... but managers should get phone number... and everyone gets avatar"
TESTS["level_4_reversal_chain"]="setup a dockerfile... um use node 18 alpine... wait no node 20... actually uh 18 is safer for now... hang on... yeah 20 is fine let's use 20... and expose port 80... wait no 8080... and um install git... wait no we don't need git in production scratch that"
TESTS["level_5_feature_creep"]="build a login form... email and password... um add a remember me checkbox... wait actually remove the checkbox we are doing stateless... but add a 'forgot password' link... and um maybe social login? nah scratch social login just the link"

LEVEL_KEYS=("level_1_pingpong" "level_2_conflict" "level_3_nested_logic" "level_4_reversal_chain" "level_5_feature_creep")

for model in "${MODELS[@]}"; do
    echo "=== Benchmarking Model: $model ==="
    echo "## Model: $model" >> "$SUMMARY_FILE"

    # Warmup
    warmup_payload=$(jq -n \
        --arg model "$model" \
        --arg user "hi" \
        '{
            model: $model,
            messages: [
                {role: "user", content: $user}
            ]
        }')
    curl -s --max-time 120 "$API_URL" -H "Content-Type: application/json" -d "$warmup_payload" >/dev/null

    for key in "${LEVEL_KEYS[@]}"; do
        input=${TESTS[$key]}
        echo "Benchmarking $key..."
        echo "### $key" >> "$SUMMARY_FILE"
        echo "**Input:** $input" >> "$SUMMARY_FILE"
        echo "" >> "$SUMMARY_FILE"
        echo "| Run | Time (s) | Specification Output |" >> "$SUMMARY_FILE"
        echo "|-----|----------|----------------------|" >> "$SUMMARY_FILE"

        # Dynamic run count
        case "$key" in
            "level_4_reversal_chain"|"level_5_feature_creep") runs=3 ;;
            *) runs=1 ;;
        esac

        for ((i=1; i<=runs; i++)); do
            echo -n "  Run $i... "

            JSON_PAYLOAD=$(jq -n \
                --arg model "$model" \
                --arg sys "$SYSTEM_PROMPT" \
                --arg user "$input" \
                '{
                    model: $model,
                    messages: [
                        {role: "system", content: $sys},
                        {role: "user", content: $user}
                    ]
                }')

            start_time=$(date +%s.%N)
            response=$(curl -s --max-time 120 "$API_URL" \
                -H "Content-Type: application/json" \
                -d "$JSON_PAYLOAD")
            end_time=$(date +%s.%N)
            duration=$(echo "$end_time - $start_time" | bc)

            output=$(echo "$response" | jq -r '.choices[0].message.content // empty' 2>/dev/null)
            if [ -z "$output" ] || [ "$output" == "null" ]; then
                output="ERROR: $(echo "$response" | jq -r '.error.message // "Empty output"' 2>/dev/null)"
            fi

            # Clean for markdown table
            clean_output=$(echo "$output" | tr -d '\n' | sed 's/|/\\|/g')

            echo "| $i | $duration | $clean_output |" >> "$SUMMARY_FILE"
            echo "Done"
            sleep 2
        done
        echo "" >> "$SUMMARY_FILE"
    done
    echo "---" >> "$SUMMARY_FILE"
done

echo "Benchmark complete. Results in: $SUMMARY_FILE"
