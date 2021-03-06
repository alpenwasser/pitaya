% Design a CIC Filter and its compensator in relative frequency terms.
Rcic      = 6;           % Decimation factor for CIC filter
diffDelay = 1;            % Differential Delay
Fpass     = 1/Rcic*.25;   % Passband of interest for CIC (normalized)
Astop     = 40;           % Stop band attenuation in dB for total chain
                          % as well as both individual filters.
Fstop     = 1.01 * Fpass;  % Stop band edge; normalized to  higher sampling
                          % rate, because that's what we care about in the
                          % end. Used for compensation filter.
Apass     = 0.01;         % Pass band ripple in dB

dcic = fdesign.decimator(Rcic,'cic',diffDelay,'Fp,Ast',Fpass,Astop);
Hcic = design(dcic,'SystemObject',true);

dcomp = fdesign.ciccomp(...
    Hcic.DifferentialDelay,...
    Hcic.NumSections,...
    Fpass * Rcic * 2,... % Compensation Filter runs at lower frequency.
    ...                  % Also account for norm to fs/2 instead of fs.
    Fstop * Rcic * 2,... % Compensate for that.
    Apass,...
    Astop...
);
Hcomp = design(dcomp,'SystemObject',true);

fvtool(Hcic,Hcomp,cascade(Hcic,Hcomp));
legend('CIC','CIC Reference','Comp','Cascade');

% Just as a reminder: Extracting data and plotting in dB. This should
% already be present in other files, but here it is again.
% [Hzcic,W] = freqz(Hcic);
% HzcicAbs  = abs(Hzcic);
% HzcicAbs  = HzcicAbs./max(HzcicAbs);
% plot(W,20*log10(HzcicAbs));
