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
        Fp  = [0.1 0.15 0.2];
        %Fp  = 0.2;

        % ------------- ---------- Stop band frequencies ("How steep is the filter?")
        % NOTE: The smallest number in Fst must be larger than the largest number in
        %       Fp (see above).
        Fst = [0.21 0.22];
        %Fst = 0.22;

        % ------------------------------------------------- Ripple in Passband in dB
        Ap  = [0.25 0.5 1];
        %Ap  = 0.25;

        % ------------------------------------------- Attenuation in Stop Band in dB
        Ast = [20 40 60 80];
        %Ast = [40 60];

        % Hd: Contains the Filter Objects along with their properties (R, Fs, Fp,...)
        Hd = decFIR(R, Fp, Fst, Ap, Ast, coefDir, plotDir);
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
    case 'DEC25'
        % 5 MHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 25 ->
        % -> 5 -> 5 ->
        clear all;close all;
        filtertype='DEC25';
        genDir  = 'generators';
        coefDir = 'coefData';
        plotDir = 'plotData';

        % -------------------------------------------------------- Decimation Factor
        R1  = 5; % T1 = 24 ns
        R2  = 5; % T2 = 24 ns * 2 = 48 ns
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
        TBw = 0.02:0.02:0.06;        % Transition band widths (normalized)
        Fst = Fp + TBw;              % NOTE: This only works if Fp is a scalar or
                                     % has same length as TBw!
        TBwHz = TBw * Fs;            % Transition band widths in Hz

        % Now we want to distribute TBwHz over two stages.
        TBw2 = TBwHz ./ Fs2;         % normalized TB width of second stage
                                     % should be the same in Hz as TBwHz
        Fst2 = Fp2 + TBw2;

        % NOTE: No value in Fst1 must exceed  2/R1 - Fst2/R1, since the second
        % stage's passband is repeated in Intervals of Fs2.
        padding = -0.02;
        Fst1 = padding + 1/R1 * (2 - Fst2);

        % ------------------------------------------------- Ripple in Passband in dB
        Ap1 = 0.125; % NOTE: Cascaded filters amplify each other's riple in PB
        Ap2 = 0.125;
        Ap  = 0.250; % Single-stage ripple can therefore be twice as big.

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
    case 'DEC125'
        % 1 MHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 125 ->
        % -> 25 -> 5 ->
        % -> 5 -> 5 -> 5 ->
    case 'DEC625'
        % 200 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 625 ->
        % -> 125 -> 5 ->
        % -> 25 -> 5 -> 5
        % -> 5 -> 5 -> 5 -> 5 ->
    case 'DEC1250'
        % 100 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 1250 ->
        % -> 625 -> 2 ->
        % -> 125 -> 5 -> 2 ->
        % -> 25 -> 5 -> 5 2 ->
        % -> 5 -> 5 -> 5 -> 5 -> 2 ->
    case 'DEC2500'
        % 50 kHz
        % Chain Possibilities (not exhaustive), both sensible and not sensible:
        % -> 2500 ->
        % -> 1250 ->
        % -> 625 -> 2 ->
        % -> 125 -> 5 -> 2 ->
        % -> 25 -> 5 -> 5 2 ->
        % -> 5 -> 5 -> 5 -> 5 -> 2 -> 2 ->
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
        Hd   = compCIC(Rcic, Fp, Fst, Ap, Ast, DL, Hcic, coefDir, plotDir);

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