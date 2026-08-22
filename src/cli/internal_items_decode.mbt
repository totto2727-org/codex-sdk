// MoonBit FromJson implementations for wire formats that cannot use derive(FromJson).
// Corresponding upstream cast: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/thread.ts#L96-L103
// Item shapes being decoded: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/items.ts#L5-L128

///|
let item_id_lens_ : @lens.Lens[String] = @lens.root().string("id")

///|
let command_execution_command_lens_ : @lens.Lens[String] = @lens.root().string(
  "command",
)

///|
let command_execution_aggregated_output_lens_ : @lens.Lens[String] = @lens.root().string(
  "aggregated_output",
)

///|
let command_execution_exit_code_lens_ : @lens.PresenceLens[Int] = @lens.root()
  .int("exit_code")
  .nullish()

///|
let command_execution_status_lens_ : @lens.Lens[CommandExecutionStatus] = @lens.root().custom(
  "status",
)

///|
let file_update_path_lens_ : @lens.Lens[String] = @lens.root().string("path")

///|
let file_update_kind_lens_ : @lens.Lens[PatchChangeKind] = @lens.root().custom(
  "kind",
)

///|
/// MCP content blocks are protocol-defined opaque JSON values; only the array shape is fixed.
let mcp_result_content_lens_ : @lens.Lens[Array[Json]] = @lens.root()
  .json("content")
  .array()

///|
/// MCP metadata is provider-defined and intentionally remains opaque JSON.
let mcp_result_meta_lens_ : @lens.PresenceLens[Json] = @lens.root()
  .json("_meta")
  .nullish()

///|
/// Structured MCP output has no SDK-owned schema and intentionally remains raw JSON.
let mcp_result_structured_content_lens_ : @lens.Lens[Json] = @lens.root().json(
  "structured_content",
)

///|
let mcp_item_server_lens_ : @lens.Lens[String] = @lens.root().string("server")

///|
let mcp_item_tool_lens_ : @lens.Lens[String] = @lens.root().string("tool")

///|
/// MCP tool arguments follow each tool's schema and intentionally remain raw JSON.
let mcp_item_arguments_lens_ : @lens.Lens[Json] = @lens.root().json("arguments")

///|
let mcp_item_result_lens_ : @lens.PresenceLens[McpToolCallResult] = @lens.root()
  .custom("result")
  .nullish()

///|
let mcp_item_error_lens_ : @lens.PresenceLens[McpToolCallError] = @lens.root()
  .custom("error")
  .nullish()

///|
let file_change_changes_lens_ : @lens.Lens[Array[FileUpdateChange]] = @lens.root().custom(
  "changes",
)

///|
let todo_list_items_lens_ : @lens.Lens[Array[TodoItem]] = @lens.root().custom(
  "items",
)

///|
let file_change_status_lens_ : @lens.Lens[PatchApplyStatus] = @lens.root().custom(
  "status",
)

///|
let mcp_item_status_lens_ : @lens.Lens[McpToolCallStatus] = @lens.root().custom(
  "status",
)

///|
let thread_item_type_lens_ : @lens.Lens[String] = @lens.root().string("type")

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
pub impl ToJson for CommandExecutionStatus with fn to_json(self) {
  match self {
    InProgress => "in_progress".to_json()
    Completed => "completed".to_json()
    Failed => "failed".to_json()
  }
}

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
pub impl ToJson for PatchChangeKind with fn to_json(self) {
  match self {
    Add => "add".to_json()
    Delete => "delete".to_json()
    Update => "update".to_json()
  }
}

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
pub impl ToJson for PatchApplyStatus with fn to_json(self) {
  match self {
    PatchCompleted => "completed".to_json()
    PatchFailed => "failed".to_json()
  }
}

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
pub impl ToJson for McpToolCallStatus with fn to_json(self) {
  match self {
    McpInProgress => "in_progress".to_json()
    McpCompleted => "completed".to_json()
    McpFailed => "failed".to_json()
  }
}

///|
pub impl ToJson for FileUpdateChange with fn to_json(self) {
  Json::object({
    "path": "\{self.path}".to_json(),
    "kind": ToJson::to_json(self.kind),
  })
}

