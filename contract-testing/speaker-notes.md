# Speaker Notes: Contract Testing Talk

## Talk Overview

- **Audience:** Mixed technical (developers, QA) and non-technical (managers, product owners)
- **Duration:** ~30-40 minutes + Q&A
- **Tone:** Conversational, fun, accessible. Every concept has a kid-friendly analogy.
- **Goal:** Everyone walks out understanding WHAT contract testing is, WHY it matters, and WHEN to use it.

---

## Slide 1: Before We Start -- A Story

**Talking Points:**

- Open with the cookie story. It's silly and memorable. That's the point.
- Pause after telling it. Let the audience laugh or react.
- Then land the punchline: "Contract testing is about making sure both sides keep their promises."
- This sets the foundation for the entire talk. Every concept maps back to this.
- Ask the room: "Has anyone ever been surprised by an API change that broke something in production?" -- Watch hands go up.

**Transition:** "Let's look at why this happens in software..."

---

## Slide 2: What is a "Service" in Software?

**Talking Points:**

- For non-technical folks: "Modern apps aren't one big thing. They're lots of small things talking to each other. Like a restaurant -- you have the front desk, the kitchen, the delivery team. They're all separate, but they need to work together."
- For technical folks: "You already know this -- microservices, APIs, etc. The challenge is: how do we make sure they keep working together when teams move fast?"
- The restaurant analogy is the anchor. Keep coming back to it.
  - Consumer = customer ordering food
  - Provider = kitchen making it
  - Contract = the menu

**Transition:** "So if services are like a customer and a kitchen... what's the 'menu' that keeps them in sync?"

---

## Slide 3: What Exactly is Contract Testing?

**Talking Points:**

- Walk through the pizza analogy slowly. Both sides agree on the fields.
- Emphasize: "The contract isn't the WHOLE pizza. It's the SHAPE of the order and the SHAPE of the response. Not whether the pizza tastes good."
- This is a critical distinction: contract tests verify STRUCTURE, not BUSINESS LOGIC.
- For technical audience: "Think of it as testing the schema of the request and response, along with example values, without needing the other service to be running."

**Transition:** "Now let's name the key players..."

---

## Slide 4: The Key Players

**Talking Points:**

- Take time on this slide. These three terms are the vocabulary for the rest of the talk.
- **Consumer:** "The one with the need. They say 'I need THIS from you.'"
- **Provider:** "The one with the goods. They say 'I can give you THAT.'"
- **Contract:** "The written agreement. If either side breaks it, the tests will catch it."
- Point out that one service can be BOTH a consumer and a provider:
  - "The Orders Service consumes from User Service (to get user info) but provides to the Mobile App (to show order status). It's like being a customer at the grocery store AND a cook at home."

**Transition:** "So how do we formalize this promise in code? Enter Pact."

---

## Slide 5: What is a Pact?

**Talking Points:**

- Pact is the tool/framework. A pact (lowercase) is the contract file it generates.
- Show the "Cookie Deal" version first. Everyone gets it.
- Then show the real JSON. Walk through it:
  - "Here's the consumer -- our Mobile App"
  - "Here's the provider -- the User Service"
  - "Here's the interaction -- when I call GET /users/42, I expect back a 200 with these fields"
- Reassure non-technical people: "You don't need to write this JSON. The testing framework generates it automatically."
- For technical people: "The pact file is the artifact. Think of it like a snapshot test, but for API interactions."

**Transition:** "Let's see the full flow of how this works..."

---

## Slide 6: How Does Contract Testing Work?

**Talking Points:**

- Walk through the three steps slowly. This is the core mechanism.
- **Step 1 (Consumer side):** "The consumer team writes a test that says 'when I call this endpoint, I expect this back.' Running the test generates a pact file."
- **Step 2 (Share):** "The pact file is published to a central location -- we'll talk about the Pact Broker next."
- **Step 3 (Provider side):** "The provider pulls down the pact and replays those expectations against its REAL code. If it can fulfill every promise, the test passes."
- Key insight: "Neither side needs the other to be running. The consumer tests against a mock. The provider tests against the pact file. They're tested INDEPENDENTLY but verified TOGETHER."
- Kid version: "Write your cookie order, give it to your friend, friend checks if they can bake it."

