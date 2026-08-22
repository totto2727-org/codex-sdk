{
  description = "A simple MoonBit library template";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    moonbit-overlay = {
      url = "github:totto2727-org/moonbit-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, moonbit-overlay, codex, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [
          moonbit-overlay.overlays.default
          codex.overlays.default
        ];
      };
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = mkPkgs system;
          defaultShell = pkgs.mkShell {
            packages = [
              pkgs.moonbit-bin.moonbit.latest
              # Uncomment when preferred_target = "js" in moon.mod.
              # pkgs.nodejs
            ];
          };
        in
        {
          default = defaultShell;
          ci = pkgs.mkShell {
            inputsFrom = [ defaultShell ];
            packages = [ pkgs.codex ];
          };
        });
    };
}
