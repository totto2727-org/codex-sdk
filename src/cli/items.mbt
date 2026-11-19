// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts

///| The status of a command execution.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L5-L6

///|
/// Type difference: MoonBit uses an enum instead of a string-literal union.
#derive(Debug, Eq)
pub enum CommandExecutionStatus {
  InProgress
  Completed
  Failed
}

///|
pub extend CommandExecutionStatus with Debug::{to_repr}

///|
pub extend CommandExecutionStatus with Eq::{not_equal, equal}

///| A command executed by the agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L8-L20
#derive(Debug, Eq)
pub struct CommandExecutionItem {
  id : String
  command : String
  aggregated_output : String
  exit_code : Int32?
  status : CommandExecutionStatus
}

///|
pub extend CommandExecutionItem with Debug::{to_repr}

///|
pub extend CommandExecutionItem with Eq::{not_equal, equal}

///| The kind of a file update.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L22-L23

///|
/// Type difference: MoonBit uses an enum instead of a string-literal union.
#derive(Debug, Eq)
pub enum PatchChangeKind {
  Add
  Delete
  Update
}

///|
pub extend PatchChangeKind with Debug::{to_repr}

///|
pub extend PatchChangeKind with Eq::{not_equal, equal}

///| One file update in an applied patch.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L25-L29

///|
/// Type difference: filesystem strings are represented by Path.
#derive(Eq)
pub struct FileUpdateChange {
  path : @path.Path
  kind : PatchChangeKind
}

///|
pub extend FileUpdateChange with Eq::{not_equal, equal}

///| The terminal status of a patch application.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L31-L32

///|
/// Type difference: MoonBit uses an enum instead of a string-literal union.
#derive(Debug, Eq)
pub enum PatchApplyStatus {
  PatchCompleted
  PatchFailed
}

///|
pub extend PatchApplyStatus with Debug::{to_repr}

///|
pub extend PatchApplyStatus with Eq::{not_equal, equal}

///| A set of file changes emitted after a patch succeeds or fails.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L34-L42
#derive(Eq)
pub struct FileChangeItem {
  id : String
  changes : ReadOnlyArray[FileUpdateChange]
  status : PatchApplyStatus
}

///|
pub extend FileChangeItem with Eq::{not_equal, equal}

///| The status of an MCP tool call.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L44-L45

///|
/// Type difference: MoonBit uses an enum instead of a string-literal union.
#derive(Debug, Eq)
pub enum McpToolCallStatus {
  McpInProgress
  McpCompleted
  McpFailed
}

///|
pub extend McpToolCallStatus with Debug::{to_repr}

///|
pub extend McpToolCallStatus with Eq::{not_equal, equal}

///| The successful result of an MCP tool call.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L60-L65

///|
/// Type difference: explicit structs replace inline TypeScript object types.
#derive(Debug, Eq)
pub struct McpToolCallResult {
  content : ReadOnlyArray[Json]
  meta : Json?
  structured_content : Json
}

///|
pub extend McpToolCallResult with Debug::{to_repr}

///|
pub extend McpToolCallResult with Eq::{not_equal, equal}

///| The failure returned by an MCP tool.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L66-L69

///|
/// Type difference: explicit structs replace inline TypeScript object types.
#derive(Debug, Eq, FromJson, ToJson)
pub struct McpToolCallError {
  message : String
}

///|
pub extend McpToolCallError with Debug::{to_repr}

///|
pub extend McpToolCallError with Eq::{not_equal, equal}

///|
pub extend McpToolCallError with @json.FromJson::{from_json}

///|
pub extend McpToolCallError with ToJson::{to_json}

///| A call dispatched to an MCP server.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L47-L72
#derive(Debug, Eq)
pub struct McpToolCallItem {
  id : String
  server : String
  tool : String
  arguments : Json
  result : McpToolCallResult?
  error : McpToolCallError?
  status : McpToolCallStatus
}

///|
pub extend McpToolCallItem with Debug::{to_repr}

///|
pub extend McpToolCallItem with Eq::{not_equal, equal}

///| A natural-language or structured response emitted by the agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L74-L80
#derive(Debug, Eq, FromJson)
pub struct AgentMessageItem {
  id : String
  text : String
}

///|
pub extend AgentMessageItem with Debug::{to_repr}

///|
pub extend AgentMessageItem with Eq::{not_equal, equal}

///|
pub extend AgentMessageItem with @json.FromJson::{from_json}

///| An agent reasoning summary.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L82-L87
#derive(Debug, Eq, FromJson)
pub struct ReasoningItem {
  id : String
  text : String
}

///|
pub extend ReasoningItem with Debug::{to_repr}

///|
pub extend ReasoningItem with Eq::{not_equal, equal}

///|
pub extend ReasoningItem with @json.FromJson::{from_json}

///| A web search request made by the agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L89-L94
#derive(Debug, Eq, FromJson)
pub struct WebSearchItem {
  id : String
  query : String
}

///|
pub extend WebSearchItem with Debug::{to_repr}

///|
pub extend WebSearchItem with Eq::{not_equal, equal}

///|
pub extend WebSearchItem with @json.FromJson::{from_json}

///| A non-fatal error surfaced as a thread item.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L96-L101
#derive(Debug, Eq, FromJson)
pub struct ErrorItem {
  id : String
  message : String
}

///|
pub extend ErrorItem with Debug::{to_repr}

///|
pub extend ErrorItem with Eq::{not_equal, equal}

///|
pub extend ErrorItem with @json.FromJson::{from_json}

///| One entry in the agent's running to-do list.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L103-L107
#derive(Debug, Eq, FromJson, ToJson)
pub struct TodoItem {
  text : String
  completed : Bool
}

///|
pub extend TodoItem with Debug::{to_repr}

///|
pub extend TodoItem with Eq::{not_equal, equal}

///|
pub extend TodoItem with @json.FromJson::{from_json}

///|
pub extend TodoItem with ToJson::{to_json}

///| The agent's current running to-do list.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L109-L117
#derive(Debug, Eq)
pub struct TodoListItem {
  id : String
  items : ReadOnlyArray[TodoItem]
}

///|
pub extend TodoListItem with Debug::{to_repr}

///|
pub extend TodoListItem with Eq::{not_equal, equal}

///| Canonical union of thread items and their type-specific payloads.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L119-L128

///|
/// Type difference: MoonBit uses an enum instead of a discriminated object union.
#derive(Eq)
pub enum ThreadItem {
  AgentMessage(AgentMessageItem)
  Reasoning(ReasoningItem)
  CommandExecution(CommandExecutionItem)
  FileChange(FileChangeItem)
  McpToolCall(McpToolCallItem)
  WebSearch(WebSearchItem)
  TodoList(TodoListItem)
  Error(ErrorItem)
}

///|
pub extend ThreadItem with Eq::{not_equal, equal}
