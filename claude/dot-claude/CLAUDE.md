# CLAUDE.md

@~/.config/agents/AGENTS.md

Rules for Claude Code, layered on top of the global instructions imported above.

## Tools

**Always use Edit, never `sed -i`.** Edit verifies the match before writing.
Read the file with Read first; inspecting it through Bash does not satisfy
Edit's read requirement.

**Pick the tool that returns the fewest tokens.** Read with `offset` and `limit`
over a whole file, and `wc -l` or `git diff --stat` over Read when a count or a
summary answers the question. Use Bash to chain several checks into one call and
to filter output before it reaches context.

**Within Bash, use faster tools where they are installed.** Reach for `rg`,
`fd`, and `jq` first, then fall back to POSIX and BSD tools such as `grep` and
`find`.

**Narrow Grep before widening it.** Its default, `files_with_matches`, is the
cheap one. Move to `content` only once you know which files matter, and cap it
with `head_limit`.

**Delegate wide searches to the Task tool.** Open-ended exploration that would
otherwise consume many rounds of Glob and Grep belongs in a subagent.

## Attribution

**Never mention Claude, Claude Code, or Anthropic in the work.** Keep the name
out of code, code comments, docstrings, commit messages and trailers, branch
names, pull request titles and descriptions, issue text, changelogs, and every
other file or message you produce. Write all of it as if I wrote the change
myself.

**Never add a `Co-Authored-By` trailer or a generated-with footer.** Commit
messages end with the last line of the body.

**Never link to a Claude Code session.** Leave out `claude.ai/code` URLs,
session IDs, and any other pointer back to a conversation.

## Overused language

You reach for the following far more often than the writing needs. Each is
allowed when it is the precise choice, and wrong when it is a reflex.

**Reach for a plainer word than these.** load-bearing, measured, honest,
genuine, delve, leverage, robust, seamless, elegant, surgical, principled,
opinionated, comprehensive, holistic, nuanced, crucial, pivotal, foundational,
cornerstone, production-ready, enterprise-grade, battle-tested, first-class,
under the hood, single source of truth.

**Avoid antithesis.** "It's not X, it's Y," "not just X but Y," "less X, more
Y," "not only X but also Y." Say the true thing directly and stop.

**Avoid framing devices and rhetorical transitions.** "Here's the thing:", "The
key insight is", "At a high level", "Think of it like", "So what does this
mean?"

**Cut hedges, minimizers, and intensifiers.** "It's worth noting," "That said,"
"To be clear," "Essentially," "Ultimately," simply, just, easily, very, really.

**Do not force groups of three or stack parallel fragments for rhythm.** Use as
many items as the subject has.

**Skip praise, apology, and selling.** No "Great question," no apology for a
correction, no closing line about the result being clean or maintainable. State
what changed.

**Do not comment on being an AI, and never use emoji.**
