Filter Design
=============

This directory containts the filter design toolchain. It is primarily based 
on Matlab.

There are two basic workflows which are supported:

- Matlab's graphical user interface.
- Invocation of Matlab via command line.

The core for both of these approaches is the same: Filter design scripts
in the `generators/` directory.


generators
==========

These are filter design scripts which produce various filter designs
through iteration (though not optimization (yet)). They may or may not 
write their results to files or display them in Matlab figures.

The generators are the backbone of the filter design toolchain; the
main work happens there.


Graphical Mode
==============

Graphical wrapper for working with the generators.

Straightforward:
- Write your filter design script, put it into the `generators/` directory.
- Open `guiDispatcher.m` in Matlab and call your iterator from there.


Commandline Mode
================

CLI wrapper for working with the generators.

- Write your filter design script, put it into the `generators/` directory.
- Make an entry for your script in the `cliDispatcher.m` file.
- Create a new target in the `Makefile` which calls `cliDispatcher.m` with
the appropriate arguments.
- Invoke via `make <yourtarget>`.

Building Everything
-------------------

There is a special `make all` target which uses a single Matlab instance
to generate all filters. Using this is therefore much more efficient if
you want to generate all filters, since if you launch each filter design
command with its own `make` target, a single Matlab instance will be launched
for each target.

It also does not launch the JVM and exits after completion. As usual, invoke via:

```
make all
```


Output Files
============

Output files with filter coefficients and plot data are stores in two directories:

```
coefData
plotData
```
(These directories will be created when the script is run if they do not already
exist.)

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

I like Vim, and prefer it to Matlab's text editor, so the CLI approach
suits me well. But I acknowledge that this is not everyone's preference;
hence the `guiDispatcher.m` script.

## How to Write generators?

However you like. As said, I like Vim; you may create your generators
directly in Matlab or in another editor of your choosing. I've heard
good things about `ex`. ;-)


Secondary Material
==================

- `examples` contains examples from other sources, either unchanged or
slightly modified.
- `deprecated` contains old design and sandbox files which are no longer 
relevant for the system implementation, but might still have some 
illustrative purpose, and are therefore kept around.


TODO
====

- write filter coefficients to files for further processing (and plotting 
in LaTeX)
- export fvtool filter plots to data, then to files, for plotting in LaTeX
- Add `help` to functions.


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
