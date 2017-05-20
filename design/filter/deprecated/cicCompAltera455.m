clear all;close all;clc;

% Compensation Filter Design Script based on a script in Altera
% application note 455:
% https://altera.com/content/dam/altera-www/global/en_US/pdfs/literature/an/an455.pdf

R = 650;     % decimation factor
M = 1;       % differential delay for cic
N = 1;       % number of cic stages
B = 32;      % comp coeff filter width
Fs = 125e6;  % Sampling freq in Hz
Fl = Fs/R;   % freq after decimation
Fc = Fl/4;   % pass band edge in Hz; maximum half of Fl;
             % inverse sinc for exactly half (wide-band comp. filter)

L = 32;             % comp filter length
Fo = R * Fc / Fs;   % normalized cutoff frequency
             
p = 2e3;                        % granularity;
s = 0.25/p;                     % step size;
fp = [0:s:Fo];                  % pass band frequency samples;
fs = (Fo+s):s:0.5;              % stop band frequency samples;
f = [fp fs] * 2;                % normalized frequenzy samples; 0<=f<=1
Mp = ones(1,length(fp));        % pass band response; Mp(1) = 1
Mp(2:end) = abs( M*R*sin(pi*fp(2:end)/R)./sin(pi*M*fp(2:end))).^N;
Mf = [Mp zeros(1, length(fs))];
f(end) = 1;
h = fir2(L,f,Mf);
h = h / max(h);
hz = round(h*power(2,B-1)-1);

