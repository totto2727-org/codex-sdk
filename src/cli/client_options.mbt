// Direct port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts

///| A recursively typed Codex CLI configuration value.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L1-L3

///|
/// Type difference: MoonBit requires an explicit recursive enum in place of the TypeScript union.
pub(all) enum ConfigValue {
  ConfigString(String)
  ConfigInt(Int)
  ConfigDouble(Double)
  ConfigBool(Bool)
  ConfigArray(Array[ConfigValue])
  ConfigObject(Map[String, ConfigValue])
} derive(Debug, Eq)

///| A JSON-shaped object whose values are serialized as TOML CLI overrides.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L3
pub type ConfigObject = Map[String, ConfigValue]

///| Client options shared by every thread created from a Codex client.

///| Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/codexOptions.ts#L5-L22

///|
/// Type difference: filesystem strings are represented by Path.
pub struct ClientOptions {
  executable_path_override : @path.Path?
  base_url : String?
  api_key : String?
  config : ConfigObject?
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
