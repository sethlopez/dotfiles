# Pull Request Template

Use this structure when the repository carries no template of its own. A project
template always wins, including one that contradicts this file.

---

```markdown
## Summary

<One to three sentences: what this changes and why it is needed. Written for
someone who has not read the issue.>

## Details

### Visible to users

<What a user notices, one bullet each. Describe the behavior, not the files.>

### Not visible to users

<Refactors, dependency bumps, schema and tooling changes, one bullet each.>

## Screenshots

<One image per change a user sees, with a line naming what to look at. Show
before and after when the change alters something that already exists.>

## Testing

<Numbered steps a reviewer follows to check this change. Leave out anything CI
already runs.>

1. <An instruction. One action, in a full sentence.>
2. <A verification. "Verify X says Y.">
3. <One item per step, in the order the reviewer takes them.>

### macOS

<A numbered list of its own, for a platform whose steps differ.>

## Notes for reviewers

<Optional. Where to start, decisions worth challenging, follow-up work left out
on purpose, anything temporary.>

Closes #NNN
```

---

## Section guidance

- **Summary**: open with the change itself. Do not repeat the PR title.
- **Details**: describe behavior, not files. "Login retries three times before
  failing" over "modified `auth.ts`". A user-visible bullet says what a person
  sees. A bullet in the other subsection says what changed underneath, and why
  it changes nothing a user sees.
- **Screenshots**: show every change a user sees. Caption each image with what
  to look at. A short recording suits a change that only shows in motion. Omit
  the section when nothing visible changed.
- **Testing**: write it for the reviewer, not as a record of what you ran. CI
  reports its own results, so list only steps CI cannot cover. Omit the section
  when CI covers everything.
- **Testing steps**: give each item one step, and write it as a full sentence.
  Each item is an instruction or a verification. An instruction tells the
  reviewer to take one action. A verification tells the reviewer what to
  confirm, and starts with "Verify".

  1. Open Settings and select Account.
  2. Verify the Account page shows a Sessions row.
  3. Select Sessions.
  4. Verify the list shows one row per signed-in device.
- **Platform sections**: give one numbered list for the common path. Add a
  heading per platform only where the steps differ, and repeat nothing that the
  common list already covers.
- **Closing keyword**: `Closes #NNN` on its own line at the end. Use
  `owner/repo#NNN` across repositories, and drop the line when no issue exists.
- **Tracker ID**: it belongs in the title. Add a full link in the last line of
  Summary when the repository has no integration turning the ID into one.

## Rules

- **Omit an empty section.** Delete the heading. Never write "N/A" or "none".
- **Never restate the diff.** The files changed tab shows it better.
- **Write in Simplified Technical English.** One idea per sentence, 20 words or
  fewer, active voice, plain words. "Retries the request" over "the request
  will be retried".
- **No secrets, internal hostnames, or private URLs.** A PR body is as public as
  the repository.

## Size

A description longer than the diff is a signal to split the PR. Aim for what a
reviewer reads in under a minute.
