// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts

///| A JSON-shaped object whose values are serialized as TOML CLI overrides.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L3
pub type ConfigObject = Map[String, Json]

///| Client options shared by every thread created from a Codex client.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L5-L22

///|
/// Type difference: filesystem strings are represented by Path.
pub struct ClientOptions {
  /// Optional executable path. When omitted, the `codex` executable is resolved through `PATH`.
  executable_path_override : @path.Path?
  /// Optional API base URL forwarded to the Codex CLI configuration.
  base_url : String?
  /// Optional API key supplied to the Codex CLI process as `CODEX_API_KEY`.
  api_key : String?
  /// Optional JSON-shaped configuration values flattened into Codex CLI `--config` overrides.
  config : ConfigObject?
  /// Optional process environment override. When supplied, only this map is used as the process environment.
  env : Map[String, String]?
} derive(Eq)

///| Constructs the same optional client option fields as the upstream object type.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L5-L22

///|
/// Type difference: MoonBit structs require a constructor to provide the upstream empty-object defaults.
pub fn ClientOptions::ClientOptions(
  executable_path_override? : @path.Path,
  base_url? : String,
  api_key? : String,
  config? : ConfigObject,
  env? : Map[String, String],
) -> ClientOptions {
  { executable_path_override, base_url, api_key, config, env }
}
