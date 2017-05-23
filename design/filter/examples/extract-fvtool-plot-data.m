% How to extract plot data from fvtool and save it in variables
% for plotting

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
