function [Hcasc] = cascador(R, Fp, Fst, Ap, Ast, plotDir, stages)
%CASCADOR Cascade filters.
%   Hcasc = cascador(R, Fp, Fst, Ap, Ast, plotDir, stages)
%       Take a number of iteration parameters and filters and
%       cascade the filters.
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
%       plotDir: directory in which to store output plot points
%
%       stages: Nx1 cell array containing 5-D cell arrays with
%               filters and meta information.
%               The 5-D cell arrays are of the type returned by
%               decFIR.m
%
%   RETURN VALUE
%       Hcasc:  5-D cell array as returned by decFIR.m
%
%   SEE ALSO
%       decFIR, pardecFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-25

plotDir=fullfile(plotDir,'cascador');
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
                    'r-',     num2str(R,         '%03.0f'),'--',...
                    'fp-',    num2str(fp  * 1000,'%03.0f'),'--',...
                    'fst-',   num2str(fst * 1000,'%03.0f'),'--',...
                    'ap-',    num2str(ap  * 1000,'%03.0f'),'--',...
                    'ast-',   num2str(ast       ,'%02.0f'),'--',...
                    'stages-',num2str(length(stages))        ,...
                    '.csv');

                plotFile = fullfile(plotDir, basename);

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
