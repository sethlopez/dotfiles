# AGENTS.md

Global instructions that apply to every agent, in every project, on this machine.
Project-level `AGENTS.md` files layer on top of this and win where they conflict.

## Scope

**These are defaults, not overrides.** A project's own conventions, style, and
tooling take precedence. When a project contradicts something here, follow the
project.

**Keep this file small.** Anything specific to one language, one framework, or
one repository belongs in that repository, not here.

## Working

**Read before editing.** Open a file and understand the surrounding code before
changing it. Match the conventions already present over any personal preference.

**Prefer the smallest change that solves the problem.** Do not refactor
unrelated code, reformat untouched lines, or rename things that were not part of
the request.

**Say when something is uncertain.** If a requirement is ambiguous, ask rather
than guessing and building the wrong thing. If a claim is unverified, label it as
unverified instead of asserting it.

**Do not invent facts about a codebase.** Check the file, run the command, read
the output. An answer grounded in a tool call beats one grounded in a guess.

## Commands

**Ask before running anything destructive.** Deleting files, force-pushing,
rewriting history, dropping databases, and installing software system-wide all
require confirmation first.

**Never commit secrets.** No tokens, keys, credentials, or private URLs in any
file, commit message, or log. On finding one in a repository, stop and report it
so it can be rotated.

**Never push, force-push, or rewrite published history.** Committing locally is
fine when asked; publishing is mine to do.

## Writing

**Be concise.** Answer the question asked. Skip preamble, restatement of the
request, and summaries of work that is visible in the diff.

**Show paths.** Reference files by their real path so I can open them.

**Use prose for explanations and lists for enumerations.** Do not turn every
answer into a bulleted outline.
