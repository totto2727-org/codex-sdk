// Direct test port of https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts

///|
/// Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L47
async test "Exec run - rejects when exit happens before stdout closes" {
  with_cli_fixture(async fn(fixture) {
    let environment = fixture.environment([])
    environment.set("FAKE_CODEX_HOLD_STDOUT", "1")
    environment.set("FAKE_CODEX_STDERR", "early failure")
    environment.set("FAKE_CODEX_EXIT_CODE", "17")
    let thread = fixture.client(environment).start_thread()
    let detail = try {
      @async.with_timeout(2000, async fn() {
        thread.run(@codex.Prompt("fail early")) |> ignore
      })
      "no error"
    } catch {
      @codex.SdkError::ExecFailed(code~, stderr~) => "\{code}:\{stderr.trim()}"
      error =>
        if @async.is_cancellation_error(error) {
          "timed out"
        } else {
          "unexpected:\{error}"
        }
    }
    inspect(detail, content="17:early failure")
  })
}

///|
/// Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L74
async test "Exec run - places resume args before image args" {
  with_cli_fixture(async fn(fixture) {
    let client = fixture.client(
      fixture.environment([completed_events("thread-1", "item-1", "Hi!")]),
    )
    client
    .resume_thread("thread-1")
    .run(
      @codex.UserInputs([
        @codex.Text("describe"),
        @codex.LocalImage(@path.Path("first.png")),
        @codex.LocalImage(@path.Path("second.jpg")),
      ]),
    )
    |> ignore
    let args = fixture.recorded_lines("args", 1).join(",")
    assert_true(
      args.contains("resume,thread-1,--image,first.png,--image,second.jpg"),
    )
  })
}

///|
/// Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L100
async test "Exec env - allows overriding environment passed to CLI" {
  with_cli_fixture(async fn(fixture) {
    let environment = fixture.environment([
      completed_events("thread-1", "item-1", "Hi!"),
    ])
    environment.set("CUSTOM_ENV", "custom")
    let client = Client::Client(
      options=Options::Options(
        executable_path_override=fixture.executable,
        base_url="https://api.example.test/v1",
        api_key="secret-test-key",
        env=environment,
      ),
    )
    client.start_thread().run(@codex.Prompt("Hello")) |> ignore
    let recorded_environment = fixture.recorded_lines("env", 1)
    assert_true(recorded_environment.contains("CUSTOM_ENV=custom"))
    assert_true(recorded_environment.contains("CODEX_API_KEY=secret-test-key"))
    assert_true(
      recorded_environment.contains(
        "CODEX_INTERNAL_ORIGINATOR_OVERRIDE=codex_sdk_mbt",
      ),
    )
    assert_true(
      contains_pair(
        fixture.recorded_lines("args", 1),
        "--config",
        "openai_base_url=\"https://api.example.test/v1\"",
      ),
    )
  })
}

///| Runtime substitution for the upstream Node package-layout test.

///| Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L149

///|
/// Runtime difference: MoonBit has no Node optional-package layout, so this proves the corresponding explicit executable override and process launch.
async test "Exec path - launches the explicit executable override" {
  with_cli_fixture(async fn(fixture) {
    let client = fixture.client(
      fixture.environment([completed_events("thread-1", "item-1", "Hi!")]),
    )
    let turn = client.start_thread().run(@codex.Prompt("Hello"))
    inspect(turn.final_response, content="Hi!")
  })
}

///| Runtime substitution for the upstream package PATH-prepend test.

///| Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L182

///|
/// Runtime difference: without Node vendor directories, MoonBit passes the caller-provided PATH through unchanged.
async test "Exec env - preserves caller PATH entries without rewriting them" {
  with_cli_fixture(async fn(fixture) {
    let environment = fixture.environment([
      completed_events("thread-1", "item-1", "Hi!"),
    ])
    let path = "/opt/codex/bin:/usr/bin:/opt/codex/bin"
    environment.set("PATH", path)
    fixture.client(environment).start_thread().run(@codex.Prompt("Hello"))
    |> ignore
    assert_true(fixture.recorded_lines("env", 1).contains("PATH=\{path}"))
  })
}

///| Runtime substitution for the upstream Windows Path-key test.

///| Upstream test: https://github.com/openai/codex/blob/f201c30c52a35f819262865a53df94b6f4ea7a50/sdk/typescript/tests/exec.test.ts#L192

///|
/// Runtime difference: without Node PATH prepending, MoonBit preserves the supplied key verbatim.
async test "Exec env - preserves the Windows Path key" {
  with_cli_fixture(async fn(fixture) {
    let environment = fixture.environment([
      completed_events("thread-1", "item-1", "Hi!"),
    ])
    environment.remove("PATH")
    environment.set("Path", "C:\\Windows\\System32")
    fixture.client(environment).start_thread().run(@codex.Prompt("Hello"))
    |> ignore
    let recorded_environment = fixture.recorded_lines("env", 1)
    assert_true(recorded_environment.contains("Path=C:\\Windows\\System32"))
    assert_true(
      !recorded_environment.iter().any(line => line.has_prefix("PATH=")),
    )
  })
}
