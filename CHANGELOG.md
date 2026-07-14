# Changelog

All notable changes to this project are documented here.

## [1.0.0] - 2026-07-14

### Added

- Separate Automatic and Zero-Idle Skill editions.
- `disable-model-invocation: true` manual-only Claude Code edition with zero unused Skill context cost.
- Basic Cheap Mode and Advanced Cheap Mode.
- Semantic activation in any user language for the Automatic edition.
- Mandatory Basic/Advanced choice when a generic activation request omits the level.
- User-language output invariant for chat, documentation, comments, and generated user-facing code text.
- First-class minimum-tool-call policy in both modes and both editions.
- Tool batching, narrow-scope reads, no repeated successful calls, no tool loops, and no unnecessary post-write re-reading.
- Minimal syntax-only default verification policy.
- Dedicated user-wide and project-only Windows installers for both editions.
- Optional strict low-cost Claude Code session launcher.
- Validation, ZIP packaging, and GitHub Release automation for both editions.
- Separate release ZIP assets for both Skill editions.
- Research notes, behavior specification, security policy, and MIT license.

### Notes

- Documentation distinguishes Claude Code's documented zero-idle behavior from Claude web's toggle-based behavior.
