///|
pub extend ClientOptions with Eq::{not_equal, equal}

///|
pub extend SdkError with Debug::{to_repr}

///|
pub extend SdkError with Eq::{not_equal, equal}

///|
pub extend ThreadStartedEvent with Debug::{to_repr}

///|
pub extend ThreadStartedEvent with Eq::{not_equal, equal}

///|
pub extend ThreadStartedEvent with @json.FromJson::{from_json}

///|
pub extend TurnStartedEvent with Debug::{to_repr}

///|
pub extend TurnStartedEvent with Eq::{not_equal, equal}

///|
pub extend TurnStartedEvent with @json.FromJson::{from_json}

///|
pub extend Usage with Debug::{to_repr}

///|
pub extend Usage with Eq::{not_equal, equal}

///|
pub extend Usage with @json.FromJson::{from_json}

///|
pub extend TurnCompletedEvent with Debug::{to_repr}

///|
pub extend TurnCompletedEvent with Eq::{not_equal, equal}

///|
pub extend TurnCompletedEvent with @json.FromJson::{from_json}

///|
pub extend ThreadError with Debug::{to_repr}

///|
pub extend ThreadError with Eq::{not_equal, equal}

///|
pub extend ThreadError with @json.FromJson::{from_json}

///|
pub extend TurnFailedEvent with Debug::{to_repr}

///|
pub extend TurnFailedEvent with Eq::{not_equal, equal}

///|
pub extend TurnFailedEvent with @json.FromJson::{from_json}

///|
pub extend ItemStartedEvent with Eq::{not_equal, equal}

///|
pub extend ItemStartedEvent with @json.FromJson::{from_json}

///|
pub extend ItemUpdatedEvent with Eq::{not_equal, equal}

///|
pub extend ItemUpdatedEvent with @json.FromJson::{from_json}

///|
pub extend ItemCompletedEvent with Eq::{not_equal, equal}

///|
pub extend ItemCompletedEvent with @json.FromJson::{from_json}

///|
pub extend ThreadErrorEvent with Debug::{to_repr}

///|
pub extend ThreadErrorEvent with Eq::{not_equal, equal}

///|
pub extend ThreadErrorEvent with @json.FromJson::{from_json}

///|
pub extend ThreadEvent with Eq::{not_equal, equal}

///|
pub extend ThreadEvent with @json.FromJson::{from_json}

///|
pub extend CommandExecutionStatus with @json.FromJson::{from_json}

///|
pub extend CommandExecutionStatus with ToJson::{to_json}

///|
pub extend PatchChangeKind with @json.FromJson::{from_json}

///|
pub extend PatchChangeKind with ToJson::{to_json}

///|
pub extend PatchApplyStatus with @json.FromJson::{from_json}

///|
pub extend PatchApplyStatus with ToJson::{to_json}

///|
pub extend McpToolCallStatus with @json.FromJson::{from_json}

///|
pub extend McpToolCallStatus with ToJson::{to_json}

///|
pub extend FileUpdateChange with ToJson::{to_json}

///|
pub extend McpToolCallResult with ToJson::{to_json}

///|
pub extend CommandExecutionItem with @json.FromJson::{from_json}

///|
pub extend FileUpdateChange with @json.FromJson::{from_json}

///|
pub extend McpToolCallResult with @json.FromJson::{from_json}

///|
pub extend McpToolCallItem with @json.FromJson::{from_json}

///|
pub extend FileChangeItem with @json.FromJson::{from_json}

///|
pub extend TodoListItem with @json.FromJson::{from_json}

///|
pub extend ThreadItem with @json.FromJson::{from_json}

///|
pub extend CommandExecutionStatus with Debug::{to_repr}

///|
pub extend CommandExecutionStatus with Eq::{not_equal, equal}

///|
pub extend CommandExecutionItem with Debug::{to_repr}

///|
pub extend CommandExecutionItem with Eq::{not_equal, equal}

///|
pub extend PatchChangeKind with Debug::{to_repr}

///|
pub extend PatchChangeKind with Eq::{not_equal, equal}

///|
pub extend FileUpdateChange with Eq::{not_equal, equal}

///|
pub extend PatchApplyStatus with Debug::{to_repr}

///|
pub extend PatchApplyStatus with Eq::{not_equal, equal}

///|
pub extend FileChangeItem with Eq::{not_equal, equal}

///|
pub extend McpToolCallStatus with Debug::{to_repr}

///|
pub extend McpToolCallStatus with Eq::{not_equal, equal}

///|
pub extend McpToolCallResult with Debug::{to_repr}

///|
pub extend McpToolCallResult with Eq::{not_equal, equal}

///|
pub extend McpToolCallError with Debug::{to_repr}

///|
pub extend McpToolCallError with Eq::{not_equal, equal}

///|
pub extend McpToolCallError with @json.FromJson::{from_json}

///|
pub extend McpToolCallError with ToJson::{to_json}

///|
pub extend McpToolCallItem with Debug::{to_repr}

///|
pub extend McpToolCallItem with Eq::{not_equal, equal}

///|
pub extend AgentMessageItem with Debug::{to_repr}

///|
pub extend AgentMessageItem with Eq::{not_equal, equal}

///|
pub extend AgentMessageItem with @json.FromJson::{from_json}

///|
pub extend ReasoningItem with Debug::{to_repr}

///|
pub extend ReasoningItem with Eq::{not_equal, equal}

///|
pub extend ReasoningItem with @json.FromJson::{from_json}

///|
pub extend WebSearchItem with Debug::{to_repr}

///|
pub extend WebSearchItem with Eq::{not_equal, equal}

///|
pub extend WebSearchItem with @json.FromJson::{from_json}

///|
pub extend ErrorItem with Debug::{to_repr}

///|
pub extend ErrorItem with Eq::{not_equal, equal}

///|
pub extend ErrorItem with @json.FromJson::{from_json}

///|
pub extend TodoItem with Debug::{to_repr}

///|
pub extend TodoItem with Eq::{not_equal, equal}

///|
pub extend TodoItem with @json.FromJson::{from_json}

///|
pub extend TodoItem with ToJson::{to_json}

///|
pub extend TodoListItem with Debug::{to_repr}

///|
pub extend TodoListItem with Eq::{not_equal, equal}

///|
pub extend ThreadItem with Eq::{not_equal, equal}

///|
pub extend Turn with Eq::{not_equal, equal}

///|
pub extend UserInput with Eq::{not_equal, equal}

///|
pub extend Input with Eq::{not_equal, equal}

///|
pub extend ApprovalMode with Debug::{to_repr}

///|
pub extend ApprovalMode with Eq::{not_equal, equal}

///|
pub extend SandboxMode with Debug::{to_repr}

///|
pub extend SandboxMode with Eq::{not_equal, equal}

///|
pub extend ModelReasoningEffort with Debug::{to_repr}

///|
pub extend ModelReasoningEffort with Eq::{not_equal, equal}

///|
pub extend WebSearchMode with Debug::{to_repr}

///|
pub extend WebSearchMode with Eq::{not_equal, equal}

///|
pub extend ThreadOptions with Eq::{not_equal, equal}

///|
pub extend TurnOptions with Debug::{to_repr}

///|
pub extend TurnOptions with Eq::{not_equal, equal}
