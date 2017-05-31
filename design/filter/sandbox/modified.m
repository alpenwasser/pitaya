clear all;close all;clc;

% https://ch.mathworks.com/help/dsp/ref/fdesign.ciccomp.html
fs     = 125e6;    % Input sampling frequency.
fpass  = 49e3;     % Frequency band of interest. (End of Pass Band)
f_stop = 50e3;     % Start of Stop Band
R      = 625;      % Decimation factor.
sbA    = 30;       % Stop band attenuation
M      = 1;        % Differential Delay
hfvt_noP = 1e5;    % Number of points for filter visualize tool

hcic = design(fdesign.decimator(R,'cic',M,fpass,sbA,fs),'SystemObject',true);

hcomp = design(...
    fdesign.ciccomp(...
        hcic.DifferentialDelay, ...
        hcic.NumSections,...
        fpass,...
        f_stop,...
        .1,...
        sbA,...
        fs/R...
    ),'SystemObject',true);

% https://ch.mathworks.com/matlabcentral/answers/160697-how-to-save-fvtool-diagram-as-a-matlab-figure
hfvt = fvtool(hcic,hcomp,...
    cascade(hcic,hcomp),'ShowReference','off','Fs',[fs fs/R fs])
set(hfvt, 'NumberofPoints', hfvt_noP);
legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');
s = get(hfvt);
hchildren = s.Children;
haxes = hchildren(strcmpi(get(hchildren,'type'),'axes'));
hline = get(haxes,'children');
x = get(hline,'XData');
y = get(hline,'YData');

% figure;
% plot(x{1,:},y{1,:});
% hold on;
% plot(x{2,:},y{2,:});
% plot(x{3,:},y{3,:});
