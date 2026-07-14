# Security Policy

## Supported versions

Security fixes are applied to the latest release.

## What this project executes

Both Skills are Markdown and execute no code.

Local scripts:

- Copy a selected Skill into a Claude Code Skills directory.
- Validate local Skill files.
- Create ZIP archives.
- Optionally invoke the authenticated GitHub CLI to create or update a release.

No telemetry, analytics, package installation, hidden network request, credential collection, hook, or background process is included.

## Trust model

Claude Skills can influence model behavior. Review both files before installing a fork or third-party release:

- `skill/automatic/low-token-mode-auto/SKILL.md`
- `skill/zero-idle/low-token-mode-zero-idle/SKILL.md`

The Skills cannot override platform safety rules, system instructions, permissions, organization policy, or operating-system access controls.

The Zero-Idle guarantee applies to Claude Code's documented `disable-model-invocation: true` behavior. Claude web should keep the Skill toggled off while unused when zero availability is required.

## Reporting a vulnerability

Open a private GitHub security advisory for the repository when available. Do not include secrets, access tokens, private repository content, or personal information in a public issue.
