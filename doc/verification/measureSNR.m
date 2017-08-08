addpath('/Users/yatekii/repos/pitaya/doc/verification/MatlabWebSocket/src/');

client = WebSocket('ws://10.84.130.54:50090');
while ~client.Status
end
client.send('{ "setNumberOfChannels": 2 }');
client.send('{ "frameConfiguration": { "frameSize": 4096, "pre": 2048, "suf": 2048 } }');
client.send('{ "triggerOn": {"type": "risingEdge", "channel": 1,"level": 32768, "slope":0}}');
client.send('{ "requestFrame": true, "channel": 1}');
while ~client.DataReceived
end
client.close();

% figure;
% H = fft(x);
% Hone = zeros(1, length(H)/2+1);
% Hone(1) = H(1);
% Hone(2:end) = 2 * H(2:length(H)/2+1);
% w = 0:(length(x)/2);
% w = w .* 2 * pi / (length(x)/2);
% 
% %plot(w, abs(Hone))
% 
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