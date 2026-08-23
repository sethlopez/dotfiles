# ADR Template

Every ADR uses this structure (Michael Nygard's format). Omit a section only if it's genuinely empty — don't write "N/A."

---

```markdown
# ADR NNNN: <Title>

## Status

<Accepted | Superseded by [ADR MMMM](MMMM-slug.md)>

## Context

<The problem, forces, or situation that made a decision necessary. Neutral,
factual tone — describe the situation, not the chosen solution.>

## Decision

<What was decided, stated plainly and concretely. This is the actual
architectural choice, not a discussion of options.>

## Consequences

<What follows from this decision: trade-offs, new constraints, follow-up
work, risks accepted. Both positive and negative outcomes belong here.>
```

---

## Section Guidance

- **Title**: short, specific, names the decision (e.g. "DCS-gRPC mission-side bootstrap," not "gRPC stuff").
- **Status**: exactly one of `Accepted` or `Superseded by [ADR MMMM](MMMM-slug.md)`. No `Proposed`/draft status — write the ADR once the decision is final.
- **Context**: describe the situation as it was *before* the decision, so the ADR still makes sense years later. Link to `docs/memory/` files or other ADRs for background instead of duplicating it.
- **Decision**: state it directly. If there were alternatives worth recording, list them here as a short sub-list (option, one-line reason rejected) rather than a separate section — keep the template's four headings fixed.
- **Consequences**: include the boring/negative consequences, not just the benefits. This is what future readers actually need — what changed, what became harder, what to revisit and when.

## Numbering

- Four digits, zero-padded, sequential: `0001`, `0002`, ... Never reuse or renumber.
- Filename: `NNNN-slug.md`, slug is lowercase and hyphenated (e.g. `0002-postgres-for-persistence.md`).

## Superseding an ADR

When a new ADR replaces an old decision:

1. The **old ADR's** Status line changes to `Superseded by [ADR MMMM](MMMM-slug.md)`. Nothing else in the old ADR is rewritten — it stays as a historical record of what was decided and why, at the time.
2. The **new ADR's** Context section references the old ADR and briefly says what changed (e.g. new constraint, new information, changed environment) to justify revisiting it.
3. If an index file (`docs/adr/README.md`) exists, update both entries.
