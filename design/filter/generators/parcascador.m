function Hcasc = cascador(R, Fp, Fst, Ap, Ast, plotDir, stages)
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
%       stages: Mx1 cell array containing Nx6 cell arrays with
%               filters and meta information, where M corresponds
%               to the number of stages to cascade.
%               The Nx6 cell arrays are of the type returned by
%               decFIR.m and pardecFIR.m
%
%   RETURN VALUE
%       Hcasc:  Nx6 cell array as returned by decFIR.m
%
%   SEE ALSO
%       cascador, compCIC, decCIC, decFIR, pardecFIR
%       halfbandFIR, parhalfbandFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-28

plotDir=fullfile(plotDir,'cascador');
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

% NOTE: This will not catch the error of stages having enough cells,
% but those cells not having been filled.
if length(stages) < 2
    error('Not enough stages!')
end

L = length(Fp);
M = length(Ap);
O = length(Fst);
P = length(Ast);
N = L*M*O*P;

Hcasc  = cell(N,6);

for l = 0:L-1
    for m = 0:M-1
        for o = 0:O-1
            for p = 0:P-1
                n = p*(O*M*L) + o * (M*L) + m * (L) + l + 1;
                Hcasc{n,2} =  Fp(l+1);
                Hcasc{n,3} =  Ap(m+1);
                Hcasc{n,4} = Fst(o+1);
                Hcasc{n,5} = Ast(p+1);
                Hcasc{n,6} = R;
            end
        end
    end
end

gcp();
Hpar = cell(N,1);
parfor n = 1:N
    % First, we create a two-stage cascade
    Hpar{n,1} = cascade(...
        stages{1}{n,1},...
        stages{2}{n,1}...
    );
    % If there are more stages, we append them
    % to the existing cascade.
    if length(stages) > 2
        for stage = 3:length(stages)
            Hpar{n,1}.addStage(stages{stage}{n,1});
        end
    end

    % Generate output file names
    basename = strcat(...
        'r-',  num2str(R                 ,'%03.0f'),'--',...
        'fp-', num2str(Hcasc{n,2} * 1000 ,'%03.0f'),'--',...
        'fst-',num2str(Hcasc{n,3} * 1000 ,'%03.0f'),'--',...
        'ap-', num2str(Hcasc{n,4} * 1000 ,'%03.0f'),'--',...
        'ast-',num2str(Hcasc{n,5}        ,'%02.0f'),'--',...
        'stages-',num2str(length(stages))            ,...
        '.csv');

    plotFile = fullfile(plotDir, basename);

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

% Copy back to Hcasc
for n = 1:N
    Hcasc{n,1} =  Hpar{n,1};
end
end % End of Function
