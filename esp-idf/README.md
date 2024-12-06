# my-esp-idf

This is a template to easily get started with a ESP-IDF project.

**1. Make directory and initiate template**

``` shell
$ mkdir myespproj && cd myespproj
$ nix flake init -t github:storvik/nix-templates#esp-idf
```

**2. Change name**

Replace all instances of _mylib_ with new name.
This can be done by using the following oneliner:

``` shell
$ grep --exclude=README.md -rl my-esp-idf . | xargs sed -i 's/mylib/myespproj/g'
```

**3. Develop and build**

Development can be done in a `nix shell`by running:

``` shell
$ nix develop
$ idf.by build -DCMAKE_EXPORT_COMPILE_COMMANDS=1
$ idf.by -p /dev/devicesomething flash monitor
```
