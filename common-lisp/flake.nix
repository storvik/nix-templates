{
  description = "Common lisp template description";

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

        devShell = pkgs.mkShell {
          buildInputs = [
            clpm
            sbcl
            ecl
          ];
        };

      });
}
