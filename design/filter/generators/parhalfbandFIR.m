function Hd = parhalfbandFIR(R, Tw, Ast, coefDir, plotDir)
%PARHALFBANDFIR Iteratively design Halfband FIR decimators. Parallel version.
%   Hd = parhalfbandFIR(R, Tw, Ast, coefDir, plotDir)
%
%   INPUT ARGUMENTS
%       R:  decimation factor
%
%       Iteration Parameters
%       Tw:  transition band widths (normalized) (double array)
%       Ast: stop band attenuation in dB         (double array)
%
%       coefDir: directory in which to store coefficients
%       plotDir: directory in which to store output plot points
%
%   RETURN VALUE
%       Hd:  N x 4 cell array
%       Structure:
%       Hd{N,4}
%
%       Where:
%       N = L*P
%       L = length(Tw)
%       P = length(Ast)
%
%       Hd{n,1}: Filter: FIR decimator object
%       Hd{n,2}:      R: decimation factor
%       Hd{n,3}:     Tw: transition band width
%       Hd{n,4}:    Ast: stop band attenuation in dB
%       Where:
%       n = p*L + l + 1;
%
%   SEE ALSO
%       decFIR, pardecFIR, cascador, parcascador, halfbandFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-29

coefDir = fullfile(coefDir,'halfbandFIR');
plotDir = fullfile(plotDir,'halfbandFIR');
if ~exist(coefDir,'dir')
    mkdir(coefDir);
end
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

% ---------------------------------------------------- Filter Design Objects
L = length(Tw);
P = length(Ast);
N = L*P;

Hd = cell(N,4);


for l = 0:L-1
    for p = 0:P-1
        n = p*L + l + 1;
        Hd{n,1} =        R;
        Hd{n,2} =  Tw(l+1);
        Hd{n,3} = Ast(p+1);
    end
end

gcp();
Hpar = cell(N,1);
parfor n = 1:N
    % Specify Filter
    d = fdesign.decimator(...
        R,...
        'halfband',...
        'Tw,Ast',...
        Hd{n,2},...
        Hd{n,3});

    % Design Filter
    Hpar{n,1} = design(d,'SystemObject',true);

    % Generate output file names
    basename = strcat(...
        'r-',  num2str(R              ,'%03.0f'),'--',...
        'tw-', num2str(Hd{n,2} * 1000 ,'%03.0f'),'--',...
        'ast-',num2str(Hd{n,3}        ,'%02.0f'));

    coefBasename = strcat(basename,'.coe');
    plotBasename = strcat(basename,'.csv');

    coefFile = fullfile(coefDir, coefBasename);
    plotFile = fullfile(plotDir, plotBasename);

    % Save Filter Coefficients
    fh = fopen(coefFile, 'w');
    if fh ~= -1
        fprintf(fh, 'radix=10;\n');
        fprintf(fh, 'coefdata=\n');
        fprintf(...
            fh,...
            [...
                repmat(...
                '%.16f,\n',...
                1,...
                numel(Hpar{n,1}.Numerator) - 1),...
                '%.16f;\n'...
            ],...
            Hpar{n,1}.Numerator ...
        );
        fclose(fh);
    end

    % Save Filter Plot Data
    [H,W] = freqz(Hpar{n,1}, 1e3);
    fh = fopen(plotFile, 'w');
    if fh ~= -1
        fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
        fclose(fh);
    end
    dlmwrite(...
        plotFile,...
        [abs(H) unwrap(angle(H)) W],...
        '-append',...
        'delimiter', ',',...
        'newline', 'unix'...
    );
end

% Copy back to Hd
for n = 1:N
    Hd{n,4} =  Hpar{n,1};
end
end % End of Function
