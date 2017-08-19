clc; clear;

sock = tcpip('localhost', 9002);
buffSize = 1000000;
set(sock,'InputBufferSize',buffSize);
set(sock,'OutputBufferSize',buffSize);

fopen(sock);

cmd = 'APPLy:SIN 1e4,1,0';
% cmd = 'SOUR1:VOLT:UNIT VPP'
% cmd = 'SOUR1:VOLT:UNIT?'
% cmd = '*IDN?';
sendCmd(sock, cmd, 1)

fclose(sock);