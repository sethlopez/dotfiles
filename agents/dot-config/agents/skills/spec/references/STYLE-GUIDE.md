# Style Guide: Token-Efficient Specs

Specs should be concise but clear. Optimize for human readability and minimal token usage.

## Principles

1. **Concise, not cryptic** — Reduce word count without sacrificing clarity
2. **No gimmicks** — No arrows (→) replacing words, no unusual abbreviations
3. **Standard abbreviations only** — API, URL, DB, ID, UI, etc. are fine
4. **Active voice** — "System sends notification" not "Notification is sent by system"
5. **Present tense** — Describe behavior as if it exists

## Do

- Use bullet points over paragraphs where structure helps
- Lead with the verb in acceptance criteria: "Displays error when..."
- Remove filler words: "In order to" → "To"; "It is necessary to" → "Must"
- One idea per bullet
- Use specific names: "UserService" not "the service"

## Don't

- Repeat information across sections
- Use hedging language: "might," "perhaps," "it seems like"
- Write acceptance criteria as vague goals: "Works well" → specify what "well" means
- Include implementation details unless they're constraints
- Pad with unnecessary context the reader already knows

## Examples

### Verbose (avoid)
> In order to ensure that users are able to receive timely updates about their order status, the system will need to implement a notification mechanism that sends push notifications to the user's mobile device whenever there is a change in the status of their order.

### Concise (prefer)
> System sends push notification to user's mobile device when order status changes.

### Vague criteria (avoid)
- [ ] Notifications work correctly
- [ ] Good performance

### Specific criteria (prefer)
- [ ] Push notification delivered within 5 seconds of status change
- [ ] Notification includes order ID and new status
- [ ] Users can disable notifications in settings

## Word Economy

| Verbose | Concise |
|---------|---------|
| in order to | to |
| due to the fact that | because |
| at this point in time | now |
| in the event that | if |
| has the ability to | can |
| a large number of | many |
| make a decision | decide |
| give consideration to | consider |
| is able to | can |
| whether or not | whether |

## Spec Length Targets

These are guidelines, not hard limits:

- **Summary**: 2-4 sentences
- **Context**: 1-3 sentences
- **Proposed Change**: 3-8 bullet points or 2-4 short paragraphs
- **Acceptance Criteria**: 3-10 items typical; more for complex changes
- **Open Questions**: 0-5 items

If a section grows much larger, consider whether the scope is too broad for a single spec.
