# Codex SDK for MoonBit

MoonBit client for the [`codex` CLI](https://github.com/openai/codex/tree/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript).

- CLI: `wasm` (preferred), `native`
- Executable: `PATH` or `Options.executable_path_override`

## Quickstart

```mbt
async fn main {
  let thread = @codex.Client::Client().start_thread()
  let turn = thread.run(@codex.Input::Prompt("Explain this repository."))
  println(turn.final_response)
}
```

## Streaming

```mbt
thread.run_streamed(
  @codex.Input::Prompt("Summarize the current changes."),
  async event => {
    match event {
      ItemCompleted(completed) => println("\{completed.item}")
      TurnCompleted(completed) => println("\{completed.usage}")
      _ => ()
    }
  },
)
```

## API

- [Client](src/cli/client.mbt) and [options](src/cli/options.mbt)
- [Thread and input](src/cli/thread.mbt)
- [Thread options](src/cli/thread_options.mbt) and [turn options](src/cli/turn_options.mbt)
- [Events](src/cli/events.mbt) and [items](src/cli/items.mbt)

## Development

```sh
nix develop
moon check
moon test
moon build
```
