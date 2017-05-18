Report
======

Obvious title is obvious.


Building
========

When starting from a clean directory:
```
make
make tikz
make
```

As long as no more externalized `tikzpicture`s are generated, `make` will do.

There is also `make debug`, for when one wants debugging output on the console.

## counttexruns

To avoid overwriting each other's `Main.ctr` file, but still have a backup of it
in the git repository, there is a `meta` target which copies the `Main.ctr` file
into the `meta` directory, with a user-specific suffix.

Usage:
```
make meta user=<USERNAME>
```

This will copy `build/Main.ctr` to `meta/Main.ctr.USERNAME`.

Resources
=========
VHDL Listings:
https://tex.stackexchange.com/a/369808/131649
