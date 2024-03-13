function [y,dy] = DualDiff(f,x)
% Input: f, the function to evaluate the value and the derivative. x is the
% plotting range to evaluate over.
% Output: y, the value of the function at x, dy the value of the derivative
% of f at x.
% This function will evaluate the derivative of a function using dual
% numbers. I did not write the Dual class, I got it from a git repo but I
% think that's within the scope of the assignment. 

% This eventually needs to be a function with form DualDiff(f,x,args)
% where f is the function to derive, x is the derivative array, and args
% are extra arguments
% Author: Tyce Olaveson

z = Dual(x,x./x); % create the dual number
ydual = f(z);
y = ydual.x;
dy = ydual.d;

% plot(x,y,'r',x,dy,'b');
end