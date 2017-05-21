% ------------------------------------------------------------------------ %
% cliDispatcher.m
%
% DESCRIPTION
% Designs and showcases various filter chains for evaluation through
% iteration. The iterators for various filter types are in a separate
% subdirectory ('iterators/').
%
% Environment Variables: filtertype
%
% The filtertype variable must have one of the following values:
% FIR5    will initiate an iterator for a FIR decimation filter with
%         decimation ratio of 5.
% 
% Call example: This script is primarily intended to be called from the
% command line:
% matlab -nosplash -nodesktop filtertype=FIR5;dispatcher;
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21
% ------------------------------------------------------------------------ %

if strcmp(filtertype,'FIR5')
    run iterators/dec5FIR;
end
