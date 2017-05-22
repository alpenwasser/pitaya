% ------------------------------------------------------------------------ %
% FILTER DESIGN ITERATOR
%
% DESCRIPTION
% Designs FIR Filters for Decimation Ratio of 5
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21
% ------------------------------------------------------------------------ %

%% ===================================================== FIR: Target: 25 MHz
%
% Specify a number of FIR lowpass filters for a permutation of:
% - Start Frequency of the pass band (upper edge)
% - Stop Frequency of the stop band (lower edge)
% - Ripple in pass band
% - Attenuation in stop band
%
%
% ASCII Diagram of Parameter Meanings:
%
% ^ Mag (dB)¬
% |
% |
% |XXXXXXXXXXXXX        _¬
% |                     _ Apass                   ___¬
% |XXXXXXXXXXXXX                                   ^¬
% |XXXXXXXXXXXXX                                   | Astop¬
% |XXXXXXXXXXXXX                                   |¬
% |XXXXXXXXXXXXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXvXXXXXXX¬
% |XXXXXXXXXXXXX¬
% +--------------------------------------------------------------> f¬
% 0            |     |                                     |¬
%              Fpass Fstop                                 Fs/2¬
%
% See also:
% https://ch.mathworks.com/help/signal/ref/fdesign.lowpass.html
% https://ch.mathworks.com/help/dsp/ref/fdesign.decimator.html

% --------------------------Width of Fixed-Point Filter Coefficients in Bits
coeff_width = 16;

% ------------------------------------------- Input Sampling Frequency in Hz
Fs  = 125e6;

% -------------------------------------------------------- Decimation Factor
R   = 5;

% ---------------------- Frequency at the Start of the Pass Band; Normalized
% NOTE: The smallest number in Fp must be smaller than the smallest number
%       in Fst (see below).
Fp  = [0.1 0.15 0.2];

% ------------- ---------- Stop band frequencies ("How steep is the filter?")
% NOTE: The smallest number in Fst must be larger than the largest number in
%       Fp (see above).
Fst = [0.21 0.22];

% ------------------------------------------------- Ripple in Passband in dB
Ap  = [0.25 0.5 1];

% ------------------------------------------- Attenuation in Stop Band in dB
Ast = [20 40 60 80];

% ---------------------------------------------------- Filter Design Objects
Hd  = cell(length(Fp),length(Ap),length(Fst),length(Ast),2);

% -------------------------- Lengths of Numerators for the Different Filters
% Saves the length of the numerator for each permutation of Fp, Ap, Fst and
% Ast, along with those parameters themselves. Each filter gets a number as
% well (see 't' below).
NumL  = cell(length(Fp),length(Ap),length(Fst),length(Ast),6);

% ----------- Same Thing, for more convenient extraction to file or somesuch
% Saves the length of the numerator for each permutation of Fp, Ap, Fst and
% Ast, but without those parameters.
NumL2 = [];

% Output Directory
directory='dec5FIR';
mkdir(directory);

% Plot as we proceed. This enables color cycling by default.
figure;hold on;
t = 0;             % total number of filters; filter number
l = 1;             % cell index for Fp
for fp = Fp
    i = 1;         % cell index for Ap
    for ap = Ap
        j = 1;     % cell index for Fst
        for fst = Fst
            k = 1; % cell index for Ast
            for ast = Ast
                d = fdesign.decimator(...
                    R,...
                    'lowpass',...
                    'Fp,Fst,Ap,Ast',...
                    fp,...
                    fst,...
                    ap,...
                    ast);

                Hd{l,i,j,k,1} = design(d,'SystemObject',true);
                Hd{l,i,j,k,2} = t;

                NumL{l,i,j,k,1} = fp;
                NumL{l,i,j,k,2} = ap;
                NumL{l,i,j,k,3} = fst;
                NumL{l,i,j,k,4} = ast;
                NumL{l,i,j,k,5} = t;
                NumL{l,i,j,k,6} = length(Hd{l,i,j,k,1}.Numerator);
                NumL2 = [NumL2 NumL{l,i,j,k,6}];
                scatter(t,NumL{l,i,j,k,6});
                
                fileName = strcat(...
                    directory,'/',...
                    'fs-', num2str(l),'--',...
                    'ap-',num2str(i),'--',...
                    'fst-',num2str(j),'--',...
                    'ast-',num2str(k),'.coe');
                
                fh = fopen(fileName, 'w');
                if fh ~= -1
                    fprintf(fh, 'radix=10;\n');
                    fprintf(fh, 'coefdata=\n');
                    fprintf(...
                        fh,...
                        [...
                            repmat(...
                            '%d,\n',...
                            1,...
                            numel(Hd{l,i,j,k,1}.Numerator) - 1),...
                            '%d;\n'...
                        ],...
                        round(...
                            Hd{l,i,j,k,1}.Numerator *...
                            power(2,coeff_width)-1)...
                    );
                    fclose(fh);
                end
                k = k+1;
                t = t+1;
            end
            j = j+1;
        end
        i = i+1;
    end
    l = l+1;
end
% hfvt = fvtool(Hd{:,:,:,:,1},'ShowReference','off','Fs',[Fs]);
% hfvt = fvtool(hcic,hcomp,...
%     cascade(hcic,hcomp),'ShowReference','off','Fs',[fs fs/R fs])
% set(hfvt, 'NumberofPoints', hfvt_noP);
% legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');
% s = get(hfvt);
% hchildren = s.Children;
% haxes = hchildren(strcmpi(get(hchildren,'type'),'axes'));
% hline = get(haxes,'children');
% x = get(hline,'XData');
% y = get(hline,'YData');
