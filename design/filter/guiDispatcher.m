% ------------------------------------------------------------------------ %
% guiDispatcher.m
%
% DESCRIPTION
% Calls various filter generators (located in the 'generators/' subdirecotry)
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

%% Fir: R = 5
clear all;close all;clc;
filtertype='FIR5';
run generators/dec5FIR;
