%%
files = dir('measurements/r5/*.csv');
set(0,'DefaultFigureWindowStyle','docked')
figure;
sample = 0
for file = files'
    csv = csvread(sprintf('measurements/r5/%s', file.name), 1, 0);
    hold on;
    plot(10*log10(abs(fft(csv))/length(csv)));
    display(file.name);
    sample = sample + 1;
    if(sample == 39) break; end
end

%%
clc; clear;
decArr = [2500, 1250, 625, 125, 25, 5];
decArr = [2500, 1250];
for dec = decArr
    files = dir(sprintf('measurements/r%d/*.csv',dec));
    set(0,'DefaultFigureWindowStyle','docked')
    figure;
    f = [];
    xrms = [];
    xmean = [];
    xsnr = [];
    for file = files'
        csv = csvread(sprintf('measurements/r%d/%s', dec, file.name), 1, 0);
        hold on;
        b = str2double(file.name(1:end-4));
%         if b == 0 || b/2000*5 > 1 * 0.95
%             continue
%         end
        data = csv ./ 2^15 * 1.1;
        f = [f b];
        xrms = [xrms rms(data)];
        xmean = [xmean mean(data)];
        xsnr = [xsnr snr(data, 125000000/dec, 12)];
        if(201 == b || 202 == b || 203 == b || 300 == b)
            figure;
            snr(data, 125000000/dec, 12)
        end
%         display(file.name);
    end
    
    trms = mean(xrms)
    tmean = mean(xmean)
    tsnr = mean(xsnr)

    figure;
    scatter(f, xsnr);

    plotFile = sprintf('measurements/results/calcs%d.csv', dec);
    fh = fopen(plotFile,'w');
    if fh ~= -1
        fprintf(fh, '%s,%s,%s,%s\n', 'f', 'xrms', 'xmean', 'xsnr');
        fclose(fh);
    end
    dlmwrite(...
        plotFile,...
        [f', xrms', xmean', xsnr'],...
        '-append',...
        'delimiter', ',',...
        'newline', 'unix'...
    );
end

%%
dec = 5;
fs = 125000000 / dec;
N = 8192;

figure;
set(0,'DefaultFigureWindowStyle','docked')
hold on;
pArr = [];
fArr = [100, 410, 700];
for f = fArr
    csv = csvread(sprintf('measurements/r%d/%d.csv', dec, f), 1, 0);

    data = csv ./ 2^15 * 1.1;
    data = data .* sqrt(1/(2*fs*N));
    X = fft(data);
    Xone = X(1:N/2+1) * 2;
    Xabs = abs(Xone);
    P = sum(Xabs.^2) * fs / N;
    plot(10*log10(Xabs.^2));
    pArr = [pArr 10*log10(Xabs.^2)];
end

plotFile = sprintf('measurements/results/attenuation%d.csv', dec);
fh = fopen(plotFile,'w');
if fh ~= -1
    fprintf(fh, '%s,%s,%s,%s\n', 'f', 's100', 's410', 's700');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [(0:N/2)', pArr],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);