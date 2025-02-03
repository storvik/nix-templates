{
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, android-nixpkgs }:
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

      devShells = forAllSystems (pkgs:
        let
          android-sdk = android-nixpkgs.sdk.${pkgs.system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            build-tools-33-0-1
            platform-tools
            platforms-android-34
            platforms-android-35
            emulator
          ]);
        in
        {
          default = pkgs.mkShell rec {
            packages = [
              pkgs.flutter
              pkgs.dart # needed in order to have a working dart formatter
              pkgs.jdk17
            ];

            # This is disabled as it was causing issues, however kept around for reference.
            # GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/33.0.1/aapt2";
            ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
            ANDROID_HOME = "${android-sdk}/share/android-sdk";
            JAVA_HOME = pkgs.jdk17;

          };
        });

    };
}
