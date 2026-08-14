// Direct port of Codex-specific execution helpers from https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts

///| Mirrors the upstream internal originator variable.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L43-L45
const ORIGINATOR_ENV_ : String = "CODEX_INTERNAL_ORIGINATOR_OVERRIDE"

// Type/language difference: the originator identifies this MoonBit port instead of the TypeScript SDK.
// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L43-L45

///|
const MOONBIT_SDK_ORIGINATOR_ : String = "codex_sdk_mbt"

///|
/// Matches the maximum container depth accepted by `totto2727/x/json` paths.
const MAX_CONFIG_DEPTH_ : Int = 256

///| Serializes Codex config overrides before per-thread arguments.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L246-L250
fn serialize_config_overrides_(
  config : ConfigObject,
) -> Array[String] raise SdkError {
  let overrides : Array[String] = []
  let flattened = @x_json.flatten(
    Json::object(config),
    @x_json.JavaScript,
    array_mode=@x_json.Preserve,
  ) catch {
    @x_json.ObjectValue(path) =>
      raise InvalidConfig(
        path~,
        message="Codex config override contains an object leaf",
      )
    @x_json.AmbiguousPointerToken(path) =>
      raise InvalidConfig(
        path~,
        message="Codex config override contains an ambiguous path token",
      )
    @x_json.InvalidPath(path) =>
      raise InvalidConfig(
        path~,
        message="Codex config override path is invalid",
      )
    @x_json.PathLengthExceeded(length) =>
      raise InvalidConfig(
        path="",
        message="Codex config override path exceeds the length limit: \{length}",
      )
    @x_json.PathDepthExceeded(depth) =>
      raise InvalidConfig(
        path="",
        message="Codex config override path exceeds the depth limit: \{depth}",
      )
    @x_json.PathConflict(path) =>
      raise InvalidConfig(path~, message="Codex config override paths conflict")
    @x_json.ArrayIndexGap(path) =>
      raise InvalidConfig(
        path~,
        message="Codex config override has an array gap",
      )
  }
  for path, value in flattened {
    guard is_codex_dotted_path_(path) else {
      raise InvalidConfig(
        path~,
        message="Codex config override paths must use dotted keys",
      )
    }
    overrides.push(
      "\{path}=\{to_toml_value_(value, path, depth=path.split(".").length())}",
    )
  }
  overrides
}

///|
/// Checks the key syntax accepted by the Codex dotted config path boundary.
fn is_codex_dotted_path_(path : String) -> Bool {
  path
  .split(".")
  .all(segment => {
    segment.length() > 0 &&
    segment
    .iter()
    .all(char => {
      char.is_ascii_alphabetic() ||
      char.is_ascii_digit() ||
      char == '-' ||
      char == '_'
    })
  })
}

///| Converts one Codex config value to the TOML literal accepted by `--config`.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L292-L323
fn to_toml_value_(
  value : Json,
  path : String,
  depth? : Int = 1,
) -> String raise SdkError {
  guard depth <= MAX_CONFIG_DEPTH_ else {
    raise InvalidConfig(
      path~,
      message="Codex config override exceeds the depth limit: \{depth}",
    )
  }
  match value {
    Json::Null =>
      raise InvalidConfig(path~, message="Codex config override cannot be null")
    Json::True => "true"
    Json::False => "false"
    Json::String(text) => Json::string(text).stringify()
    Json::Number(number, repr~) => {
      guard !number.is_nan() && !number.is_inf() else {
        raise InvalidConfig(
          path~,
          message="Codex config override must be a finite number",
        )
      }
      repr.unwrap_or(number.to_string())
    }
    Json::Array(values) =>
      "[\{values.mapi((index, item) => to_toml_value_(item, "\{path}[\{index}]", depth=depth + 1)).join(", ")}]"
    Json::Object(object) => {
      let parts : Array[String] = []
      for key, child in object {
        guard key != "" else {
          raise InvalidConfig(
            path~,
            message="Codex config override keys must be non-empty strings",
          )
        }
        parts.push(
          "\{format_toml_key_(key)} = \{to_toml_value_(child, "\{path}.\{key}", depth=depth + 1)}",
        )
      }
      "{\{parts.join(", ")}}"
    }
  }
}

///| Formats a TOML key exactly as the upstream TOML_BARE_KEY branch.

///|
/// Upstream: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/src/exec.ts#L325-L328
fn format_toml_key_(key : String) -> String {
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