**Transition:** "But how do we share the pact file between teams? Enter the Pact Broker."

---

## Slide 7: The Pact Broker

**Talking Points:**

- "Without a broker, you're emailing JSON files around. That's chaos."
- The school notice board analogy works great here. Everyone can see all promises.
- Walk through each feature in the table:
  - **Contract storage:** "One place. No more 'which Slack channel did we share it in?'"
  - **Version tracking:** "You can see the contract from last week vs. today."
  - **Dependency visualization:** "This is GOLD for architects. You get a live map of who depends on whom."
  - **Can-I-Deploy:** "We'll deep-dive this next. It's the killer feature."
  - **Webhooks:** "Provider team gets notified the moment a consumer publishes a new contract."
- Mention PactFlow as the managed SaaS option, and open-source Pact Broker for self-hosting.

**Transition:** "Let me show you the single most useful feature..."

---

## Slide 8: Can-I-Deploy

**Talking Points:**

- This is the "wow" moment for most people. Build it up.
- "Before you deploy, you ask one question: 'Will this break anyone?'"
- Walk through the green scenario: all checks pass, safe to deploy.
- Walk through the red scenario: email field removed, Mobile App would break. Deployment blocked.
- "This replaces the 'let's deploy and hope for the best' strategy."
- The cafeteria analogy: checking for allergies before changing the menu.
- For technical audience: "This is a CLI command: `pact-broker can-i-deploy --pacticipant UserService --version 1.2.3 --to production`. It returns a pass/fail."
- For managers: "This means fewer broken deployments, fewer late-night incidents, and more confident releases."

**Transition:** "How does this compare to testing approaches you already know?"

---

## Slide 9: Contract Testing vs Other Testing

**Talking Points:**

- This is the "where does it fit?" slide. Important for both audiences.
- Walk through the pyramid from bottom to top.
- Key message: "Contract tests sit between unit tests and integration tests. They're fast like unit tests but give you confidence about service interactions like integration tests."
- Point at the table:
  - "Contract tests are FAST -- seconds, not minutes."
  - "They DON'T need all services running -- each side tests independently."
  - "They're NOT a replacement for other tests. They're an addition."
- Common misconception to address: "Contract tests don't mean you stop doing integration or E2E tests. They mean you need FEWER of the slow, expensive ones because contracts catch most interface issues early."

**Transition:** "So when should you actually use this?"

---

## Slide 10: When TO Use Contract Testing

**Talking Points:**

- Go through each scenario. Ask the audience to raise hands if they relate.
- **Multiple services:** "If you have more than 3 services, contract testing pays for itself quickly."
- **Different teams:** "This is the #1 use case. Team autonomy requires shared contracts."
- **Fast feedback:** "30 seconds vs. 30 minutes. Which do you prefer?"
- **Independent deployments:** "If Service A and Service B deploy on different schedules, you NEED to know they're still compatible."
- **Tired of flaky environments:** "Raise your hand if your staging environment is unreliable." (Expect laughs)
- **Safe deploys:** "can-i-deploy answers the question every team asks before every release."

**Transition:** "But it's not always the right tool..."

---

## Slide 11: When NOT to Use Contract Testing

**Talking Points:**

- This is equally important. Shows maturity and honesty.
- **Monolith:** "If you have one big app, there are no service boundaries to test. Use integration tests."
- **Co-deployed services:** "If they always ship together, contract tests add overhead with little benefit."
- **Business logic:** "Contract tests check 'does the response have a price field?' not 'is the price calculated correctly?' Use unit tests for logic."
- **Full user journeys:** "Contract tests don't click buttons or fill forms. Use E2E tests for that."
- **Third-party APIs:** "You can use contracts one-sidedly, but you can't force Google to verify your pact."
- **Simple architecture:** "Two stable services? Probably not worth the setup cost."
- End with: "Use the right tool for the right job. Contract testing is powerful, but it's not everything."

**Transition:** "For those still on the fence, let me show you the real impact..."

---

## Slide 12: The Real-World Benefits

**Talking Points:**

