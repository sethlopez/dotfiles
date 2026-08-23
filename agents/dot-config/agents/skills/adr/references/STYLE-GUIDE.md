# Style Guide: Token-Efficient ADRs

ADRs should be concise but clear. Optimize for human readability and minimal token usage — future readers (human or agent) rely on these being quick to scan and unambiguous.

## Principles

1. **Concise, not cryptic** — reduce word count without sacrificing clarity.
2. **No gimmicks** — no arrows (`->`) replacing words, no unusual abbreviations.
3. **Standard abbreviations only** — things already common in the project (e.g. "ADR," "gRPC," "API," "URL," "ID") are fine; don't invent new ones.
4. **Past/present tense fits the section** — Context describes the situation as it was ("The test environment is..."); Decision states the choice directly ("Use mission-triggered loading"); Consequences describes what follows now.
5. **Factual, not persuasive** — an ADR records a decision, it doesn't need to sell it. Skip hedging and marketing language.

## Do

- Use bullet points for lists of consequences, alternatives, or constraints.
- Link to `docs/memory/` or other ADRs instead of repeating their content.
- Name things specifically: "the Kotlin backend," not "the service."
- Remove filler: "in order to" to "to"; "it is necessary to" to "must."
- State the decision in one clear sentence before elaborating.

## Don't

- Repeat information already in a linked ADR or memory file.
- Use hedging language: "might," "perhaps," "it seems like."
- Bury the actual decision in a wall of context — lead with it in the Decision section.
- Include information that belongs in `docs/memory/` (ongoing operational detail, host setup steps, config values that may change) — an ADR records the *decision*, not the living reference material. Link to memory files for that instead.

## Word Economy

| Verbose | Concise |
|---|---|
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

## Length Targets

Guidelines, not hard limits:

- **Context**: 1-2 short paragraphs, or a few bullets.
- **Decision**: 1 sentence stating the choice, plus a short bulleted list of specifics/alternatives if needed.
- **Consequences**: 3-6 bullets covering trade-offs, risks, and follow-up work.

If Context or Consequences grow much larger than this, consider whether the ADR is trying to cover more than one decision.
