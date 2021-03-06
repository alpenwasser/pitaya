% CIC Filters
clear all;close all;clc;

M = 1;
R = 650;
N = 2;
K = 1e5;
% Building Blocks

%% Integrator
% B_int = [1];
% A_int = [1 -1];
% K = 1e5;
% figure('name', 'B_int, A_int');
% freqz(B_int,A_int,K);
% title('B_{int}/A_{int}');

%% Comb
% R = 650;
% M = 1;
% B_comb = [1 zeros(1,R*M-1) -1];
% A_comb = [1];
% K = 1e5;
% figure('name','B_comb/A_comb');
% freqz(B_comb,A_comb,K);
% title('B_{comb}/A_{comb}');

%% Combination
% The number of cascaded integrator and comb stages (N of each!):
% N = 3;
% NOTE: since this script does not explicitly handle overflow, increasing
% N can very quickly result in numerically unstable results.
% B_cic = conv(B_int, B_comb);
% A_cic = conv(A_int, A_comb);
B_cic2 = ones(1,R*M);

% Exponentiate polynomials
for n = 2:N
%     B_cic = conv(B_cic, B_cic);
%     A_cic = conv(A_cic, A_cic);
    B_cic2 = conv(B_cic2, B_cic2);
end
% B_cic2 = round(B_cic2*power(2,31)-1); % fixed-point coeffs
A_cic2 = [1 zeros(1, length(B_cic2 - 1))];
B_cic2 = B_cic2; % Normalize to roughly 1 for N = 1 and R-650

% figure('name', 'B_cic, A_cic');
% freqz(B_cic,A_cic,K);
% title('B_{cic}/A_{cic}');

figure('name', 'B_cic2');
[h_B_cic2, w_B_cic2] = freqz(B_cic2,A_cic2,K);
H_B_cic2 = 20 * log10(abs(h_B_cic2)./max(abs(h_B_cic2))); % normalize to 0 dB
semilogx(w_B_cic2, H_B_cic2);
title('B_{cic2}');
axis([0 pi -100 10]);
grid on;
% ax = findall(gcf, 'Type', 'axes');
% set(ax, 'XScale', 'log');


% figure('name', 'B_int/A_int')
% zplane(B_int,A_int);
% title('B_{int}/A_{int}');
% 
% figure('name', 'B_comb/A_comb')
% zplane(B_comb,A_comb);
% title('B_{comb}/A_{comb}');
% 
% figure('name', 'B_cic');
% zplane(B_cic);
% title('B_{cic}');
% 
% figure('name', 'A_cic');
% zplane(A_cic);
% title('A_{cic}');
% 
% figure('name', 'B_cic/A_cic');
% zplane(B_cic,A_cic);
% title('B_{cic}/A_{cic}');
% 
% figure('name', 'B_cic2');
% zplane(B_cic2);
% title('B_{cic2}');

%% Save to Files
[H,W] = freqz(B_cic2, A_cic2, K);
[z,p,k] = tf2zp(B_cic2, A_cic2);

% Account for Fuzziness
% fuzz=1/80;
% [idx, centroids] = kmeans(z,8)
% zpl

fileName = 'freqzCIC-as-FIR.txt';
fh = fopen(fileName, 'w');
if fh ~= -1
    fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
    fclose(fh);
end
dlmwrite(fileName, [abs(H) unwrap(angle(H)) W], '-append', 'delimiter', ',', 'newline', 'unix');

% fileName = 'polesCIC-as-FIR.txt';
% fh = fopen(fileName, 'w');
% if fh ~= -1
%     fprintf(fh, '%s,%s\n', 'abs(p)', 'angle(p)');
%     fclose(fh);
% end
% dlmwrite(fileName, [abs(p) angle(p)], '-append', 'delimiter', ',', 'newline', 'unix');
% 
% fileName = 'zerosCIC-as-FIR.txt';
% fh = fopen(fileName, 'w');
% if fh ~= -1
%     fprintf(fh, '%s,%s\n', 'abs(z)', 'angle(z)');
%     fclose(fh);
% end
% dlmwrite(fileName, [abs(z) angle(z)], '-append', 'delimiter', ',', 'newline', 'unix');