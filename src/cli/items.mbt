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

///| One file update in an applied patch.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L25-L29

///|
/// Type difference: filesystem strings are represented by Path.
#derive(Eq)
pub struct FileUpdateChange {
  path : @path.Path
  kind : PatchChangeKind
}

///| The terminal status of a patch application.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L31-L32

///|
/// Type difference: MoonBit uses an enum instead of a string-literal union.
#derive(Debug, Eq)
pub enum PatchApplyStatus {
  PatchCompleted
  PatchFailed
}

///| A set of file changes emitted after a patch succeeds or fails.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L34-L42
#derive(Eq)
pub struct FileChangeItem {
  id : String
  changes : ReadOnlyArray[FileUpdateChange]
  status : PatchApplyStatus
}

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

///| The failure returned by an MCP tool.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L66-L69

///|
/// Type difference: explicit structs replace inline TypeScript object types.
#derive(Debug, Eq, FromJson, ToJson)
pub struct McpToolCallError {
  message : String
}

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

///| A natural-language or structured response emitted by the agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L74-L80
#derive(Debug, Eq, FromJson)
pub struct AgentMessageItem {
  id : String
  text : String
}

///| An agent reasoning summary.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L82-L87
#derive(Debug, Eq, FromJson)
pub struct ReasoningItem {
  id : String
  text : String
}

///| A web search request made by the agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L89-L94
#derive(Debug, Eq, FromJson)
pub struct WebSearchItem {
  id : String
  query : String
}

///| A non-fatal error surfaced as a thread item.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L96-L101
#derive(Debug, Eq, FromJson)
pub struct ErrorItem {
  id : String
  message : String
}

///| One entry in the agent's running to-do list.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L103-L107
#derive(Debug, Eq, FromJson, ToJson)
pub struct TodoItem {
  text : String
  completed : Bool
}

///| The agent's current running to-do list.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L109-L117
#derive(Debug, Eq)
pub struct TodoListItem {
  id : String
  items : ReadOnlyArray[TodoItem]
}

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
