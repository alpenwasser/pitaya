% ------------------------------------------------------------------------ %
% guiDispatcher.m
%
% DESCRIPTION
% Calls various filter iterators (located in the 'iterators/' subdirecotry)
% with the appropriate parameters. Fulfills the same role as the combination
% of Makefile and clidispatcher.m on the command line, but from Matlab's
% graphical user interface.
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21
% ------------------------------------------------------------------------ %

filtertype='FIR5';
run iterators/dec5FIR;