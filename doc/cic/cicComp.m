clear cll;close all;clc;

%%%%%% filter parameters %%%%%%
R = 650;            % Decimation Factor
M = 1;              % Differential Delay
N = 2;              % Number of Stages
B = 18;             % Coefficient Bit width
Fs = 125e6;         % High sampling rate in Hz before decimation
Fc = 192e3;         % Pass band edge in Hz

%%%%%%% CIC Filter %%%%%%
B_cic = ones(1,R*M);

for n = 2:N
    B_cic = conv(B_cic, B_cic);
end
A_cic = [1 zeros(1, length(B_cic) - 1)];

%%%%%%% fir2.m parameters %%%%%%
L = 110;            % Filter oder; must be even
Fo = R*Fc/Fs;       % Normalized Cutoff frequenzy; 0<Fo<=0.5/M
%Fo = 0.5/M;         % use Fo=0.5 if you don't care that responses are
                    % outside the pass band.

%%%%%%% CIC Compensator Design using fir2.m %%%%%%
p = 2e3;            % Granularity
s = 0.25/p;         % Step size
fp = [0:s:Fo];      % Pass band frequency samples
fs = (Fo+s):s:1;  % Stop band frequency samples
f = [fp fs]*1;      % Normalized frequency samples; 0<=f<=1
Mp = ones(1,length(fp)); % Pass band response; Mp(1)=1
Mp(2:end) = abs( M*R*sin(pi*fp(2:end)/R)./sin(pi*M*fp(2:end))).^N;
Mf = [Mp zeros(1,length(fs))];
f(end) = 1;
h = fir2(L,f,Mf);             % Filter length L+1
h = h/max(h);                 % Floating point coefficients
hz = round(h*power(2,B-1)-1); % Fixed point coefficients

tot_filt = conv(hz, B_cic);
figure;
freqz(B_cic,[1],1e5,Fs);
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XScale', 'log');
figure;
freqz(hz,[1],1e5,Fs/R);
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XScale', 'log');
figure;
freqz(tot_filt,[1],1e5);
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XScale', 'log');