- The before/after table is designed to provoke recognition. People will nod.
- Read a few of the "before" quotes dramatically. Pause. Then read the "after."
- The numbers row is powerful for managers:
  - "Integration test suite from 30 minutes to 30 seconds for contract coverage."
  - "Broken deployments from 5-10 per month to nearly zero."
  - "Friday deploys go from terrifying to routine."
- Share a personal anecdote if you have one: "We had an incident where a field name was changed from `userName` to `user_name`. It broke the mobile app in production. A contract test would have caught it before the PR was merged."
- For skeptics: "You don't have to do everything at once. Start with one consumer-provider pair. Prove the value. Then expand."

**Transition:** "Here's how it fits into your pipeline..."

---

## Slide 13: The Workflow in CI/CD

**Talking Points:**

- Walk through the pipeline diagram step by step.
- "Unit tests run first -- fast, foundational."
- "Contract tests run next -- publish pacts to the broker."
- "Before deployment, can-i-deploy checks the broker."
- "If all contracts are verified: green light. If not: stop and fix."
- This is where DevOps and developers intersect. Both care about this flow.
- "This adds maybe 30 seconds to your pipeline. In exchange, you stop shipping broken integrations."
- Mention that this works with GitHub Actions, GitLab CI, Jenkins, CircleCI -- anything.

**Transition:** "Let me summarize everything with one final analogy..."

---

## Slide 14: A 10-Year-Old's Summary

**Talking Points:**

- Read this slide out loud. It's the most memorable part of the talk.
- The LEGO spaceship analogy ties everything together:
  - Consumer test = checking YOUR half has the right studs
  - Provider test = checking YOUR FRIEND'S half has the right studs
  - You check BEFORE you try to snap them together
  - Pact Broker = the shared instruction manual
- "If the spaceship falls apart at show-and-tell, that's a production incident. Contract testing prevents that."
- Pause. Let it land.

**Transition:** "Let's do a quick vocabulary recap, then I'll take questions."

---

## Slide 15: Key Vocabulary Recap

**Talking Points:**

- Don't read the whole table. Skim it and point out your favorites.
- "If you remember nothing else: Consumer asks, Provider answers, Contract is the deal."
- This slide is also a reference for people to photograph or revisit later.

**Transition:** "For those eager to get started..."

---

## Slide 16: Getting Started

**Talking Points:**

- Practical, actionable steps. People want to know "what do I do Monday morning?"
- "Pick your most problematic integration. The one that breaks the most. Start there."
- "Pact has libraries for every major language."
- "You can use PactFlow.io for a managed broker, or self-host the open-source version."
- "Your first contract test can be written in an afternoon."
- Offer to help: "I'm happy to pair with anyone who wants to set up their first contract test."

**Transition:** "Any questions?"

---

## Slide 17: Questions

**Talking Points:**

- Read the closing quote. It's a perfect summary.
- Have these ready for common questions:

**Q: How is this different from mocking?**
A: Mocking is one-sided -- the consumer makes up what it thinks the provider returns. Contract testing VERIFIES that the mock matches reality. The provider proves it.

**Q: Does this replace integration tests?**
A: No. It reduces how many you need. Use contract tests for interface compatibility. Use integration tests for complex, stateful workflows.

**Q: What about GraphQL / gRPC / message queues?**
A: Pact supports all of these. It's not just REST. Message-based contract testing (for Kafka, RabbitMQ, etc.) is also supported.

**Q: How much effort is the initial setup?**
A: For one consumer-provider pair: a day or two. The ROI shows within the first week when you catch a breaking change in CI.

**Q: Who owns the contract?**
A: The consumer drives it (consumer-driven contract testing). The consumer says what it needs, and the provider verifies it can deliver. This encourages communication between teams.

---

## General Delivery Tips

1. **Energy:** Keep it conversational. Don't lecture. Ask questions. Get reactions.
2. **Pacing:** Spend more time on Slides 3-8 (the core concepts). Skim 15-16 if short on time.
3. **Audience read:** If technical folks are nodding, speed up. If non-technical folks look lost, add another analogy.
4. **Props (optional):** Bring actual LEGO bricks to demonstrate the spaceship analogy. Bring cookies for the opening story (instant engagement).
5. **Handout:** Distribute the cheat sheet (cheat-sheet.md) at the end so people have a reference.
