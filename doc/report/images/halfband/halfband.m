%% Half-band Filter Example
d = fdesign.decimator(2,'halfband','Tw,Ast',0.1,30);
Hd = design(d,'SystemObject',true);


%% Store results
[H,w] = zerophase(Hd);
plotFile = 'halfbandZerophase.csv';
fh = fopen(plotFile,'w'); 
if fh ~= -1
    fprintf(fh, '%s,%s\n', 'abs(H)', 'w');
    fclose(fh);
end
dlmwrite(...
    plotFile,...
    [H w],...
    '-append',...
    'delimiter', ',',...
    'newline', 'unix'...
);