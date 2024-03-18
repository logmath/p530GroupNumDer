% Using Chebyshev polynomials to find the derivative of a function
%
% INPUTS
%   f - function handle
%   x - point(s) to evaluate derivative at
% OPTIONAL INPUTS
%   N - order of Chebyshev polynomial
% OUTPUTS
%   dx - final computed derivative of the function
%   y - the function as estimated by chebyshev
%
% Author: Levi Moats
%

function [dx,y] = chebyshevDir(f,range,N)

    if nargin < 3
    N = 10; % default order of polynomial is 10 (This was arbitrary)
    end
    
    % Find the coefficients of the aproximation of the function
    k=0:N-1;
    j=0:N-1;
    c=(2/N)*sum(f(cos((pi*(k.'+(1/2))/N))).*cos((pi*j.*(k.'+(1/2))/N)),1);
    % Find dir coefficents
    cdir=zeros(1,length(c)+1);
    cdir(N+1)=0;
    cdir(N)=0;
    for m=N-1:-1:1
        cdir(m)=cdir(m+2)+2*(m)*c(m+1);
    end
    % Transform to be withing the chebyshyv range [-1 to 1]
    rangeSmall=(range-((1/2)*(max(range)+min(range))))/((1/2)*(max(range)-min(range)));
    y=ones(size(range)).*(-1/2)*c(1);
    dx=ones(size(range)).*(-1/2)*cdir(1);
    for n=1:N
        y=y+c(n)*chebyshevT(n-1,rangeSmall);
        dx=dx+cdir(n)*chebyshevT(n-1,rangeSmall);
    end
    % Scale the answer to be original range again
    y=y*2*(max(range)-min(range))+(1/2*(max(range)+min(range)));
    dx=dx*2*(max(range)-min(range))+(1/2*(max(range)+min(range)));
    % Calculate coefficients of the derivative
    
    % Calculate the derivative with coefficients

end

