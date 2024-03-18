function [y,dy] = DerivativeDriver(method,f,x,args)
% This function will evaluate the derivative of function f at the location
% x using method.

method = lower(method);

switch method
    case 'dualdiff'
        [y,dy] = DualDiff(f,x);
    case {'richextrap','richardson'}
        [df,y] = richExtrapDiff(f,x);
    otherwise
        disp("Undefined derivative method")
end

