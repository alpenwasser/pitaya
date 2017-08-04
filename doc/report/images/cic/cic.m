% CIC Filter
clear all;close all;clc;

% represented as:
% three integrators
% three combs
% Rate reduction: 9 (comb order = 9);

%% Integrator
A = 1;
B = [1 -1];

% Cascade 3 stages
Aint1 = A;
Bint1 = B;
Aint3 = 1;
Bint3 = conv(conv(B,B),B);
% fvtool(Aint3,Bint3);

%% Comb of order 9 for rate reduction 9
A = [1 0 0 0 0 0 0 0 0 -1];
B = 1;

Acomb1 = A;
Bcomb1 = B;
Acomb3 = conv(conv(A,A),A);
Bcomb3 = 1;
% fvtool(Acomb3,Bcomb3);

%% Cascade
Acic1 = conv(Aint1,Acomb1);
Bcic1 = conv(Bint1,Bcomb1);
Acic3 = conv(Aint3,Acomb3);
Bcic3 = conv(Bint3,Bcomb3);
% fvtool(Acic3,Bcic3);

%% Store to Disk
[H,w] = freqz(Acomb1,Bcomb1);
plotFile = 'comb1.csv';
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

[H,w] = freqz(Aint1,Bint1);
plotFile = 'integrator1.csv';
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
[H,w] = freqz(Acomb3,Bcomb3);
plotFile = 'comb3.csv';
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

[H,w] = freqz(Aint3,Bint3);
plotFile = 'integrator3.csv';
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

[H,w] = freqz(Acic3,Bcic3);
plotFile = 'cic3.csv';
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