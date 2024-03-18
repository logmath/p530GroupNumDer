% Improved finite difference derivative approximation method using
% Richardson extrapolation via Ridder's implementation of Neville's
% algorithm.
%
% INPUTS
%   f - function handle
%   x - point(s) to evaluate derivative at
% OPTIONAL INPUTS
%   h0 - inital step size for finite difference, default is 10^-3
%   ntab - order of extrapolation to do in table, default is 5
% OUTPUTS
%   dfun - final computed derivative of the function
%   y - just f(x)
%
% Author: Logan Mathews
%
function [dfun,y] = richExtrapDiff(f,x,h0,ntab)
% set default values for h0 and ntab if not specified
if nargin < 4
    ntab = 5; % default order of extrapolation is 5
end
if nargin < 3
    h0 = 1e-3; % default step size is 10^-3
end

cdiff = @(f,x,h) (f(x+h) - f(x-h))/(2*h); % centered difference formula
df(1,1,:) = cdiff(f,x,h0); % first derivative estimate with input step size
fac = 2;
h(1) = h0;
err = inf;
for i = 1:ntab-1 % loop over progressively smaller step sizes
    %fac = con; % reduce step size by factor of 2
    h(i+1) = h(i)/fac;
    df(1,i+1,:) = cdiff(f,x,h(i+1)); % try smaller step size
    currFac = fac^2;
    for j = 1:i % loop over progressively higher orders of extrapolation
        % perform Richardson extrapolation to higher order
        df(j+1,i+1,:) = (df(j,i+1,:)*currFac - df(j,i,:)) / (currFac - 1);
        currFac = currFac*fac^2;
        % find maximum error of this iteration
        errij = max(sum(abs(df(j+1,i+1,:)-df(j,i+1,:))),sum(abs(df(j+1,i+1,:)-df(j,i,:))));
        if errij <= err
            err = errij;
            dfun = squeeze(df(j+1,i+1,:));
            y = f(x);
            hfinal = h(end);
        end
    end
    if sum(abs(df(j+1,i+1,:)-df(j,i,:))) >= fac*err
        % if error is 2x or more worse than the best error so far, break 
        % out of function and return last answer.
        return
    end
end

