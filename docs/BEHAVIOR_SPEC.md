# Behavior Specification

## Objective

Provide two reusable Claude behavior profiles that minimize total consumption without pretending to control undocumented internal model operations.

## Editions

| Edition | Invocation | Idle Claude Code Skill context |
|---|---|---|
| Automatic | Natural-language semantic activation or direct slash command | Short description remains available while installed and enabled |
| Zero-Idle | Direct slash command only | Zero until invoked because `disable-model-invocation: true` removes it from context |

Installing both editions preserves the Automatic edition's metadata cost. Install only Zero-Idle when zero unused Skill context is the priority.

## State machine

| Current state | User intent | Result |
|---|---|---|
| Off, Automatic visible | Generic savings activation | Ask one localized Basic/Advanced question; perform no attached task yet |
| Off, Automatic visible | Explicit Basic activation | Enter Basic immediately |
| Off, Automatic visible | Explicit Advanced activation | Enter Advanced immediately |
| Off, Zero-Idle hidden | Ordinary natural-language request | No activation; the Skill is not visible |
| Off, Zero-Idle hidden | Direct invocation with Basic | Enter Basic immediately |
| Off, Zero-Idle hidden | Direct invocation with Advanced | Enter Advanced immediately |
| Any active mode | Explicit mode switch | Switch immediately |
| Any active mode | Disable/normal request | Exit mode; shortest localized confirmation allowed |
| Any active mode | Ordinary task | Apply the active mode |

Detection after loading is semantic rather than dependent on an English keyword list. The user's language can change during the chat; output follows the latest substantive user message.

## Basic mode contract

- Direct execution.
- No unsolicited planning or narration.
- Minimum indispensable tool calls.
- Syntax-only default verification when useful.
- Optional final status with up to three terse bullets after file changes.
- One compact answer for non-code tasks.
- Brief localized uncertainty instead of guessing.

## Advanced mode contract

- Direct file edits with no final summary.
- Absolute minimum indispensable tool calls.
- Code-only chat responses when code must be shown.
- Silent successful completion where the interface permits.
- One shortest truthful fragment if the interface requires text.
- No rationale unless required for truth, safety, or a direct user request.

## Tool-call policy

Tool calls are minimized as an explicit first-class objective.

Allowed only when needed to:

- Read external state not already available.
- Change external state requested by the user.
- Retrieve current or private information needed for accuracy.
- Verify a claim that cannot honestly be made otherwise.

Operational requirements:

- Use no tool when context is sufficient.
- Select the most direct tool and narrowest scope.
- Batch compatible actions when safe.
- Use exact paths and identifiers instead of discovery.
- Never repeat successful calls.
- Avoid broad scans, full logs, large diffs, subagents, background agents, and tool loops.
- Do not re-read successful writes unless ambiguous.
- Retry only after a specific failure and with a changed approach.
- Advanced mode allows only indispensable calls.

## Verification policy

Default allowed verification:

- At most one fast parser or syntax checker scoped to the edited file, and only when useful.

Default disallowed verification unless explicitly requested:

- Test suites.
- Builds.
- Linters.
- Type-checkers.
- Formatters.
- Security scanners.
- Benchmarks.
- Browser automation.
- Runtime service startup.
- Broad repository review.
- Repeated trial-and-error loops.

The Skills do not claim to disable hidden platform behavior. They control only the assistant's explicit choices and output.

## Language policy

All natural language follows the user's current chat language, including:

- Chat responses.
- Generated documentation.
- New code comments.
- New user-facing UI strings.
- New logs and error messages.
- Examples written for the user.

Exceptions preserve technical correctness:

- Programming syntax and keywords.
- External API names.
- Protocol literals.
- Existing public identifiers.
- Test fixtures whose exact text is required.
- Repository or localization conventions.
- A direct user instruction to use another language.

## Uncertainty policy

- Never fabricate certainty.
- Omit uncertainty irrelevant to the requested output.
- When a missing fact blocks the answer, use the shortest localized equivalent of "I don't know" or ask one blocking question.
- Do not claim successful execution without direct evidence.
