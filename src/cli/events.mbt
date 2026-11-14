// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts

///| Emitted when a new thread is started.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L5-L10
#derive(Debug, Eq, FromJson)
pub struct ThreadStartedEvent {
  thread_id : String
}

///| Emitted when a turn starts.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L12-L18
#derive(Debug, Eq, FromJson)
pub struct TurnStartedEvent {}

///| Token usage reported for a completed turn.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L20-L32
#derive(Debug, Eq)
pub struct Usage {
  input_tokens : Int32
  cached_input_tokens : Int32
  cache_write_input_tokens : Int32
  output_tokens : Int32
  reasoning_output_tokens : Int32
}

///| Emitted when a turn completes.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L34-L38
#derive(Debug, Eq, FromJson)
pub struct TurnCompletedEvent {
  usage : Usage
}

///| A fatal error attached to a failed turn.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L64-L67
#derive(Debug, Eq, FromJson)
pub struct ThreadError {
  message : String
}

///| Emitted when a turn fails.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L40-L44
#derive(Debug, Eq, FromJson)
pub struct TurnFailedEvent {
  error : ThreadError
}

///| Emitted when a new item is added to a thread.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L46-L50
#derive(Eq, FromJson)
pub struct ItemStartedEvent {
  item : ThreadItem
}

///| Emitted when an existing item changes.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L52-L56
#derive(Eq, FromJson)
pub struct ItemUpdatedEvent {
  item : ThreadItem
}

///| Emitted when an item reaches a terminal state.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L58-L62
#derive(Eq, FromJson)
pub struct ItemCompletedEvent {
  item : ThreadItem
}

///| An unrecoverable error emitted directly by the event stream.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L69-L73
#derive(Debug, Eq, FromJson)
pub struct ThreadErrorEvent {
  message : String
}

///| Top-level JSONL event emitted by `codex exec`.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L75-L84
#derive(Eq)
pub enum ThreadEvent {
  ThreadStarted(ThreadStartedEvent)
  TurnStarted(TurnStartedEvent)
  TurnCompleted(TurnCompletedEvent)
  TurnFailed(TurnFailedEvent)
  ItemStarted(ItemStartedEvent)
  ItemUpdated(ItemUpdatedEvent)
  ItemCompleted(ItemCompletedEvent)
  StreamError(ThreadErrorEvent)
}
