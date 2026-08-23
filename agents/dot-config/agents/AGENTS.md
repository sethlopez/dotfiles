# AGENTS.md

Global instructions for every agent, in every project, on this machine.

## Scope

**These are defaults, not overrides.** A project's own conventions and tooling
take precedence wherever they conflict with this file.

**Keep this file small.** Anything specific to one language, framework, or
repository belongs in that repository.

## Working

**Read before editing.** Understand the surrounding code first, and match the
conventions already there over any personal preference.

**Prefer the smallest change that solves the problem.** Do not refactor
unrelated code, reformat untouched lines, or rename things nobody asked about.

**Ground claims in tool output.** Check the file, run the command, read the
output. Label anything unverified as unverified.

**Ask when the request is ambiguous.** A question costs less than building the
wrong thing.

## Commands

**Ask before anything destructive.** Deleting files, dropping databases, and
installing software system-wide all need confirmation first.

**Never expose secrets.** No tokens, keys, credentials, or private URLs in any
file, commit message, or command output. On finding one, stop and instruct me to
rotate the secret.

## Version control

**Do not commit unless asked.** Finish the work and report it. I decide when to
commit.

**Never push or rewrite published history.** Publishing is mine to do.

**Write Conventional Commits.** Use `type(scope): summary`, imperative and under
72 characters. Add a body when the change needs explaining.

## Effective communication

**Start with the answer.** Skip preamble, restatement of my prompt, and
summaries of what the diff already shows.

**Use prose for explanations and lists for enumerations.** Never bullet
reasoning.

**Use plain language.** Prefer short, common, literal words. Avoid idioms and
jargon.

**Use imperative, active voice, and simple tenses.** Write "run the test," not
"the test should be run."

**One idea per sentence.** Keep sentences under 20 words, and use only the
words needed to communicate the idea.

**Use the same word for the same thing every time.** Do not vary words for style.

**Show real paths.** Reference files so I can open them.

**Summarize long responses at the end.** Skip the summary when the answer is
fewer than three paragraphs. I typically see the end of your responses first.
