#!/bin/bash

# ultimate_benchmark_qwen_rfc.sh
# The definitive stress test for intent tracking and noise filtering.
# Runs the ULTIMATE BENCHMARK against LOCAL QWEN 3 (4B) using the RFC-OPTIMIZED PROMPTS.

API_URL="http://localhost:1234/v1/chat/completions"
# Using the proven best model for this task
MODEL="qwen3-4b-instruct-2507" 
SUMMARY_FILE="ultimate_benchmark_qwen_rfc_results.md"

# Clear previous results
echo "# Voxtype Ultimate Benchmark: QWEN 3 (4B) (RFC Optimized)" > "$SUMMARY_FILE"
echo "Date: $(date)" >> "$SUMMARY_FILE"
echo "Model: $MODEL" >> "$SUMMARY_FILE"
echo "Goal: Testing if Qwen 3 (4B) can handle strict RFC 2119 prompts." >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

# ==========================================
# SYSTEM PROMPTS (RFC 2119 OPTIMIZED)
# ==========================================

# 1. CODER PROMPT
SYSTEM_PROMPT_CODER=$(cat <<'EOF'
<system_definition>
You are a STOIC INTENT COMPILER. You are NOT a chat assistant. You DO NOT converse.
Your sole function is to parse messy spoken dictation into a strict technical specification.
</system_definition>

<protocol_rfc2119>
1. **OUTPUT_FORMAT_REQUIREMENTS**:
   - The Output **MUST** consist of EXACTLY two parts:
     1. A single, imperative sentence summarizing the final intent (The "Summary").
     2. A hyphenated bullet list of specific requirements (The "Specs").
   - The Output **MUST NOT** contain any other text, preambles, intros, outros, or meta-commentary.
   - The Output **MUST NOT** start with phrases like "Here is", "Sure", "To do this", "The requirements are", or "Based on".
   - The Summary **MUST** be the very first line of the response.

2. **PROCESSING_CONSTRAINTS**:
   - You **SHALL** strip all disfluencies ("um", "uh", "like", "you know").
   - You **MUST** execute all "correction commands" (e.g., "scratch that", "wait", "actually", "no") by immediately overwriting any preceding conflicting instructions.
   - The User's final decision is **ABSOLUTE**, even if it appears technically inferior.
   - You **MUST NOT** include code blocks, code fences (```), or snippets.
   - You **MUST NOT** list features that were excluded, omitted, or rejected.

3. **STYLE_GUIDELINES**:
   - Technical terms **SHOULD** be enclosed in single backticks.
   - Bullets **MUST** be concise and direct.
   - You **MUST NOT** justify or explain why a feature was included or excluded.
</protocol_rfc2119>

<one_shot_example>
Input: "setup a server... um use node... wait python... actually go... and use gin"
Output:
Set up a Go server using the Gin framework.
- Configure the backend using `Go`.
- Implement the web layer using the `Gin` framework.
</one_shot_example>
EOF
)

# 2. GENERAL/BUSINESS MASTER RULES
MASTER_RULES=$(cat <<'EOF'
<system_definition>
You are an EXPERT GHOSTWRITER. Your goal is to produce the *final, polished message* the user intended to send.
</system_definition>

<compliance_protocol>
1. **DELETION_MANDATE (CRITICAL)**:
   - If the user issues a deletion command (e.g., "drop X", "remove Y", "scratch Z"), you **MUST** ensure that the referenced content does NOT appear in the final output.
   - This rule is **ABSOLUTE**. It applies to thanks, greetings, compliments, and specific topics.
   - **Verification**: Before outputting, you **MUST** verify that all deleted items are gone.

2. **TIME_TRAVEL_LOGIC**:
   - You **SHALL** treat the input as a timeline of thought.
   - If the user corrects themselves (A -> B), the Output **MUST** reflect ONLY state B.
   - You **MUST NOT** acknowledge the correction (e.g., do NOT write "Actually", "Correction", or "Wait").

3. **CLEANUP_STANDARDS**:
   - You **MUST** remove all fillers (um, uh, like).
   - You **MUST** remove all meta-commentary (wait, hang on).
   - You **MUST** Output ONLY the final message text. No quotes. No labels.
</compliance_protocol>
EOF
)

# 3. MODE SPECIFIC EXPANSIONS
MODE_GENERAL=$(cat <<'EOF'
<mode type="general">
    <context>Casual conversation (WhatsApp, Discord, SMS).</context>
    <style_guide>
        <tone>Natural, conversational, concise.</tone>
        <spelling>British English.</spelling>
    </style_guide>
    <specific_instructions>
        - You **MUST** rewrite the text to sound like a coherent text message.
        - **EXAMPLE**: Input "Go left. No, right." -> Output "Go right." (NOT "No, right" or "Forget left, right").
    </specific_instructions>
</mode>
EOF
)

MODE_BUSINESS=$(cat <<'EOF'
<mode type="business">
    <context>Professional communication (Email, Slack, LinkedIn).</context>
    <style_guide>
        <tone>Professional, clear, polite.</tone>
        <spelling>British English.</spelling>
    </style_guide>
    <specific_instructions>
        - You **MUST** rewrite the text to sound like a polished professional update.
        - You **MUST** be ruthless in removing "draft" thoughts. If they said "Feature A... actually Feature B", ONLY "Feature B" remains.
        - **CRITICAL**: If the user says "drop the X", you **MUST NOT** mention X.
    </specific_instructions>
</mode>
EOF
)

# ==========================================
# TEST CASES (30 Total) - ULTRA HARD
# ==========================================

declare -A TESTS_CODER
declare -A TESTS_GENERAL
declare -A TESTS_BUSINESS

# --- CODER TEST CASES (10) ---
TESTS_CODER["coder_01_stack_war"]="okay so like start a new web project... ummm use django... wait actually no flask is like way lighter... you know? actually uh stick with django because of the admin panel... that's useful... but um use postgres... wait no sqlite is fine for dev... actually uh no let's use docker with postgres from day one... and like use htmx... wait no react... actually vue... yeah vue 3... definitely vue 3"
TESTS_CODER["coder_02_auth_flipflop"]="so uh add authentication... start with google oauth... wait um we need email password too... actually scratch email password just google... wait no clients want microsoft login... so google and microsoft... but um remove google for now just microsoft... and make sure we require 2fa... wait no 2fa is too annoying for v1 scratch that... yeah just remove it"
TESTS_CODER["coder_03_deploy_mess"]="create a deployment script... target aws beanstalk... wait uh no too expensive... like use a digital ocean droplet... with nginx... actually uh caddy is easier... use caddy... and um install python 3.10... wait 3.11... actually 3.12 is stable now right? use 3.12... and setup a firewall allowing port 80... wait like 443 only... force https... yeah force it"
TESTS_CODER["coder_04_data_model"]="define a user schema... fields for name and email... and uh age... wait no date of birth... actually scratch date of birth just age is fine... and add a subscription status... enum active inactive... wait add suspended too... actually remove suspended just active inactive... and link to an organization... wait no a team... link to a team table"
TESTS_CODER["coder_05_api_style"]="design the api... um use graphql... wait no rest is standard... actually trpc since we are fullstack typescript... wait no the mobile app is flutter... so back to rest... make it rest... but use json:api spec... wait no that is too verbose just standard json... and version it in the url... wait no in the header... yeah header"
TESTS_CODER["coder_06_state_mgmt"]="setup the frontend store... use redux toolkit... wait it is too much boilerplate... use zustand... actually context api is enough... wait we have complex auth state... back to zustand... and use persist middleware... wait no security risk dont persist auth token... just persist theme... yeah only theme"
TESTS_CODER["coder_07_css_framework"]="style the dashboard... use bootstrap... wait that looks old... use tailwind... actually material ui is faster... wait no material is heavy... go back to tailwind... and use the daisyui plugin... wait no headless ui... actually just raw tailwind... yeah keep it simple"
TESTS_CODER["coder_08_testing_lib"]="write tests for the login... use jest... wait vitest is faster... so vitest... and use react testing library... wait cypress for e2e... actually playright is better... so playwright for e2e... and vitest for unit... but um omit the screenshot testing for now... yeah skip that"
TESTS_CODER["coder_09_cloud_storage"]="setup file upload... use s3... wait google cloud storage... actually azure blob... no s3 is standard... use s3... but use a minio instance locally... wait no localstack... actually just mock it in code for now scratch the local instance... yeah just mock it"
TESTS_CODER["coder_10_logging"]="implement logging... use winston... wait pino is faster... use pino... log to a file... wait no stdout for docker... and send to datadog... wait too expensive... send to sentry... actually just log to stdout and we will use grafana loki later... so just stdout JSON format... yeah JSON"

# --- GENERAL TEST CASES (10) ---
TESTS_GENERAL["gen_01_movie_indecision"]="wanna watch a movie? thinking dune... wait no it is like three hours... maybe barbie... actually seen it... ummm oppenheimer? nah too heavy for a tuesday... how about the bear? wait that is a show... actually yeah let's binge the bear... start season 2? you know?"
TESTS_GENERAL["gen_02_dinner_plans"]="ordering food... pizza... wait dave is on a diet... sushi then... actually i don't trust the fish today... maybe just burgers... wait no carbs... uh thai salad? yeah let's do thai... get the green curry... wait no red curry... and extra rice... wait no rice for dave... poor dave"
TESTS_GENERAL["gen_03_meetup_time"]="meet at the pub at 6... wait traffic is bad... make it 6:30... actually i have that call... push to 7... yeah 7 works... wait if we do 7 the kitchen closes... okay 6:45... meet at 6:45 sharp... basically"
TESTS_GENERAL["gen_04_grocery_run"]="can you grab milk... oat milk... wait no almond... actually soy is better for coffee... and get eggs... wait we have eggs... get bread though... sourdough... if they don't have it get rye... wait no just sourdough or nothing... literally nothing else"
TESTS_GENERAL["gen_05_weekend_trip"]="thinking of going to brighton this weekend... wait forecast says rain... maybe bath? actually too far... how about london... wait too expensive... um maybe just a hike locally... yeah let's do the ridge walk... bring the dog... wait no dog is limping... leave the dog... sad times"
TESTS_GENERAL["gen_06_gift_brainstorm"]="need a gift for mom... maybe a scarf... wait she has too many... a kindle... actually she likes paper books... get her that new thriller... wait the cooking one... actually the gardening book... yeah the gardening one... and maybe some seeds... wait no just the book... keep it simple"
TESTS_GENERAL["gen_07_gym_day"]="hitting the gym monday... wait monday is chest day it's packed... tuesday... actually i have a meeting tuesday night... wednesday morning... yeah wednesday morning... 6am... wait 7am... 6 is too early... 7am wednesday... definitely"
TESTS_GENERAL["gen_08_gamer_setup"]="building a pc... ryzen 7... wait intel is cheaper right now... actually ryzen is better for multitasking... stick with ryzen... and a 4070... wait 4060 ti is enough... actually no 4070... future proof... and 32gb ram... wait 16 is fine... no 32... ram is cheap... might as well"
TESTS_GENERAL["gen_09_coffee_run"]="large latte... wait flat white... oat milk... wait no dairy is fine today... actually skim... and vanilla syrup... wait no hazelnut... actually caramel... no scrap the syrup just a plain skim flat white... extra hot... like really hot"
TESTS_GENERAL["gen_10_cleaning_duty"]="gonna clean the kitchen... and the bathroom... wait bathroom is fine... just kitchen... and vacuum the lounge... actually vacuum the whole downstairs... wait no just the rug... the rest is clean... so kitchen and rug... yeah that's enough"

# --- BUSINESS TEST CASES (10) ---
TESTS_BUSINESS["biz_01_email_subject"]="Subject: Project Update... wait Q3 Report... actually Weekly Sync Notes... wait no that sounds boring... make it 'Key Milestones Achieved - Q3'... yeah that sounds punchy... wait drop the 'Q3'... just 'Key Milestones Achieved'... yeah simpler is better"
TESTS_BUSINESS["biz_02_slack_status"]="set status to in a meeting... wait out sick... actually deep work... urgent only... wait no that sounds rude... just 'Focus Time'... with the headphones emoji... wait no the laptop emoji... yeah laptop"
TESTS_BUSINESS["biz_03_linkedin_announce"]="Excited to announce I'm joining... wait humbled to share... actually just 'I'm starting a new position'... as VP of Eng... wait no Director of Eng... at TechCorp... wait no stealth startup... just say 'at a new AI startup'... keep it mysterious... you know?"
TESTS_BUSINESS["biz_04_feedback_sandwich"]="Great job on the preso... wait fix the typos on slide 3... actually rewrite the intro entirely it was weak... but good effort... wait drop the 'good effort' it sounds patronizing... just say 'Please rewrite intro and fix typos on slide 3'... straight to the point"
TESTS_BUSINESS["biz_05_ooo_reply"]="I am OOO until Monday... wait Tuesday... checking emails sporadically... actually no I have no access... contact Sarah for emergencies... wait Sarah is off too... contact Mike... wait Mike is junior... actually just 'I will reply when I return'... safer"
TESTS_BUSINESS["biz_06_agenda_change"]="Agenda for tomorrow: Review budget... wait skip budget finance isn't ready... discuss hiring pipeline... actually focus entirely on the roadmap blockers... yeah just roadmap blockers... and maybe a quick round table... wait no round table we run over... just roadmap... keep it focused"
TESTS_BUSINESS["biz_07_launch_comms"]="The beta is live... wait almost live... deploying in 1 hour... actually say 'Beta is rolling out now'... sounds more dynamic... and include the link... wait no link yet... say 'Link coming in comments'... yeah that works"
TESTS_BUSINESS["biz_08_client_reply"]="Thanks for the email... wait 'Received'... actually 'On it'... wait that is too casual... 'I have received your request and will process it'... by Friday... wait Thursday... actually by EOD today... yeah impress them... EOD today"
TESTS_BUSINESS["biz_09_strategy_pivot"]="We are pivoting to B2B... wait B2C is still growing... actually focus on B2B2C... wait that is jargon... let's say 'Partnership-led growth'... yeah focus on partnerships... and drop direct sales... wait keep direct sales for enterprise... so partnerships and enterprise direct... sound strategy"
TESTS_BUSINESS["biz_10_quarterly_goals"]="Goal: Increase revenue 10%... wait 20%... actually focus on retention... reduce churn by 5%... wait 2% is realistic... actually 5% stretch goal... yeah aim for 5% churn reduction... and ignore new leads for now... wait don't say ignore... say 'deprioritize new leads'... nicer phrasing"

# ==========================================
# EXECUTION LOOP
# ==========================================

run_test() {
    local category=$1
    local key=$2
    local input=$3
    local prompt=$4

    echo "Benchmarking $category / $key..."
    echo "#### $key" >> "$SUMMARY_FILE"
    echo "**Input:** $input" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "| Time (s) | Output |" >> "$SUMMARY_FILE"
    echo "|----------|--------|" >> "$SUMMARY_FILE"

    JSON_PAYLOAD=$(jq -n \
        --arg model "$MODEL" \
        --arg sys "$prompt" \
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

    clean_output=$(echo "$output" | tr -d '\n' | sed 's/|/\\|/g')
    echo "| $duration | $clean_output |" >> "$SUMMARY_FILE"
    echo "Done"
    sleep 1
}

# --- RUN CODER TESTS ---
echo "=== Running Coder Tests ==="
echo "### CODER MODE" >> "$SUMMARY_FILE"
for key in "${!TESTS_CODER[@]}"; do
    run_test "CODER" "$key" "${TESTS_CODER[$key]}" "$SYSTEM_PROMPT_CODER"
done

# --- RUN GENERAL TESTS ---
echo "=== Running General Tests ==="
echo "### GENERAL MODE" >> "$SUMMARY_FILE"
FULL_PROMPT_GENERAL="${MASTER_RULES}\n\n<mode_specific_instructions>\n${MODE_GENERAL}\n</mode_specific_instructions>"
for key in "${!TESTS_GENERAL[@]}"; do
    run_test "GENERAL" "$key" "${TESTS_GENERAL[$key]}" "$FULL_PROMPT_GENERAL"
done

# --- RUN BUSINESS TESTS ---
echo "=== Running Business Tests ==="
echo "### BUSINESS MODE" >> "$SUMMARY_FILE"
FULL_PROMPT_BUSINESS="${MASTER_RULES}\n\n<mode_specific_instructions>\n${MODE_BUSINESS}\n</mode_specific_instructions>"
for key in "${!TESTS_BUSINESS[@]}"; do
    run_test "BUSINESS" "$key" "${TESTS_BUSINESS[$key]}" "$FULL_PROMPT_BUSINESS"
done

echo "" >> "$SUMMARY_FILE"
echo "Benchmark complete. Results in: $SUMMARY_FILE"
