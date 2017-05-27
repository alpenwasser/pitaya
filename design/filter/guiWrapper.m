% ------------------------------------------------------------------------ %
% guiDispatcher.m
%
% DESCRIPTION
% Calls various filter generators (located in the 'generators/' subdirecotry)
% with the appropriate parameters. Fulfills the same role as the combination
% of Makefile and clidispatcher.m on the command line, but from Matlab's
% graphical user interface.
%
% AUTHORS:
% Raphael Frey, <rmfrey@alpenwasser.net>
%
% DATE:
% 2017-MAY-21
% ------------------------------------------------------------------------ %

%% Decimation by 5
clear all;close all;clc;
filtertype = 'DEC5';
disp('Designing Chain for R = 5')
run cliDispatcher;

%% Decimation by 25
clear all;close all;clc;
filtertype = 'DEC25';
disp('Designing Chain for R = 25')
run cliDispatcher;

%% Decimation by 125
clear all;close all;clc;
filtertype = 'DEC125';
disp('Designing Chain for R = 125')
run cliDispatcher;

%% Decimation by 625
clear all;close all;clc;
filtertype = 'DEC625';
disp('Designing Chain for R = 625')
run cliDispatcher;

%% Decimation by 1250
clear all;close all;clc;
filtertype = 'DEC1250';
disp('Designing Chain for R = 1250')
run cliDispatcher;

%% Decimation by 2500
clear all;close all;clc;
filtertype = 'DEC2500';
disp('Designing Chain for R = 2500')
run cliDispatcher;

%% Decimation by 4
clear all;close all;clc;
filtertype = 'DEC4';
disp('Designing Chain for R = 4')
run cliDispatcher;

%% Decimation by 6
clear all;close all;clc;
filtertype = 'DEC6';
disp('Designing Chain for R = 6')
run cliDispatcher;

%% Decimation by 24
clear all;close all;clc;
filtertype = 'DEC24';
disp('Designing Chain for R = 24')
run cliDispatcher;

%% Decimation by 120
clear all;close all;clc;
filtertype = 'DEC120';  
disp('Designing Chain for R = 120')
run cliDispatcher;

%% Decimation by 600
clear all;close all;clc;
filtertype = 'DEC600';
disp('Designing Chain for R = 600')
run cliDispatcher;

%% Decimation by 1200
clear all;close all;clc;
filtertype = 'DEC1200';
disp('Designing Chain for R = 1200')
run cliDispatcher;

%% Decimation by 2400
clear all;close all;clc;
filtertype = 'DEC2400';
disp('Designing Chain for R = 2400')
run cliDispatcher;
