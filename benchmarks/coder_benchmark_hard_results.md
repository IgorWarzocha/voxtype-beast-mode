# Voxtype Coder Benchmark: HARD MODE
Date: Thu Jan  8 06:20:30 PM GMT 2026
Models: qwen3-4b-instruct-2507
Goal: Stress test intent tracking with ping-pong reversals and heavy noise.

## Model: qwen3-4b-instruct-2507
### level_1_pingpong
**Input:** um so I need a function that filters an array... uh by a property called isActive... wait no scratch that make it filter by the role being exactly admin... actually uh you know what isActive was better stick with that... and um make sure it returns the count not the array

| Run | Time (s) | Specification Output |
|-----|----------|----------------------|
| 1 | .924362822 | Develop a function that filters an array of objects by the `isActive` property and returns the count of matching items.  - Accept an array of objects as input.  - Filter the array to include only objects where the `isActive` property is true.  - Return an integer representing the count of filtered items.  - Ensure the function handles null or undefined inputs gracefully by returning 0. |

### level_2_conflict
**Input:** right so we need a store for the session... um use zustand... wait we need to persist to localstorage... actually uh if we are persisting maybe redux toolkit is better because of the middleware... yeah let's go with redux... oh and make it strict mode

| Run | Time (s) | Specification Output |
|-----|----------|----------------------|
| 1 | .743136142 | Implement a state management solution using Redux Toolkit with persistent storage via localStorage and enable strict mode.  - Utilize Redux Toolkit to manage application state with immutable updates.  - Integrate a middleware for automatic persistence of state to `localStorage`.  - Configure the store to operate in strict mode to enforce immutability and prevent unintended state mutations. |

### level_3_nested_logic
**Input:** api endpoint for users... um return id and name... if they are an admin include email... wait if they are an admin OR a manager include email... actually uh scratch the manager part just admins get email... but managers should get phone number... and everyone gets avatar

| Run | Time (s) | Specification Output |
|-----|----------|----------------------|
| 1 | .945052471 | Develop an API endpoint to return user ID, name, and avatar; include email only for administrators.  - Return user `id` and `name` for all users.  - Include a `avatar` field for every user.  - Add the `email` field exclusively for users with administrative roles.  - Exclude email from non-administrative users, including managers.  - Provide phone number for manager users instead of email. |

### level_4_reversal_chain
**Input:** setup a dockerfile... um use node 18 alpine... wait no node 20... actually uh 18 is safer for now... hang on... yeah 20 is fine let's use 20... and expose port 80... wait no 8080... and um install git... wait no we don't need git in production scratch that

| Run | Time (s) | Specification Output |
|-----|----------|----------------------|
| 1 | .925922307 | Set up a Dockerfile using Node.js 20 Alpine to build and run a production-ready application, exposing port 8080.- Use Node.js 20 Alpine as the base image.  - Install dependencies during the build process using npm.  - Expose port 8080 for the application to listen on.  - Keep the container minimal by excluding git and other non-essential tools. |
| 2 | .643813270 | Setup a Dockerfile using Node.js 20 Alpine to build and run a Node.js application.  - Use Node.js 20 runtime from the Alpine Linux base image.  - Expose port 8080 for the application.  - Include minimal dependencies required for runtime execution. |
| 3 | .918673633 | Set up a Dockerfile using Node.js 20 Alpine to build and run a production-ready application, exposing port 8080.- Use Node.js 20 runtime from the Alpine Linux base image.  - Install necessary dependencies during the build phase.  - Expose port 8080 for the application to listen on.  - Minimize the final image size by using multi-stage builds when applicable. |

### level_5_feature_creep
**Input:** build a login form... email and password... um add a remember me checkbox... wait actually remove the checkbox we are doing stateless... but add a 'forgot password' link... and um maybe social login? nah scratch social login just the link

| Run | Time (s) | Specification Output |
|-----|----------|----------------------|
| 1 | .790563255 | Build a login form with email and password fields, including a 'forgot password' link.  - Include an email input field for user authentication.  - Include a password input field with masking.  - Add a 'forgot password' link that directs to a password recovery page.  - Omit the 'remember me' checkbox due to stateless architecture requirements. |
| 2 | .772228758 | Build a login form with email and password fields, including a "forgot password" link.  - Include an email input field for user authentication.  - Include a password input field with masking.  - Add a "forgot password" hyperlink that directs to a dedicated recovery page.  - Omit the "remember me" checkbox due to stateless architecture requirements. |
| 3 | .774582515 | Build a login form with email and password fields, including a 'forgot password' link.  - Include an email input field for user authentication.  - Include a password input field with masking.  - Add a 'forgot password' hyperlink that redirects to a password recovery page.  - Omit the 'remember me' checkbox due to stateless architecture requirements. |

---
