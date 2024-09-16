function Out = make_landscape(Rw,Pr,X)

% This script makes a seascape of MPAs, given input parameters
% Inputs:
% Rw = width of a reserve
% Pr= proportion of coastline in reserves
% X = number of repeating units


if Pr > 0 % fix in case of no reserves
unit= [zeros(1,round(((Rw/Pr)-Rw)/2)),ones(1,Rw),zeros(1,round(((Rw/Pr)-Rw)/2))];
else
unit = zeros(1,X);
end

% Outputs:
% Out = vector of 1s and 0s

% Target length = X
Repeats = round(X/length(unit));

Out = repmat(unit,[1,Repeats]);

