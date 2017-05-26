Filter Design
=============

This directory containts the filter design toolchain. It is primarily based
on Matlab.

There are two basic workflows which are supported:

- Matlab's graphical user interface.
- Invocation of Matlab via command line.

The core for both of these approaches is the same: Filter design scripts
in the `generators/` directory.


Generators
==========

These are filter design scripts which produce various filter designs
through iteration (though not optimization (yet)). They may or may not
write their results to files or display them in Matlab figures.

The generators are the backbone of the filter design toolchain; the
main work happens there.

Adding New Generators
---------------------

- Write a new generator script and put it into the `generators/` directory.
- Write the dispatching script part into `cliDispatcher.m`. This part is
responsible for setting the filter design parameters:
  - pass band ripple
  - stop band attenuation
  - pass band edge frequency
  - stop band edge frequency
- Add an invocation of `cliDispatcher.m` to the `Makefile` and to `guiwrapper.m`.
You don't technically need to do both, but it keeps things nice and proper and 
allows anyone else who might ever want to work with this to have both options.


Designing New Filters With Existing Generators
----------------------------------------------

If you want to design new filtes but have no need to write a new generator,
as the above section might have you suspect, you can this as follows: Write
the appropriate dispatching script section in `cliDispatcher.m` and add the
calling commands to the `Makefile` and `guiWrapper.m`.


Running in Graphical Mode
=========================

Invoked via the `guiWrapper.m` file. Set the `filtertype` variable as
needed and call `cliDispatcher.m` from there from within Matlab. 

The basic idea is to execute a single code block via `Ctrl` + `Return`,
but you can run the enture script via `F5` as usual.

Call Structure
--------------

From within Matlab:

```
.
└── guiWrapper.m
    └── cliDispatcher.m
        ├── generators/
        ├── coefData/
        └── plotData/
```


Running in Commandline Mode
===========================

Allows to run the filter design toolchain from the command line.

Call Structure
--------------

Invoked from command line.

```
.
└── Makefile
    └── cliDispatcher.m
        ├── generators/
        ├── coefData/
        └── plotData/
```

Building Everything
-------------------

There is a special `make all` target which uses a single Matlab instance
to generate all filters. Using this is therefore much more efficient if
you want to generate all filters, since if you launch each filter design
command with its own `make` target, a single Matlab instance will be launched
for each target.

It also does not launch the JVM and exits after completion. As usual, 
invoke via:

```
make all
```


Output Files
============

Output files with filter coefficients and plot data are stored in two directories:

```
coefData
plotData
```
These directories will be created during execution if they do not already
exist.

`coefData` contains coefficient files for filter types which have coefficients.
The format complies with `.coe` files for Xilinx.

`plotData` are data points from the `fvtool` utility for further processing
with other tools (e.g. `pgfplots` in LaTeX, or whatever one's heart desires).

Note that these directories are in the `.gitignore` file and will be ignored
by Git unless you remove them.


Filename Specification
----------------------

The filenames in these directories correspond to the following scheme:
```
r-VVV--fp-WWW--fst-XXX--ap-YYY--ast-ZZ.ext
r-VVV--fp-WWW--fst-XXX--ap-YYY--ast-ZZ--stages-S.ext
```

Where:
```
 VVV: Three digits indicating decimation factor, zero-padded from left.
 WWW: Three digits inticating pass band edge, normalized, multiplied by 1000.
      Example: 250 corresponds to Fp = 0.250
 XXX: Stop band edge frequency, normalized, multiplied by 1000. Same as WWW.
 YYY: Passband ripple in dB, multiplied by 1000.
      Example: 300 corresponds to 0.3 dB passband ripple
  ZZ: Stop band attenuation in dB, zero-padded to two digits.
   S: Number of stages in case of a cascade file
 ext: File extension.
```


FAQ
===

## Why So Convoluted?

We are trying to keep everything in this project as flexible and scriptable
as possible. Besides that,I like Vim, and prefer it to Matlab's text editor,
so the CLI approach suits me well. But I acknowledge that this is not
everyone's preference; hence the `guiWrapper.m` script.

## How to Write generators?

However you like. As said, I like Vim; you may create your generators
directly in Matlab or in another editor of your choosing. I've heard
good things about `ex`. ;-)

The basic idea behind the generators is that they iterate through a number
of filter design parameters. There is nothing technically binding you to
that though.


Secondary Material
==================

- `examples` contains examples from other sources, either unchanged or
slightly modified.
- `deprecated` contains old design and sandbox files which are no longer
relevant for the system implementation, but might still have some
illustrative purpose, and are therefore kept around.


Side Note on Downsampling to Audio CD
=====================================

Hypothetically, if we were to want to downsample to 44.1 kHz:

```
125000000 = 2*2*2*2*2*2    *5*5*5*5*5*5*5*5*5     = 2^6 * 5^9
    44100 =         2*2*3*3*5*5              *7*7 = 2^2 * 3^2 * 5^2 * 7^2

Sought:
        L
125e6 * - = 44.1e3
        R
```

Therefore:
```
125e6    R
------ = -
44.1e3   L
```

Decomposing into prime factors and determining the rate change fraction:

```
2^6 * 5^9               2^4 * 5^7   1.25e6   R
--------------------- = --------- = ------ = -
2^2 * 3^2 * 5^2 * 7^2   3^2 * 7^2     441    L

R = 1.25e6
L =  441

125e6 * 441 = 5.4466e10
```

The frequency before sampling down is therefore __5.5566e10__.
