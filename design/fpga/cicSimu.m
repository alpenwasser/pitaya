clear all;close all;clc;

R = 650; % decimation factor
M = 1; % differential delay for cic
N = 1; % number of cic stages
B = 18; % comp coeff filter width
Fs = 125e6; % Sampling freq in Hz
Fc = 192e3; % pass band edge in Hz

L = 110; % comp filter length
Fo = R * Fc / Fs; % normalized cutoff frequency
             
p = 2e3;                        % granularity;
s = 0.25/p;                     % step size;
fp = [0:s:Fo];                  % pass band frequency samples;
fs = (Fo+s):s:1;                % stop band frequency samples;
f = [fp fs];                    % normalized frequenzy samples; 0<=f<=1
Mp = ones(1,length(fp));        % pass band response; Mp(1) = 1
Mp(2:end) = abs( M*R*sin(pi*fp(2:end)/R)./sin(pi*M*fp(2:end))).^N;
fx = f./R;
fr = [fx fx(end)+s:s:1];
fr(end) = 1;
Mf = [Mp zeros(1,length(fr)-length(Mp))];
h = fir2(L,fr,Mf);
h = h/max(h);                   % floating point coefficients
hz = round(h*power(2,B-1)-1);   % fixed point coefficients;

B_cic = ones(1, R*M);
for n = 2:N
    B_cic = conv(B_cic, B_cic);
end
A_cic = [1 zeros(1, length(B_cic) - 1)];

figure;
freqz(hz, 1, 1e5, Fs);
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XScale', 'log');

figure;
loglog(fr, Mf);

B_tot = conv(B_cic, hz);



% figure;
% freqz(B_cic, A_cic, 1e5, Fs);
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log')
% 
% figure;
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log')
% freqz(hz, 1, 1e5, Fc);

% options = simset('SrcWorkspace', 'current');

% sim('filterChain',[],options);

% sim('cicFilterGen',[],options);

% sim('cicFilterManual',[],options);