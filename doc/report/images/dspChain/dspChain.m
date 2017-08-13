% DSP Chain Signal illustrations
% http://www.gaussianwaves.com/2014/07/how-to-plot-fft-using-matlab-fft-of-basic-signals-sine-and-cosine-waves/

%% Noisy Sine, Analog, Much noise

clear all;close all;clc;
f = 10;
overSample = 1000;
fs = overSample * f;
phase = 1/4*pi;
nCycl = 4;
t = 0:1/fs:nCycl*1/f;
y = sin(2*pi*f*t*phase);
noiseAmplitude = 1.5;
noisy_y = y + noiseAmplitude * randn(1, length(y));
% noisy_y = y;
% plot(t,noisy_y);

% plotFile = 'noisySine.csv';
% fh = fopen(plotFile,'w'); 
% if fh ~= -1
%     fprintf(fh, '%s,%s\n', 't', 'y');
%     fclose(fh);
% end
% dlmwrite(...
%     plotFile,...
%     [t', noisy_y'],...
%     '-append',...
%     'delimiter', ',',...
%     'newline', 'unix'...
% );


%% Lower noise
clear all;close all;clc;
f = 10;
overSample = 100;
fs = overSample * f;
phase = 1/4*pi;
nCycl = 4;
t = 0:1/fs:nCycl*1/f;
y = sin(2*pi*f*t*phase);
noiseAmplitude = 1.5;
noisy_y = y + noiseAmplitude * randn(1, length(y));
plot(t,noisy_y);

%% Denoised Sine, Analog
plot(t,y);
plotFile = 'smoothSine.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [t', y'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Sampled Sine
y_sampled = y(1:100:length(y));
sample_times = t(1:100:length(t));
stem(sample_times,y_sampled);
plotFile = 'sampledSine.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [sample_times', y_sampled'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Spectrum of Noisy Signal (exaggerated)
% detr_noisy_y = detrend(noisy_y,0);
% ydft = fft(detr_noisy_y);
% freq = 0:fs/length(noisy_y):fs/2;
% ydft = ydft(1:length(ydft)/2+1);
% plot(freq,abs(ydft));

% NFFT = 2^10;
% ydft = fftshift(fft(noisy_y,NFFT));
% freq = (-NFFT/2:NFFT/2-1)/NFFT;
% plot(freq,abs(ydft));

% plot(1:1000,ones(1000))
plotFile = 'spectrumFlat.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:100)', ones(100,1)],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Spectrum of denoised signal (exaggerated)
passband = ones(400,1)';
transitionband = 1:-0.01:0;
stopband = zeros(499,1)';
spectrum = [passband, transitionband, stopband];
% plot(1:1000,spectrum);

plotFile = 'spectrumLP.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(spectrum))', spectrum'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Spectrum of denoised and sampled signal (exaggerated)
passband = ones(400,1)';
transitionband_down = 1:-0.01:0;
transitionband_up   = fliplr(transitionband_down);
spectrum = [passband, transitionband_down, transitionband_up, passband];
spectrum = [spectrum, fliplr(spectrum)];
% plot(spectrum);
plotFile = 'spectrumSampled.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(1:length(spectrum))', spectrum'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Read noisySine.csv
noisy_sine_t = csvread('noisySine.csv',1,0);
spectrum = fft(noisy_sine_t(:,2))./length(noisy_sine_t(:,2));
spectrum = spectrum(1:(length(spectrum)-1)/2)*2;
spectrum = spectrum(1:100);
% stem(abs(spectrum(1:100)))
plotFile = 'noisySineFFT.csv';
f = 0:1:length(spectrum)-1;
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [f' abs(spectrum)],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);

%% Sine
f = 10;
overSample = 1000;
fs = overSample * f;
phase = 1/4*pi;
nCycl = 4;
t = 0:1/fs:nCycl*1/f;
y = sin(2*pi*f*t*phase);
spectrum = fft(y)./length(y);
spectrum = spectrum(1:(length(spectrum)-1)/2)*2;
spectrum = spectrum(1:100);
% stem(abs(spectrum(1:100)));
plotFile = 'sineFFT.csv';
f = 0:1:length(spectrum)-1;
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'f', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [f' abs(spectrum)'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);
plotFile = 'sine.csv';
f = 0:1:length(spectrum)-1;
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 't', 'y');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [t' y'],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);