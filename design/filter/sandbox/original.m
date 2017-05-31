clear all;close all;clc

% Mathworks website:
% https://ch.mathworks.com/help/dsp/ref/fdesign.ciccomp.html

fs = 96e3;   % Input sampling frequency.
fpass = 4e3; % Frequency band of interest.
m = 6;  % Decimation factor.
hcic = design(fdesign.decimator(m,'cic',1,fpass,60,fs),'SystemObject',true);
hd = design(fdesign.ciccomp(hcic.DifferentialDelay, ...
            hcic.NumSections,fpass,4.5e3,.1,60,fs/m),'SystemObject',true);
% fvtool(hcic,hd,...
%     cascade(hcic,hd),'ShowReference','off','Fs',[96e3 96e3/m 96e3])
%     legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');

% https://ch.mathworks.com/matlabcentral/answers/160697-how-to-save-fvtool-diagram-as-a-matlab-figure

hfvt = fvtool(hcic,hd,...
    cascade(hcic,hd),'ShowReference','off','Fs',[96e3 96e3/m 96e3])
    legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');
s = get(hfvt);
hchildren = s.Children;
haxes = hchildren(strcmpi(get(hchildren,'type'),'axes'));
hline = get(haxes,'children');
x = get(hline,'XData');
y = get(hline,'YData');

% https://ch.mathworks.com/help/matlab/matlab_prog/access-data-in-a-cell-array.html
figure;
plot(x{1,:},y{1,:});
hold on;
plot(x{2,:},y{2,:});
plot(x{3,:},y{3,:});