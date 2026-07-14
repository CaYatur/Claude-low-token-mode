# Research Notes

Research date: 2026-07-14

## Official Claude behavior relevant to this project

### Automatic versus zero-idle Claude Code Skills

By default, a Skill description is available in Claude's context so Claude can decide whether to invoke it. Adding `disable-model-invocation: true` prevents automatic invocation and removes that Skill from Claude's context until the user invokes it directly. Claude Code documentation describes this as zero context cost for manually triggered Skills.

Official references:

- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/features-overview

### Claude web behavior

Enabled Skills are applied automatically when Claude judges them relevant. Users can toggle Skills on and off under **Customize > Skills**. Anthropic's web documentation does not state that `disable-model-invocation: true` provides the same zero-context behavior on Claude web, so this project does not claim that guarantee for the web surface. Keeping the Skill disabled while unused is the documented reliable way to make it unavailable to Claude web.

Official reference:

- https://support.claude.com/en/articles/12512180-use-skills-in-claude

### Progressive disclosure

For ordinary automatically invocable Claude Code Skills, metadata is available before activation and the full `SKILL.md` loads when invoked or judged relevant. This is still substantially smaller than placing the entire behavior profile in an always-loaded global instruction file.

Official references:

- https://code.claude.com/docs/en/skills
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

### Claude Code installation and lifecycle

Claude Code discovers user Skills under `~/.claude/skills/` and project Skills under `.claude/skills/`. Direct slash invocation can pass arguments through `$ARGUMENTS`.

Official reference:

- https://code.claude.com/docs/en/skills

### Low effort and optional strict profile

Claude Code supports `--effort low` and persistent effort settings. The optional launcher applies low effort for the session and reduces optional background features where supported.

Official references:

- https://code.claude.com/docs/en/model-config
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/cli-reference
- https://code.claude.com/docs/en/costs

## Similar public projects reviewed

- `drona23/claude-token-efficient`: demonstrates that a persistent `CLAUDE.md` adds input overhead on every turn and warns against relying on old headline savings claims.
- `JuliusBrussee/caveman`: focuses mainly on terse output and persistent activation.
- `farhan523/claude-code-lean`: combines guides, Skills, hooks, and context-management techniques.

Useful lessons adopted:

- Separate automatic convenience from true unused-context savings.
- Minimize always-loaded instructions.
- Minimize tool calls as well as visible prose.
- Avoid unverifiable savings percentages.
- Separate output reduction from context reduction.
- Preserve code and technical literals instead of shortening or translating them destructively.
- Prefer explicit activation state over permanently forcing a terse style.

Differences in this project:

- Separate Automatic and Zero-Idle editions.
- Two distinct savings modes inside each edition.
- Mandatory localized level selection when no level is supplied.
- Any-language semantic activation after the Skill is visible or invoked.
- User-language output across chat and human-readable code content.
- Explicit minimum-tool-call policy with batching, narrow scope, and no repeated successful calls.
- Syntax-only default verification policy.
- Advanced mode forbids final summaries after successful file edits.
- Portable Claude web ZIPs plus Claude Code installers and release automation.
- No hooks, telemetry, dependencies, or background processes in either Skill.

## Claims intentionally avoided

The project does not claim that a prompt can:

- Disable undocumented internal model reasoning.
- Disable platform safety or permission checks.
- Guarantee no internal evaluation.
- Guarantee a fixed token-saving percentage.
- Guarantee equal code quality on complex tasks when verification is removed.
- Guarantee zero context cost on Claude web while a Skill is enabled.

These limitations matter because reduced verification can reduce reliability on difficult changes.
