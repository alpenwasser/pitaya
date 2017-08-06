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
Aint2 = Aint1;
Bint2 = conv(Bint1,B);
Aint3 = Aint2;
Bint3 = conv(Bint2,B);
Aint4 = Aint3;
Bint4 = conv(Bint3,B);
Aint5 = Aint4;
Bint5 = conv(Bint4,B);
Aint6 = Aint5;
Bint6 = conv(Bint5,B);

%% Comb of order 9 for R=9, M=1
A = [1 0 0 0 0 0 0 0 0 -1];
B = 1;
Acomb911 = A;
Bcomb911 = B;
Acomb912 = conv(Acomb911,A);
Bcomb912 = Bcomb911;
Acomb913 = conv(Acomb912,A);
Bcomb913 = Bcomb912;
Acomb914 = conv(Acomb913,A);
Bcomb914 = Bcomb913;
Acomb915 = conv(Acomb914,A);
Bcomb915 = Bcomb914;
Acomb916 = conv(Acomb915,A);
Bcomb916 = Bcomb915;
% Naming scheme: AcombRMN

%% Comb of order 18 for R=9, M=2
A = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1];
B = 1;
Acomb921 = A;
Bcomb921 = B;
Acomb922 = conv(Acomb921,A);
Bcomb922 = Bcomb921;
Acomb923 = conv(Acomb922,A);
Bcomb923 = Bcomb922;
Acomb924 = conv(Acomb923,A);
Bcomb924 = Bcomb923;
Acomb925 = conv(Acomb924,A);
Bcomb925 = Bcomb924;
Acomb926 = conv(Acomb925,A);
Bcomb926 = Bcomb925;
% Naming scheme: AcombRMN

%% Cascade
% Naming scheme: AcicRMN
Acic911 = conv(Aint1,Acomb911);
Bcic911 = conv(Bint1,Bcomb911);
Acic912 = conv(Aint2,Acomb912);
Bcic912 = conv(Bint2,Bcomb912);
Acic913 = conv(Aint3,Acomb913);
Bcic913 = conv(Bint3,Bcomb913);
Acic914 = conv(Aint4,Acomb914);
Bcic914 = conv(Bint4,Bcomb914);
Acic915 = conv(Aint5,Acomb915);
Bcic915 = conv(Bint5,Bcomb915);
Acic916 = conv(Aint6,Acomb916);
Bcic916 = conv(Bint6,Bcomb916);

Acic921 = conv(Aint1,Acomb921);
Bcic921 = conv(Bint1,Bcomb921);
Acic922 = conv(Aint2,Acomb922);
Bcic922 = conv(Bint2,Bcomb922);
Acic923 = conv(Aint3,Acomb923);
Bcic923 = conv(Bint3,Bcomb923);
Acic924 = conv(Aint4,Acomb924);
Bcic924 = conv(Bint4,Bcomb924);
Acic925 = conv(Aint5,Acomb925);
Bcic925 = conv(Bint5,Bcomb925);
Acic926 = conv(Aint6,Acomb926);
Bcic926 = conv(Bint6,Bcomb926);

%% Cutoff Frequencies
fc = [1/256 1/128 1/64 1/32 1/16 1/8 1/4];

%% Store to Disk
w = 0:2*pi/9/1e3:2*pi/(9*2); % cut off in middle of lobe around zero.
H = freqz(Acic914,Bcic914,w);
absH = abs(H);
absH = absH/max(absH);
plotFile = 'pbattenuation914.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [absH' w'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
w = 0:2*pi/9/1e3/2:2*pi/(9*2)/2; % cut off in middle of lobe around zero.
H = freqz(Acic924,Bcic924,w);
absH = abs(H);
absH = absH/max(absH);
plotFile = 'pbattenuation924.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [absH' w'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);