% Aliasing
close all;clear all;clc;

%% No aliasing
fs = 1e3;
freq = -1.5 * fs:1:1.5*fs;
rising_edge = 0:0.01:1;
top         = ones(1,100);
falling_edge = fliplr(rising_edge);
padding     = zeros(1,100);

Y = [rising_edge top falling_edge padding rising_edge top falling_edge padding rising_edge top falling_edge];
plot(Y);
plotFile = 'bandNoAliasing.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'Y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(Y))', Y'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Aliasing
close all;clear all;clc;
overall_length = 1001;
f = -(overall_length-1)/2:1:(overall_length-1)/2;
rising_edge = 0:0.01:1;
top         = ones(1,200);
falling_edge = fliplr(rising_edge);
Y = [rising_edge top falling_edge];
Y1 = [Y zeros(1,overall_length - length(Y))];
% plot(f,Y1);hold on;
Y2 = [zeros(1,(overall_length-1)/2 - (length(Y))/2) Y zeros(1,(overall_length-1)/2 - (length(Y))/2+1)];
% plot(f,Y2)
Y3 = [zeros(1,overall_length - length(Y)) Y];
% plot(f,Y3)

plotFile = 'bandAliased1.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'Y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(Y1))', Y1'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

plotFile = 'bandAliased2.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'Y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(Y2))', Y2'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

plotFile = 'bandAliased3.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'Y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(Y3))', Y3'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);