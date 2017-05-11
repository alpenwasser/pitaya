clear all;close all;clc;

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

%%%% SANDBOX %%%%
% fx = f./R;
% fr = [fx fx(end)+s:s:1];
% fr(end) = 1;
% Mf = [Mp zeros(1,length(fr)-length(Mp))];
% h = fir2(L,fr,Mf);
% h = h/max(h);                   % floating point coefficients
% hz = round(h*power(2,B-1)-1);   % fixed point coefficients;
%%%% SANDBOX %%%%


B_cic = ones(1, R*M);
for n = 2:N
    B_cic = conv(B_cic, B_cic);
end
A_cic = [1 zeros(1, length(B_cic) - 1)];

%%%% Manual Approach: Wrong? %%%%
% [H,F] = freqz(B_cic, A_cic, 1e5, Fs);
% H_cic = H;
% F_cic = F;
% 
% [H,F] = freqz(h, 1, 1e5, Fc);
% H_comp = H;
% F_comp = F;
% 
% B_tot = conv(B_cic,h);
% A_tot = [1 zeros(1,length(B_tot) - 1)];
% [H,F] = freqz(B_tot, 1, 1e5, Fc);
% H_tot = H;
% F_tot = F;
% 
% % figure;freqz(B_cic, A_cic, 1e5, Fs);
% % figure;freqz(hz, 1, 1e5, Fc);
% % figure;freqz(B_tot, A_tot, 1e5, Fs);
% 
% figure;
% freqz(B_cic, A_cic, 1e5, Fs);
% hold on;
% legend('CIC');
% freqz(h, 1, 1e5, Fc);
% legend('COMP');
% freqz(B_tot, A_tot, 1e5, Fs);
% legend('TOT');
%%%% Manual Approach %%%%

%%%% FDA Approach %%%
% H1=dfilt.df2t(B_cic,A_cic);
% H2=dfilt.df2t(h,[1]);
% Hcas=dfilt.cascade(H1,H2);
% freqz(H1)
% freqz(H2)
% freqz(Hcas)

% figure;
% freqz(hz, [1], 1e5,Fc);
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log');
% hold on;
% figure;
% freqz(B_cic,A_cic, 1e5, Fs);
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log');
% axis([0 Fs -80 70]);



%%%% SANDBOX %%%%
% figure;
% loglog(fr, Mf);
% B_tot = conv(B_cic, hz);
% figure;
% freqz(B_cic, A_cic, 1e5, Fs);
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log')
% 
% figure;
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log')
% freqz(hz, 1, 1e5, Fc);
%%%% SANDBOX %%%%


% options = simset('SrcWorkspace', 'current');
% sim('filterChain',[],options);
% sim('cicFilterGen',[],options);
% sim('cicFilterManual',[],options);