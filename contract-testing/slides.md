# Contract Testing: A Promise Between Friends

### A Talk for Humans (Technical and Otherwise)

**Lead DevOps Engineer Presentation**

---

## Slide 1: Before We Start -- A Story

> Imagine you and your best friend have a deal:
>
> Every Friday, you bring **chocolate cookies** to school,
> and your friend brings **cold milk**.
>
> One Friday, you show up with **raisin cookies** instead.
> Your friend is confused. The deal is broken. Lunch is ruined.

**Contract testing makes sure both sides keep their promises.**

---

## Slide 2: What is a "Service" in Software?

In modern software, applications are built from many small pieces that talk to each other.

```
  [Mobile App]  ---requests--->  [Orders Service]
  [Website]     ---requests--->  [User Service]
  [Orders]      ---requests--->  [Payments Service]
```

**Think of it like a restaurant:**

| Role             | Software Term |
|------------------|---------------|
| You (the customer) ordering food | **Consumer** |
| The kitchen making your food     | **Provider** |
| The menu (what you can order)    | **Contract / API** |

Each piece needs to **trust** that the other piece will behave as expected.

---

## Slide 3: What Exactly is Contract Testing?

Contract testing verifies that two services (a **Consumer** and a **Provider**)
can talk to each other correctly -- by testing against a shared **agreement** (the contract).

### The Pizza Analogy

```
  YOU (Consumer)                    PIZZA SHOP (Provider)
  ----------------                  ---------------------
  "I expect to order                "We promise to accept
   a pizza with:                     orders that include:
   - size                            - size
   - toppings                        - toppings
   - delivery address"               - delivery address

   and get back:                     and we will return:
   - order ID                        - order ID
   - estimated time                  - estimated time
   - total price"                    - total price
```

**The contract is the shared understanding between both sides.**

---

## Slide 4: The Key Players

### Consumer (The one who ASKS)

- The service that **sends a request** and expects a specific response
- Example: A mobile app asking "Give me the user's profile"
- Analogy: **You ordering food at a restaurant**

### Provider (The one who ANSWERS)

- The service that **receives a request** and sends back a response
- Example: The User Service returning name, email, avatar
- Analogy: **The kitchen preparing and delivering your order**

### The Contract (The PROMISE)

- A formal description of: "If you send me THIS, I will respond with THAT"
- Analogy: **The menu -- it tells you what you can order and what you'll get**

---

## Slide 5: What is a Pact?

**Pact** is the most popular contract testing framework.

It formalizes the "promise" into a file called a **pact file** (JSON).

```
The Cookie Deal as a Pact:
--------------------------
Consumer: "Me"
Provider: "Best Friend"

Interaction #1:
  I will ask for:    "cookies"
  I expect to get:   "chocolate chip cookies"

  NOT raisin.
  NOT oatmeal.
  CHOCOLATE CHIP.
```

### In real software, a pact file looks like:

```json
{
  "consumer": { "name": "MobileApp" },
  "provider": { "name": "UserService" },
  "interactions": [
    {
      "description": "a request for user profile",
      "request": {
        "method": "GET",
        "path": "/users/42"
      },
      "response": {
        "status": 200,
        "body": {
          "id": 42,
          "name": "Jane Doe",
          "email": "jane@example.com"
        }
      }
    }
  ]
}
```

---

## Slide 6: How Does Contract Testing Work? (Step by Step)

```
 STEP 1                    STEP 2                     STEP 3
 Consumer Side             Share the Contract          Provider Side
 ─────────────             ──────────────────          ─────────────

 Mobile App says:          The Pact file is     --->   User Service
 "When I call              shared (via Pact           checks: "Can I
  GET /users/42,           Broker or file)             actually return
  I expect back                                        what the Mobile
  id, name, email"                                     App expects?"
       |                                                     |
       v                                                     v
  Generates a                                          Runs the pact
  PACT FILE                                            against its
  (the contract)                                       real code
       |                                                     |
       v                                                     v
  "Here's what                                         PASS: "Yes, I can!"
   I need from you"                                    FAIL: "Uh oh, I
                                                        changed something"
```

### In kid terms:

1. **You write down your cookie order** (consumer generates the pact)
2. **You give the order to your friend** (pact is shared)
3. **Your friend checks if they can make those cookies** (provider verifies)

---

## Slide 7: The Pact Broker -- The Middleman

### The Problem Without a Broker

Sharing pact files manually is like passing notes in class -- messy, easy to lose.

### Enter the Pact Broker

The **Pact Broker** is a central server that:

