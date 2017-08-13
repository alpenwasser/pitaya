function recordData(x, samplingRate)
    persistent freq;
    if length(freq) == 0
        freq = 0;
    end
    plotFile = sprintf('measurements%d/%d.csv', 125e6 / samplingRate, freq);
    freq = freq + 1;
    fh = fopen(plotFile,'w');
    if fh ~= -1
        fprintf(fh, '%s\n', 'x');
        fclose(fh);
    end
    dlmwrite(...
        plotFile,...
        [x],...
        '-append',...
        'delimiter', ',',...
        'newline', 'unix'...
    );
end