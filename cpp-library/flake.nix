{
  description = "C++ library description";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, gitignore, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        gitignoreSource = (import gitignore { inherit (pkgs) lib; }).gitignoreSource;
      in
      rec {
        packages.mylib = with pkgs; stdenv.mkDerivation {
          name = "mylib";
          version = "0.0.1";

          src = gitignoreSource ./.;

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

        devShell = pkgs.mkShell {
          buildInputs = [
            packages.mylib.nativeBuildInputs
            packages.mylib.buildInputs
          ];
        };

        defaultPackage = packages.mylib;

      });
}
