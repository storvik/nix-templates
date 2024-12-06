{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esp-idf = {
      url = "github:mirrexagon/nixpkgs-esp-dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, esp-idf }:
    let
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems)
          (system:
            function (import nixpkgs {
              inherit system;
              overlays = [ esp-idf.overlays.default ];
              config = { };
            }));
    in
    {

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell rec {
          packages = [
            pkgs.clang-tools
            (pkgs.writeScriptBin "clang-format-all" ''
              #!${pkgs.bash}/bin/bash
              find ./ -iname '*.h' -o -iname '*.cpp' | xargs ${pkgs.clang-tools}/bin/clang-format -i
            '')

            (pkgs.esp-idf-esp32s3.override {
              rev = "v5.3.1";
              sha256 = "sha256-dGwkN+a2wYX5f/epDo+HPIhCGPziLQpTy0zfHiVUMls=";
            })
          ];
        };
      });
    };

}
