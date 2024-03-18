function [y] = yHelper(x)
% This function takes an array x and returns an array of vectors that
% correspond to the function y from the homework

y = zeros([2,length(x)]);

for i = 1:length(x)
    y(:,i) = [1 x(i); 2 x(i)^2]\[1;1];
end

