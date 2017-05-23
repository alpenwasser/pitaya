function [Hd] = decFIR(R, Fs, Fp, Fst, Ap, Ast, coefDir, plotDir)
%FILTER DESIGNER
%
% DESCRIPTION
% Designs FIR Filters for Decimation Ratio of 5
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21

coefDir=strcat(coefDir,'/','decFIR');
plotDir=strcat(plotDir,'/','decFIR');
mkdir(coefDir);
mkdir(plotDir);

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
                    'r-',  num2str(R),'--',...
                    'fs-', num2str(l),'--',...
                    'ap-', num2str(i),'--',...
                    'fst-',num2str(j),'--',...
                    'ast-',num2str(k));

                coefFile = strcat(...
                    coefDir,'/',...
                    basename,...
                    '.coe');

                plotFile = strcat(...
                    plotDir,'/',...
                    basename,...
                    '.csv');

                % Save Filter Coefficients
                fh = fopen(coefFile, 'w');
                if fh ~= -1
                    fprintf(fh, 'radix=10;\n');
                    fprintf(fh, 'coefdata=\n');
                    fprintf(...
                        fh,...
                        [...
                            repmat(...
                            '%.15f,\n',...
                            1,...
                            numel(Hd{l,i,j,k,1}.Numerator) - 1),...
                            '%.15f;\n'...
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
