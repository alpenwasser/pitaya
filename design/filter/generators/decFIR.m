function [Hd] = decFIR(R, Fs, Fp, Fst, Ap, Ast, genDir)
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

outDir=strcat(genDir,'/','decFIR');
mkdir(outDir);

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
                d = fdesign.decimator(...
                    R,...
                    'lowpass',...
                    'Fp,Fst,Ap,Ast',...
                    fp,...
                    fst,...
                    ap,...
                    ast);

                Hd{l,i,j,k,1} = design(d,'SystemObject',true);
                Hd{l,i,j,k,2} = R;
                Hd{l,i,j,k,3} = fp;
                Hd{l,i,j,k,4} = ap;
                Hd{l,i,j,k,5} = fst;
                Hd{l,i,j,k,6} = ast;
                Hd{l,i,j,k,7} = t;

                fileName = strcat(...
                    outDir,'/',...
                    'r-',  num2str(R),'--',...
                    'fs-', num2str(l),'--',...
                    'ap-', num2str(i),'--',...
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
                            '%.15f,\n',...
                            1,...
                            numel(Hd{l,i,j,k,1}.Numerator) - 1),...
                            '%.15f;\n'...
                        ],...
                        Hd{l,i,j,k,1}.Numerator ...
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
end % End of Function

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
