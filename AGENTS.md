# Codex SDK for MoonBit

## Repository structure

```text
src/cli/              Public Codex client, thread, event, item, and option APIs
src/cli/test/         Blackbox behavior tests
.github/workflows/    Check and Mooncakes publishing workflows
README.mbt.md         Canonical literate README
README.md             Relative symlink to README.mbt.md
moon.mod              Module metadata and dependencies
flake.nix             Nix development shells
```

## Development commands

### Execution rules

- Run commands from the repository root.
- Use the preferred `wasm` target unless deliberately validating the declared `native` target.
- Keep `README.md` as the relative symlink to `README.mbt.md`.
- Keep public behavior documented in source `///` comments so Mooncakes renders a complete API reference.

### Standard tasks

- `nix develop` — Enter the MoonBit development shell.
- `moon fmt` — Format MoonBit source and literate documentation.
- `moon check` — Type-check the module.
- `moon test` — Run the module test suite.
- `moon build` — Build the module.
- `moon package --list` — Inspect files included in the Mooncakes package.

## Architecture

### Public package

- `src/cli` is the published `totto2727/codex-sdk/cli` package.
- The public API models Codex clients, persisted threads, turns, JSONL events, thread items, and execution options.
- The package delegates process lifecycle and JSONL transport to `totto2727/agent-core-sdk/cli`.

### Internal implementation

- Put provider-specific private implementation details in `internal_*.mbt` files; do not repeat `codex` in those filenames.
- Name private variables, functions, methods, constants, and helper types with a trailing underscore, such as `serialize_config_overrides_` or `OutputSchemaFile_`.
- Keep shared provider-interface files focused on common symbols and move protocol decoding, serialization, and temporary-resource helpers into `internal_*.mbt` files.
- Use typed Lens constructors, including `custom` for matching `FromJson` and `ToJson` wire contracts. Use a raw `Lens[Json]` only for opaque protocol payloads and document that choice next to its declaration.
- Keep public API symbols provider-neutral and do not add compatibility aliases or shims for renamed internal symbols.
- Use `totto2727/x/json` for configuration flattening. Keep TOML literal conversion at the Codex CLI boundary until the shared JSON/TOML conversion work tracked by TOT-186 is available as a normal registry dependency.

## Development tools

- **MoonBit**: Builds, checks, tests, formats, and packages the module.
- **Mooncakes**: Publishes the module and renders the canonical API documentation from `///` comments.
- **Nix flakes**: Provide reproducible development and CI shells.
- **GitHub Actions**: Run preferred-target checks and publishing workflows.

## Package-specific rules

- Update `moon.mod` when package metadata or dependencies change.
- Keep the README's Mooncakes API link pointed at the published module documentation.
- Run `moon fmt`, `moon check`, `moon test`, `moon build`, and `moon package --list` after public API or documentation changes.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
