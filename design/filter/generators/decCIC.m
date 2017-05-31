function Hd = decCIC(R, Fp, Ast, DL, plotDir)
%DECCIC Iteratively design CIC decimators.
%   Hd = decCIC(R, Fp, Ast, DL, plotDir)
%
%   INPUT ARGUMENTS
%       R:  decimation factor
%
%       Iteration Parameters
%       Fp:  pass band of interest (normalized) (double array)
%       Ast: stop band attenuation in dB        (double array)
%       DL:  differential delay                 (double array)
%
%       plotDir: directory in which to store output plot points
%
%   RETURN VALUE
%       Hd:  N x 4 cell array
%       Structure:
%       Hd{N,4}
%
%       Where:
%       N = L*P
%       L = length(Fp)
%       M = length(Ast)
%       P = length(DL)
%
%       Hd{n,1}: Filter: CIC decimator object
%       Hd{n,2}:     Fp: pass band edge frequency 
%       Hd{n,3}:    Ast: stop band attenuation in dB
%       Hd{n,4}:     DL: differential delay
%       Hd{n,5}:      R: decimation factor
%       Where:
%       n = p*(M*L) + m*L + l + 1;
%
%   SEE ALSO
%       cascador, parcascador, compCIC, decFIR, pardecFIR, 
%       halfbandFIR, parhalfbandFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-21

plotDir = fullfile(plotDir,'decCIC');
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end

L = length(Fp);
M = length(Ast);
P = length(DL);
N = L*M*P;

Hd = cell(N,5);

for l = 0:L-1
    for m = 0:M-1
        for p = 0:P-1
            n = p*(M*L) + m*L + l + 1;

            Hd{n,2} = Fp(l+1);
            Hd{n,3} = Ast(m+1);
            Hd{n,4} = DL(p+1);
            Hd{n,5} = R;

            % Specify Filter
            d = fdesign.decimator(...
                R,...
                'CIC',...
                Hd{n,4},...
                'Fp,Ast',...
                Hd{n,2},...
                Hd{n,3});

            % Design Filter
            Hd{n,1} = design(d,'SystemObject',true);

            % Generate output file names
            basename = strcat(...
                'r-',  num2str(R              ,'%03.0f'),'--',...
                'fp-', num2str(Hd{n,2} * 1000 ,'%03.0f'),'--',...
                'ast-',num2str(Hd{n,3}        ,'%03.0f'),'--',...
                'dl-' ,num2str(Hd{n,4}        ,'%d'));

            plotBasename = strcat(basename,'.csv');

            plotFile = fullfile(plotDir, plotBasename);

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
end % End of Function
