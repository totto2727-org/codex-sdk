// MoonBit FromJson implementations for wire formats that cannot use derive(FromJson).
// Corresponding upstream cast: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/thread.ts#L96-L103
// Item shapes being decoded: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L5-L128

///|
#custom.serde(decode_only)
priv struct CommandExecutionWire_ {
  id : String
  command : String
  aggregated_output : String
  exit_code : WireInt_?
  status : CommandExecutionStatus
}

///|
#custom.serde
priv struct FileUpdateWire_ {
  path : String
  kind : PatchChangeKind
}

///|
#custom.serde(decode_only)
priv struct FileChangeWire_ {
  id : String
  changes : Array[FileUpdateChange]
  status : PatchApplyStatus
}

///|
#custom.serde(decode_only)
priv struct TodoListWire_ {
  id : String
  items : Array[TodoItem]
}

///|
#custom.serde
priv struct McpResultWire_[Content] {
  // The MCP server defines the contents of these JSON values.
  content : Content
  structured_content : Json
  #custom.serde(rename="_meta", skip_serializing_if="Option::is_none")
  meta : Json?
}

///|
pub impl @json.FromJson for CommandExecutionStatus with fn from_json(json, path) {
  let value : String = @json.from_json(json, path~)
  match value {
    "in_progress" => InProgress
    "completed" => Completed
    "failed" => Failed
    _ =>
      raise @json.JsonDecodeError(
        (path, "unsupported command execution status: \{value}"),
      )
  }
}

///|
pub extend CommandExecutionStatus with @json.FromJson::{from_json}

///|
pub impl ToJson for CommandExecutionStatus with fn to_json(self) {
  match self {
    InProgress => ToJson::to_json("in_progress")
    Completed => ToJson::to_json("completed")
    Failed => ToJson::to_json("failed")
  }
}

///|
pub extend CommandExecutionStatus with ToJson::{to_json}

///|
pub impl @json.FromJson for PatchChangeKind with fn from_json(json, path) {
  let value : String = @json.from_json(json, path~)
  match value {
    "add" => Add
    "delete" => Delete
    "update" => Update
    _ =>
      raise @json.JsonDecodeError(
        (path, "unsupported patch change kind: \{value}"),
      )
  }
}

///|
pub extend PatchChangeKind with @json.FromJson::{from_json}

///|
pub impl ToJson for PatchChangeKind with fn to_json(self) {
  match self {
    Add => ToJson::to_json("add")
    Delete => ToJson::to_json("delete")
    Update => ToJson::to_json("update")
  }
}

///|
pub extend PatchChangeKind with ToJson::{to_json}

///|
pub impl @json.FromJson for PatchApplyStatus with fn from_json(json, path) {
  let value : String = @json.from_json(json, path~)
  match value {
    "completed" => PatchCompleted
    "failed" => PatchFailed
    _ =>
      raise @json.JsonDecodeError(
        (path, "unsupported patch apply status: \{value}"),
      )
  }
}

///|
pub extend PatchApplyStatus with @json.FromJson::{from_json}

///|
pub impl ToJson for PatchApplyStatus with fn to_json(self) {
  match self {
    PatchCompleted => ToJson::to_json("completed")
    PatchFailed => ToJson::to_json("failed")
  }
}

///|
pub extend PatchApplyStatus with ToJson::{to_json}

///|
pub impl @json.FromJson for McpToolCallStatus with fn from_json(json, path) {
  let value : String = @json.from_json(json, path~)
  match value {
    "in_progress" => McpInProgress
    "completed" => McpCompleted
    "failed" => McpFailed
    _ =>
      raise @json.JsonDecodeError(
        (path, "unsupported MCP tool call status: \{value}"),
      )
  }
}

///|
pub extend McpToolCallStatus with @json.FromJson::{from_json}

///|
pub impl ToJson for McpToolCallStatus with fn to_json(self) {
  match self {
    McpInProgress => ToJson::to_json("in_progress")
    McpCompleted => ToJson::to_json("completed")
    McpFailed => ToJson::to_json("failed")
  }
}

///|
pub extend McpToolCallStatus with ToJson::{to_json}

///|
pub impl ToJson for FileUpdateChange with fn to_json(self) {
  ToJson::to_json(FileUpdateWire_::{ path: "\{self.path}", kind: self.kind, })
}

///|
pub extend FileUpdateChange with ToJson::{to_json}

///|
pub impl ToJson for McpToolCallResult with fn to_json(self) {
  ToJson::to_json(McpResultWire_::{
    content: self.content,
    meta: self.meta,
    structured_content: self.structured_content,
  })
}

///|
pub extend McpToolCallResult with ToJson::{to_json}

///|
pub impl @json.FromJson for CommandExecutionItem with fn from_json(json, path) {
  let wire : CommandExecutionWire_ = @json.from_json(json, path~)
  {
    id: wire.id,
    command: wire.command,
    aggregated_output: wire.aggregated_output,
    exit_code: wire.exit_code.map(value => value.0),
    status: wire.status,
  }
}

///|
pub extend CommandExecutionItem with @json.FromJson::{from_json}

///|
pub impl @json.FromJson for FileUpdateChange with fn from_json(json, path) {
  let wire : FileUpdateWire_ = @json.from_json(json, path~)
  { path: @path.Path(wire.path), kind: wire.kind, }
}

///|
pub extend FileUpdateChange with @json.FromJson::{from_json}

///|
pub impl @json.FromJson for McpToolCallResult with fn from_json(json, path) {
  let wire : McpResultWire_[Array[Json]] = @json.from_json(json, path~)
  {
    content: ReadOnlyArray::from_array(wire.content),
    meta: wire.meta,
    structured_content: wire.structured_content,
  }
}

///|
pub extend McpToolCallResult with @json.FromJson::{from_json}

///|
pub extend McpToolCallItem with @json.FromJson::{from_json}

///|
pub impl @json.FromJson for FileChangeItem with fn from_json(json, path) {
  let wire : FileChangeWire_ = @json.from_json(json, path~)
  {
    id: wire.id,
    changes: ReadOnlyArray::from_array(wire.changes),
    status: wire.status,
  }
}

///|
pub extend FileChangeItem with @json.FromJson::{from_json}

///|
pub impl @json.FromJson for TodoListItem with fn from_json(json, path) {
  let wire : TodoListWire_ = @json.from_json(json, path~)
  { id: wire.id, items: ReadOnlyArray::from_array(wire.items), }
}

///|
pub extend TodoListItem with @json.FromJson::{from_json}

///|
pub impl @json.FromJson for ThreadItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "thread item must be an object"))
  }
  let discriminator : ThreadDiscriminator_ = @json.from_json(json, path~)
  match discriminator.tag {
    "agent_message" => AgentMessage(@json.from_json(json, path~))
    "reasoning" => Reasoning(@json.from_json(json, path~))
    "command_execution" => CommandExecution(@json.from_json(json, path~))
    "file_change" => FileChange(@json.from_json(json, path~))
    "mcp_tool_call" => McpToolCall(@json.from_json(json, path~))
    "web_search" => WebSearch(@json.from_json(json, path~))
    "todo_list" => TodoList(@json.from_json(json, path~))
    "error" => Error(@json.from_json(json, path~))
    tag =>
      raise path.add_key("type").error("unsupported thread item type: \{tag}")
  }
}

///|
pub extend ThreadItem with @json.FromJson::{from_json}
