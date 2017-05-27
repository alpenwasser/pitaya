function [Hd] = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir)
%DECFIR Iteratively design FIR decimators.
%   Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir)
%
%   INPUT ARGUMENTS
%       R:  decimation factor
%
%       Iteration Parameters
%       Fp:  pass band edge frequencies (normalized) (array)
%       Fst: stop band edge frequencies (normalized) (array)
%       Ap:  pass band ripples in dB (array)
%       Ast: stop band attenuation in dB (array)
%
%       coefDir: directory in which to store coefficients
%       plotDir: directory in which to store output plot points
%
%   RETURN VALUE
%       Hd:  5-D cell array
%       Structure:
%       Hd{l,i,j,k,:}
%
%       Its first four coordinates are:
%       l: cell index for Fp
%       i: cell index for Ap
%       j: cell index for Fst
%       k: cell index for Ast
%
%       Finally, in the last coordinate, we store the actual
%       information (yes a Map would also be a way to implement
%       this, but that carries its own pitfalls and drawbacks
%       in the Matlab world).
%       Hd{l,i,j,k,1}       FIR decimator object
%       Hd{l,i,j,k,2}:   R: decimation factor
%       Hd{l,i,j,k,3}:  Fp: pass band edge frequency
%       Hd{l,i,j,k,4}:  Ap: pass band ripple in dB
%       Hd{l,i,j,k,5}: Fst: stop band edge frequency
%       Hd{l,i,j,k,6}: Ast: stop band attenuation in dB
%       Hd{l,i,j,k,7}:   t: filter number in iteration
%
%   SEE ALSO
%       cascador, pardecFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-21

coefDir = fullfile(coefDir,'decFIR');
plotDir = fullfile(plotDir,'decFIR');
if ~exist(coefDir,'dir')
    mkdir(coefDir);
end
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

% ---------------------------------------------------- Filter Design Objects
Hd  = cell(length(Fp),length(Ap),length(Fst),length(Ast),7);

t = 0;             % total number of filters; filter number
l = 1;             % cell index for Fp
for fp = Fp
    i = 1;         % cell index for Ap
    for ap = Ap
        j = 1;     % cell index for Fst
        for fst = Fst
            k = 1; % cell index for Ast
            for ast = Ast

                % Specify Filter
                d = fdesign.decimator(...
                    R,...
                    'lowpass',...
                    'Fp,Fst,Ap,Ast',...
                    fp,...
                    fst,...
                    ap,...
                    ast);

                % Design Filter
                Hd{l,i,j,k,1} = design(d,'SystemObject',true);

                % Store additional Data for Filter
                Hd{l,i,j,k,2} = R;
                Hd{l,i,j,k,3} = fp;
                Hd{l,i,j,k,4} = ap;
                Hd{l,i,j,k,5} = fst;
                Hd{l,i,j,k,6} = ast;
                Hd{l,i,j,k,7} = t;

                % Generate output file names
                basename = strcat(...
                    'r-',  num2str(R,          '%03.0f'),'--',...
                    'fp-', num2str(fp  * 1000 ,'%03.0f'),'--',...
                    'fst-',num2str(fst * 1000 ,'%03.0f'),'--',...
                    'ap-', num2str(ap  * 1000 ,'%03.0f'),'--',...
                    'ast-',num2str(ast        ,'%02.0f'));

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
                            numel(Hd{l,i,j,k,1}.Numerator) - 1),...
                            '%.16f;\n'...
                        ],...
                        Hd{l,i,j,k,1}.Numerator ...
                    );
                    fclose(fh);
                end

                % Save Filter Plot Data
                [H,W] = freqz(Hd{l,i,j,k,1}, 1e3);
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

                k = k+1;
                t = t+1;
            end
            j = j+1;
        end
        i = i+1;
    end
    l = l+1;
end
end % End of Function
