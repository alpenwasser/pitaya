function [Hcasc] = cascador(R, Fs, Fp, Fst, Ap, Ast, coefDir, plotDir, stages)
%Cascade Generator
%
% Takes a number of filters and cascades them
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-25

plotDir=strcat(plotDir,'/','cascador');
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

% NOTE: This will not catch the error of stages having enough cells,
% but those cells not having been filled.
if length(stages) < 2
    error('Not enough stages!')
end

Hcasc  = cell(length(Fp),length(Ap),length(Fst),length(Ast),7);

t = 0;             % total number of filters; filter number
l = 1;             % cell index for Fp
for fp = Fp
    i = 1;         % cell index for Ap
    for ap = Ap
        j = 1;     % cell index for Fst
        for fst = Fst
            k = 1; % cell index for Ast
            for ast = Ast
                % First, we create a two-stage cascade
                Hcasc{l,i,j,k,1} = cascade(...
                    stages{1}{l,i,j,k,1},...
                    stages{2}{l,i,j,k,1}...
                );
                % If there are more stages, we append them
                % to the existing cascade.
                if length(stages) > 2
                    for stage = 3:length(stages)
                        Hcasc{l,i,j,k,1}.addStage(stages{stage}{l,i,j,k,1});
                    end
                end

                % Generate output file names
                basename = strcat(...
                    'r-',  num2str(R),'--',...
                    'fs-', num2str(l),'--',...
                    'ap-', num2str(i),'--',...
                    'fst-',num2str(j),'--',...
                    'ast-',num2str(k),'--',...
                    'stages-',num2str(length(stages)));

                plotFile = strcat(...
                    plotDir,'/',...
                    basename,...
                    '.csv');

                % Save Filter Plot Data
                [H,W] = freqz(Hcasc{l,i,j,k,1}, 1e3);
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
