% ------------------------------------------------------------------------ %
% cliDispatcher.m
%
% DESCRIPTION
% Designs and showcases various filter chains for evaluation through
% iteration. The generators for various filter types are in a separate
% subdirectory ('generators/').
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
genDir = 'generators';
coefDir = 'coefData';
plotDir = 'plotData';
addpath(genDir);

if strcmp(filtertype,'FIR5')

    % - Start Frequency of the pass band (upper edge) (Fpass)
    % - Stop Frequency of the stop band (lower edge)  (Fstop)
    % - Ripple in pass band                           (Apass)
    % - Attenuation in stop band                      (Astop)
    %
    %
    % ASCII Diagram of Parameter Meanings:
    %
    % ^ Mag (dB)¬
    % |
    % |
    % |XXXXXXXXXXXXX        _¬
    % |                     _ Apass                   ___¬
    % |XXXXXXXXXXXXX                                   ^¬
    % |XXXXXXXXXXXXX                                   | Astop¬
    % |XXXXXXXXXXXXX                                   |¬
    % |XXXXXXXXXXXXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXvXXXXXXX¬
    % |XXXXXXXXXXXXX¬
    % +--------------------------------------------------------------> f¬
    % 0            |     |                                     |¬
    %              Fpass Fstop                                 Fs/2¬
    %
    % See also:
    % https://ch.mathworks.com/help/signal/ref/fdesign.lowpass.html
    % https://ch.mathworks.com/help/dsp/ref/fdesign.decimator.html

    % ------------------------------------------- Input Sampling Frequency in Hz
    Fs  = 125e6;

    % -------------------------------------------------------- Decimation Factor
    R   = 5;

    % ---------------------- Frequency at the Start of the Pass Band; Normalized
    % NOTE: The smallest number in Fp must be smaller than the smallest number
    %       in Fst (see below).
    Fp  = [0.1 0.15 0.2];
    %Fp  = [0.2];

    % ------------- ---------- Stop band frequencies ("How steep is the filter?")
    % NOTE: The smallest number in Fst must be larger than the largest number in
    %       Fp (see above).
    Fst = [0.21 0.22];
    %Fst = [0.22];

    % ------------------------------------------------- Ripple in Passband in dB
    Ap  = [0.25 0.5 1];
    %Ap  = [1];

    % ------------------------------------------- Attenuation in Stop Band in dB
    Ast = [20 40 60 80];
    %Ast = [80 40];

    % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
    Hd = decFIR(R, Fs, Fp, Fst, Ap, Ast, coefDir, plotDir);
end
