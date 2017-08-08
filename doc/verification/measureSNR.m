clc; clear;
addpath('/Users/yatekii/repos/pitaya/doc/verification/MatlabWebSocket/src/');

client = WebSocket('ws://10.84.130.54:50090', @calculateSNR, 1000000, 4096);

% plotFile = 'snr1kHzsine50kHzfs.csv';
% fh = fopen(plotFile,'w'); 
% if fh ~= -1
%     fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
%     fclose(fh);
% end
% dlmwrite(...
%     plotFile,...
%     [abs(H) (w)],...
%     '-append',...
%     'delimiter', ',',...
%     'newline', 'unix'...
% );