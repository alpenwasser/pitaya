clc; clear;
addpath('/Users/yatekii/repos/pitaya/doc/verification/MatlabWebSocket/src/');

clc; clear;

sock = tcpip('localhost', 9002);
buffSize = 1000000;
set(sock,'InputBufferSize',buffSize);
set(sock,'OutputBufferSize',buffSize);

fopen(sock);

fs = 5000000;
for freq = linspace(1, 5*fs/2, 197)
    cmd = sprintf('APPLy:SIN %d,1,0', freq);
    sendCmd(sock, cmd, 1)

    client = WebSocket('ws://10.84.130.54:50090', @recordData, fs, 2^12);
    delay = 0.01;  % 10 milliseconds
    while ~client.Done
        pause(delay);
    end
end

fclose(sock);