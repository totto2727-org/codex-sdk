# Codex SDK for MoonBit

Embed the Codex agent in MoonBit applications through the published `cli` package. This module wraps the Codex CLI, exposes typed threads, turns, events, items, and options, and delegates process lifecycle management to `totto2727/agent-core-sdk/cli`.

See the package-specific API guide at [`src/cli/README.mbt.md`](./src/cli/README.mbt.md).

## Usage

Ask Codex to summarize a repository and return the completed response:

```mbt check
///|
import {
  "totto2727/codex-sdk/cli" @codex,
}

///|
pub async fn summarize_repository() -> String {
  let client = @codex.Client::Client()
  let thread = client.start_thread()
  let turn = thread.run(
    @codex.Input::Prompt("Summarize the repository status"),
  )
  turn.final_response
}
```

See the [`cli` package guide](./src/cli/README.mbt.md) for executable examples of turns, streaming callbacks, structured output, and thread options.

## Key features

- A published `totto2727/codex-sdk/cli` package for embedding Codex CLI sessions.
- Persistent and resumable threads with typed buffered and streamed turns.
- Typed JSONL events, thread items, client options, thread options, and turn options.
- Native and Wasm package targets with the process bridge supplied by the host runtime.

## Prerequisites

- **MoonBit**: Use a MoonBit toolchain compatible with the package version.
- **Codex CLI**: Make `codex` available on `PATH`, or set an explicit executable path in `ClientOptions`.
- **Codex authentication**: Configure the Codex CLI using its supported login or API-key flow.

## Setup

Add the module's published package to a MoonBit project:

```bash
moon add totto2727/codex-sdk@0.4.0
```

The package imports as `totto2727/codex-sdk/cli`; continue with the [package API guide](./src/cli/README.mbt.md).

## API

See the [totto2727/codex-sdk API reference on Mooncakes](https://mooncakes.io/docs/totto2727/codex-sdk) for the generated public API, and the [`cli` package guide](./src/cli/README.mbt.md) for usage-oriented examples.

## Development

For repository structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
