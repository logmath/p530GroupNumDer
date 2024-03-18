function [df,y] = DerivativeDriver(method,f,x,args)
% This function will evaluate the derivative of function f at the location
% x using method. args needs to come in as a cell array

method = lower(method);

switch method
    case {'dual', 'automatic'}
        [y,df] = DualDiff(f,x);
    case {'richextrap','richardson'}
        [df,y] = richExtrapDiff(f,x,args{:});
    otherwise
        disp("Undefined derivative method")
end

