// Direct test port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts

///| Runtime substitution for the upstream legacy package-layout fallback test.

///| Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L166

///|
/// Runtime difference: MoonBit resolves the unqualified `codex` executable through PATH.
test "Exec path - falls back to the PATH executable" {
  let exec = Exec::Exec(None, None, None)
  inspect(exec.executable_path.to_string(), content="codex")
}

///|
test "Config overrides - rejects null values" {
  let config : ConfigObject = { "approval_policy": Json::null() }
  try serialize_config_overrides_(config) |> ignore catch {
    InvalidConfig(path~, message~) => {
      inspect(path, content="approval_policy")
      inspect(message, content="Codex config override cannot be null")
    }
    _ => fail("unexpected config error")
  } noraise {
    _ => fail("expected invalid config")
  }
}

///|
test "Config overrides - rejects keys without dotted-path representation" {
  let config : ConfigObject = { "network.access": true }
  try serialize_config_overrides_(config) |> ignore catch {
    InvalidConfig(path~, message~) => {
      inspect(path, content="[\"network.access\"]")
      inspect(
        message,
        content="Codex config override paths must use dotted keys",
      )
    }
    _ => fail("unexpected config error")
  } noraise {
    _ => fail("expected invalid config")
  }
}
