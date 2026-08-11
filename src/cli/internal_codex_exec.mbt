// Direct port of Codex-specific execution helpers from https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts

///| Mirrors the upstream internal originator variable.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L43-L45
const INTERNAL_CODEX_ORIGINATOR_ENV : String = "CODEX_INTERNAL_ORIGINATOR_OVERRIDE"

// Type/language difference: the originator identifies this MoonBit port instead of the TypeScript SDK.
// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L43-L45

///|
const INTERNAL_CODEX_MOONBIT_SDK_ORIGINATOR : String = "codex_sdk_mbt"

///| Serializes Codex config overrides before per-thread arguments.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L246-L250
fn internal_codex_serialize_config_overrides(
  config : ConfigObject,
) -> Array[String] raise SdkError {
  let overrides : Array[String] = []
  internal_codex_flatten_config_overrides(ConfigObject(config), "", overrides)
  overrides
}

///| Flattens nested Codex config objects into dotted CLI override paths.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L252-L290
fn internal_codex_flatten_config_overrides(
  value : ConfigValue,
  prefix : String,
  overrides : Array[String],
) -> Unit raise SdkError {
  match value {
    ConfigObject(object) => {
      if prefix == "" && object.is_empty() {
        return
      }
      if prefix != "" && object.is_empty() {
        overrides.push("\{prefix}={}")
        return
      }
      for key, child in object {
        guard key != "" else {
          raise InvalidConfig(
            path=prefix,
            message="Codex config override keys must be non-empty strings",
          )
        }
        let path = if prefix == "" { key } else { "\{prefix}.\{key}" }
        match child {
          ConfigObject(_) =>
            internal_codex_flatten_config_overrides(child, path, overrides)
          _ =>
            overrides.push(
              "\{path}=\{internal_codex_to_toml_value(child, path)}",
            )
        }
      }
    }
    _ =>
      if prefix == "" {
        raise InvalidConfig(
          path="",
          message="Codex config overrides must be a plain object",
        )
      } else {
        overrides.push(
          "\{prefix}=\{internal_codex_to_toml_value(value, prefix)}",
        )
      }
  }
}

///| Converts one Codex config value to the TOML literal accepted by `--config`.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L292-L323
fn internal_codex_to_toml_value(
  value : ConfigValue,
  path : String,
) -> String raise SdkError {
  match value {
    ConfigString(text) => Json::string(text).stringify()
    ConfigInt(number) => number.to_string()
    ConfigDouble(number) => {
      guard !number.is_nan() && !number.is_inf() else {
        raise InvalidConfig(
          path~,
          message="Codex config override must be a finite number",
        )
      }
      number.to_string()
    }
    ConfigBool(value) => if value { "true" } else { "false" }
    ConfigArray(values) =>
      "[\{values.mapi((index, item) => internal_codex_to_toml_value(item, "\{path}[\{index}]")).join(", ")}]"
    ConfigObject(object) => {
      let parts : Array[String] = []
      for key, child in object {
        guard key != "" else {
          raise InvalidConfig(
            path~,
            message="Codex config override keys must be non-empty strings",
          )
        }
        parts.push(
          "\{internal_codex_format_toml_key(key)} = \{internal_codex_to_toml_value(child, "\{path}.\{key}")}",
        )
      }
      "{\{parts.join(", ")}}"
    }
  }
}

///| Formats a TOML key exactly as the upstream TOML_BARE_KEY branch.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L325-L328
fn internal_codex_format_toml_key(key : String) -> String {
  let is_bare = key
    .iter()
    .all(char => {
      char.is_ascii_alphabetic() ||
      char.is_ascii_digit() ||
      char == '-' ||
      char == '_'
    })
  if is_bare {
    key
  } else {
    Json::string(key).stringify()
  }
}
