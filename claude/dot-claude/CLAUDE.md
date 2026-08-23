# CLAUDE.md

@~/.config/agents/AGENTS.md

## Claude Code

Rules below are Claude Code specific and layer on top of the global instructions
imported above.

### Tools

**Prefer the specialized tool over Bash.** Use Read instead of `cat`, Edit
instead of `sed -i`, Glob instead of `find`, and Grep instead of `grep`. Bash is
for running programs, not for inspecting or editing files.

**Batch independent calls.** When several tool calls have no dependency on each
other, issue them in one block rather than one at a time.

**Delegate wide searches to the Task tool.** Open-ended exploration that would
otherwise consume many rounds of Glob and Grep belongs in a subagent, so the
findings come back without the search noise.

### Plan mode

**Use plan mode for anything touching more than a couple of files.** Present the
approach and wait for approval before editing.
