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
%       Hd:  N x 6 cell array
%       Structure:
%       Hd{N,6}
%
%       Where:
%       N = L*M*O*P
%       L = length(Fp)
%       M = length(Ap)
%       O = length(Fst)
%       P = length(Ast)
%
%       Hd{n,1}: Filter: FIR decimator object
%       Hd{n,2}:     Fp: pass band edge frequency 
%       Hd{n,3}:      R: decimation factor
%       Hd{n,4}:    Fst: stop band edge frequency
%       Hd{n,5}:    Ast: stop band attenuation in dB
%       Hd{n,6}:      R: decimation factor
%       Where:
%       n = p*(O*M*L) + o * (M*L) + m * (L) + l + 1;
%
%   SEE ALSO
%       cascador, parcascador, compCIC, decCIC, pardecFIR, 
%       halfbandFIR, parhalfbandFIR
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

L = length(Fp);
M = length(Ap);
O = length(Fst);
P = length(Ast);
N = L*M*O*P;

Hd = cell(N,6);

for l = 0:L-1
    for m = 0:M-1
        for o = 0:O-1
            for p = 0:P-1
                n = p*(O*M*L) + o * (M*L) + m * (L) + l + 1;

                Hd{n,2} =  Fp(l+1);
                Hd{n,3} =  Ap(m+1);
                Hd{n,4} = Fst(o+1);
                Hd{n,5} = Ast(p+1);
                Hd{n,6} = R;

                % Specify Filter
                d = fdesign.decimator(...
                    R,...
                    'lowpass',...
                    'Fp,Fst,Ap,Ast',...
                    Hd{n,2},...
                    Hd{n,4},...
                    Hd{n,3},...
                    Hd{n,5});

                % Design Filter
                Hd{n,1} = design(d,'SystemObject',true);

                % Generate output file names
                basename = strcat(...
                    'r-',  num2str(R              ,'%03.0f'),'--',...
                    'fp-', num2str(Hd{n,2} * 1000 ,'%03.0f'),'--',...
                    'fst-',num2str(Hd{n,4} * 1000 ,'%03.0f'),'--',...
                    'ap-', num2str(Hd{n,3} * 1000 ,'%03.0f'),'--',...
                    'ast-',num2str(Hd{n,5}        ,'%02.0f'));

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
                            numel(Hd{n,1}.Numerator) - 1),...
                            '%.16f;\n'...
                        ],...
                        Hd{n,1}.Numerator ...
                    );
                    fclose(fh);
                end

                % Save Filter Plot Data
                [H,W] = freqz(Hd{n,1}, 1e3);
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
        end
    end
end
end % End of Function
