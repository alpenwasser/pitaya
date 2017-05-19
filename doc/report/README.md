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

As long as no more externalized  `tikzpicture`s are generated or index entries
changed/added, `make` will suffice from then on.

There is  also `make debug`, which  is equivalent to `make`,  except it prints
`pdflatex` 's debugging output to the console.

## counttexruns

The `counttexrunx` package  is used to track the total  number of compilations
of the document.  To avoid overwriting each other's `Main.ctr` file, but still
have a  backup of it  in the  git repository, there  is a `meta`  target which
copies the  `Main.ctr` file  into the `meta`  directory, with  a host-specific
suffix and the host name appended to the file.

Usage:
```
make meta
```
This will copy `build/Main.ctr` to `meta/Main.ctr.HOST_ID`, where `HOST_ID` is
a host-unique  identifier (`meta/machine-id`). The  hostname (`meta/hostname`)
is also appended to the file.

The machine id  and hostname in `meta/machine-id` and  `meta/hostname` have to
be set manually for each host. On  Linux, you can potentially base the machine
ID  on  `/etc/machine-id` and  take  the  hostname from  `/etc/hostname`.   On
machines where these  are not available, you can  create `meta/machine-id` and
`meta/hostname` manually and fill them  with the desired string. Note that the
machine ID should be a valid string for a file name.

**NOTE**: The machine-id is considered confidential  and should not be exposed
to  untrusted environments. If  you  wish to  base  `meta/machine-id` on  your
`/etc/machine-id`, hash  the latter and  put the  result into the  former (for
example).   

See here: http://man7.org/linux/man-pages/man5/machine-id.5.html


## Ti*k*Z Cache
```
make tikz
```
Note that you'll  need to have compiled  the document at least  once before in
order  for Ti*k*Z  to collect  the  information on  which images  it needs  to
generate, and to  create the `build/Main.makefile`, which is  needed for `make
tikz`.

`make tikz` will use `build/Main.makefile` to process multiple `tikzpictures`s
in parallel.  You can modify the `CORE_COUNT` variable in the Makefile to your
machine's  core count  (default: 4). Careful when  pushing or  pulling though;
that change might get overwritten.

## makeindex
The index can be built with
```
make index
```
Note that you'll need to have built the document at least once before this via
either `make` or `make debug`, in  order to generate the `build/Main.idx` file
which is used as the input for `makeindex`.

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


Sandbox
=======

The  `sandbox` directory  contains  code snippets  and standalone  experiments
which may or may not at some  point be integrated into the main document. Code
which is integrated into the main document from the sandbox should be put into
a proper place, not into the  sandbox. Nothing in the sandbox should be relied
upon to build the main document.


Resources
=========
VHDL Listings:
https://tex.stackexchange.com/a/369808/131649
