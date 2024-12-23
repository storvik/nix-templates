{
  description = "C++ application description";

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

    rec {
      packages = forAllSystems (pkgs: rec {
        myapp = with pkgs; stdenv.mkDerivation {
          name = "myapp";
          version = "0.0.1";

          src = lib.cleanSource ./.;

          nativeBuildInputs = [
            cmake
            ninja
            gtest
          ] ++ lib.optionals (stdenv.isDarwin) [
            lldb
          ] ++ lib.optionals (stdenv.isLinux) [
            gdb
          ];

          buildInputs = [
            spdlog
          ];
        };

        myapptest = myapp.overrideAttrs (oldAttrs: rec {
          doCheck = true;
          cmakeFlags = [ "-DENABLE_TESTING=ON" ];
        });

        default = myapp;
      });

      devShells = forAllSystems
        (pkgs: {
          default = pkgs.mkShell rec {
            buildInputs = [
              packages."${pkgs.system}".myapp.nativeBuildInputs
              packages."${pkgs.system}".myapp.buildInputs
            ];
          };
        });

    };
}
