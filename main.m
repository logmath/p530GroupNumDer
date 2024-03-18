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
er = @(x,h) dfdx(x,h) - cos(x); % error

x = linspace(-pi,pi,100); % domain
h = eps^(1/3); % step size
hNR = eps^(1/3); % numerical recipies optimal step size

figure()
plot(x,dfdx(x,h),x,cos(x))
xlabel('x')
ylabel('y')
figure()
plot(x,er(x,h));
xlabel('x')
ylabel('error')

hs = logspace(0,-16,100);
ers = zeros(size(hs)); % initialize
for i = 1:length(hs)
    ers(i) = norm(er(x,hs(i)));
end
figure()
loglog(hs,ers)
xlabel('step size, h')
ylabel('error norm')
xline(hNR)
norm(er(x,hNR))
% looks like using a step size of about 6.1 \times 10^{-6} gives the
% minimum error with a norm of 1.01\times 10^{-10}
%% Functions
f1 = @(x) sin(x);
f2 = @(x) sin(1./x);
f3 = @(x) 3*x.^2 + 1/pi^2 * log((pi - x).^2) + 1;
%f4 = @(x) sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(x))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
f4 = @(x) sinn(x,100); % updated to use a loop instead.
%y = @(x) [1 x; 2 x.^2].\[1;1]; % helper function for f5. This doesn't
%handle vectors
f5 = @(x) 1./vecnorm(yHelper(x));
funcs = {f1,f2,f3,f4,f5}; % cell array to loop through each function
lims = {[-pi,pi],[-1,1],[3.13,3.16],[-1,1],[-3,3]}; % the specified limits for the functions
% Have each person in your group implement on of the methods in your
% environment. Logan - Richardson, Tyce - Automatic differentiation, Levi -
% Chebyshev.

% Write a driver function that implements these methods for an arbitrary
% function. DerivativeDriver.m

% Apply your methods to evaluate the derivatives of the following functions
% at the specified points. How do your methods far in terms of accuracy and
% computaiton time?

methods = {'dual','richardson'}; % methods to use for the DerivativeDriver
args = {{},{},{}}; % additional argumnets to use for each method
for i = 1:length(funcs)
    f = funcs{i}; % current function
    x = linspace(lims{i}(1),lims{i}(2),1000); % x range for plotting
    figure(i) % create the figure for plotting
    plot(x,f(x),'k','DisplayName','f(x)')
    hold on
    for j = 1:length(methods)
        dy = DerivativeDriver(methods{j},f,x,args{j}); % evaluate the derivative
        plot(x,dy,'DisplayName',methods{j})
    end
    hold off
    title(sprintf('f%i',i))
    legend('location','best')
end