///|
/// Accept only JSON numbers, keeping the CLI's historical Int32 conversion.
#derive(Default)
priv struct WireInt_(Int32)

///|
impl @json.FromJson for WireInt_ with fn from_json(json, path) {
  match json {
    Number(value, ..) => WireInt_(value.to_int())
    _ => raise path.error("expected a JSON number")
  }
}

///|
#custom.serde(decode_only)
priv struct UsageWire_ {
  input_tokens : WireInt_
  cached_input_tokens : WireInt_
  #custom.serde(default)
  cache_write_input_tokens : WireInt_
  output_tokens : WireInt_
  reasoning_output_tokens : WireInt_
}

///|
pub impl @json.FromJson for Usage with fn from_json(json, path) {
  let wire : UsageWire_ = @json.from_json(json, path~)
  {
    input_tokens: wire.input_tokens.0,
    cached_input_tokens: wire.cached_input_tokens.0,
    cache_write_input_tokens: wire.cache_write_input_tokens.0,
    output_tokens: wire.output_tokens.0,
    reasoning_output_tokens: wire.reasoning_output_tokens.0,
  }
}

///|
pub extend Usage with @json.FromJson::{from_json}

///|
#custom.serde(decode_only)
priv struct ThreadDiscriminator_ {
  #custom.serde(rename="type")
  tag : String
}

///|
pub impl @json.FromJson for ThreadEvent with fn from_json(json, path) {
  guard json is Json::Object(_) else {
    raise @json.JsonDecodeError((path, "thread event must be an object"))
  }
  let discriminator : ThreadDiscriminator_ = @json.from_json(json, path~)
  match discriminator.tag {
    "thread.started" => ThreadStarted(@json.from_json(json, path~))
    "turn.started" => TurnStarted(@json.from_json(json, path~))
    "turn.completed" => TurnCompleted(@json.from_json(json, path~))
    "turn.failed" => TurnFailed(@json.from_json(json, path~))
    "item.started" => ItemStarted(@json.from_json(json, path~))
    "item.updated" => ItemUpdated(@json.from_json(json, path~))
    "item.completed" => ItemCompleted(@json.from_json(json, path~))
    "error" => StreamError(@json.from_json(json, path~))
    tag =>
      raise path.add_key("type").error("unsupported thread event type: \{tag}")
  }
}

///|
pub extend ThreadEvent with @json.FromJson::{from_json}
