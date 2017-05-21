% Calls simulink file

% NOTE: Currently throwing errors. but leaving this here in case we
% ever want to continue debugging it. Unlikely though.
% Date: 2017-05-21,
% Author: Raphael Frey <rmfrey@alpenwasser.net>
options = simset('SrcWorkspace', 'current');
sim('cicFilterManual',[],options);