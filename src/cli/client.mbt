// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codex.ts

///| Main client for interacting with the Codex agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codex.ts#L6-L13
pub struct Client {
  priv exec : Exec
  priv options : Options
}

///| Constructs a Codex client.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codex.ts#L15-L19
pub fn Client::Client(options? : Options = Options::Options()) -> Client {
  {
    exec: Exec::Exec(
      options.executable_path_override,
      options.env,
      options.config,
    ),
    options,
  }
}

///| Starts a new persisted conversation with an agent.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codex.ts#L21-L27
pub fn Client::start_thread(
  self : Client,
  options? : ThreadOptions = ThreadOptions::ThreadOptions(),
) -> Thread {
  Thread::Thread(self.exec, self.options, options)
}

///| Resumes a persisted conversation by thread identifier.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codex.ts#L29-L38
pub fn Client::resume_thread(
  self : Client,
  id : String,
  options? : ThreadOptions = ThreadOptions::ThreadOptions(),
) -> Thread {
  Thread::Thread(self.exec, self.options, options, id~)
}