```
  [Consumer A] ---publishes pact--->  +--------------+
  [Consumer B] ---publishes pact--->  | PACT BROKER  |  <---verifies--- [Provider X]
  [Consumer C] ---publishes pact--->  |              |  <---verifies--- [Provider Y]
                                      | - Stores all |
                                      |   contracts  |
                                      | - Tracks     |
                                      |   versions   |
                                      | - Shows who  |
                                      |   depends on |
                                      |   whom       |
                                      +--------------+
```

**Analogy: The School Notice Board**

> Instead of passing notes between friends, everyone posts their
> cookie/milk promises on the school notice board.
> Everyone can see who promised what.
> If someone changes their promise, everyone knows immediately.

### Key Features of the Pact Broker:

| Feature                  | What It Does                                    |
|--------------------------|-------------------------------------------------|
| Contract storage         | Keeps all pact files in one place               |
| Version tracking         | Knows which version of a contract is active     |
| Dependency visualization | Shows a map of who talks to whom (network diagram) |
| Can-I-Deploy             | Answers: "Is it safe to release this version?"  |
| Webhooks                 | Notifies teams when contracts change            |

---

## Slide 8: "Can I Deploy?" -- The Safety Net

One of the most powerful features of the Pact Broker.

```
  Developer: "I changed the User Service. Can I deploy to production?"

  Pact Broker checks:
    - Mobile App expects fields: id, name, email      ... STILL THERE? YES
    - Website expects fields: id, name, avatar_url     ... STILL THERE? YES
    - Admin Panel expects fields: id, name, role       ... STILL THERE? YES

  Pact Broker says: "YES, you can deploy safely."
```

```
  Developer: "I removed the 'email' field. Can I deploy?"

  Pact Broker checks:
    - Mobile App expects: id, name, email              ... email MISSING!

  Pact Broker says: "NO! Mobile App will break!"
```

**Analogy:**

> Before changing the school lunch menu, the cafeteria checks:
> "Will any kid with allergies be affected?"
> If yes -- STOP. Fix it first.

---

## Slide 9: Contract Testing vs Other Testing

```
                        +---------------------------+
                        |     END-TO-END TESTS      |
                        |  (Whole system running)    |  Slow, expensive,
                        |  Like test-driving a car   |  fragile
                        +---------------------------+
                       /                             \
          +-----------------+               +-----------------+
          | INTEGRATION     |               | CONTRACT        |
          | TESTS           |               | TESTS           |  Fast, focused,
          | (Two real       |               | (Promise-based  |  reliable
          |  services       |               |  verification)  |
          |  talking)       |               |                 |
          +-----------------+               +-----------------+
                       \                             /
                        +---------------------------+
                        |       UNIT TESTS          |
                        |  (Single function)         |  Fastest, most
                        |  Like checking one LEGO    |  isolated
                        +---------------------------+
```

| Type             | Speed   | Confidence | Cost    | Needs All Services Running? |
|------------------|---------|------------|---------|------------------------------|
| Unit Tests       | Fast    | Low        | Low     | No                           |
| Contract Tests   | Fast    | Medium-High| Low     | No (each side tested alone)  |
| Integration Tests| Slow    | High       | Medium  | Yes (at least 2 services)    |
| End-to-End Tests | Slowest | Highest    | High    | Yes (everything)             |

**Contract tests give you high confidence at low cost.**

---

## Slide 10: When TO Use Contract Testing

### Use contract testing when:

**1. You have multiple services (microservices)**
> Many small apps talking to each other = many promises to keep

**2. Different teams own different services**
> Team A builds the Mobile App, Team B builds the User Service.
> They need a shared "promise" so they don't break each other.

**3. You want fast feedback**
> Contract tests run in seconds, not minutes.
> No need to spin up the entire system.

**4. You deploy services independently**
> Service A deploys Monday, Service B deploys Thursday.
> Contract tests ensure they'll still work together.

**5. You're tired of "works on my machine" surprises**
> Integration environments are flaky. Contract tests are not.

**6. You want to know: "Can I deploy safely?"**
> The Pact Broker's can-i-deploy tool answers this definitively.

---

## Slide 11: When NOT to Use Contract Testing

### Skip contract testing when:

**1. You have a monolith (one big application)**
> One app, no service boundaries = no contracts needed.
> Regular unit and integration tests are sufficient.

**2. You control both sides and they deploy together**
> If Consumer and Provider are always released as one package,
> integration tests cover this already.

**3. You need to test business logic**
> Contract tests verify SHAPE and STRUCTURE, not business rules.
> "Does the API return the right fields?" YES.
> "Does the discount calculation work correctly?" NO -- use unit tests.

**4. You need to test the full user journey**
> Contract tests don't replace end-to-end tests.
> "Can a user sign up, log in, and buy something?" -- use E2E tests.

**5. Third-party APIs you don't control**
> You can't ask Google to verify your pact.
> (Though you CAN use contract tests on your side to detect changes.)

