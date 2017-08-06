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
Aint3 = 1;
Bint3 = conv(conv(B,B),B);
Aint4 = 1;
Bint4 = conv(Bint3,Bint1);
% fvtool(Aint3,Bint3);

%% Comb of order 9 for R=9, M=1
A = [1 0 0 0 0 0 0 0 0 -1];
B = 1;
% Naming scheme: AcombRMN
Acomb911 = A;
Bcomb911 = B;
Acomb913 = conv(conv(A,A),A);
Bcomb913 = 1;
Acomb914 = conv(Acomb913,A);
Bcomb914 = 1;
% fvtool(Acomb913,Bcomb913);

%% Comb of order 3 for R=3, M=1
A = [1 0 0 -1];
B = 1;
% Naming scheme: AcombRMN
Acomb311 = A;
Bcomb311 = B;
Acomb313 = conv(conv(A,A),A);
Bcomb313 = 1;
% fvtool(Acomb313,Bcomb313,Acomb3,Bcomb313);

%% Cascade
% Naming scheme: AcicRMN
Acic911 = conv(Aint1,Acomb911);
Bcic911 = conv(Bint1,Bcomb911);
Acic913 = conv(Aint3,Acomb913);
Bcic913 = conv(Bint3,Bcomb913);
Acic313 = conv(Aint3,Acomb313);
Bcic313 = conv(Bint3,Bcomb313);
Acic914 = conv(Aint4,Acomb914);
Bcic914 = conv(Bint4,Bcomb914);
% fvtool(Acic914,Bcic914);
% fvtool(Acic913,Bcic913,Acic313,Bcic313);

%% Store to Disk
[H,w] = freqz(Acomb911,Bcomb911);
plotFile = 'comb911.csv';
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

[H,w] = freqz(Acic911,Bcic911);
plotFile = 'cic911.csv';
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
[H,w] = freqz(Acomb913,Bcomb913);
plotFile = 'comb913.csv';
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

[H,w] = freqz(Acic913,Bcic913);
plotFile = 'cic913.csv';
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

[H,w] = freqz(Acic313,Bcic313);
plotFile = 'cic313.csv';
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
[H,w] = freqz(Acic914,Bcic914);
plotFile = 'cic914.csv';
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

%%
%%%% Influence of Design Parameters

%% Influence of M
Aint = 1;
Bint = [1 -1];
Acomb911 = [1 0 0 0 0 0 0 0 0 -1]; % M = 1, R = 9
Bcomb   = 1;
Acomb921 = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1]; % M = 2, R = 9
Acic911 = conv(Aint,Acomb911);
Bcic911 = conv(Bint,Bcomb);
Acic921 = conv(Aint,Acomb921);
Bcic921 = Bcic911;
% fvtool(Acic911,Bcic911,Acic921,Bcic921);

%% Store to disk
[H,w] = freqz(Acic911,Bcic911);
plotFile = 'cic911.csv';
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
[H,w] = freqz(Acic921,Bcic921);
plotFile = 'cic921.csv';
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

%% Influence of R: See above

%% Influence of N:
Aint = 1;
Bint = [1 -1];
Acomb911 = [1 0 0 0 0 0 0 0 0 -1]; % M = 1, R = 9
Bcomb911 = 1;

Aint911 = Aint;
Bint911 = Bint;
Aint913  = Aint;
Bint913  = conv(conv(Bint,Bint),Bint);
Acomb913 = conv(conv(Acomb911,Acomb911),Acomb911);
Bcomb913 = Bcomb;

Acic911 = conv(Aint911,Acomb911);
Bcic911 = conv(Bint911,Bcomb911);
Acic913 = conv(Aint913,Acomb913);
Bcic913 = conv(Bint913,Bcomb913);

% fvtool(Acic911,Bcic911,Acic913,Bcic913);

%% Store to disk
[H,w] = freqz(Acic911,Bcic911);
plotFile = 'cic911.csv';
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
[H,w] = freqz(Acic913,Bcic913);
plotFile = 'cic913.csv';
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