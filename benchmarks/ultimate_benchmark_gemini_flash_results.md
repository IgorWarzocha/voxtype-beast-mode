# Voxtype Ultimate Benchmark: GEMINI 2.5 FLASH (RFC Optimized)
Date: Thu Jan  8 06:49:39 PM GMT 2026
Model: gemini_cli/gemini-2.5-flash
Goal: Stress test intent tracking with STRICT RFC 2119 prompts.

### CODER MODE
#### coder_08_testing_lib
**Input:** write tests for the login... use jest... wait vitest is faster... so vitest... and use react testing library... wait cypress for e2e... actually playright is better... so playwright for e2e... and vitest for unit... but um omit the screenshot testing for now... yeah skip that

| Time (s) | Output |
|----------|--------|
| 2.502471794 | Write login tests using Playwright for end-to-end and Vitest for unit testing.- Write tests for the login functionality.- Use `Playwright` for end-to-end tests.- Use `Vitest` for unit tests.- Omit screenshot testing. |
#### coder_03_deploy_mess
**Input:** create a deployment script... target aws beanstalk... wait uh no too expensive... like use a digital ocean droplet... with nginx... actually uh caddy is easier... use caddy... and um install python 3.10... wait 3.11... actually 3.12 is stable now right? use 3.12... and setup a firewall allowing port 80... wait like 443 only... force https... yeah force it

| Time (s) | Output |
|----------|--------|
| 2.937007227 | Create a deployment script for a DigitalOcean Droplet.- Target `DigitalOcean Droplet` for deployment.- Install the `Caddy` web server.- Install `Python 3.12`.- Configure a firewall to allow only `port 443`.- Enforce `HTTPS`. |
#### coder_06_state_mgmt
**Input:** setup the frontend store... use redux toolkit... wait it is too much boilerplate... use zustand... actually context api is enough... wait we have complex auth state... back to zustand... and use persist middleware... wait no security risk dont persist auth token... just persist theme... yeah only theme

| Time (s) | Output |
|----------|--------|
| 2.865390102 | Set up a frontend store using Zustand with theme persistence.- Implement state management using `Zustand`.- Configure `Zustand` with `persist middleware`.- Ensure only the `theme` state is persisted. |
#### coder_01_stack_war
**Input:** okay so like start a new web project... ummm use django... wait actually no flask is like way lighter... you know? actually uh stick with django because of the admin panel... that's useful... but um use postgres... wait no sqlite is fine for dev... actually uh no let's use docker with postgres from day one... and like use htmx... wait no react... actually vue... yeah vue 3... definitely vue 3

| Time (s) | Output |
|----------|--------|
| 3.119088255 | Start a new web project using Django, PostgreSQL with Docker, and Vue 3.- Initialize a new web project.- Utilize `Django` for the backend framework.- Deploy `PostgreSQL` using `Docker` for the database.- Implement the frontend using `Vue 3`. |
#### coder_05_api_style
**Input:** design the api... um use graphql... wait no rest is standard... actually trpc since we are fullstack typescript... wait no the mobile app is flutter... so back to rest... make it rest... but use json:api spec... wait no that is too verbose just standard json... and version it in the url... wait no in the header... yeah header

| Time (s) | Output |
|----------|--------|
| 3.000790309 | Design a REST API using standard JSON payloads and header-based versioning.- Implement a `REST` API.- Utilize `standard JSON` for data payloads.- Version the API via `HTTP headers`. |
#### coder_07_css_framework
**Input:** style the dashboard... use bootstrap... wait that looks old... use tailwind... actually material ui is faster... wait no material is heavy... go back to tailwind... and use the daisyui plugin... wait no headless ui... actually just raw tailwind... yeah keep it simple

| Time (s) | Output |
|----------|--------|
| 1.552279244 | Style a dashboard using raw Tailwind CSS.- Style the dashboard with `Tailwind CSS`.- Do not use `DaisyUI`.- Do not use `Headless UI`. |
#### coder_04_data_model
**Input:** define a user schema... fields for name and email... and uh age... wait no date of birth... actually scratch date of birth just age is fine... and add a subscription status... enum active inactive... wait add suspended too... actually remove suspended just active inactive... and link to an organization... wait no a team... link to a team table

