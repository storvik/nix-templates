# qt-application

This is a template to easily get started with a Qt application utilizing Nix.
Structure is based on [The Pitchfork Layout](https://github.com/vector-of-bool/pitchfork).

**1. Make directory and initiate template**

``` shell
$ mkdir mysuperqtapp && cd mysuperqtapp
$ nix flake init -t github:storvik/nix-templates#qt-application
```

**2. Change name**

Replace all instances of _myqtapp_ with new name.
This can be done by using the following oneliner:

``` shell
$ grep --exclude=README.md -rl myqtapp . | xargs sed -i 's/myqtapp/mysuperqtapp/g'
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

This will produce an executable in `./result/bin/`.
Executable can be run directly with:

``` shell
$ nix run
```
