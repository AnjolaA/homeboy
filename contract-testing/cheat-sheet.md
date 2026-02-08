# Contract Testing Cheat Sheet (One-Pager)

## What Is It?

Contract testing verifies that two services (Consumer and Provider) can communicate correctly by testing each side independently against a shared agreement (the contract).

## The Core Analogy

```
  YOU order a burger       -->  MENU says what's available  -->  KITCHEN makes the burger
  (Consumer)                    (Contract)                       (Provider)

  Contract testing checks: Does the menu match what you expect AND what the kitchen delivers?
```

## Key Terms

| Term            | Definition                                               |
|-----------------|----------------------------------------------------------|
| **Consumer**    | Service that sends requests (the one who asks)           |
| **Provider**    | Service that returns responses (the one who answers)     |
| **Contract**    | Shared agreement: "If you send X, I respond with Y"     |
| **Pact**        | Popular contract testing framework + the file it creates |
| **Pact Broker** | Central server that stores and manages all contracts     |
| **Can-I-Deploy**| CLI tool that checks if a release is safe                |
| **Verification**| Provider proving it satisfies the consumer's contract    |

## How It Works (3 Steps)

```
  1. CONSUMER writes test    -->  Generates pact file (JSON contract)
  2. PACT FILE is published  -->  To the Pact Broker
  3. PROVIDER verifies       -->  Replays pact against real code: PASS or FAIL
```

## Use It When

- Multiple services / microservices architecture
- Different teams own different services
- Services deploy independently
- You want fast feedback (seconds, not minutes)
- You need "can I deploy safely?" answered definitively

## Don't Use It When

- Monolith (no service boundaries)
- Testing business logic (use unit tests)
- Testing full user journeys (use E2E tests)
- Both sides always deploy together
- Third-party APIs you can't ask to verify

## Contract Tests vs Others

| Test Type      | Speed   | Needs Other Service? | Tests What?                |
|----------------|---------|----------------------|----------------------------|
| Unit           | Fastest | No                   | Single function logic      |
| **Contract**   | **Fast**| **No**               | **API shape & structure**  |
| Integration    | Slow    | Yes                  | Two+ services together     |
| End-to-End     | Slowest | Yes (all)            | Full user journey          |

## Quick-Start Commands (JavaScript/Node.js Example)

```bash
# Install Pact
npm install --save-dev @pact-foundation/pact

# Run consumer tests (generates pact file)
npx jest --testPathPattern=consumer.pact.spec.js

# Publish pact to broker
npx pact-broker publish ./pacts \
  --consumer-app-version=$(git rev-parse HEAD) \
  --broker-base-url=https://your-broker.pactflow.io \
  --broker-token=YOUR_TOKEN

# Verify provider against pacts
npx jest --testPathPattern=provider.pact.spec.js

# Can I deploy?
npx pact-broker can-i-deploy \
  --pacticipant=MyService \
  --version=$(git rev-parse HEAD) \
  --to-environment=production
```

## Resources

- Pact Docs: https://docs.pact.io
- PactFlow (Managed Broker): https://pactflow.io
- Pact Best Practices: https://docs.pact.io/best_practices

---

*"Contract testing doesn't test that the kitchen cooks well. It tests that when you order a burger, you don't get a salad."*
