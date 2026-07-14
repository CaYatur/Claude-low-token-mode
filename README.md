# Claude Low Token Mode

Two separate English-language Claude Skills for reducing output, tool calls, verification overhead, and unnecessary context while always responding in the user's current language.

## Choose an edition

### Automatic edition

Skill name: `low-token-mode-auto`

- Detects savings requests semantically in any language.
- If the user says only "cheap mode," "low-token mode," or an equivalent phrase, asks one short localized question: Basic or Advanced savings?
- If the request already specifies Basic/Simple or Advanced/Aggressive, activates immediately.
- Its short description is available to Claude so automatic detection can work. This creates a small recurring context cost while the Skill is enabled.

Direct commands:

```text
/low-token-mode-auto basic
/low-token-mode-auto advanced
```

### Zero-Idle edition

Skill name: `low-token-mode-zero-idle`

- Uses `disable-model-invocation: true`.
- In Claude Code, its description is excluded from Claude's context until the user invokes it directly.
- Therefore, it adds zero Skill context cost while unused in Claude Code.
- It cannot activate from an ordinary natural-language phrase before invocation because Claude cannot see it.

Direct commands:

```text
/low-token-mode-zero-idle basic
/low-token-mode-zero-idle advanced
```

For actual zero idle Skill cost, install only the Zero-Idle edition. Installing both leaves the Automatic edition's small metadata cost active.

On Claude web, the documented reliable zero-idle method is to keep the Skill toggled off when unused, then enable it before use. Claude web automatically applies enabled relevant Skills; Anthropic does not document the same zero-context guarantee there for `disable-model-invocation` that Claude Code documents.

## Modes

### Basic Cheap Mode

- Produces the shortest complete answer that is still useful.
- For coding tasks, writes or returns code directly without a planning preamble.
- Runs no tests, builds, linting, type-checking, formatting, benchmarks, or broad verification unless explicitly requested.
- May perform only the fastest useful syntax or parse check.
- After a successful file edit, may send one short completion line and up to three very short change bullets.
- Does not guess. When a required answer is unknown, it says so briefly in the user's language.

### Advanced Cheap Mode

- Uses the same low-overhead execution rules as Basic mode with a stricter output contract.
- For file-writing coding tasks, performs the edit and sends no final summary, completion message, or change list.
- If code must be returned in chat, returns only the code or patch.
- For non-code tasks, returns only the shortest exact answer required.
- Speaks only when a blocking question, failure, uncertainty disclosure, permission request, safety rule, or platform-required final text makes silence impossible.

> "Advanced" means more aggressive savings, not deeper reasoning.

## Tool-call minimization

Both editions treat tool calls as expensive and minimize them independently of output length.

- No tool is used when current context is sufficient.
- Only the most direct tool and smallest relevant scope are allowed.
- Compatible reads, searches, edits, or commands are batched when safe.
- Repeated reads, broad repository scans, tool loops, subagents, background agents, and optional verification are avoided.
- A successful write is not re-read unless its result is ambiguous.
- Web research uses the fewest focused queries and authoritative sources necessary.
- Advanced mode permits only indispensable tool calls.

## Language behavior

The Skill files are entirely English, but Claude must produce all natural-language output in the user's latest conversation language. This includes chat, generated documentation, new comments, UI strings, logs, errors, and examples unless technical correctness or the user's explicit instruction requires another language.

Programming syntax, protocol literals, API names, public identifiers, exact test fixtures, and repository naming conventions are preserved.

## Important limitations

These Skills control Claude's explicit behavior. They cannot directly disable hidden model reasoning, platform safety behavior, mandatory permission checks, or every undocumented internal verification mechanism. They also cannot guarantee a fixed token-saving percentage.

Removing tests and broad verification can reduce reliability on complex changes. An explicit user request for a test or check temporarily permits exactly that requested verification.

## Repository layout

```text
claude-low-token-mode/
├── skill/
│   ├── automatic/
│   │   └── low-token-mode-auto/
│   │       └── SKILL.md
│   └── zero-idle/
│       └── low-token-mode-zero-idle/
│           └── SKILL.md
├── claude-code/
│   ├── install-user-auto.bat
│   ├── install-user-zero-idle.bat
│   ├── install-project-auto.bat
│   ├── install-project-zero-idle.bat
│   ├── start-low-cost.bat
│   └── profiles/
│       └── strict-low-cost.settings.json
├── scripts/
│   ├── package-skill.bat
│   ├── package-release.ps1
│   ├── release.bat
│   └── validate-skill.ps1
├── docs/
│   ├── BEHAVIOR_SPEC.md
│   └── RESEARCH.md
├── LICENSE
├── CHANGELOG.md
└── SECURITY.md
```

## Install on Claude web

1. Ensure **Code execution and file creation** is enabled.
2. Open **Customize > Skills**.
3. Click **+**, select **Create skill**, then **Upload a skill**.
4. Upload one of the release ZIP files:
   - `claude-low-token-mode-auto-skill-v1.0.0.zip`
   - `claude-low-token-mode-zero-idle-skill-v1.0.0.zip`
5. Enable the selected Skill.

For minimum recurring web overhead, upload the Zero-Idle edition but keep it disabled until needed. Once enabled, explicitly request the named Skill and desired level. Claude web may still use enabled Skill metadata; a zero-context guarantee is not documented for the web surface.

## Install on Claude Code

### User-wide Automatic edition

```bat
claude-code\install-user-auto.bat
```

Installs to:

```text
%USERPROFILE%\.claude\skills\low-token-mode-auto\SKILL.md
```

### User-wide Zero-Idle edition

```bat
claude-code\install-user-zero-idle.bat
```

Installs to:

```text
%USERPROFILE%\.claude\skills\low-token-mode-zero-idle\SKILL.md
```

### Project-only Automatic edition

```bat
claude-code\install-project-auto.bat "C:\path\to\your\project"
```

### Project-only Zero-Idle edition

```bat
claude-code\install-project-zero-idle.bat "C:\path\to\your\project"
```

Restart Claude Code if the top-level Skills directory was created during the current session.

## Optional strict Claude Code launcher

```bat
claude-code\start-low-cost.bat
```

It starts Claude Code for the current session with `--effort low` and the included session settings profile. The profile reduces optional background behavior where supported. It does not bypass permissions, safety controls, or organization policy.

## Build release ZIP files

```bat
package.bat 1.0.0
```

Outputs:

```text
dist\claude-low-token-mode-auto-skill-v1.0.0.zip
dist\claude-low-token-mode-zero-idle-skill-v1.0.0.zip
dist\claude-low-token-mode-source-v1.0.0.zip
```

## Create and upload a GitHub Release

Requirements:

- Git
- PowerShell 5.1 or newer
- GitHub CLI (`gh`)
- `gh auth login` completed
- The repository pushed to GitHub

Run:

```bat
release.bat 1.0.0
```

The script validates both Skills, builds all three ZIP files, detects the current GitHub repository, and creates or updates release `v1.0.0`.

## Security

Review Skills before installing them. These Skills contain Markdown instructions only. Packaging and installation scripts work locally; only the explicit release script invokes the authenticated GitHub CLI.

See [SECURITY.md](SECURITY.md).

## License

MIT. See [LICENSE](LICENSE).