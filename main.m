% This script contains the work for P530 Numerical Derivatives homework.
% Authors: Logan Mathews, Levi Moates, Tyce Olaveson
% Initialize
clc; clear; close all;

%% Problem 1
% Calculate the numerical first derivative of the function f(x)=sin(x)
% using the centered two-point formula. Plot the error y'(x) - cos(x) in
% the range (-\pi,\pi) at 100 points. Optimize the step size, h. How
% accurate can you get by adjusting h?

f = @(x) sin(x); % function
dfdx = @(x,h) (f(x+h) - f(x-h)) / (2*h); % derivative

x = linspace(-pi,pi,100); % domain
h = 0.01; % step size
er = dfdx(x,h) - cos(x); % error

figure()
plot(x,dfdx(x,h),x,cos(x))
xlabel('x')
ylabel('y')
figure()
plot(x,er);
xlabel('x')
ylabel('error')
%% Functions
f1 = @(x) sin(x);
f2 = @(x) sin(1./x);
f3 = @(x) 3*x.^2 + 1/pi^2 * log((pi - x).^2) + 1;
%f4 = @(x) sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(x))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
f4 = @(x) sinn(x,100); % updated to use a loop instead.
f5 = @(y) 1./norm(y);

