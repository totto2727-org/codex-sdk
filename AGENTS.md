# Codex SDK repository instructions

## Internal MoonBit implementation

- Put provider-specific private implementation details in `internal_*.mbt` files. Do not repeat `codex` in those filenames.
- Name private variables, functions, methods, constants, and private helper types that exist only for internal implementation with a trailing underscore, such as `serialize_config_overrides_` or `OutputSchemaFile_`. Do not prefix identifiers with `internal_` or abbreviate the prefix to `i_`.
- Keep files that define the shared provider interface focused on the common symbols. Move provider-specific protocol decoding, serialization, and temporary-resource helpers into `internal_*.mbt` files.
- Prefer typed Lens constructors, including `custom` for types with matching `FromJson` and `ToJson` wire contracts. Do not use `Lens[Json]` by default; when an opaque protocol payload requires a raw JSON lens, document that reason next to its declaration.
- Keep public API symbols provider-neutral and do not add compatibility aliases or shims for renamed internal symbols.
- Use `totto2727/x/json` for configuration flattening. Keep TOML literal conversion at the Codex CLI boundary until the shared Json/TOML conversion work tracked by TOT-186 is available as a normal registry dependency.
