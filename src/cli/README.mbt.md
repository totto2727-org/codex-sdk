# Codex SDK CLI for MoonBit

The `totto2727/codex-sdk/cli` package owns Codex client, thread, turn, event, item, and option types.

Consumer prerequisites, installation, imports, and the basic buffered turn are documented in the root [Setup](../../README.mbt.md#setup) and [Usage](../../README.mbt.md#usage).

## Package role

- `Client::start_thread` creates a persisted conversation, while `Client::resume_thread` continues one by its assigned identifier.
- `Thread::run` returns buffered items, final response text, and token usage.
- `Thread::run_streamed` delivers typed `ThreadEvent` values through an async callback.
- `ClientOptions`, `ThreadOptions`, and `TurnOptions` configure the executable, environment, sandbox, approval, model, search behavior, and optional JSON output schema.
- Cancelling the task that owns a turn terminates the Codex subprocess after temporary output-schema cleanup.

## Runnable examples

See the [checked thread flows](./test/thread_test.mbt) for buffered turns, streamed events, resumed threads, structured output, and cancellation behavior.

## API

[Mooncakes API reference for `totto2727/codex-sdk/cli`](https://mooncakes.io/docs/totto2727/codex-sdk/cli)

### `Client` and `ClientOptions`

`Client` owns shared options and starts or resumes persisted threads. `ClientOptions` controls the executable path, environment, and configuration overrides.

### `Thread`, `ThreadOptions`, and `TurnOptions`

`Thread` runs buffered or streamed turns. `ThreadOptions` configures model, sandbox, approval, and web search behavior; `TurnOptions` adds a per-turn JSON output schema.

### `ThreadEvent` and `ThreadItem`

Streamed turns expose typed lifecycle events, while completed items represent agent messages, reasoning, command executions, file changes, MCP calls, web searches, errors, and to-do lists.
