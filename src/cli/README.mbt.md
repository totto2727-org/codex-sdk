# Codex SDK CLI for MoonBit

Use the `totto2727/codex-sdk/cli` package to start or resume Codex CLI conversations, run buffered or streamed turns, and inspect typed events and items.

This document is the canonical package README; the root `README.md` alias points to the physical module overview.

## Usage

Create a client and a thread, then run a prompt. The call returns a `Turn` containing the final response and token usage:

```mbt check
///|
pub async fn run_once() -> String {
  let client = Client::Client()
  let thread = client.start_thread()
  let turn = thread.run(Input::Prompt("Summarize the repository status"))
  turn.final_response
}
```

Use `run_streamed` when the application needs structured events while the turn runs. MoonBit delivers each event to an async callback:

```mbt check
///|
pub async fn stream_once(thread : Thread) -> Unit {
  thread.run_streamed(Input::Prompt("Diagnose the test failure"), async fn(
    event,
  ) {
    @async.pause()
    match event {
      ItemCompleted(completed) => ignore(completed)
      TurnCompleted(completed) => ignore(completed)
      _ => ()
    }
  })
}
```

Cancelling the MoonBit task that owns `Thread::run` or `Thread::run_streamed` terminates the Codex subprocess after temporary output-schema cleanup.

## Key features

- `Client::start_thread` creates a new persisted conversation.
- `Client::resume_thread` continues a conversation by its persisted identifier.
- `Thread::run` buffers completed items, the final response, and token usage.
- `Thread::run_streamed` forwards typed `ThreadEvent` values to an async callback.
- `TurnOptions` writes an optional JSON output schema for the Codex CLI.
- `ClientOptions` and `ThreadOptions` configure executable, environment, sandbox, approval, model, and search behavior.

## Prerequisites

- **MoonBit**: Use a MoonBit toolchain compatible with this package version.
- **Codex CLI**: Make `codex` available on `PATH`, or set `ClientOptions.executable_path_override`.
- **Codex authentication**: Configure the Codex CLI using its supported login or API-key flow.

## Setup

Add the package to a MoonBit project:

```bash
moon add totto2727/codex-sdk@0.4.0
```

Import it as `totto2727/codex-sdk/cli`:

```mbt check
///|
test "a new thread starts without an identifier" {
  let client = Client::Client()
  let thread = client.start_thread()
  debug_inspect(thread.id(), content="None")
}
```

## API

The [totto2727/codex-sdk API reference on Mooncakes](https://mooncakes.io/docs/totto2727/codex-sdk) is the canonical generated API index. The primary public surfaces are:

### `Client` and `ClientOptions`

`Client` owns shared options and starts or resumes persisted threads. `ClientOptions` controls the executable path, environment, and configuration overrides.

```mbt check
///|
test "client options construct a client" {
  let options = ClientOptions::ClientOptions()
  let client = Client::Client(options~)
  let thread = client.start_thread()
  debug_inspect(thread.id(), content="None")
}
```

### `Thread`, `ThreadOptions`, and `TurnOptions`

`ThreadOptions` configures a thread's model, sandbox, approval policy, and web search mode. `TurnOptions` adds a per-turn JSON output schema. A thread may be resumed with `Client::resume_thread` after Codex has assigned an identifier.

```mbt check
///|
test "thread and turn options retain their configuration" {
  let thread_options = ThreadOptions::ThreadOptions(
    model="gpt-5.6",
    sandbox_mode=ReadOnly,
    approval_policy=Never,
  )
  assert_true(thread_options.model is Some(_))

  let schema = @json.parse("{\"type\":\"object\"}")
  let turn_options = TurnOptions::TurnOptions(output_schema=schema)
  assert_true(turn_options.output_schema is Some(_))
}
```

### `ThreadEvent` and `ThreadItem`

Streamed turns expose typed lifecycle events such as `ThreadStarted`, `TurnCompleted`, and `ItemCompleted`; completed items carry agent messages, reasoning, command executions, file changes, MCP calls, web searches, errors, and to-do lists.

## Development

For repository structure, implementation rules, and complete validation commands, see [AGENTS.md](../../AGENTS.md).

## License

[MIT](../../LICENSE)

_This README was generated from the [share-artifact skill](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/SKILL.md) and [README template](https://raw.githubusercontent.com/totto2727-org/agent/refs/heads/main/plugins/totto2727-coding/skills/share-artifact/readme/template.md)._
