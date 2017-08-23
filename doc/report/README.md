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
package  creates a  list of  all dependencies  of the  document (class  files,
package  files, font  files,  etc.),  while the  `bundledoc`  utility (a  Perl
script) can be used to gather all files  from that list and pack them, and all
else which is needed to build the document, into an archive.

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
errors. Before running the `bundle` target,  make sure to compile the document
at  least once  before to  create the  `build/Main.dep` file. Then  create the
bundle file via:
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

Install solarized theme for pygments:
```
# pip install pygments-style-solarized
```

Statistics (v1.0.2, 2017-AUG-23)
================================

## Word Count

```
texcount chunks/*.tex

Total
-----------------------------------------
Words:                              27067

of which:
Words in text:                      24157
Words in headers:                     389
Words outside text (captions, etc.): 2521

Number of headers:                    153
Number of floats/tables/figures:       70
Number of math inlines:               195
Number of math displayed:              32
Files:                                 20

Subcounts (sorted by text word count)
-------------------------------------------------------------------------------------
  total text headers captions  #headers #floats #inlines #displayed File
   5963 4913      32     1018        13      21       99         19 chunks/theory.tex
   4072 3891      95       86        31       0        1          0 chunks/devguide.tex
   2734 2572      44      118        18       5        9          1 chunks/mission.tex
   2719 2485      43      191        21       7       16          4 chunks/gui.tex
   2105 1878      33      194         9       3       10          3 chunks/fpga.tex
   1874 1782      26      166        11       4       17          0 chunks/fdesign.tex
   1612 1322      13      277         6      11       22          2 chunks/verification.tex
   1049 1024      11       14         6       0        0          0 chunks/appgui.tex
    970  930       9       31         2       1        0          0 chunks/introduction.tex
    984  742      11      231         3       9       15          3 chunks/apptheory.tex
    632  605      13       14         7       1        0          0 chunks/server.tex
    645  586       2       57         2       5        0          0 chunks/userguide.tex
    422  421       1        0         1       0        0          0 chunks/conclusion.tex
    480  312      44      124        16       3        6          0 chunks/appfdesign.tex
    309  306       3        0         2       0        0          0 chunks/abstract.tex
    210  206       4        0         2       0        0          0 chunks/licenses.tex
    116  115       1        0         1       0        0          0 chunks/thanks.tex
     64   62       2        0         1       0        0          0 chunks/media.tex
      3    3       0        0         0       0        0          0 chunks/info.tex
      4    2       2        0         1       0        0          0 chunks/task.tex
```

## Build Time (2 x X5680 Xeon, 12 PC/24 LC)

When building from a clean directory:
```
time make
make        101.91s user  1.23s system  99% cpu  1:43.75 total
time make tikz
make tikz  5556.67s user 11.26s system 725% cpu 12:47.14 total
time make
make         72.34s user  0.37s system  99% cpu  1:12.80 total                           
```

## File Sizes
File size without Ti*k*Z pictures: 3.8 MiB
File size with Ti*k*Z pictures: 14 MiB

## Page Count (oneside)
Pages without Ti*k*Z pictures: 111
Pages with Ti*k*Z pictures: 143
