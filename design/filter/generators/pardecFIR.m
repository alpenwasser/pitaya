function Hd = pardecFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir)
%PARDECFIR Iteratively design FIR decimators. Parallel version.
%   Hd = pardecFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir)
%
%   INPUT ARGUMENTS
%       R:  decimation factor (double scalar)
%
%       Iteration Parameters
%       Fp:  pass band edge frequencies (normalized) (double array)
%       Fst: stop band edge frequencies (normalized) (double array)
%       Ap:  pass band ripples in dB                 (double array)
%       Ast: stop band attenuation in dB             (double array)
%
%       coefDir: directory in which to store coefficients       (string)
%       plotDir: directory in which to store output plot points (string)
%
%   RETURN VALUE
%       Hd:  n x 6 cell array
%       Structure:
%       Hd{n,6}
%
%       Where:
%       n = k*(J*I*L) + j * (I*L) + i * (L) + l + 1;
%       L = length(Fp);
%       I = length(Ap);
%       J = length(Fst);
%       K = length(Ast);
%
%       Hd{n,1}:     Fp: pass band edge frequency 
%       Hd{n,2}:      R: decimation factor
%       Hd{n,3}:    Fst: stop band edge frequency
%       Hd{n,4}:    Ast: stop band attenuation in dB
%       Hd{n,5}:      R: decimation factor
%       Hd{n,6}: Filter: FIR decimator object
%
%   SEE ALSO
%       cascador, decFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-28

coefDir = fullfile(coefDir,'decFIR');
plotDir = fullfile(plotDir,'decFIR');
if ~exist(coefDir,'dir')
    mkdir(coefDir);
end
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

% ---------------------------------------------------- Filter Design Objects
L = length(Fp);
I = length(Ap);
J = length(Fst);
K = length(Ast);
cellsize = L*I*J*K;

Hd  = cell(cellsize,6);

% Unroll so that we can slice everything in a single parfor loop.
for l = 0:L-1
    for i = 0:I-1
        for j = 0:J-1
            for k = 0:K-1
                index = k*(J*I*L) + j * (I*L) + i * (L) + l + 1;
                Hd{index,1} =  Fp(l+1);
                Hd{index,2} =  Ap(i+1);
                Hd{index,3} = Fst(j+1);
                Hd{index,4} = Ast(k+1);
                Hd{index,5} = R;
            end
        end
    end
end

% Design filters in parallel (this is the time-consuming part)
gcp();
Hpar = cell(cellsize,1);
parfor n = 1:cellsize
    % Specify Filter
    d = fdesign.decimator(...
        R,...
        'lowpass',...
        'Fp,Fst,Ap,Ast',...
        Hd{n,1},...
        Hd{n,3},...
        Hd{n,2},...
        Hd{n,4});
        
    Hpar{n,1} = design(d,'SystemObject',true);

    basename = strcat(...
        'r-',  num2str(R,             '%03.0f'),'--',...
        'fp-', num2str(Hd{n,1} * 1000 ,'%03.0f'),'--',...
        'fst-',num2str(Hd{n,3} * 1000 ,'%03.0f'),'--',...
        'ap-', num2str(Hd{n,2} * 1000 ,'%03.0f'),'--',...
        'ast-',num2str(Hd{n,4}        ,'%02.0f'));
    
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
for n = 1:cellsize
    Hd{n,6} =  Hpar{n,1};
end
end % End of Function