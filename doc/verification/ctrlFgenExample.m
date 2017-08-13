clc; clear;

sock = tcpip('localhost', 9002);
buffSize = 1000000;
set(sock,'InputBufferSize',buffSize);
set(sock,'OutputBufferSize',buffSize);

fopen(sock);

cmd = 'APPLy:SIN 1e3,1,0';
% cmd = '*IDN?';
sendCmd(sock, cmd, 1)

fclose(sock);