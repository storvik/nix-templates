{
  description = "C++ library description";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems)
          (system:
            function (import nixpkgs {
              inherit system;
              overlays = [ ];
              config = { };
            }));
    in

    {
      packages = forAllSystems (pkgs: {
        mylib = with pkgs; stdenv.mkDerivation {
          name = "mylib";
          version = "0.0.1";

          src = lib.cleanSource ./.;

          nativeBuildInputs = [
            cmake
            ninja
            gdb
            gtest
          ];

          buildInputs = [
            spdlog
          ];
        };

        mylibtest = packages.mylib.overrideAttrs (oldAttrs: rec {
          doCheck = true;
          cmakeFlags = [ "-DENABLE_TESTING=ON" ];
        });
      });

      devShells = forAllSystems
        (pkgs: {
          default = pkgs.mkShell rec {
            buildInputs = [
              packages.mylib.nativeBuildInputs
              packages.mylib.buildInputs
            ];
          };
        });
    };
}
