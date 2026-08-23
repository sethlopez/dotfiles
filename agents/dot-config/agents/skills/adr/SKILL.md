---
name: adr
description: Write standardized Architecture Decision Records (ADRs) in Nygard format (Title, Status, Context, Decision, Consequences). Use when a significant architectural, framework, protocol, or structural decision needs to be recorded, or when superseding an existing ADR.
---

# Writing ADRs

Record architectural decisions in a single, standardized format so every ADR in the project reads the same way. This skill can draft an ADR either from context already established in conversation, or by interviewing the user for the missing pieces — use whichever the current situation calls for.

## Principles

- **One standard format**: every ADR uses the Nygard structure — Title, Status, Context, Decision, Consequences. See [TEMPLATE.md](references/TEMPLATE.md).
- **Two statuses only**: `Accepted` or `Superseded`. There is no `Proposed`/draft status — an ADR gets written once the decision is actually made. See [TEMPLATE.md](references/TEMPLATE.md) for how superseding works.
- **Adaptive input**: if the conversation already contains the context, decision, and reasoning, draft directly from it and confirm with the user before writing. If information is missing, ask targeted questions to fill the gaps. Don't run a full interview when it isn't needed.
- **Token-efficient output**: concise, human-readable prose. No arrows replacing words, no unusual abbreviations beyond ones already common in the project (see [STYLE-GUIDE.md](references/STYLE-GUIDE.md)).
- **Index-aware, not index-requiring**: if `docs/adr/README.md` (or similar index) exists, keep it up to date. Never create one — that's the user's call, not this skill's.

---

## Phase 1: Discovery

1. **Locate the ADR directory**
   ```bash
   ls -d docs/adr docs/decisions docs/architecture/decisions 2>/dev/null | head -1
   ```
   If none exists, ask the user where ADRs should live (don't assume `docs/adr/`).

2. **Find the next number**
   ```bash
   ls docs/adr | grep -E '^[0-9]+' | sort -n | tail -5
   ```
   ADRs are numbered sequentially, four digits, zero-padded: `0001`, `0002`, etc. The next number is the highest existing number plus one.

3. **Check for an index**
   ```bash
   ls docs/adr/README.md 2>/dev/null
   ```
   Note whether one exists. If it does, it must be updated in Phase 5. If not, don't create one.

4. **Check for a status to supersede**
   If this ADR replaces an earlier decision, identify which existing ADR it supersedes (ask the user if unclear, or infer from conversation).

---

## Phase 2: Gather Context

Assess what's already known from the conversation:

- **If the decision and reasoning were already discussed in this session**: summarize your understanding back to the user in a few sentences and confirm accuracy before drafting. Don't re-ask questions already answered in the conversation.
- **If context is missing or this is a cold start**: ask only for what's missing, from this list:
  1. **The problem**: "What problem or forces led to needing this decision?"
  2. **The decision**: "What was decided, concretely?"
  3. **Alternatives**: "What other options were considered, if any, and why weren't they chosen?" (optional — skip if there weren't real alternatives)
  4. **Consequences**: "What trade-offs, risks, or follow-up work does this decision create?"
  5. **Superseding**: "Does this replace an earlier ADR?"

Keep questions conversational and minimal — one or two at a time, not a form.

---

## Phase 3: Draft

1. Apply the structure in [TEMPLATE.md](references/TEMPLATE.md).
2. Apply the writing guidelines in [STYLE-GUIDE.md](references/STYLE-GUIDE.md).
3. Cross-reference related ADRs or memory files (`docs/memory/`) where relevant, using relative links.
4. If this ADR supersedes another, note that explicitly in this ADR's Status and Context.

---

## Phase 4: Confirm

Before writing, show the user:
- The proposed filename: `docs/adr/NNNN-slug.md` (slug: lowercase, hyphenated, descriptive)
- A brief summary of Status, Decision, and Consequences

Confirm the filename and content are correct before writing.

---

## Phase 5: Write and Update

1. **Write the new ADR** to `docs/adr/NNNN-slug.md`.
2. **If superseding an existing ADR**: edit that ADR's Status line to `Superseded by [ADR NNNN](NNNN-slug.md)`. Do not delete or rewrite its content otherwise — the historical record stays intact.
3. **If `docs/adr/README.md` exists**: add an entry for the new ADR (number, title, status) and update the superseded ADR's entry if applicable.
4. **Check `docs/memory/`** for topic files that reference the superseded decision or the area this ADR touches; update them in the same change if they'd otherwise go stale.

---

## Reference Files

- [TEMPLATE.md](references/TEMPLATE.md) — ADR structure and superseding mechanics
- [STYLE-GUIDE.md](references/STYLE-GUIDE.md) — token-efficient writing guidelines
