% ------------------------------------------------------------------------ %
% cliDispatcher.m
%
% DESCRIPTION
% Designs and showcases various filter chains for evaluation through
% iteration. The generators for various filter types are in a separate
% subdirectory ('generators/').
%
% Environment Variables: filtertype
%
% The filtertype variable must have one of the following values:
% DEC5    will initiate an iterator for a FIR decimation filter with
%         decimation ratio of 5.
%
% Call example: This script is primarily intended to be called from the
% command line:
% matlab -nosplash -nodesktop filtertype=DEC5;dispatcher;
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21
% ------------------------------------------------------------------------ %
% Lowpass specification:
% - Start Frequency of the pass band (upper edge) (Fpass)
% - Stop Frequency of the stop band (lower edge)  (Fstop)
% - Ripple in pass band                           (Apass)
% - Attenuation in stop band                      (Astop)
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

genDir  = 'generators';
coefDir = 'coefData';
plotDir = 'plotData';
addpath(genDir);

% ---------------------------------------------------------------- 5,2 Chain
switch filtertype
    case 'DEC5'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='DEC5';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R   = 5; % T = 40 ns

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        %Fp  = [0.1 0.15 0.2];
        Fp  = 0.2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.225]; % As implemented per 2017-08-04

        %Fst = 0.22;

        % ------------------------------------------------- Ripple in Passband in dB
        %Ap  = [0.25 0.5 1];
        Ap  = [0.2];

        % ------------------------------------------- Attenuation in Stop Band in dB
        %Ast = [20 40 60 80];
        Ast = [60];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
    case 'DEC25'
        % 5 MHz, 200 ns
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 25 ->
        % -> 5 -> 5 ->
        clear all;close all;
        filtertype='DEC25';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R1   = 5;
        R2   = 5;
        R    = R1 * R2;
        Fs1  = Fs;
        Fs2  = Fs1/R1;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp1 = 1/R1;
        Fp2 = 1/R2;
        Fp  = 1/R;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst1 = 0.30;
        Fst2 = 0.225;
        Fst  = 0.225;

        % ------------------------------------------------- Ripple in Passband in dB
        % NOTE: Cascaded filters amplify each other's passpand rippples.
        Ap1  = 0.05;
        Ap2  = 0.20; % to have same filter as for dec5
        Ap   = 0.1;

        % ------------------------------------------- Attenuation in Stop Band in dB
        %Ast = [20 40 60 80];
        Ast1 = 60;
        Ast2 = 60;
        Ast  = 60;

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd1 = decFIR(R1, Fp1, Fst1, Ap1, Ast1, coefDir, plotDir);
        Hd2 = decFIR(R2, Fp2, Fst2, Ap2, Ast2, coefDir, plotDir);

        % ---------------------------------------------------- Filter Design Objects
        stages = cell(2,1);
        stages{1} = Hd1;
        stages{2} = Hd2;
        Hcasc = cascador(R, Fp, Fst, Ap, Ast, 1, plotDir, stages);

        % Plot detail of passband
        % This is for the report.
        plotDirDetail  = fullfile(plotDir,'chainDetails');
        if ~exist(plotDirDetail,'dir')
            mkdir(plotDirDetail);
        end

        W = 0:pi/(R*1e3)*2:pi/R*2;
        H = freqz(Hcasc{1,1}, W);
        plotFile = fullfile(plotDirDetail, 'chain25detail.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC125'
        % 1 MHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 125 ->
        % -> 25 -> 5 ->
        % -> 5 -> 5 -> 5 ->
        clear all;close all;
        filtertype='DEC125';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R     = 125; % overall decimation rate
        RCIC  =  25; % decimation rate in CIC
        RComp =   1; % Compensator decimation rate
        RFIR  =   5; % decimation rate in FIR filter (not the compensator)

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp    = 1/R;

        % The frequency band coming out of the CIC which is of interest.
        % In this case, that is Fp. The CIC filter decimates by 25, going down to
        % 0.04 (normalized to half the new sampling frequency).
        % The final FIR filter decimates by another factor of 5. Thus, the frequency
        % band which is of actual interest at the end of the CIC filter is 0.04/5
        % wide, which equals 0.008.
        FpCIC  = Fp;     % The frequency band coming out of the CIC filter which is of interest.
        FpComp = Fp;     % The frequency band over which the compensator has to work.
        FpFIR  = 1/RFIR; % The frequency band coming out of the final FIR filter which is of interest.

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        FstComp = FpComp + 0.008; % Must be smaller than or equal to 0.04. FpComp = 0.008
                                  % FpComp,max = 0.032
        FstFIR  = 0.225;
        Fst     = FstFIR / RCIC; % overall stop band imposed by the final FIR filter. Only used for filename.

        % ------------------------------------------------- Ripple in Passband in dB
        ApComp = 0.05;
        ApFIR  = 0.2;
        Ap     = ApComp + ApFIR; % Ripple of cascaded filters is additive. Only used for filename.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast     = 60; % only used for filename.
        AstComp = 60;
        AstFIR  = 60;

        % ----------------------------------------------- Differential Delay for CIC
        DL = 1;

        HdCIC   =    decCIC(RCIC,  FpCIC, Ast, DL, plotDir);
        HdComp =   compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
        HdFIR  = decFIR(RFIR, FpFIR,  FstFIR,  ApFIR, AstFIR, coefDir, plotDir);

        stages    = cell(2,1);
        stages{1} = HdComp;
        stages{2} = HdFIR;
        Hcasc     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);

        % NOTE: Something doesn't quite work correctly when iterating and sometimes
        %       not all configurations might be iterated. Fixing this bug might not
        %       be worth the time, so make sure to check results.
        %sizeHdComp = size(HdComp);
        %sizeHdFIR  = size(HdFIR);
        %stages     = cell(2,1);
        %stages{1}  = repmat(HdComp, [sizeHdFIR(1) / sizeHdComp(1),1]);
        %stages{2}  = HdFIR;
        %Hcasc      = parcascador(R, Fp, FstFIR, Ap, Ast, DL, plotDir, stages);

        % Plot detail of passband
        % This is for the report.
        plotDirDetail  = fullfile(plotDir,'chainDetails');
        if ~exist(plotDirDetail,'dir')
            mkdir(plotDirDetail);
        end

        W = 0:pi/(R*1e3)*2:pi/R*2;
        H = freqz(Hcasc{1,1}, W);
        plotFile = fullfile(plotDirDetail, 'chain125detail.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC625'
        % 200 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 625 ->
        % -> 125 -> 5 ->
        % -> 25 -> 5 -> 5
        % -> 5 -> 5 -> 5 -> 5 ->
        clear all;close all;
        filtertype='DEC625';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R     = 625; % overall decimation rate
        RCIC  =  25; % decimation rate in CIC
        RComp =   1; % Compensator decimation rate
        RFIR1 =   5; % decimation rate in flat FIR filter
        RFIR2 =   5; % decimation rate in steep FIR filter

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp    = 1/R;

        % The frequency band coming out of the CIC which is of interest.
        % In this case, that is Fp*RFIR2 (half the sampling frequency before the
        % final FIR decimator).
        FpCIC  = Fp*RFIR2; % The frequency band coming out of the CIC filter which is of interest.
        FpComp = Fp*RFIR1; % The frequency band over which the compensator has to work.
        FpFIR1 = 1/RFIR1;
        FpFIR2 = 1/RFIR2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The compensator's frequency specifications are relative to the CIC filter's.
        %       0.008 transition band width is in terms of the CIC filter, and means that
        %       on the compensator's frequency axis, it will be 0.2 wide (0.008*RCIC).
        FstComp = FpComp + 0.008; % Must be smaller than or equal to 0.04 (1/RCIC). FpComp = 0.008
                                  % FpComp,max = 0.032
        FstFIR1 = 0.225;
        FstFIR2 = 0.225;
        Fst     = FstFIR2 / RCIC / RFIR1; % overall stop band imposed by the final FIR filter. Only used for filename.

        % ------------------------------------------------- Ripple in Passband in dB
        ApComp = 0.05;
        ApFIR1 = 0.05;
        ApFIR2 = 0.20;
        Ap     = ApComp + ApFIR1 + ApFIR2; % Ripple of cascaded filters is additive. Only used for filename.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast     = 60; % only used for filename.
        AstComp = 60;
        AstFIR1 = 60;
        AstFIR2 = 60;

        % ----------------------------------------------- Differential Delay for CIC
        DL = 1;

        HdCIC  =    decCIC(RCIC,  FpCIC, Ast, DL, plotDir);
        HdComp =   compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
        HdFIR1 = decFIR(RFIR1, FpFIR1,  FstFIR1,  ApFIR1, AstFIR1, coefDir, plotDir);
        HdFIR2 = decFIR(RFIR2, FpFIR2,  FstFIR2,  ApFIR2, AstFIR2, coefDir, plotDir);

        stages    = cell(3,1);
        stages{1} = HdComp;
        stages{2} = HdFIR1;
        stages{3} = HdFIR2;
        Hcasc     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);

        % NOTE: Something doesn't quite work correctly when iterating and sometimes
        %       not all configurations might be iterated. Fixing this bug might not
        %       be worth the time, so make sure to check results.
        %sizeHdComp = size(HdComp);
        %sizeHdFIR  = size(HdFIR);
        %stages     = cell(2,1);
        %stages{1}  = repmat(HdComp, [sizeHdFIR(1) / sizeHdComp(1),1]);
        %stages{2}  = HdFIR;
        %Hcasc      = parcascador(R, Fp, FstFIR, Ap, Ast, DL, plotDir, stages);

        % Plot detail of passband
        % This is for the report.
        plotDirDetail  = fullfile(plotDir,'chainDetails');
        if ~exist(plotDirDetail,'dir')
            mkdir(plotDirDetail);
        end

        W = 0:pi/(R*1e3)*2:pi/R*2;
        H = freqz(Hcasc{1,1}, W);
        plotFile = fullfile(plotDirDetail, 'chain625detail.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC1250'
        % 100 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 1250 ->
        % -> 625 -> 2 ->
        % -> 125 -> 5 -> 2 ->
        % -> 25 -> 5 -> 5 -> 2 ->
        % -> 5 -> 5 -> 5 -> 5 -> 2 ->
        clear all;close all;
        filtertype='DEC1250';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R    = 1250; % overall decimation rate
        RCIC  = 125; % decimation rate in CIC
        RComp =   5; % Compensator decimation rate
        RFIR1 =   2; % decimation rate in flat FIR filter

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp    = 1/R;

        % The frequency band coming out of the CIC which is of interest.
        % In this case, that is Fp*RFIR2 (half the sampling frequency before the
        % final FIR decimator).
        FpCIC  = Fp*RFIR1; % The frequency band coming out of the CIC filter which is of interest.
        FpComp = Fp*RFIR1; % The frequency band over which the compensator has to work.
        FpFIR1 = 1/RFIR1;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The compensator's frequency specifications are relative to the CIC filter's.
        FstComp = FpComp + 0.0008; % Must be smaller than or equal to 0.008 (1/RCIC). FpComp = 0.0016
                                   % FpComp,max = 0.0064
        % NOTE: FstComp must be small enough so that it does not get picked up by the repetition
        %       of the halfband filter running at the lower frequency (FsComp/5).
        % Can be checked with:
        % fvtool(Hcasc{1,1},Hcasc{1,1}.Stage1,Hcasc{1,1}.Stage2,Hcasc{1,1}.Stage3,'Fs',[125e6,125e6,1e6,2e5])
        FstFIR2 = 0.225;
        TwHB1   = 0.04;
        FstHB1  = 0.5 + 0.5*TwHB1;
        Fst     = FstHB1 / RCIC / RComp; % overall stop band imposed by the final FIR filter. Only used for filename.

        % ------------------------------------------------- Ripple in Passband in dB
        ApComp = 0.05;
        ApHB1  = 0.20;
        Ap     = ApComp + ApHB1; % Ripple of cascaded filters is additive. Only used for filename.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast     = 60; % only used for filename.
        AstComp = 60;
        AstHB1  = 60;

        % ----------------------------------------------- Differential Delay for CIC
        DL = 1;

        HdCIC  =    decCIC(RCIC,  FpCIC, Ast, DL, plotDir);
        HdComp =   compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
        HdHB1  = halfbandFIR(2, TwHB1, AstHB1, coefDir, plotDir);

        stages    = cell(2,1);
        stages{1} = HdComp;
        stages{2} = HdHB1;
        Hcasc     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);

        % NOTE: Something doesn't quite work correctly when iterating and sometimes
        %       not all configurations might be iterated. Fixing this bug might not
        %       be worth the time, so make sure to check results.
        %sizeHdComp = size(HdComp);
        %sizeHdFIR  = size(HdFIR);
        %stages     = cell(2,1);
        %stages{1}  = repmat(HdComp, [sizeHdFIR(1) / sizeHdComp(1),1]);
        %stages{2}  = HdFIR;
        %Hcasc      = parcascador(R, Fp, FstFIR, Ap, Ast, DL, plotDir, stages);

        % Plot detail of passband
        % This is for the report.
        plotDirDetail  = fullfile(plotDir,'chainDetails');
        if ~exist(plotDirDetail,'dir')
            mkdir(plotDirDetail);
        end

        W = 0:pi/(R*1e3)*2:pi/R*2;
        H = freqz(Hcasc{1,1}, W);
        plotFile = fullfile(plotDirDetail, 'chain1250detail.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC2500'
        % 50 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 2500 ->
        % -> 1250 -> 2 ->
        % -> 625 -> 2 -> 2 ->
        % -> 125 -> 5 -> 2 -> 2 ->
        % -> 25 -> 5 -> 5 -> 2 ->
        % -> 5 -> 5 -> 5 -> 5 -> 2 -> 2 ->
        clear all;close all;
        filtertype='DEC2500';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R    = 1250; % overall decimation rate
                     % NOTE: This is not a typo! Set to 1250 so that the same CIC
                     % Filter results.
        RCIC  = 125; % decimation rate in CIC
        RComp =   5; % Compensator decimation rate
        RFIR1 =   2; % decimation rate in flat FIR filter
        RFIR2 =   2; % decimation rate in flat FIR filter

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp    = 1/R;

        % The frequency band coming out of the CIC which is of interest.
        % In this case, that is Fp*RFIR2 (half the sampling frequency before the
        % final FIR decimator).
        FpCIC  = Fp*RFIR1; % The frequency band coming out of the CIC filter which is of interest.
        FpComp = Fp*RFIR1; % The frequency band over which the compensator has to work.
        FpFIR1 = 1/RFIR1;
        FpFIR2 = 1/RFIR2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The compensator's frequency specifications are relative to the CIC filter's.
        FstComp = FpComp + 0.0008; % Must be smaller than or equal to 0.008 (1/RCIC). FpComp = 0.0016
                                   % FpComp,max = 0.0064
        % NOTE: FstComp must be small enough so that it does not get picked up by the repetition
        %       of the halfband filter running at the lower frequency (FsComp/5).
        % Can be checked with:
        % fvtool(Hcasc{1,1},Hcasc{1,1}.Stage1,Hcasc{1,1}.Stage2,Hcasc{1,1}.Stage3,'Fs',[125e6,125e6,1e6,2e5])
        FstFIR2 = 0.225;
        TwHB1   = 0.04;
        TwHB2   = 0.04;
        FstHB1  = 0.5 + 0.5*TwHB1;
        FstHB2  = 0.5 + 0.5*TwHB2;
        Fst     = FstHB2 / FstHB1 / RCIC / RComp; % overall stop band imposed by the final FIR filter. Only used for filename.

        % ------------------------------------------------- Ripple in Passband in dB
        ApComp = 0.05;
        ApHB1  = 0.20;
        ApHB2  = 0.20;
        Ap     = ApComp + ApHB1 + ApHB2; % Ripple of cascaded filters is additive. Only used for filename.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast     = 60; % only used for filename.
        AstComp = 60;
        AstHB1  = 60;
        AstHB2  = 60;

        % ----------------------------------------------- Differential Delay for CIC
        DL = 1;

        HdCIC  =    decCIC(RCIC,  FpCIC, Ast, DL, plotDir);
        HdComp =   compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
        HdHB1  = halfbandFIR(2, TwHB1, AstHB1, coefDir, plotDir);

        stages    = cell(3,1);
        stages{1} = HdComp;
        stages{2} = HdHB1;
        stages{3} = HdHB1;
        Hcasc     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);

        % NOTE: Something doesn't quite work correctly when iterating and sometimes
        %       not all configurations might be iterated. Fixing this bug might not
        %       be worth the time, so make sure to check results.
        %sizeHdComp = size(HdComp);
        %sizeHdFIR  = size(HdFIR);
        %stages     = cell(2,1);
        %stages{1}  = repmat(HdComp, [sizeHdFIR(1) / sizeHdComp(1),1]);
        %stages{2}  = HdFIR;
        %Hcasc      = parcascador(R, Fp, FstFIR, Ap, Ast, DL, plotDir, stages);

        % Plot detail of passband
        % This is for the report.
        plotDirDetail  = fullfile(plotDir,'chainDetails');
        if ~exist(plotDirDetail,'dir')
            mkdir(plotDirDetail);
        end

        W = 0:pi/(2*R*1e3)*2:pi/(2*R)*2;
        H = freqz(Hcasc{1,1}, W);
        plotFile = fullfile(plotDirDetail, 'chain2500detail.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC4'
        % 31.25 MHz, T = 32 ns
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 4 ->
        % -> 2 -> 2 ->
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='DEC4';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R   = 4;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp  = 0.25;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.26 0.27 0.28];
        Tw  = Fst - Fp; % Only works if Fst and Fp are same length or one is a scalar.

        % ------------------------------------------------- Ripple in Passband in dB
        Ap = [0.05 0.1 0.15];

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [40 60 80];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd   =      decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
        HdHB = halfbandFIR(2, Tw,          Ast, coefDir, plotDir);
        stages=cell(2,1);
        stages{1} = HdHB;
        stages{2} = HdHB;
        Hcasc = cascador(R, Fp, Fst, 1, Ast, 1, plotDir, stages);
    case 'DEC6'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='DEC6';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % -------------------------------------------------------- Decimation Factor
        R1  = 3; % T1 = 24 ns
        R2  = 2; % T2 = 24 ns * 2 = 48 ns
        R = R1 * R2;

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs   = 125e6;  % Single-stage
        Fs1  = Fs;     % Input of first stage
        Fs2  = Fs1/R1; % Input of second stage

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        Fp  = 1/R;   % Single stage
        Fp1 = 1/R1;  % First stage
        Fp2 = 1/R2;  % second stage

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        TBw = 0.01:0.02:0.07;        % Transition band widths (normalized)
        Fst = Fp + TBw;              % NOTE: This only works if Fp is a scalar or
                                     % has same length as TBw!
        TBwHz = TBw * Fs;            % Transition band widths in Hz

        % Now we want to distribute TBwHz over two stages.
        TBw2 = TBwHz ./ Fs2;           % normalized TB width of second stage
                                       % should be the same in Hz as TBwHz
        Fst2 = Fp2 + TBw2;

        % NOTE: No value in Fst1 must exceed  2/R1 - Fst2/R1, since the second
        % stage's passband is repeated in Intervals of Fs2.
        padding = -0.02;
        Fst1 = padding + 1/R1 * (2 - Fst2);

        % ------------------------------------------------- Ripple in Passband in dB
        Ap1 = [0.125 0.0625 0.03125]; % NOTE: Cascaded filters amplify
        Ap2 = [0.125 0.0625 0.03125]; % each other's riple in PB.
        Ap  = [0.250 0.125  0.0625 ]; % Single-stage ripple can therefore be twice
                                      % as big.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast1 = [60 80 100];
        Ast2 = [60 80 100];
        Ast  = [60 80 100];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd  = decFIR(R , Fp , Fst , Ap , Ast , coefDir, plotDir);
        Hd1 = decFIR(R1, Fp1, Fst1, Ap1, Ast1, coefDir, plotDir);
        Hd2 = decFIR(R2, Fp2, Fst2, Ap2, Ast2, coefDir, plotDir);

        % ---------------------------------------------------- Filter Design Objects
        stages = cell(2,1);
        stages{1} = Hd1;
        stages{2} = Hd2;
        Hcasc = cascador(R, Fp, Fst, Ap, Ast, 1, plotDir, stages);
    case 'DEC24'
        % 5.2803 MHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 24 ->
        % -> 8 -> 3 ->
        % -> 6 -> 4 ->
        % -> 6 -> 2 -> 2 ->
        % -> 4 -> 3 -> 2 ->
    case 'DEC120'
        % 1.0417 MHz, T = 960 ns
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 120 ->
        % -> 60 -> 2 ->
        % -> 40 -> 3 ->
        % -> 30 -> 2 -> 2 ->
        % -> 24 -> 5 ->
        % -> 20 -> 3 -> 2 ->
        clear all;close all;
        filtertype='DEC120';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R   = 120;  % overall decimation rate
        Rcic = R/4; % decimation rate in CIC

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp  = 1/R;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = Fp * 1.1;
        Tw  = Fst - Fp; % Only works if Fst and Fp are same length or one is a scalar.

        % ------------------------------------------------- Ripple in Passband in dB
        Ap = [0.05 0.1];

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [40 60];

        % ----------------------------------------------- Differential Delay for CIC
        DL = [1];

        Hcic =  decCIC(Rcic, Fp, Ast, DL, plotDir);
        Hd   = compCIC(1, Fp, Fst, Ap, Ast, DL, Hcic, coefDir, plotDir);

        slopeFactor = 4; % arbitrary slope weakener for first HB
        HdHB1 = halfbandFIR(2, Tw * Rcic * slopeFactor, Ast, coefDir, plotDir);
        HdHB2 = halfbandFIR(2, Tw * Rcic              , Ast, coefDir, plotDir);

        % Hd is going to have more filters if DL is longer than 1 element
        % Compensate for that by repeating the HB filters.
        sizeHd  = size(Hd);
        sizeHB1 = size(HdHB1);
        sizeHB2 = size(HdHB2);
        stages    = cell(3,1);
        stages{1} = Hd;
        stages{2} = repmat(HdHB1, [sizeHd(1) / sizeHB1(1),1]);
        stages{3} = repmat(HdHB2, [sizeHd(1) / sizeHB2(1),1]);
        Hcasc = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);
    case 'DEC600'
        % 208.3 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 600 ->
        % -> 300 -> 2 ->
        % -> 150 -> 2 -> 2 ->
        % -> 120 -> 5 ->
        % -> 75 -> 2 -> 2 -> 2 ->
        % -> 60 -> 5 -> 2 ->
        % -> 50 -> 4 -> 3 ->
        % -> 50 -> 3 -> 2 -> 2 ->
        % -> 40 -> 5 -> 3 ->
        % -> 30 -> 5 -> 2 -> 2 ->
    case 'DEC1200'
        % 104.2 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 1200 ->
        % ->  600 -> 2 ->
        % ->  400 -> 3 ->
        % ->  300 -> 2 -> 2 ->
        % ->  200 -> 6 ->
        % ->  200 -> 3 -> 2 ->
        % ->  150 -> 4 -> 2 ->
        % ->  150 -> 2 -> 2 -> 2 ->
        % ->  120 -> 5 -> 2 ->
        % ->  100 -> 6 -> 2 ->
        % ->  100 -> 3 -> 2 -> 2 ->
        % ->   60 -> 5 -> 2 -> 2 ->
        % ->   50 -> 6 -> 2 -> 2 ->
        % ->   50 -> 4 -> 3 -> 2 ->
        % ->   40 -> 6 -> 5 ->
        % ->   40 -> 5 -> 3 ->  2 ->
        % ->   30 -> 8 -> 5 ->
        % ->   30 -> 5 -> 2 ->  2 -> 2 ->
    case 'DEC2400'
        % 52.1 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 2400 ->
        % -> 1200 -> 2 ->
        % ->  800 -> 3 ->
        % ->  600 -> 2 -> 2 ->
        % ->  400 -> 3 -> 2 ->
        % ->  300 -> 4 -> 2 ->
        % ->  300 -> 2 -> 2 -> 2 ->
        % ->  200 -> 6 -> 2 ->
        % ->  200 -> 3 -> 2 -> 2 ->
        % ->  150 -> 8 -> 2 ->
        % ->  150 -> 4 -> 2 -> 2 ->
        % ->  120 -> 5 -> 2 -> 2 ->
        % ->  100 -> 6 -> 2 -> 2 ->
        % ->  100 -> 3 -> 2 -> 2 -> 2 ->
        % ->   60 -> 10 -> 2 -> 2 ->
        % ->   60 -> 5 -> 2 -> 2 -> 2 ->
        % ->   50 -> 12 -> 2 -> 2 ->
        % ->   50 -> 6 -> 2 -> 2 -> 2 ->
        % ->   50 -> 4 -> 3 -> 2 -> 2 ->
        % ->   40 -> 6 -> 5 ->  2 ->
        % ->   40 -> 5 -> 3 ->  2 -> 2 ->
        % ->   30 -> 8 -> 5 ->   2 ->
        % ->   30 -> 5 -> 2 ->  2 -> 2 -> 2 ->
    case 'SPECS_DEMO'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='SPECS_DEMO';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R   = 1;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp  = 0.3;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.40];

        % ------------------------------------------------- Ripple in Passband in dB
        Ap  = [2];

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [60];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
    case 'TBW_DEMO'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='TBW_DEMO';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs_high  = 2e6;;
        Fs_low   = 1e6;;

        % -------------------------------------------------------- Decimation Factor
        R   = 1;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp  = 0.3;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.40];

        % ------------------------------------------------- Ripple in Passband in dB
        Ap  = [2];

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [60];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
        %fvtool(Hd{1,1},Hd{1,1},'Fs',[2e6,1e6]);

        plotDir  = fullfile(plotDir,'TBWDemo');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        % Save Filter Plot Data
        [H_high,F_high] = freqz(Hd{1,1}, 1e3, Fs_high);
        plotFile = fullfile(plotDir, 'fs-high.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'F');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_high) F_high],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

        [H_low,F_low] = freqz(Hd{1,1}, 0.5e3, Fs_low);
        H_low = [H_low' fliplr(H_low')]';
        plotFile = fullfile(plotDir, 'fs-low.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'F');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_low) F_high],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'AST_DEMO'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='AST_DEMO';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs = 2e6;;

        % -------------------------------------------------------- Decimation Factor
        R1 = 4;
        R2 = 4;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp1 = 0.25;
        Fp2 = 0.25;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst1 = 0.3;
        Fst2 = 0.3;

        % ------------------------------------------------- Ripple in Passband in dB
        Ap1 = 1;
        Ap2 = 1;

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast1 = 60;
        Ast2 = 40;

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd1 = decFIR(R1, Fp1, Fst1, Ap1, Ast1, coefDir, plotDir);
        Hd2 = decFIR(R2, Fp2, Fst2, Ap2, Ast2, coefDir, plotDir);
        Hcasc1 = cascade(Hd1{1,1},Hd2{1,1});
        Hcasc2 = cascade(Hd2{1,1},Hd1{1,1});

        plotDir  = fullfile(plotDir,'AstDemo');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        % Save Filter Plot Data
        % Cascades
        [H_21,W_21] = freqz(Hcasc1, 2e3);
        plotFile = fullfile(plotDir, 'ast-60-40.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_21) W_21],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_12,W_12] = freqz(Hcasc2, 2e3);
        plotFile = fullfile(plotDir, 'ast-40-60.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_12) W_12],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        % Stages
        [H_1,W_1] = freqz(Hd1{1,1}, 2e3);
        plotFile = fullfile(plotDir, 'ast-60.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_1) W_1],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_2,W_2] = freqz(Hd2{1,1}, 2e3);
        plotFile = fullfile(plotDir, 'ast-40.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_2) W_2],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        % Stages referenced to incoming frequency for copies
        [H_1,W_1] = freqz(Hd1{1,1}, 0.5e3);
        plotFile = fullfile(plotDir, 'ast-60-ref-high.csv');
        H_1_ref_high = [H_1' fliplr(H_1') H_1' fliplr(H_1')]';
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_1_ref_high) W_21],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_2,W_2] = freqz(Hd2{1,1}, 0.5e3);
        plotFile = fullfile(plotDir, 'ast-40-ref-high.csv');
        H_2_ref_high = [H_2' fliplr(H_2') H_2' fliplr(H_2')]';
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_2_ref_high) W_21],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

    case 'TBW_DEMO2'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='TBW_DEMO2';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs = 2e6;;

        % -------------------------------------------------------- Decimation Factor
        R1 = 2;
        R2 = 4;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp1 = 0.5;
        Fp2 = 0.25;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst1 = 0.6;
        Fst2 = 0.3;

        % ------------------------------------------------- Ripple in Passband in dB
        Ap1 = 1;
        Ap2 = 1;

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast1 = 40;
        Ast2 = 40;

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd1 = decFIR(R1, Fp1, Fst1, Ap1, Ast1, coefDir, plotDir);
        Hd2 = decFIR(R2, Fp2, Fst2, Ap2, Ast2, coefDir, plotDir);

        plotDir  = fullfile(plotDir,'TBWDemo');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        % Save Filter Plot Data
        [H_wide,W_wide] = freqz(Hd1{1,1}, 1e3);
        plotFile = fullfile(plotDir, 'fs-wide.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_wide) W_wide],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

        [H_narrow,W_narrow] = freqz(Hd2{1,1}, 1e3);
        plotFile = fullfile(plotDir, 'fs-narrow.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_narrow) W_narrow],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'RIDICULOUS'
        % NOTE: This takes a long time to run (an hour in one of my tests) and
        % generates a filter with almost 9000 coefficients.
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='RIDICULOUS';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        R = 625;
        Fp = 1/R;
        Fst = 1/R*1.2;
        Ap = 1;
        Ast = 40;
        Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
    case 'CASCADE_DEMO'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='CASCADE_DEMO';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % Demonistrates Two Cascaded HAlfband filters, once with overlap, once without
        R1 = 2;
        R2 = 2;
        R  = 4;
        TwHB  = [0.3 0.6];
        Fp    = [0.35/R1 0.2/R1];
        Fst   = [0.65/R1 0.8/R1];
        AstHB = 40;
        Ap = 0.5;
        HdHB  = halfbandFIR(2, [TwHB TwHB], AstHB, coefDir, plotDir);
        stages = cell(2,1);
        stages{1} = HdHB;
        stages{2} = HdHB;
        Hcasc = cascador(R, Fp, Fst, Ap, AstHB, 0, plotDir, stages);

        plotDir  = fullfile(plotDir,'CascadeDemo');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        % Save Filter Plot Data
        [H_good_cascade,W_good_cascade] = freqz(Hcasc{1,1}, 1e3);
        plotFile = fullfile(plotDir, 'cascadeDemoHBGoodCascade.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_good_cascade) W_good_cascade],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_good_stage1,W_good_stage1] = freqz(Hcasc{1,1}.Stage1, 1e3);
        plotFile = fullfile(plotDir, 'cascadeDemoHBGoodStage1.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_good_stage1) W_good_stage1],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_good_stage2,W_good_stage2] = freqz(Hcasc{1,1}.Stage2, 0.5e3);
        H_good_stage2 = [H_good_stage2' fliplr(H_good_stage2')]';
        plotFile = fullfile(plotDir, 'cascadeDemoHBGoodStage2.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_good_stage2) W_good_stage1],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

        [H_bad_cascade,W_bad_cascade] = freqz(Hcasc{2,1}, 1e3);
        plotFile = fullfile(plotDir, 'cascadeDemoHBBadCascade.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_bad_cascade) W_bad_cascade],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_bad_stage1,W_bad_stage1] = freqz(Hcasc{2,1}.Stage1, 1e3);
        plotFile = fullfile(plotDir, 'cascadeDemoHBBadStage1.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_bad_stage1) W_bad_stage1],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        [H_bad_stage2,W_bad_stage2] = freqz(Hcasc{2,1}.Stage2, 0.5e3);
        H_bad_stage2 = [H_bad_stage2' fliplr(H_bad_stage2')]';
        plotFile = fullfile(plotDir, 'cascadeDemoHBBadStage2.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_bad_stage2) W_bad_stage1],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'CASCADE_DEMO2'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='CASCADE_DEMO2';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs = 2e6;;

        % -------------------------------------------------------- Decimation Factor
        R1 = 2;
        R2 = 4;

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp1 = 0.5;
        Fp2 = 0.25;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst1 = 0.6;
        Fst2 = 0.3;

        % ------------------------------------------------- Ripple in Passband in dB
        Ap1 = 1;
        Ap2 = 1;

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast1 = 40;
        Ast2 = 40;

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd1 = decFIR(R1, Fp1, Fst1, Ap1, Ast1, coefDir, plotDir);
        Hd2 = decFIR(R2, Fp2, Fst2, Ap2, Ast2, coefDir, plotDir);

        plotDir  = fullfile(plotDir,'CascadeDemo');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        % Save Filter Plot Data
        [H_wide,W_wide] = freqz(Hd1{1,1}, 1e3);
        plotFile = fullfile(plotDir, 'fs-wide.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_wide) W_wide],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

        [H_narrow,W_narrow] = freqz(Hd2{1,1}, 1e3);
        plotFile = fullfile(plotDir, 'fs-narrow.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_narrow) W_narrow],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );

        [H_narrow,W_narrow] = freqz(cascade(Hd1{1,1},Hd1{1,1}), 1e3);
        plotFile = fullfile(plotDir, 'cascade-of-wide.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s\n', 'abs(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H_narrow) W_narrow],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEC625_VARIANTS'
        % 200 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 625 ->
        % -> 125 -> 5 ->
        % -> 25 -> 5 -> 5
        % -> 5 -> 5 -> 5 -> 5 ->
        clear all;close all;
        filtertype='DEC625_VARIANTS';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R     = 625; % overall decimation rate
        RCIC  =  25; % decimation rate in CIC
        RComp =   1; % Compensator decimation rate
        RFIR1 =   5; % decimation rate in flat FIR filter
        RFIR2 =   5; % decimation rate in steep FIR filter

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp    = 1/R;

        % The frequency band coming out of the CIC which is of interest.
        % In this case, that is Fp*RFIR2 (half the sampling frequency before the
        % final FIR decimator).
        FpCIC  = Fp*RFIR2; % The frequency band coming out of the CIC filter which is of interest.
        FpComp = Fp*RFIR1; % The frequency band over which the compensator has to work.
        FpFIR1 = 1/RFIR1;
        FpFIR2 = 1/RFIR2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The compensator's frequency specifications are relative to the CIC filter's.
        %       0.008 transition band width is in terms of the CIC filter, and means that
        %       on the compensator's frequency axis, it will be 0.2 wide (0.008*RCIC).
        FstComp = FpComp + 0.008; % Must be smaller than or equal to 0.04 (1/RCIC). FpComp = 0.008
                                  % FpComp,max = 0.032
        FstFIR1 = 0.225;
        FstFIR2 = 0.225;
        Fst     = FstFIR2 / RCIC / RFIR1; % overall stop band imposed by the final FIR filter. Only used for filename.

        % ------------------------------------------------- Ripple in Passband in dB
        ApComp = 0.05;
        ApFIR1 = 0.05;
        ApFIR2 = 0.20;
        Ap     = ApComp + ApFIR1 + ApFIR2; % Ripple of cascaded filters is additive. Only used for filename.

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast     = 60; % only used for filename.
        AstComp = 60;
        AstFIR1 = 60;
        AstFIR2 = 60;

        % ----------------------------------------------- Differential Delay for CIC
        DL = 1;

        HdCIC  =    decCIC(RCIC,  FpCIC, Ast, DL, plotDir);
        HdComp =   compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
        HdFIR1 = decFIR(RFIR1, FpFIR1,  FstFIR1,  ApFIR1, AstFIR1, coefDir, plotDir);
        HdFIR2 = decFIR(RFIR2, FpFIR2,  FstFIR2,  ApFIR2, AstFIR2, coefDir, plotDir);

        stages    = cell(3,1);
        stages{1} = HdComp;
        stages{2} = HdFIR1;
        stages{3} = HdFIR2;
        Hcasc     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages);

        HdCIC2     =    decCIC(125, 0.0016 , Ast, DL, plotDir);
        HdComp2    =   compCIC(  1, 0.0016, 0.0016+0.0008, ApComp, AstComp, DL, HdCIC2, coefDir, plotDir);
        stages2    = cell(2,1);
        stages2{1} = HdComp2;
        stages2{2} = HdFIR2;
        Hcasc2     = cascador(R, Fp, Fst, Ap, Ast, DL, plotDir, stages2);

        plotDir  = fullfile(plotDir,'dec625Variants');
        if ~exist(plotDir,'dir')
            mkdir(plotDir);
        end

        %% Save Filter Plot Data
        W = 0:pi/(R*1e3)*2:pi/R*2;
        H = freqz(Hcasc{1,1}, W);
        H = H./max(abs(H));
        plotFile = fullfile(plotDir, 'dec625--25-5-5.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H)' unwrap(angle(H))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
        H2 = freqz(Hcasc2{1,1}, W);
        H2 = H2./max(abs(H2));
        plotFile = fullfile(plotDir, 'dec625--125-5.csv');
        fh = fopen(plotFile, 'w');
        if fh ~= -1
            fprintf(fh, '%s,%s,%s\n', 'abs(H)', 'angle(H)', 'W');
            fclose(fh);
        end
        dlmwrite(...
            plotFile,...
            [abs(H2)' unwrap(angle(H2))' W'],...
            '-append',...
            'delimiter', ',',...
            'newline', 'unix'...
        );
    case 'DEV_EXAMPLE'
        % Example for Developer Guide

        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='DEV_EXAMPLE';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        R1     = 5;
        Fp     = 0.2;
        Fst    = [0.21 0.225];
        Ast    = 60;
        Ap     = 0.25;
        HdFIR  = decFIR(R1, Fp, Fst, Ap, Ast, coefDir, plotDir);

        R2     = 32;
        RCIC   = 8;
        AstCIC = 60;
        FpCIC  = 1/R2;
        DL     = 1;
        HdCIC  =    decCIC(RCIC,  FpCIC, AstCIC, DL, plotDir);
        RComp   = 4;
        FpComp  = 1/R2;
        FstComp = 1/R2 * 1.1;
        ApComp  = 0.25;
        AstComp = 60;
        HdComp  =  compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, HdCIC, coefDir, plotDir);
    case 'FIR_UTIL'
        % Cleanup if the script is called multiple times from the same Matlab instance.
        clear all;close all;
        filtertype='FIR_UTIL';
        genDir = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % ------------------------------------------- Input Sampling Frequency in Hz
        Fs  = 125e6;

        % -------------------------------------------------------- Decimation Factor
        R   = 5; % T = 40 ns

        % ---------------------- Frequency at the Start of the Pass Band; Normalized
        % NOTE: The smallest number in Fp must be smaller than the smallest number
        %       in Fst (see below).
        Fp  = 0.2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.205 0.210 0.215 0.220 0.225 0.230 0.235 0.240 0.245 0.250];

        % ------------------------------------------------- Ripple in Passband in dB
        Ap  = [0.01 0.1 0.2 0.25 0.5 0.999];

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [40 60 80 100];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd = pardecFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
    otherwise
        error('No valid filter type specified. Please assign a valid value to filtertype')
end
% In general, use CIC when R >= 32 (rule of thumb)

% designmethods(d,'default'): equiripple
% Available: equiripple, ifir, kaiserwin, multistage
% H = design(d,'multistage','SystemObject',true)
% H = design(d,'multistage','NStages',2,'SystemObject',true)
% H = design(d,'multistage','UseHalfbands',true,'SystemObject',true)
% H = design(d,'multistage','UseHalfbands',true,,HalfbandDesignMethod',DESMETH'SystemObject',true)
% DESMETH: 'equiripple', 'ellip', 'iirlinphase'
% H.Stage1
% H.order
% etc.