**6. Your system has only 2 services with stable APIs**
> The overhead may not be worth it for very simple architectures.

---

## Slide 12: The Real-World Benefits

### Why Teams Love Contract Testing

```
  BEFORE Contract Testing          AFTER Contract Testing
  ─────────────────────────        ──────────────────────

  "We broke production              "We caught it in CI
   on Friday at 5 PM"               before it merged"

  "Nobody told us the API           "The pact broker showed
   changed"                          us the change immediately"

  "We need 4 hours to run           "Contract tests run in
   integration tests"                30 seconds"

  "Can we deploy?"                  "can-i-deploy says YES"
   "...maybe? Let's pray"

  "Which services depend            "Here's the dependency
   on us?"                           map from the broker"
```

### By the numbers (typical improvements):

| Metric                       | Before       | After          |
|------------------------------|-------------|----------------|
| Integration test suite time  | 30-60 min   | 30 sec (contracts) + focused integration |
| Broken deployments per month | 5-10        | 0-1            |
| Time to detect API breakage  | Hours/Days  | Minutes (in CI)|
| Confidence to deploy Friday  | Low         | High           |

---

## Slide 13: The Workflow in Your CI/CD Pipeline

```
  Developer pushes code
         |
         v
  +------------------+
  | 1. Unit Tests    |
  +------------------+
         |
         v
  +------------------+
  | 2. Contract Tests|-----> Publish pact to Broker
  +------------------+
         |
         v
  +------------------+
  | 3. can-i-deploy? |-----> Broker checks all consumers/providers
  +------------------+
         |
      PASS? ──YES──> Deploy to staging/production
         |
        NO
         |
      STOP. Fix the contract mismatch first.
```

**This fits naturally into any CI/CD pipeline (GitHub Actions, GitLab CI, Jenkins, etc.)**

---

## Slide 14: A 10-Year-Old's Summary

```
  CONTRACT TESTING explained to a kid:
  =====================================

  Imagine you're building a LEGO spaceship with your friend.

  You build the TOP half.
  Your friend builds the BOTTOM half.

  You BOTH agree: "The connection point will have
  8 studs across and 4 studs deep."

  CONTRACT TESTING is like checking:
    - YOUR half has the right connection points       (Consumer test)
    - YOUR FRIEND'S half has the right connection     (Provider test)

  BEFORE you try to snap them together.

  If either side doesn't match = you find out EARLY
  (not when the spaceship falls apart at show-and-tell!)
```

**The PACT BROKER is the shared LEGO instruction manual
that both of you can look at anytime.**

---

## Slide 15: Key Vocabulary Recap

| Term              | Plain English                        | Kid-Friendly Version                  |
|-------------------|--------------------------------------|---------------------------------------|
| **Consumer**      | The service making a request         | The person ordering food              |
| **Provider**      | The service fulfilling the request   | The kitchen making the food           |
| **Contract/Pact** | The agreed format of communication   | The menu / the deal with your friend  |
| **Pact Broker**   | Central place to store & manage pacts| The school notice board               |
| **Can-I-Deploy**  | Safety check before releasing        | "Will I break anyone's lunch?"        |
| **Interaction**   | One request-response pair in a pact  | One item on your order                |
| **Verification**  | Provider proving it can keep the deal| Friend showing they baked the cookies |
| **Consumer-Driven** | Consumer defines what it needs     | You get to pick what's on the menu    |

---

## Slide 16: Getting Started -- Practical First Steps

### 1. Pick your first pair of services
> Choose a Consumer and Provider that talk to each other frequently.

### 2. Install Pact for your language
> Pact supports: JavaScript, Java, Python, Go, Ruby, .NET, and more.

### 3. Write your first consumer test
> Define what your consumer expects from the provider.

### 4. Generate the pact file
> Run the consumer test -- it auto-generates the contract.

### 5. Set up a Pact Broker
> Use PactFlow (SaaS) or self-host the open-source Pact Broker.

### 6. Verify on the provider side
> The provider pulls the pact and runs it against its real API.

### 7. Add can-i-deploy to your CI pipeline
> Gate deployments on contract verification passing.

---

## Slide 17: Questions?

```
  +--------------------------------------------------+
  |                                                    |
  |   "A contract test doesn't test that the           |
  |    kitchen cooks well.                             |
  |                                                    |
  |    It tests that when you order a burger,          |
  |    you don't get a salad."                         |
  |                                                    |
  +--------------------------------------------------+
```

### Resources:
- Pact Documentation: https://docs.pact.io
- PactFlow (Managed Broker): https://pactflow.io
- Contract Testing Best Practices: https://pact.io/best-practices

### Thank you!

---
