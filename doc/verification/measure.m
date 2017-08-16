clc; clear;
addpath('/Users/yatekii/repos/pitaya/doc/verification/MatlabWebSocket/src/');

clc; clear;

sock = tcpip('localhost', 9002);
buffSize = 1000000;
set(sock,'InputBufferSize',buffSize);
set(sock,'OutputBufferSize',buffSize);

fopen(sock);
path = 'measurements';
fsArr = [100000, 50000];
for fs = fsArr
    datestr(now)
    cnt = 0;
    for freq = linspace(1, 5*fs/2, 2000)
        cmd = sprintf('APPLy:SIN %d,1,0', freq);
        sendCmd(sock, cmd, 1)
        pause(0.01);
        client = WebSocket('ws://10.84.130.54:50090', @recordData, fs, 2^13, path, cnt);
        while ~client.Done
            pause(0.01); % 10 milliseconds
        end
        cnt = cnt + 1;
    end
    fs
end
datestr(now)
fclose(sock);