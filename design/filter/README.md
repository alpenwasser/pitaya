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
- Make an entry in the `Makefile` which calls `cliDispatcher.m` with
the appropriate arguments.
- Invoke via `make <yourtarget>`.


Coefficient Data
================

Each filter will store its coefficients in an appropriately subdirectory
in the `coefData` directory.


Plot Data
=========

Plotting data from the `fvtool` for further processing (for example
with `pgfplots` in LaTeX) can be found in the `plotData` directory.


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
