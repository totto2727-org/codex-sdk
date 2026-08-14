// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts
// allow: SIZE_OK — this file intentionally preserves the upstream exec.ts responsibility boundary.

///| Mirrors ExecArgs from the upstream implementation.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L10-L41

///|
/// MoonBit uses Path for filesystem values and task cancellation instead of an AbortSignal field.
priv struct ExecArgs {
  input : String
  base_url : String?
  api_key : String?
  thread_id : String?
  images : Array[@path.Path]
  model : String?
  sandbox_mode : SandboxMode?
  working_directory : @path.Path?
  additional_directories : Array[@path.Path]
  skip_git_repo_check : Bool?
  output_schema_file : @path.Path?
  model_reasoning_effort : ModelReasoningEffort?
  network_access_enabled : Bool?
  web_search_mode : WebSearchMode?
  web_search_enabled : Bool?
  approval_policy : ApprovalMode?
}

///| Executes the Codex CLI and streams its JSONL output.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L63-L67

///| Runtime type difference: the upstream type stores `pathDirs` for directories bundled in the npm platform package; this MoonBit package has no npm optional-package resolver, so that property is intentionally absent.

///|
/// Upstream path type and bundled-directory resolution: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L58-L65 and https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L412-L430
struct Exec {
  executable_path : @path.Path
  env_override : Map[String, String]?
  config : ConfigObject?
}

///| Constructs the process adapter used by a Codex client.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L69-L84

///|
/// Runtime difference: MoonBit packages have no Node optional-package resolution context, so an omitted override resolves `codex` through PATH.
fn Exec::Exec(
  executable_path : @path.Path?,
  env : Map[String, String]?,
  config : ConfigObject?,
) -> Exec {
  {
    // Runtime default-resolution difference: the upstream implementation resolves its npm platform package and bundled executable, whereas MoonBit resolves `codex` through the process PATH when no override is supplied.
    // Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L69-L81 and https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L334-L410
    executable_path: executable_path.unwrap_or(@path.Path("codex")),
    env_override: env,
    config,
  }
}

///| Runs the CLI with the same argument ordering, environment behavior, and process lifecycle as the upstream generator.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L86-L243

///| Async type difference: MoonBit has no AsyncGenerator, so each decoded event is delivered to an async callback returning whether iteration should continue.

///|
/// Cancellation type difference: cancelling the owning MoonBit task replaces the upstream AbortSignal.
async fn Exec::run(
  self : Exec,
  args : ExecArgs,
  on_event : async (ThreadEvent) -> Bool,
) -> Unit {
  let command_args = ["exec", "--experimental-json"]
  if self.config is Some(config) {
    for item in serialize_config_overrides_(config) {
      command_args.push("--config")
      command_args.push(item)
    }
  }
  if args.base_url is Some(base_url) {
    command_args.push("--config")
    command_args.push(
      "openai_base_url=\{to_toml_value_(Json::string(base_url), "openai_base_url")}",
    )
  }
  if args.model is Some(model) {
    command_args.push("--model")
    command_args.push(model)
  }
  if args.sandbox_mode is Some(mode) {
    command_args.push("--sandbox")
    command_args.push(mode.to_string())
  }
  if args.working_directory is Some(directory) {
    command_args.push("--cd")
    command_args.push("\{directory}")
  }
  for directory in args.additional_directories {
    command_args.push("--add-dir")
    command_args.push("\{directory}")
  }
  if args.skip_git_repo_check == Some(true) {
    command_args.push("--skip-git-repo-check")
  }
  if args.output_schema_file is Some(schema_path) {
    command_args.push("--output-schema")
    command_args.push("\{schema_path}")
  }
  if args.model_reasoning_effort is Some(effort) {
    command_args.push("--config")
    command_args.push("model_reasoning_effort=\"\{effort.to_string()}\"")
  }
  if args.network_access_enabled is Some(enabled) {
    command_args.push("--config")
    command_args.push(
      "sandbox_workspace_write.network_access=\{if enabled { "true" } else { "false" }}",
    )
  }
  match (args.web_search_mode, args.web_search_enabled) {
    (Some(mode), _) => {
      command_args.push("--config")
      command_args.push("web_search=\"\{mode.to_string()}\"")
    }
    (None, Some(true)) => {
      command_args.push("--config")
      command_args.push("web_search=\"live\"")
    }
    (None, Some(false)) => {
      command_args.push("--config")
      command_args.push("web_search=\"disabled\"")
    }
    (None, None) => ()
  }
  if args.approval_policy is Some(policy) {
    command_args.push("--config")
    command_args.push("approval_policy=\"\{policy.to_string()}\"")
  }
  if args.thread_id is Some(thread_id) {
    command_args.push("resume")
    command_args.push(thread_id)
  }
  for image in args.images {
    command_args.push("--image")
    command_args.push("\{image}")
  }

  let environment = match self.env_override {
    Some(environment_override) => @copy.Copy::copy(environment_override)
    None => Map([])
  }
  let inherited_originator = if self.env_override is None {
    @env.get_env_var(ORIGINATOR_ENV_)
  } else {
    None
  }
  if environment.get(ORIGINATOR_ENV_) is None && inherited_originator is None {
    environment.set(ORIGINATOR_ENV_, MOONBIT_SDK_ORIGINATOR_)
  }
  if args.api_key is Some(value) {
    environment.set("CODEX_API_KEY", value)
  }
  // Runtime PATH difference: the upstream implementation prepends its bundled `pathDirs` here; MoonBit performs no equivalent mutation because it neither resolves nor stores npm-bundled directories.
  // Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L177-L179
  let inherit_environment = self.env_override is None

  let result = @agent_cli.run(
    @agent_cli.Invocation::new(
      command=self.executable_path.to_string(),
      arguments=command_args,
      environment~,
      inherit_environment~,
      input=args.input,
    ),
    on_event,
  ) catch {
    @agent_cli.AgentCliError::InvalidJson(line~, cause~) =>
      raise InvalidEvent(
        message="Failed to parse item: \{line}; cause: \{cause}",
      )
    error => raise error
  }
  match result {
    @agent_cli.RunResult::Completed | @agent_cli.RunResult::Stopped => ()
    @agent_cli.RunResult::Failed(code~, stderr~) =>
      raise ExecFailed(code~, stderr~)
  }
}
