Report
======

Obvious title is obvious.


Building
========

When starting from a clean directory:
```
make
make tikz
make index
make
```

As long as  no more externalized `tikzpicture`s are generated,  `make` will do
from then on.

There  is also  `make  debug`, for  when  one wants  debugging  output on  the
console.

## counttexruns

To avoid overwriting each other's `Main.ctr`  file, but still have a backup of
it in the git repository, there is a `meta` target which copies the `Main.ctr`
file into the `meta` directory, with a user-specific suffix.

Usage:
```
make meta user=<USERNAME>
```

This will copy `build/Main.ctr` to `meta/Main.ctr.USERNAME`.


## makeindex

When starting from a clean directory:
```
make
make index
make
```

## bundledoc

For archival purposes, `snapshot` and  `bundledoc` can be used. The `snapshot`
package creates a list of all  dependencies of the document (class files, font
files, etc.),  while the `bundledoc`  utility (a Perl  script) can be  used to
gather all files from that list and pack them, and all else which is needed to
build the document, into an archive.

### Creating an Archive

`snapshot` 's  dependency list file  will be placed  in `build/Main.dep`. Each
compilation of the document will update the list.

**NOTE:** The  `snapshot` package  collects some  superfluous (I  think) files
which will then raise an error because they cannot be found:

- `Main.w18`
- `Main.out` (twice)
- `Main.ind`

The  `make  bundle`  target  from   the  Makefile  automatically  filters  out
any  entries   from  `build/Main.dep`  containing  `Main`   to  prevent  these
errors. Create the bundle file via:

```
make bundle
```

This will create a timestamped `meta/Main--YYYY-MM-DD--hh-mm-ss.tar.xz` file.

Note that the `snapshot` package does not  correctly pick up the code files so
the Makefile copies those into the archive manually, along with itself.


### Building From an Archive

Extract the snapshot `.tar.xz` somewhere, change into the `Main` directory and
build according to the above instructions (`make` etc.).


Resources
=========
VHDL Listings:
https://tex.stackexchange.com/a/369808/131649
