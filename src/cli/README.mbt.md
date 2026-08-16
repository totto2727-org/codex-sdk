# Codex SDK for MoonBit

Embed the Codex agent in MoonBit applications and workflows through the Codex CLI.

This document is canonical `README.mbt.md`; maintain `README.md` as the relative symlink `README.md -> README.mbt.md`.

## Usage

Import the `cli` package, create a client, and run a turn on a persisted thread:

```mbt nocheck
import {
  "totto2727/codex-sdk/cli" @codex,
}

async fn main {
  let client = @codex.Client::Client()
  let thread = client.start_thread()
  let turn = thread.run(
    @codex.Input::Prompt("Summarize the repository status"),
  )
  println(turn.final_response)
}
```

Use `Thread::run_streamed` when the application needs structured events while the turn is running:

```mbt nocheck
thread.run_streamed(
  @codex.Input::Prompt("Diagnose the test failure"),
  async fn(event) {
    match event {
      @codex.ItemCompleted(completed) => println("\{completed.item}")
      @codex.TurnCompleted(completed) => println("\{completed.usage}")
      _ => ()
    }
  },
)
```

Cancelling the MoonBit task that calls `Thread::run` or `Thread::run_streamed` terminates the Codex subprocess after temporary output-schema cleanup.

Pass `TurnOptions` to require a JSON response matching an output schema. Import `moonbitlang/core/json` as `@json` and this package as `@codex` in the consumer package:

```mbt nocheck
import {
  "moonbitlang/core/json" @json,
  "totto2727/codex-sdk/cli" @codex,
}
```

The following complete consumer example was verified in an isolated consumer during validation:

```mbt nocheck
///|
test "README configures an output schema" {
  let schema = @json.parse(
    "{\"type\":\"object\",\"properties\":{\"answer\":{\"type\":\"string\"}},\"required\":[\"answer\"],\"additionalProperties\":false}",
  )

  let options = @codex.TurnOptions::TurnOptions(output_schema=schema)
  assert_true(options.output_schema is Some(_))
}
```

## Key features

- Persistent threads with `Client::start_thread` and `Client::resume_thread`
- Buffered turns with `Thread::run` and event callbacks with `Thread::run_streamed`
- Typed event and item models for Codex JSONL output
- Per-turn JSON output schemas through `TurnOptions`
- Native and Wasm package targets with the Codex process supplied by the host runtime

## Prerequisites

- **MoonBit**: Use a MoonBit toolchain compatible with the package version.
- **Codex CLI**: Make `codex` available on `PATH`, or provide an explicit executable path in `ClientOptions`.
- **Codex authentication**: Configure the Codex CLI using its supported login or API-key flow.

## Setup

Add the package to a MoonBit project:

```bash
moon add totto2727/codex-sdk@0.4.0
```

The package imports as `totto2727/codex-sdk/cli`.

## API

See the [totto2727/codex-sdk API reference on Mooncakes](https://mooncakes.io/docs/totto2727/codex-sdk).

The canonical API package exposes the same constructors used by the application examples:

```mbt check
///|
test "README starts an unpersisted thread" {
  let client = Client::Client()
  let thread = client.start_thread()
  debug_inspect(thread.id(), content="None")
}
```

## Development

For repository structure and development commands, see [AGENTS.md](./AGENTS.md).

## License

[MIT](./LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