| Time (s) | Output |
|----------|--------|
| 3.925207502 | Define a `User` schema with specified fields and relationships.- Define a `User` schema.- Include a `name` field.- Include an `email` field.- Include an `age` field.- Include a `subscription_status` field as an enum with values `active` and `inactive`.- Link to a `Team` table. |
#### coder_02_auth_flipflop
**Input:** so uh add authentication... start with google oauth... wait um we need email password too... actually scratch email password just google... wait no clients want microsoft login... so google and microsoft... but um remove google for now just microsoft... and make sure we require 2fa... wait no 2fa is too annoying for v1 scratch that... yeah just remove it

| Time (s) | Output |
|----------|--------|
| 2.197067776 | Implement authentication using Microsoft Login.- Add an authentication mechanism.- Utilize `Microsoft Login` for user authentication. |
#### coder_10_logging
**Input:** implement logging... use winston... wait pino is faster... use pino... log to a file... wait no stdout for docker... and send to datadog... wait too expensive... send to sentry... actually just log to stdout and we will use grafana loki later... so just stdout JSON format... yeah JSON

| Time (s) | Output |
|----------|--------|
| 2.076811631 | Implement logging using Pino to stdout in JSON format.- Use `Pino` for logging.- Output logs to `stdout`.- Format logs as `JSON`. |
#### coder_09_cloud_storage
**Input:** setup file upload... use s3... wait google cloud storage... actually azure blob... no s3 is standard... use s3... but use a minio instance locally... wait no localstack... actually just mock it in code for now scratch the local instance... yeah just mock it

| Time (s) | Output |
|----------|--------|
| 11.371095276 | Implement S3 file upload with an in-code mocked client.- Implement file upload functionality.- Utilize `S3` for storage.- Mock the `S3` client directly in code for testing. |
### GENERAL MODE
#### gen_03_meetup_time
**Input:** meet at the pub at 6... wait traffic is bad... make it 6:30... actually i have that call... push to 7... yeah 7 works... wait if we do 7 the kitchen closes... okay 6:45... meet at 6:45 sharp... basically

| Time (s) | Output |
|----------|--------|
| 4.088201885 | Meet at the pub at 6:45 sharp. |
#### gen_06_gift_brainstorm
**Input:** need a gift for mom... maybe a scarf... wait she has too many... a kindle... actually she likes paper books... get her that new thriller... wait the cooking one... actually the gardening book... yeah the gardening one... and maybe some seeds... wait no just the book... keep it simple

| Time (s) | Output |
|----------|--------|
| 2.902794009 | A gardening book. |
#### gen_01_movie_indecision
**Input:** wanna watch a movie? thinking dune... wait no it is like three hours... maybe barbie... actually seen it... ummm oppenheimer? nah too heavy for a tuesday... how about the bear? wait that is a show... actually yeah let's binge the bear... start season 2? you know?

| Time (s) | Output |
|----------|--------|
| 2.988292494 | Wanna binge The Bear? Let's start with season 2. |
#### gen_10_cleaning_duty
**Input:** gonna clean the kitchen... and the bathroom... wait bathroom is fine... just kitchen... and vacuum the lounge... actually vacuum the whole downstairs... wait no just the rug... the rest is clean... so kitchen and rug... yeah that's enough

| Time (s) | Output |
|----------|--------|
| 2.711605580 | Gonna clean the kitchen and vacuum the rug. |
#### gen_04_grocery_run
**Input:** can you grab milk... oat milk... wait no almond... actually soy is better for coffee... and get eggs... wait we have eggs... get bread though... sourdough... if they don't have it get rye... wait no just sourdough or nothing... literally nothing else

| Time (s) | Output |
|----------|--------|
| 2.478206242 | Can you grab soy milk for coffee and sourdough bread? If they don't have sourdough, just get nothing else. |
#### gen_07_gym_day
**Input:** hitting the gym monday... wait monday is chest day it's packed... tuesday... actually i have a meeting tuesday night... wednesday morning... yeah wednesday morning... 6am... wait 7am... 6 is too early... 7am wednesday... definitely

