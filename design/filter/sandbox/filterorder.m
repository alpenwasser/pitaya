% ------------------------------------------------------------ %
% Filter Order Estimator
% ------------------------------------------------------------ %
% Estimates minimum filter order  required for a FIR lowpass
% implementation.
%
% ------------------------------------------------------------ %
% Based on:
% Herrmann, Rabiner and Chan:
% Practical Design Rules for Optimum Finite Impulse Response
% Low-Pass Digital  Filters (Bell System  Technical Journal,
% July-August 1973)
%
% Optimum FIR Digital Filter Implementations for Decimation,
% Interpolation, and Narrow-Band Filtering
% Crochiere, Rabiner, IEEE, 1975
%
% Further  Considerations in  the Design  of Decimators  and
% Interpolators
% Crochiere, Rabiner, IEEE, 1976
%
% ------------------------------------------------------------ %
% Author: Raphael Frey <rmfrey@alpenwasser.net>
% Date: 2017-05-25
% ------------------------------------------------------------ %
% NOTES:
% Results do  not seem  to match  up with  Matlab's fdesign
% toolbox. Not sure why.
%
% Possible Reasons:
% - Matlab does not implement optimum filters (unlikely?)
% - I'm doing something wrong with the formulae
% ------------------------------------------------------------ %


clear all;close all;

Apass = 0.25;                      % Passband ripple band height in dB
d1 = 10^((Apass)/20)/2;            % passband ripple amplitude
Astop = 40;                        % Stopband attenuation in dB
d2 = 1/(10^((Astop/20))) * (1+d1); % stop band peak ripple
                                   % 06773862, p. 307
fp = 0.200;                        % pass band stop frequency (upper edge)
fs = 0.220;                        % stop band stop frequency (lower edge)
df = fs-fp;                        % width of transition band

% Self:
d1 = 1-10^(-Apass/2/20);
% 06773985, p.788
%d1 = 10^(-Apass/20)/(2-10^(-Apass/20));
d2 = 10^(-Astop/20) * (1+d1);

%d1 = 0.014;
%d2 = 0.009;

% 06773985, p. 791
K = d1/d2;
f = 0.51244*log10(K) + 11.01217;
D = (5.309e-3 * (log10(d1))^2 + 7.114e-2 * log10(d1) - 0.4761)...
    * log10(d2) ...
    - (2.66e-3*(log10(d1))^2 + 0.5941 * log10(d2) + 0.4278);
N1 = (D - f*df^2)/df + 1

% Alternatively:
% Harris' Rule of Thumb:
% N ~= Astop/(22 * df)
% Astop: Stopband attenuation in dB
% fstop: stopband edge (normalized)
% df: transition band width (normalized)
% See:
% https://dsp.stackexchange.com/a/37662
% and
% https://dsp.stackexchange.com/a/31210
% Doesn't quite seem to work either.
