---
name: spec
description: Interview-driven specification writing for features, changes, refactors, migrations, and other significant work. Produces dated, token-efficient specs that reference existing ADRs.
---

# Specification Writing

Guide the user through a structured interview to capture requirements for a significant change, then synthesize their answers into a **draft spec** that the user will refine.

## Principles

- **Starting point, not final draft**: The goal is to scaffold a spec the user will edit. Capture enough to flesh out the template; don't aim for exhaustive completeness.
- **Human-driven content**: The spec reflects the user's answers. Summarize and expand only when it improves clarity.
- **Human-finished document**: The user is responsible for editing the draft to add details, refine acceptance criteria, and ensure completeness.
- **Token-efficient output**: Concise but human-readable. No arrows replacing words, no unusual abbreviations.
- **Context-frugal process**: Minimize what you read into context. List filenames; read contents only when confirmed relevant.
- **ADR-aware**: Surface relevant architectural decisions without duplicating their purpose.

---

## Phase 1: Discovery

Before starting the interview:

1. **Locate spec directory**
   ```bash
   # Check common locations
   ls -d docs/specs docs/specifications specs 2>/dev/null | head -1
   ```
   If none exist, default to `docs/specs/` (create during output phase).

2. **Scan for ADRs (filenames only)**
   ```bash
   # List ADR filenames — do NOT read contents
   find . -type f -name "*.md" \( -path "*/adr/*" -o -path "*/decisions/*" -o -path "*/architecture/decisions/*" \) 2>/dev/null | head -30
   ```
   Store the list for reference during the interview. Infer topic from filename.

3. **Note project context**
   - Glance at top-level structure (`ls -la`) to understand the codebase
   - Do NOT read files unless directly relevant

---

## Phase 2: Classification

Ask the user to identify the change type:

> What type of change is this?
> 1. **New feature** — Greenfield functionality
> 2. **Feature modification** — Changing existing behavior
> 3. **Refactor** — Structural change, behavior preserved
> 4. **Migration** — Data, API, or dependency migration
> 5. **Deprecation** — Removing or replacing functionality
> 6. **Bug fix** — Complex bug requiring design
> 7. **Integration** — Third-party system connection
> 8. **Other** — Describe it

Store their answer to guide phase 3 questioning.

---

## Phase 3: Interview

Conduct a conversational interview. Ask one or two questions at a time; let the user elaborate naturally.

### Core Questions (all change types)

1. **The idea**: "What's the general idea? What problem does this solve or what capability does it add?"

2. **Interactions**: "How does this interact with the rest of the project? What existing systems, modules, or data does it touch?"

3. **Acceptance criteria**: "What would tell you this is done and working correctly? Any specific scenarios or edge cases?"

4. **Technical unknowns**: "Are there technical unknowns or areas where you're uncertain about the approach?"

5. **ADR conflicts**: Surface any ADRs whose filenames suggest relevance:
   > "I see these existing ADRs that might relate: [list names]. Do any of these apply? Should I read any of them?"
   
   - If user confirms relevance, read that specific ADR
   - Ask: "Does this change conflict with or extend any existing architectural decisions?"

### Type-Specific Questions

**Feature modification:**
- "What exists today? Describe the current behavior."
- "What specifically is changing? What stays the same?"

**Refactor:**
- "What's the current structure you're refactoring?"
- "What's the target structure?"
- "How will you verify behavior is preserved?"

**Migration:**
- "What's the source state? What's the target state?"
- "Is there a rollback plan if something goes wrong?"
- "Any data integrity concerns?"

**Deprecation:**
- "What's being removed or replaced?"
- "What's the migration path for existing consumers?"
- "What's the timeline?"

**Bug fix:**
- "What's the observed behavior vs expected behavior?"
- "What's your current hypothesis about the cause?"

**Integration:**
- "What external system are you integrating with?"
- "What's the API/protocol? Any authentication requirements?"
- "How should failures be handled?"

### Interview Conduct

- Ask follow-up questions when answers are vague
- Probe for edge cases the user may not have considered
- Keep questions conversational, not interrogative
- Summarize your understanding periodically to confirm accuracy

---

## Phase 4: Synthesis

After the interview is complete:

1. **Review answers** — Identify the key points from each response

2. **Summarize where beneficial** — If the user was verbose, distill to essentials. If terse, expand slightly for clarity.

3. **Mark incomplete areas** — Use placeholder text like `[TODO: expand]` or `[TODO: add criteria]` for sections that need human attention

4. **Identify gaps** — Note any areas that remained unclear as open questions

5. **Flag potential ADRs** — If a significant architectural decision emerged, note it as a candidate for a future ADR

6. **Apply style guidelines** — See [STYLE-GUIDE.md](references/STYLE-GUIDE.md)

---

## Phase 5: Output

Generate the spec file:

1. **Determine filename**
   - Format: `YYYY-MM-DD-<slug>.md`
   - Slug: lowercase, hyphenated, descriptive (e.g., `user-notification-preferences`)

2. **Confirm with user**
   > "I'll write this spec to `docs/specs/2026-07-02-user-notification-preferences.md`. Does that path and name work?"

3. **Write the file** using the template structure from [TEMPLATE.md](references/TEMPLATE.md)

4. **Create directory if needed**
   ```bash
   mkdir -p docs/specs
   ```

5. **Present summary** — After writing, show:
   - Brief summary of what was captured
   - Sections marked as needing expansion (`[TODO]` items)
   - Flagged open questions or potential ADRs
   - Remind user to review and edit the draft

---

## Reference Files

- [TEMPLATE.md](references/TEMPLATE.md) — Spec output structure
- [STYLE-GUIDE.md](references/STYLE-GUIDE.md) — Token-efficient writing guidelines
