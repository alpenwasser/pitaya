clc; clear;
addpath('/Users/yatekii/repos/pitaya/doc/verification/MatlabWebSocket/src/');

clc; clear;

sock = tcpip('localhost', 9002);
buffSize = 1000000
set(sock,'InputBufferSize',buffSize);
set(sock,'OutputBufferSize',buffSize);

fopen(sock);

cmd = 'APPLy:SIN 1e2,1,0';
% cmd = '*IDN?';
sendCmd(sock, cmd, 1)

fclose(sock);

client = WebSocket('ws://10.84.130.54:50090', @recordData, 50000, 2^13);

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
