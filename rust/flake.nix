{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let

      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems)
          (system:
            function (import nixpkgs {
              inherit system;
              overlays = [ rust-overlay.overlays.default ];
              config = { };
            }));
      src = nixpkgs.lib.cleanSource ./.;
      cargoTOML = nixpkgs.lib.importTOML "${src}/Cargo.toml";
      mkRustToolchain = pkgs: pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

    in
    {

      packages = forAllSystems (pkgs:
        let
          toolchain = mkRustToolchain pkgs;
          rust = pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          };
        in
        rec {
          hello-world = rust.buildRustPackage {
            pname = cargoTOML.package.name;
            version = cargoTOML.package.version;

            nativeBuildInputs = [ ];

            inherit src;

            cargoLock = {
              lockFile = "${src}/Cargo.lock";
            };

          };
          default = hello-world;
        });

      devShells = forAllSystems (pkgs:
        let
          toolchain = mkRustToolchain pkgs;
        in
        {
          default = pkgs.mkShell rec {
            RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
            #RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
            packages = [
              toolchain

              # We want the unwrapped version, "rust-analyzer" (wrapped) comes with nixpkgs' toolchain
              pkgs.rust-analyzer-unwrapped
              pkgs.clippy
            ];

            buildInputs = with pkgs; [
              # Dependencies goes here
            ];

            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
          };
        });
    };
}
