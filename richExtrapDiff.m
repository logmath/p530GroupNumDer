% Improved finite difference derivative approximation method using
% Richardson extrapolation via Ridder's implementation of Neville's
% algorithm.
% Author: Logan Mathews
%

function dfun = richExtrapDiff(fun,x,h0)
ntab = 10;
cdiff = @(fun,x,h) (fun(x+h) - f(x-h))/(2*h); % centered difference formula
df(1,1) = cdiff(fun,x,h0);
h(1) = h0;
err = inf;
for i = 1:ntab-1
    fac = 2; % reduce step size by factor of 2
    h(i+1) = h(i)/fac;
    df(1,i+1) = cdiff(fun,x,h(i+1)); % try smaller step size
    for j = 1:i
        % perform Richardson extrapolation to higher order
        df(j+1,i+1) = (df(j,i+1)*fac - a(j,i)) / (fac^(2*j) - 1);
        % find maximum error of this iteration
        errij = max(abs(df(j+1,i+1)-df(j,i+1)),abs(df(j+1,i+1)-df(j,i)));
        if errij <= err
            err = errij;
            dfun = df(j+1,i+1);
        end
    end
    if abs(df(j+1,i+1)-df(j,i)) >= fac*err
        % if error is 2x or more worse than the best error so far, break.
        break
    end
end

