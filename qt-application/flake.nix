{
  description = "A very basic flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, flake-utils, gitignore }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        gitignoreSource = (import gitignore { inherit (pkgs) lib; }).gitignoreSource;
      in
      rec {
        packages.myqtapp =
          with import nixpkgs { system = system; };
          with libsForQt5;
          mkDerivation {
            name = "myqtapp";
            version = "0.0.1";

            src = gitignoreSource ./.;

            nativeBuildInputs = [
              cmake
              ninja
              gdb
              wrapQtAppsHook
              makeWrapper
            ];

            buildInputs = [
              libsForQt5.qtbase
              libsForQt5.qttools # needed for designer
            ];

          };

        devShell = pkgs.mkShell {
          buildInputs = [
            packages.myqtapp.nativeBuildInputs
            packages.myqtapp.buildInputs
          ];

          shellHook = ''
            wrapdir=$(mktemp -d)
            if [ $XDG_SESSION_TYPE == "wayland" ]; then
                echo "QT_QPA_PLATFORM=wayland" > $wrapdir/qtenvs
            fi
            echo ''${qtWrapperArgs[@]} | \
                sed "s|--prefix |\nexport |g" | \
                sed "s| : |=|g" | \
                sed "s|QT_PLUGIN_PATH=|QT_PLUGIN_PATH=$\{QT_PLUGIN_PATH\}:|g" | \
                sed "s|QML2_IMPORT_PATH=|QML2_IMPORT_PATH=$\{QML2_IMPORT_PATH\}:|g" > $wrapdir/qtenvs
            source $wrapdir/qtenvs
          '';

        };

        defaultPackage = packages.myqtapp;

        defaultApp = {
          type = "app";
          program = "${packages.myqtapp}/bin/myqtapp";
        };

      });
}
