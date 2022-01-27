# nix-templates

This repo contains useful templates for scaffolding various projects.

## Usage

Templates in this repo can be initiated using the `nix flake` command.
All templates can be listed by running:

``` shell
$ nix flake show github:storvik/nix-templates
```

To initiate the `cpp-library` template run the following command:

``` shell
$ nix flake init -t github:storvik/nix-templates#cpp-library
```
