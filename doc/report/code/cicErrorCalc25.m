%% Impulse response coefficients
clear all;close all;%clc;

N = 4;
M = 1;
R = 25;

kmax1 = (R*M-1) * N + 1 - 1;
kmax2 = (R*M-1) * N + 2 - 1;
kmax3 = (R*M-1) * N + 3 - 1;
kmax4 = (R*M-1) * N + 4 - 1;
kmax5 = 2*N+1-5;
kmax6 = 2*N+1-6;
kmax7 = 2*N+1-7;
kmax8 = 2*N+1-8;

h1 = zeros(1,kmax1+1);
h2 = zeros(1,kmax2+1);
h3 = zeros(1,kmax3+1);
h4 = zeros(1,kmax4+1);
h5 = zeros(1,kmax5+1);
h6 = zeros(1,kmax6+1);
h7 = zeros(1,kmax7+1);
h8 = zeros(1,kmax8+1);

j = 1;
for k = 0:kmax1
    for l = 0:floor(k/(R*M))
        h1(k+1) = h1(k+1)+(-1)^l * nchoosek(N,l) * nchoosek(N-j+k-R*M*l,k-R*M*l);
    end
end
j = 2;
for k = 0:kmax2
    for l = 0:floor(k/(R*M))
        h2(k+1) = h2(k+1)+(-1)^l * nchoosek(N,l) * nchoosek(N-j+k-R*M*l,k-R*M*l);
    end
end
j = 3;
for k = 0:kmax3
    for l = 0:floor(k/(R*M))
        h3(k+1) = h3(k+1)+(-1)^l * nchoosek(N,l) * nchoosek(N-j+k-R*M*l,k-R*M*l);
    end
end
j = 4;
for k = 0:kmax4
    for l = 0:floor(k/(R*M))
        h4(k+1) = h4(k+1)+(-1)^l * nchoosek(N,l) * nchoosek(N-j+k-R*M*l,k-R*M*l);
    end
end
j = 5;
for k = 0:kmax5
    for l = 0:floor(k/(R*M))
        h5(k+1) = (-1)^k * nchoosek(2*N+1-j,k);
    end
end
j = 6;
for k = 0:kmax6
    for l = 0:floor(k/(R*M))
        h6(k+1) = (-1)^k * nchoosek(2*N+1-j,k);
    end
end
j = 7;
for k = 0:kmax7
    for l = 0:floor(k/(R*M))
        h7(k+1) = (-1)^k * nchoosek(2*N+1-j,k);
    end
end
j = 8;
for k = 0:kmax8
    for l = 0:floor(k/(R*M))
        h8(k+1) = (-1)^k * nchoosek(2*N+1-j,k);
    end
end

%% Maximum Gain
Gmax1 = sum(abs(h1));
Gmax2 = (R*M)^N;
Bin = 14;
Bmax = ceil(N*log2(R*M)+Bin - 1);

%% Truncation and Rounding
% NOTE: 2N+1 stages, since output is counted as a stage as well.

% Number of bits discarded at each stage
B = [0 0 0 0 0 0 0 0 17];
% Width of probability distribution for errors
E = [0 0 0 0 0 0 0 0 2^B(9)];

% Mean error for all stages
mu = 1/2 * E;

% Variance of Error for all stages
sigmaSq = 1/12 * E.^2;

% Total mean
muT1 = mu(1) * sum(h1);
muT2 = mu(2) * sum(h2);
muT3 = mu(3) * sum(h3);
muT4 = mu(4) * sum(h4);
muT5 = mu(5) * sum(h5);
muT6 = mu(6) * sum(h6);
muT7 = mu(7) * sum(h7);
muT8 = mu(8) * sum(h8);
muT9 = mu(9) * 1;

% NOTE: The sums are zero for all but the first and last stages, as shown
%       by Hogenauer, Equation 17 on page 159.

muT = [muT1 muT2 muT3 muT4 muT5 muT6 muT7 muT8 muT9];
muTotal = sum(muT);

% Total variance
sigmaSqT1 = sigmaSq(1) * sum(h1.^2);
sigmaSqT2 = sigmaSq(2) * sum(h2.^2);
sigmaSqT3 = sigmaSq(3) * sum(h3.^2);
sigmaSqT4 = sigmaSq(4) * sum(h4.^2);
sigmaSqT5 = sigmaSq(5) * sum(h5.^2);
sigmaSqT6 = sigmaSq(6) * sum(h6.^2);
sigmaSqT7 = sigmaSq(7) * sum(h7.^2);
sigmaSqT8 = sigmaSq(8) * sum(h8.^2);
sigmaSqT9 = sigmaSq(9) * 1;

sigmaSqT = [sigmaSqT1 sigmaSqT2 sigmaSqT3 sigmaSqT4 sigmaSqT5 sigmaSqT6 sigmaSqT7 sigmaSqT8 sigmaSqT9];
sigmaSqTotal = sum(sigmaSqT);

% Assuming a binary point to the right of the LSB of the output register
mean = muTotal/2^B(9)
sigma = sqrt(sigmaSqTotal)/2^B(9)
