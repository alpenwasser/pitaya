% CIC Filters
clear all;close all;clc;

% Building Blocks

%% Integrator
B_int = [1];
A_int = [1 -1];
K = 1e4;
figure('name', 'B_int, A_int');
freqz(B_int,A_int,K);
title('B_{int}/A_{int}');

%% Comb
R = 8;
M = 1;
B_comb = [1 zeros(1,R*M-1) -1];
A_comb = [1];
K = 1e4;
figure('name','B_comb/A_comb');
freqz(B_comb,A_comb,K);
title('B_{comb}/A_{comb}');

%% Combination
K = 1e4;
% The number of cascaded integrator and comb stages (N of each!):
N = 3;
% NOTE: since this script does not explicitly handle overflow, increasing
% N can very quickly result in numerically unstable results.
B_cic = conv(B_int, B_comb);
A_cic = conv(A_int, A_comb);
B_cic2 = ones(1,R*M);
A_cic2 = [1];

% Exponentiate polynomials
for n = 2:N
    B_cic = conv(B_cic, B_cic);
    A_cic = conv(A_cic, A_cic);
    B_cic2 = conv(B_cic2, B_cic2);
end
B_cic2 = round(B_cic2*power(2,31)-1); % fixed-point coeffs

% B_cic2 = B_cic2/2^12; % Normalize to 1 for N = 3
figure('name', 'B_cic, A_cic');
freqz(B_cic,A_cic,K);
title('B_{cic}/A_{cic}');

figure('name', 'B_cic2');
freqz(B_cic2,A_cic2,K);
title('B_{cic2}');

figure('name', 'B_int/A_int')
zplane(B_int,A_int);
title('B_{int}/A_{int}');

figure('name', 'B_comb/A_comb')
zplane(B_comb,A_comb);
title('B_{comb}/A_{comb}');

figure('name', 'B_cic');
zplane(B_cic);
title('B_{cic}');

figure('name', 'A_cic');
zplane(A_cic);
title('A_{cic}');

figure('name', 'B_cic/A_cic');
zplane(B_cic,A_cic);
title('B_{cic}/A_{cic}');

figure('name', 'B_cic2');
zplane(B_cic2);
title('B_{cic2}');