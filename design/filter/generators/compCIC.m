function Hd = compCIC(R, Fp, Fst, Ap, Ast, DL, Hcic, coefDir, plotDir)
%COMPCIC Iteratively design FIR compensators for CIC decimators.
%   Hd = compCIC(R, Fp, Fst, Ap, Ast, DL, Hcic, coefDir, plotDir)
%
%   Design multiple compensators for several CIC decimators.
%   INPUT ARGUMENTS
%       R:  decimation factor
%
%       Iteration Parameters
%       Fp:  pass band edge frequencies
%            (normalized to CIC frequency scale) (array)
%       Fst: stop band edge frequencies
%            (normalized to CIC frequency scale) (array)
%       Ap:  pass band ripples in dB (array)
%       Ast: stop band attenuation in dB (array)
%       DL:  differential delay
%
%       Hcic: Cell array of CIC filters and their parameters
%
%       coefDir: directory in which to store coefficients
%       plotDir: directory in which to store output plot points
%
%   RETURN VALUE
%       Hd:  Q x 8 cell array
%
%       Where:
%       Q = O*K*L*M*P
%       O = length(Fst)
%       K = length(Ap)
%       L = length(Fp)
%       M = length(Ast)
%       P = length(DL)
%
%       Structure:
%       Hd{q,1}: Filter: Cascade of CIC and Compensator
%       Hd{q,2}: Filter: CIC Filter
%       Hd{q,3}: Filter: Compensator
%       Hd{q,4}:     Fp: pass band frequency
%                        (normalized to CIC frequency scale)
%       Hd{q,5}:      R: decimation factor
%       Hd{q,6}:    Fst: stop band edge frequency
%                        (normalized to CIC frequency scale)
%       Hd{q,7}:    Ast: stop band attenuation in dB
%       Hd{q,8}:      R: decimation factor
%       Where:
%       q = o * (K*P*M*L) + k * (P*M*L) + p*(M*L) + m*L + l + 1;
%
%   SEE ALSO
%       cascador, parcascador, decCIC, decFIR, pardecFIR,
%       halfbandFIR, parhalfbandFIR
%
%   AUTHORS:
%       Raphael Frey, <rmfrey@alpenwasser.net>
%
%   DATE:
%       2017-MAY-29

coefDir = fullfile(coefDir,'compCIC');
cascDir = fullfile(plotDir,'cascCIC');
plotDir = fullfile(plotDir,'compCIC');
if ~exist(coefDir,'dir')
    mkdir(coefDir);
end
if ~exist(plotDir,'dir')
    mkdir(plotDir);
end
if ~exist(cascDir,'dir')
    mkdir(cascDir);
end

L = length(Fp);
M = length(Ast);
P = length(DL);
N = L*M*P;

K = length(Ap);
O = length(Fst);
Q = O*K*N;

Hd = cell(Q,8);

compensatorDecimation = R;

% Iterate through all decimators.
for l = 0:L-1
    for m = 0:M-1
        for p = 0:P-1
            n = p*(M*L) + m*L + l + 1;

            % Design a bunch of compensators for each decimator.
            for k = 0:K-1
                for o = 0:O-1
                    q = o * (K*P*M*L) + k * (P*M*L) + n;

                       %Hd{q,1} : reserved for cascade
                        Hd{q,2} = Hcic{n,1};
                       %Hd{q,3} : reserved for compensator
                        Hd{q,4} =  Fp(l+1);
                        Hd{q,5} =  Ap(k+1);
                        Hd{q,6} = Fst(o+1);
                        Hd{q,7} = Ast(m+1);
                        Hd{q,8} = Hcic{n,1}.DecimationFactor;

                        % Specify Filter
                        % NOTE: 
                        % Since Compensator runs at decimated frequency
                        % coming out of the CIC filter, its Fp and Fst
                        % parameters must be scaled up accordingly.
                        d = fdesign.decimator(...
                            compensatorDecimation,...
                            'ciccomp',...
                            Hcic{n,1}.DifferentialDelay,...
                            Hcic{n,1}.NumSections,...
                            'Fp,Fst,Ap,Ast',...
                            Hd{q,4} * Hcic{n,1}.DecimationFactor,...
                            Hd{q,6} * Hcic{n,1}.DecimationFactor,...
                            Hd{q,5},...
                            Hd{q,7});

                        % Design Filter
                        Hd{q,3} = design(d,'SystemObject',true);

                        % Generate cascade of current CIC and compensator
                        Hd{q,1} = cascade(Hcic{n,1}, Hd{q,3});

                        % Generate output file names
                        basename = strcat(...
                            'r-',  num2str(Hd{q,8}         ,'%03.0f'),'--',...
                            'fp-', num2str(Hd{q,4} * 10000 ,'%04.0f'),'--',...
                            'fst-',num2str(Hd{q,6} * 10000 ,'%04.0f'),'--',...
                            'ap-', num2str(Hd{q,5} * 1000  ,'%03.0f'),'--',...
                            'ast-',num2str(Hd{q,7}         ,'%02.0f'),'--',...
                            'dl-' ,num2str(Hcic{n,1}.DifferentialDelay,'%d'));

                        coefBasename = strcat(basename,'.coe');
                        plotBasename = strcat(basename,'.csv');

                        coefFile = fullfile(coefDir, coefBasename);
                        plotFile = fullfile(plotDir, plotBasename);
                        cascFile = fullfile(cascDir, plotBasename);

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
                                    numel(Hd{n,3}.Numerator) - 1),...
                                    '%.16f;\n'...
                                ],...
                                Hd{q,3}.Numerator ...
                            );
                            fclose(fh);
                        end

                        % Save Compensation Filter Plot Data
                        [H,W] = freqz(Hd{q,3}, 1e4);
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

                        % Save Cascade Plot Data
                        [H,W] = freqz(Hd{q,1}, 1e4);
                        fh = fopen(cascFile, 'w');
                        if fh ~= -1
                            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
                            fclose(fh);
                        end
                        dlmwrite(...
                            cascFile,...
                            [abs(H) unwrap(angle(H)) W],...
                            '-append',...
                            'delimiter', ',',...
                            'newline', 'unix'...
                        );
                    end
                end
            end
        end
    end
end % End of Function
