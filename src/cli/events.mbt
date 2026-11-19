// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts

///| Emitted when a new thread is started.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L5-L10
#derive(Debug, Eq, FromJson)
pub struct ThreadStartedEvent {
  thread_id : String
}

///|
pub extend ThreadStartedEvent with Debug::{to_repr}

///|
pub extend ThreadStartedEvent with Eq::{not_equal, equal}

///|
pub extend ThreadStartedEvent with @json.FromJson::{from_json}

///| Emitted when a turn starts.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L12-L18
#derive(Debug, Eq, FromJson)
pub struct TurnStartedEvent {}

///|
pub extend TurnStartedEvent with Debug::{to_repr}

///|
pub extend TurnStartedEvent with Eq::{not_equal, equal}

///|
pub extend TurnStartedEvent with @json.FromJson::{from_json}

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

///|
pub extend Usage with Debug::{to_repr}

///|
pub extend Usage with Eq::{not_equal, equal}

///| Emitted when a turn completes.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L34-L38
#derive(Debug, Eq, FromJson)
pub struct TurnCompletedEvent {
  usage : Usage
}

///|
pub extend TurnCompletedEvent with Debug::{to_repr}

///|
pub extend TurnCompletedEvent with Eq::{not_equal, equal}

///|
pub extend TurnCompletedEvent with @json.FromJson::{from_json}

///| A fatal error attached to a failed turn.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L64-L67
#derive(Debug, Eq, FromJson)
pub struct ThreadError {
  message : String
}

///|
pub extend ThreadError with Debug::{to_repr}

///|
pub extend ThreadError with Eq::{not_equal, equal}

///|
pub extend ThreadError with @json.FromJson::{from_json}

///| Emitted when a turn fails.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L40-L44
#derive(Debug, Eq, FromJson)
pub struct TurnFailedEvent {
  error : ThreadError
}

///|
pub extend TurnFailedEvent with Debug::{to_repr}

///|
pub extend TurnFailedEvent with Eq::{not_equal, equal}

///|
pub extend TurnFailedEvent with @json.FromJson::{from_json}

///| Emitted when a new item is added to a thread.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L46-L50
#derive(Eq, FromJson)
pub struct ItemStartedEvent {
  item : ThreadItem
}

///|
pub extend ItemStartedEvent with Eq::{not_equal, equal}

///|
pub extend ItemStartedEvent with @json.FromJson::{from_json}

///| Emitted when an existing item changes.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L52-L56
#derive(Eq, FromJson)
pub struct ItemUpdatedEvent {
  item : ThreadItem
}

///|
pub extend ItemUpdatedEvent with Eq::{not_equal, equal}

///|
pub extend ItemUpdatedEvent with @json.FromJson::{from_json}

///| Emitted when an item reaches a terminal state.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L58-L62
#derive(Eq, FromJson)
pub struct ItemCompletedEvent {
  item : ThreadItem
}

///|
pub extend ItemCompletedEvent with Eq::{not_equal, equal}

///|
pub extend ItemCompletedEvent with @json.FromJson::{from_json}

///| An unrecoverable error emitted directly by the event stream.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/events.ts#L69-L73
#derive(Debug, Eq, FromJson)
pub struct ThreadErrorEvent {
  message : String
}

///|
pub extend ThreadErrorEvent with Debug::{to_repr}

///|
pub extend ThreadErrorEvent with Eq::{not_equal, equal}

///|
pub extend ThreadErrorEvent with @json.FromJson::{from_json}

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

///|
pub extend ThreadEvent with Eq::{not_equal, equal}
