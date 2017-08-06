% CIC Filter
clear all;close all;clc;

% represented as:
% three integrators
% three combs
% Rate reduction: 9 (comb order = 9);


%% Integrators
A = 1;
B = [1 -1];

% Cascade 3 stages
Aint1 = A;
Bint1 = B;
Aint4 = Aint1;
Bint4 = conv(conv(conv(Bint1,B),B),B);

%% Comb of order 9 for R=9, M=1
A = [1 0 0 0 0 0 0 0 0 -1];
B = 1;
Acomb911 = A;
Bcomb911 = B;
Acomb914 = conv(conv(conv(Acomb911,A),A),A);
Bcomb914 = Bcomb911;
% Naming scheme: AcombRMN

%% Comb of order 18 for R=9, M=2
A = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1];
B = 1;
Acomb921 = A;
Bcomb921 = B;
Bcomb924 = Bcomb921;
Acomb924 = conv(conv(conv(Acomb921,A),A),A);
% Naming scheme: AcombRMN

%% Cascade
% Naming scheme: AcicRMN
Acic914 = conv(Aint4,Acomb914);
Bcic914 = conv(Bint4,Bcomb914);

Acic924 = conv(Aint4,Acomb924);
Bcic924 = conv(Bint4,Bcomb924);

%% Aliasing
fc = [1/256 1/128 1/64 1/32 1/16 1/8 1/4]; % cutoff freqs

N = 2^8; % Number of points per lobe in f direction
R = 9;
fc = 1/2;

[H, w] = freqz(Acic914, Bcic914, R*N+1);

Hr = reshape(H(2:end), N, R)';
Hr(2:2:end, :) = Hr(2:2:end, end:-1:1);

wr = w(2:N+1);
Hrtot = max(abs(Hr(2:end, :)));

% figure;
% plot(w, 20*log10(abs(H)), '-k', wr(1:N*fc), 20*log10(abs(Hr(2:end,1:N*fc)))', wr(1:N*fc), 20*log10(Hrtot(1:N*fc)), '-k','LineWidth', 2); grid on

%% Store to Disk
plotFile = 'pbAliasing914Complete.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(H) (w)],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null1Left.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(2,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null1Right.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(3,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null2Left.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(4,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null2Right.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(5,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null3Left.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(6,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null3Right.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(7,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null4Left.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(8,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'pbAliasing914Null4Right.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(Hr(9,1:N*fc))' (wr(1:N*fc))],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);