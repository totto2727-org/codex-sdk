name = "totto2727/codex-sdk"

version = "0.2.0"

readme = "README.mbt.md"

repository = "https://github.com/totto2727-org/codex-sdk"

license = "MIT"

keywords = [ "openai", "codex", "sdk", "moonbit" ]

description = "MoonBit SDK for embedding the Codex agent in workflows and applications"

preferred_target = "native"

supported_targets = "+wasm+native"

import {
  "moonbitlang/x@0.4.47",
  "moonbitlang/async@0.20.3",
  "totto2727/agent-core-sdk@0.1.0",
  "totto2727/copy@0.2.0",
  "totto2727/lens@0.4.0",
}

source = "./src"
