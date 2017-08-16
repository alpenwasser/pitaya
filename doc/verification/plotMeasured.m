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

plot(csvread('measurements/r5/1.csv', 1, 0));