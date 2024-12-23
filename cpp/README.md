# myapp

This is a template to easily get started with a C++ application using Nix.
Structure is based on [The Pitchfork Layout](https://github.com/vector-of-bool/pitchfork).

**1. Make directory and initiate template**

``` shell
$ mkdir mysuperapp && cd mysuperapp
$ nix flake init -t github:storvik/nix-templates#cpp
```

**2. Change name**

Replace all instances of _myapp_ with new name.
This can be done by using the following oneliner:

``` shell
$ grep --exclude=README.md -rl myapp . | xargs sed -i 's/mylib/mysuperapp/g'
```

**3. Add third party dependencies, if any**

To add third party libraries to both `CMakeLists.txt` and `flake.nix`.

**4. Develop and build**

Development can be done in a `nix shell`by running:

``` shell
$ nix develop
$ mkdir build
$ cmake -Bbuild -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
$ cd build
$ ninja
```

To build with Nix:

``` shell
$ nix build
```

In order to build and run tests theres a `myapptest` package that can be used.
This sets `doCheck = true` and adds `-DENABLE_TESTING=ON`cmake flag.

``` shell
$ nix build .#myapptest --print-build-logs
```

Note that `--print-build-logs` prints build log to screen, which is hidden by default when using `nix build`.
