# hello-world

This is a template to easily get started with a Rust project utilizing Nix.

**1. Make directory and initiate template**

``` shell
$ mkdir myrustapp && cd myrustapp
$ nix flake init -t github:storvik/nix-templates#rust
```

**2. Change name**

Replace all instances of _mylib_ with new name.
This can be done by using the following oneliner:

``` shell
$ grep --exclude=README.md -rl mylib . | xargs sed -i 's/mylib/myrustapp/g'
```

**3. Add third party dependencies, if any**

Add dependencies to `flake.nix`.

**4. Generate lockfile**

Generate `Cago.lock` lockfile.

``` shell
$ cargo generate-lockfile
```

**5. Develop and build**

Development can be done in a `nix shell`by running:

``` shell
$ nix develop
$ cargo run
```

To build with Nix:

``` shell
$ nix build
```

Note that `--print-build-logs` prints build log to screen, which is hidden by default when using `nix build`.