///|
pub impl ToJson for McpToolCallResult with fn to_json(self) {
  let value : Map[String, Json] = {
    "content": self.content.to_json(),
    "structured_content": self.structured_content,
  }
  match self.meta {
    Some(meta) => value["_meta"] = meta
    None => ()
  }
  Json::object(value)
}

///|
pub impl @json.FromJson for CommandExecutionItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "command_execution must be an object"))
  }
  let id = item_id_lens_.get_or_json_decode_error(json, path)
  let command = command_execution_command_lens_.get_or_json_decode_error(
    json, path,
  )
  let aggregated_output = command_execution_aggregated_output_lens_.get_or_json_decode_error(
    json, path,
  )
  let exit_code = command_execution_exit_code_lens_.get_or_json_decode_error(
    json, path,
  )
  let status = command_execution_status_lens_.get_or_json_decode_error(
    json, path,
  )
  { id, command, aggregated_output, exit_code, status }
}

///|
pub impl @json.FromJson for FileUpdateChange with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "file update must be an object"))
  }
  let path_value = file_update_path_lens_.get_or_json_decode_error(json, path)
  let kind = file_update_kind_lens_.get_or_json_decode_error(json, path)
  { path: @path.Path(path_value), kind }
}

///|
pub impl @json.FromJson for McpToolCallResult with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "MCP tool result must be an object"))
  }
  let content = mcp_result_content_lens_.get_or_json_decode_error(json, path)
  let meta = mcp_result_meta_lens_.get_or_json_decode_error(json, path)
  let structured_content = mcp_result_structured_content_lens_.get_or_json_decode_error(
    json, path,
  )
  { content: ReadOnlyArray::from_array(content), meta, structured_content }
}

///|
pub impl @json.FromJson for McpToolCallItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "mcp_tool_call must be an object"))
  }
  let id = item_id_lens_.get_or_json_decode_error(json, path)
  let server = mcp_item_server_lens_.get_or_json_decode_error(json, path)
  let tool = mcp_item_tool_lens_.get_or_json_decode_error(json, path)
  let arguments = mcp_item_arguments_lens_.get_or_json_decode_error(json, path)
  let result = mcp_item_result_lens_.get_or_json_decode_error(json, path)
  let error = mcp_item_error_lens_.get_or_json_decode_error(json, path)
  let status = mcp_item_status_lens_.get_or_json_decode_error(json, path)
  { id, server, tool, arguments, result, error, status }
}

///|
pub impl @json.FromJson for FileChangeItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "file_change must be an object"))
  }
  let id = item_id_lens_.get_or_json_decode_error(json, path)
  let changes = file_change_changes_lens_.get_or_json_decode_error(json, path)
  let status = file_change_status_lens_.get_or_json_decode_error(json, path)
  { id, changes: ReadOnlyArray::from_array(changes), status }
}

///|
pub impl @json.FromJson for TodoListItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "todo_list must be an object"))
  }
  let id = item_id_lens_.get_or_json_decode_error(json, path)
  let items = todo_list_items_lens_.get_or_json_decode_error(json, path)
  { id, items: ReadOnlyArray::from_array(items) }
}

///|
pub impl @json.FromJson for ThreadItem with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "thread item must be an object"))
  }
  let item_type = thread_item_type_lens_.get_or_json_decode_error(json, path)
  match item_type {
    "agent_message" => AgentMessage(@json.from_json(json, path~))
    "reasoning" => Reasoning(@json.from_json(json, path~))
    "command_execution" => CommandExecution(@json.from_json(json, path~))
    "file_change" => FileChange(@json.from_json(json, path~))
    "mcp_tool_call" => McpToolCall(@json.from_json(json, path~))
    "web_search" => WebSearch(@json.from_json(json, path~))
    "todo_list" => TodoList(@json.from_json(json, path~))
    "error" => Error(@json.from_json(json, path~))
    _ =>
      raise thread_item_type_lens_.json_decode_error(
        path,
        "unsupported thread item type: \{item_type}",
      )
  }
}
