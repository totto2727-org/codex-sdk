# Codex SDK for MoonBit

## Repository structure

```text
src/cli/              Published Codex client, thread, event, item, and option APIs
src/cli/README.mbt.md Canonical package README checked in package context
src/cli/test/         Native black-box behavior tests
.github/workflows/    Check and Mooncakes publishing workflows
README.mbt.md         Physical module overview
README.md             Relative symlink to README.mbt.md
moon.mod              Module metadata, targets, and dependencies
flake.nix             Reproducible development shells
```

The root README describes the module and links to the detailed [`cli` package README](./src/cli/README.mbt.md). Do not replace the physical root `README.mbt.md` with a symlink to the package README. There is no package-level `README.md`; the package's canonical documentation is `src/cli/README.mbt.md`.

## Development commands

### Execution rules

- Run commands from the repository root.
- The preferred target is `wasm`; validate `native` explicitly when checking the declared secondary target.
- Keep the root alias `README.md -> README.mbt.md` and the package README as a physical `README.mbt.md`.
- Keep public behavior documented in source `///` comments so Mooncakes renders the generated API reference.
- Keep provider-specific implementation details in `internal_*.mbt` files, and do not add compatibility aliases for renamed internal symbols.

### Standard tasks

- `nix develop` — Enter the MoonBit development shell.
- `moon fmt` — Format MoonBit source and literate documentation.
- `moon check --target wasm` — Type-check the preferred target.
- `moon check --target native` — Type-check the declared native target.
- `moon test --target wasm` — Run the preferred-target test suite.
- `moon test --target native` — Run the declared native process-test target.
- `moon build --target wasm` — Build the preferred target.
- `moon build --target native` — Build the declared native target.
- `moon -C /tmp check "$(pwd)/README.mbt.md"` — Check the root README as a standalone Markdown program from outside the module; its front matter supplies versioned imports and a supported backend.
- `moon test src/cli --target wasm` — Execute the package tests on the preferred target.
- `moon test src/cli --target native` — Execute the package tests on the declared native target.
- `moon package --list` — Check the package manifest and included files.
- `moon package` — Create `_build/publish/totto2727-codex-sdk-0.4.0.zip`.
- `unzip -l _build/publish/totto2727-codex-sdk-0.4.0.zip` — Inspect the generated archive.

## Architecture

### Public package

- `src/cli` publishes `totto2727/codex-sdk/cli`.
- The public API models Codex clients, persisted threads, turns, JSONL events, thread items, and execution options.
- `Thread::run` buffers a turn; `Thread::run_streamed` forwards typed events to an async callback.
- The package delegates process lifecycle and JSONL transport to `totto2727/agent-core-sdk/cli`.

### Internal implementation

- Keep shared provider-interface files focused on common symbols; move protocol decoding, serialization, and temporary-resource helpers into `internal_*.mbt` files.
- Name private variables, functions, methods, constants, and helper types with a trailing underscore, such as `serialize_config_overrides_` or `OutputSchemaFile_`.
- Use typed Lens constructors, including `custom` for matching `FromJson` and `ToJson` wire contracts. Use a raw `Lens[Json]` only for opaque protocol payloads and document that choice next to its declaration.
- Use `totto2727/x/json` for configuration flattening. Keep TOML literal conversion at the Codex CLI boundary until the shared JSON/TOML conversion work tracked by TOT-186 is available as a normal registry dependency.

## Development tools

- **MoonBit**: Builds, checks, tests, formats, and packages the module.
- **Mooncakes**: Publishes the module and renders the canonical API documentation from `///` comments.
- **Nix flakes**: Provide reproducible development and CI shells.
- **GitHub Actions**: Run preferred-target checks and publishing workflows.

## Package-specific rules

- Update `moon.mod` only when package metadata or runtime dependencies change; preserve unrelated existing changes in that file.
- Add test-only dependencies to the relevant `moon.pkg` with `for "test"` or `for "wbtest"`; do not broaden runtime imports for documentation examples.
- Run formatting and both target checks after documentation or public API changes, then verify the README links, package list, and archive contents.

_This AGENTS.md was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [AGENTS template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/agents/template.md)._