| Time (s) | Output |
|----------|--------|
| 2.351288228 | Hitting the gym 7am Wednesday. Definitely. |
#### gen_08_gamer_setup
**Input:** building a pc... ryzen 7... wait intel is cheaper right now... actually ryzen is better for multitasking... stick with ryzen... and a 4070... wait 4060 ti is enough... actually no 4070... future proof... and 32gb ram... wait 16 is fine... no 32... ram is cheap... might as well

| Time (s) | Output |
|----------|--------|
| 3.277879121 | Building a PC: Ryzen, a 4070 (for future proofing), and 32GB RAM since it's cheap enough. |
#### gen_05_weekend_trip
**Input:** thinking of going to brighton this weekend... wait forecast says rain... maybe bath? actually too far... how about london... wait too expensive... um maybe just a hike locally... yeah let's do the ridge walk... bring the dog... wait no dog is limping... leave the dog... sad times

| Time (s) | Output |
|----------|--------|
| 2.879019659 | Let's do the ridge walk locally this weekend. Can't bring the dog though, it's limping. Sad times. |
#### gen_02_dinner_plans
**Input:** ordering food... pizza... wait dave is on a diet... sushi then... actually i don't trust the fish today... maybe just burgers... wait no carbs... uh thai salad? yeah let's do thai... get the green curry... wait no red curry... and extra rice... wait no rice for dave... poor dave

| Time (s) | Output |
|----------|--------|
| 4.912587875 | Let's get Thai. Red curry and extra rice. Poor Dave, no rice for him. |
#### gen_09_coffee_run
**Input:** large latte... wait flat white... oat milk... wait no dairy is fine today... actually skim... and vanilla syrup... wait no hazelnut... actually caramel... no scrap the syrup just a plain skim flat white... extra hot... like really hot

| Time (s) | Output |
|----------|--------|
| 3.364579959 | Large skim flat white, extra hot. |
### BUSINESS MODE
#### biz_05_ooo_reply
**Input:** I am OOO until Monday... wait Tuesday... checking emails sporadically... actually no I have no access... contact Sarah for emergencies... wait Sarah is off too... contact Mike... wait Mike is junior... actually just 'I will reply when I return'... safer

| Time (s) | Output |
|----------|--------|
| 3.108186443 | I will reply when I return. |
#### biz_10_quarterly_goals
**Input:** Goal: Increase revenue 10%... wait 20%... actually focus on retention... reduce churn by 5%... wait 2% is realistic... actually 5% stretch goal... yeah aim for 5% churn reduction... and ignore new leads for now... wait don't say ignore... say 'deprioritize new leads'... nicer phrasing

| Time (s) | Output |
|----------|--------|
| 5.205147065 | The goal is to focus on retention, aiming for a 5% reduction in churn, and to deprioritise new leads. |
#### biz_02_slack_status
**Input:** set status to in a meeting... wait out sick... actually deep work... urgent only... wait no that sounds rude... just 'Focus Time'... with the headphones emoji... wait no the laptop emoji... yeah laptop

| Time (s) | Output |
|----------|--------|
| 2.659837162 | Focus Time 💻 |
#### biz_06_agenda_change
**Input:** Agenda for tomorrow: Review budget... wait skip budget finance isn't ready... discuss hiring pipeline... actually focus entirely on the roadmap blockers... yeah just roadmap blockers... and maybe a quick round table... wait no round table we run over... just roadmap... keep it focused

| Time (s) | Output |
|----------|--------|
| 3.306080819 | Agenda for tomorrow: Focus entirely on roadmap blockers. |
#### biz_09_strategy_pivot
**Input:** We are pivoting to B2B... wait B2C is still growing... actually focus on B2B2C... wait that is jargon... let's say 'Partnership-led growth'... yeah focus on partnerships... and drop direct sales... wait keep direct sales for enterprise... so partnerships and enterprise direct... sound strategy

| Time (s) | Output |
|----------|--------|
| 8.348543733 | The strategy focuses on partnership-led growth and direct sales for enterprise clients. |
#### biz_03_linkedin_announce
**Input:** Excited to announce I'm joining... wait humbled to share... actually just 'I'm starting a new position'... as VP of Eng... wait no Director of Eng... at TechCorp... wait no stealth startup... just say 'at a new AI startup'... keep it mysterious... you know?

| Time (s) | Output |
|----------|--------|
| 3.876206253 | I am delighted to share that I am commencing a new role as Director of Engineering at an innovative AI startup. |
