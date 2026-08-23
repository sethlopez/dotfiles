# Spec Template

Use this structure for all spec output. Omit sections that don't apply to the change type.

**Note:** This produces a draft. Use `[TODO: ...]` placeholders for sections needing human expansion. The user will edit the file to finalize.

---

```markdown
# <Title>

**Date:** YYYY-MM-DD  
**Type:** <New Feature | Modification | Refactor | Migration | Deprecation | Bug Fix | Integration>  
**Status:** Draft — Needs Review

## Summary

<2-4 sentences describing the change and its purpose.>

## Context

<Why this change is needed. What problem it solves or opportunity it addresses.>

## Current State

<For modifications, refactors, migrations, deprecations, bug fixes: describe what exists today. Omit for new features.>

## Proposed Change

<What will be built or changed. Be specific about scope.>

## Interactions

<Systems, modules, data, or APIs this change touches. How it integrates with existing functionality.>

## Acceptance Criteria

<Bulleted list of conditions that define "done." Include key scenarios and edge cases.>

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Open Questions

<Unresolved technical unknowns or decisions that need further investigation.>

- Question 1
- Question 2

## Related ADRs

<Links or references to existing ADRs that apply to this change.>

- [ADR-NNN: Title](../adr/NNN-title.md) — <brief note on relevance>

## Potential ADRs

<Significant decisions surfaced during this spec that may warrant their own ADR.>

- <Decision topic> — <why it may need an ADR>

## Out of Scope

<Explicitly list what this change does NOT include, to prevent scope creep.>

## Notes

<Any additional context, constraints, or considerations.>
```

---

## Section Guidance

- **Summary**: Lead with the what. Keep it scannable.
- **Acceptance Criteria**: Checkboxes allow tracking during implementation.
- **Open Questions**: Flag unknowns explicitly rather than burying them.
- **Out of Scope**: Prevents misunderstandings about boundaries.
- **Related ADRs / Potential ADRs**: Maintains connection to architectural decisions without duplicating them.

Omit empty sections rather than writing "N/A" or "None."
