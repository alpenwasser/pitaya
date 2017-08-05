% CIC Filter
clear all;close all;clc;

% represented as:
% three integrators
% three combs
% Rate reduction: 9 (comb order = 9);

%% Integrator
A = 1;
B = [1 -1];

% Cascade 1 stage
Aint1 = A;
Bint1 = B;

%% Comb of order 2 for rate reduction 2
A = [1 0 -1];
B = 1;

Acomb1 = A;
Bcomb1 = B;
% fvtool(Acomb3,Bcomb3);
fvtool(Acomb1,Bcomb1);

%% Cascade
Acic1 = conv(Aint1,Acomb1);
Bcic1 = conv(Bint1,Bcomb1);
fvtool(Acic1,Bcic1);

%% Store to Disk
[H,w] = freqz(Acic1,Bcic1);
plotFile = 'cic1.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [abs(H) w],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);