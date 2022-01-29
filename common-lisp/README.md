# common-lisp template

This is a template to easily get started with a common lisp project.
Nix integration is so far lacking, I usually install `sbcl` and `clpm` globally.

**1. Make directory and initiate template**

``` shell
$ mkdir mynewclproject && cd mynewclproject
$ nix flake init -t github:storvik/nix-templates#common-lips
```

**2. Change name**

Replace all instances of _myclproject_ with new name.
This can be done by using the following oneliner:

``` shell
$ grep --exclude=README.md -rl myclproject . | xargs sed -i 's/myclproject/mynewclproject/g'
```

**3. Start REPL in Emacs and lisp away**
