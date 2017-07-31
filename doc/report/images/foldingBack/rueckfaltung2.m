%%
clear all;close all;clc;

f = 0.7e3;
T = 1/f;
fs = 2e3;
Ts = 1/fs;

t = 0:Ts:1-Ts;
% t = 0:0.001*T:(3-0.001)*T;
% t = 0:.001:1-0.001;
% x = 2 + sin(2*pi*f*t) + 0.5*sin(2*pi*2*f*t);
x = sin(2*pi*f*t);
figure;grid on;
plot(t,x);

x = detrend(x,0);
xdft = fft(x);
freq = 0:fs/length(x):fs/2;
xdft = xdft(1:length(x)/2+1);
plot(freq,abs(xdft));


%%
X=(20*log10(abs(fft(x)/(length(x)-1))));
X=X(1:(length(X)-1)/2);
spec=zeros(1,2*length(X));
spec(1:length(X))=X(length(X):-1:1);
spec(length(X)+1:2*length(X))=X(1:1:length(X));
faxis=linspace(-fs/2, fs/2, length(spec));
figure;grid on;
plot(faxis, spec, '-*'); grid on; zoom on;


%%
X=abs(fft(x)/(length(x)-1));
X=X(1:(length(X)-1)/2);
spec=zeros(1,2*length(X));
spec(1:(length(X)-1))=X((length(X)-1):-1:1);
spec(length(X):2*(length(X)-1))=X(1:1:(length(X)-1));
faxis=linspace(-fs/2, fs/2, length(spec));
figure;grid on;
plot(faxis, spec); grid on; zoom on;

%%
% https://ch.mathworks.com/matlabcentral/answers/28239-get-frequencies-out-of-data-with-an-fft
clear all;close all;clc;
t = 0:.001:1-0.001;
Fs = 1e3;
x = 2+sin(2*pi*60*t) + 0.5 * sin(2*pi*30*t);
x = detrend(x,0);
xdft = fft(x);
freq = 0:Fs/length(x):Fs/2;
xdft = xdft(1:length(x)/2+1);
plot(freq,abs(xdft));
[~,I] = max(abs(xdft));
fprintf('Maximum occurs at %d Hz.\n',freq(I));