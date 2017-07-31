%%
clear all; close all; clc;
fs = 125e6; T = 1/fs;
N = 2048;
R = 5;
e = 0.85;
fp = (fs/R*e/2);

[Ord, Wp] = ellipord(e/R, (1/e)/R, 1, 60 );
[B, A] = ellip(Ord, 1, 60, fp/(fs/2));

[H, F] = freqz(B, A, R*N+1, fs);

Hr = reshape(H(2:end), N, R)';
Hr(2:2:end, :) = Hr(2:2:end, end:-1:1);

Fr = F(2:N+1);
Hrtot = max(abs(Hr(2:end, :)));

figure;
plot(F, 20*log10(abs(H)), '-k', Fr, 20*log10(abs(Hr(2:end, :)))', Fr, 20*log10(Hrtot), '-k','LineWidth', 2); grid on

figure;
plot(F, 20*log10(abs(H)), '-b', Fr, 20*log10(Hrtot), '-r','LineWidth', 2); grid on