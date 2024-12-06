{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
              overlays = [ esp-idf.overlays.default ];
              config = { };
            }));
    in
    {

      packages = forAllSystems
        (pkgs: {
          myqtapp =
            with import nixpkgs { system = system; };
            with libsForQt5;
            mkDerivation {
              name = "myqtapp";
              version = "0.0.1";

              src = lib.cleanSource ./.;

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
        });

      devShells = forAllSystems
        (pkgs: {
          default = pkgs.mkShell rec {
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
        });
    };
}
