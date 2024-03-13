function [y] = sinn(x,n)
% this function evaluates the function sin(x) composed with itself n times.
% sinn(x,1) = sin(x).
y = x;
for i = 1:n
    y = sin(y);
end
end

