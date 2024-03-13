classdef Dual
% DUAL Dual numbers class for automatic differentiation.
%
% To do automatic differentiation we introduce a number d such that d^2 == 0.
% Then by a simple application of Taylor's theorem we have
%
%     f(x + d) = f(x) + f'(x) d
%
% with all higher-order terms vanishing. Therefore applying a function to a dual
% number x + d generates both the value f(x) *and* the derivative f'(x).
%
% To pull off this trick we define a dual number class that overrides the basic
% arithmetic functions:
%
%     (x1 + y1 d) + (x2 + y2 d) = (x1 + x2) + (y1 + y2) d
%
%     (x1 + y1 d) * (x2 + y2 d) = (x1 * x2) + (x1 * y2 + y1 * x2) d
%
% We then make use of linearity of the derivative,
%
%     (f+g)'(x) = f'(x) + g'(x)
%
% Leibniz' rule for products,
%
%     (fg)'(x) = f(x) g'(x) + f'(x) g(x)
%
% and the chain rule for function composition.
%
%     (f.g)'(x) = g'(x) f'(g(x))
%
% Note that with dual numbers, the rule for composition falls straight out of
% the definition for multiplication of dual numbers:
%
%     f(g(x+d)) = f(g(x) + g'(x) d) = f(g(x)) + f'(g(x)) g'(x) d
%
% So it suffices to define the action of succifiently many elementary functions
% on dual numbers, and the action of more complicated functions will follow
% by virtue of the algebra of dual numbers.
%
% Author: Chris Taylor
% Last modified: 08/03/2012

    properties
        x = 0;
        d = 0;
    end

    methods
        % Constructor
        function obj = Dual(x,d)
            if size(x,1) ~= size(d,1) || size(x,2) ~= size(d,2)
                error('DUAL:constructor','X and D are different size')
            else
                obj.x = x;
                obj.d = d;
            end
        end
        % Getters
        function v = getvalue(a)
            v = a.x;
        end
        function d = getderiv(a)
            d = a.d;
        end
        % Indexing
        function B = subsref(A,S)
            switch S.type
                case '()'
                    idx = S.subs;
                    switch length(idx)
                        case 1
                            B = Dual(A.x(idx{1}),A.d(idx{1}));
                        case 2
                            B = Dual(A.x(idx{1},idx{2}), A.d(idx{1},idx{2}));
                        otherwise
                            error('Dual:subsref','Arrays with more than 2 dims not supported')
                    end
                case '.'
                    switch S.subs
                        case 'x'
                            B = A.x;
                        case 'd'
                            B = A.d;
                        otherwise
                            error('Dual:subsref','Field %s does not exist',S.subs)
                    end
                otherwise
                    error('Dual:subsref','Indexing with {} is not supported')
            end
        end
        function A = subsasgn(A,S,B)
            switch S.type
                case '()'
                    idx = S.subs;
                otherwise
                    error('Dual:subsasgn','Assignment with {} and . not supported')
            end
            if ~isdual(B)
                B = mkdual(B);
            end
            switch length(idx)
                case 1
                    A.x(idx{1}) = B.x;
                    A.d(idx{1}) = B.d;
                case 2
                    A.x(idx{1},idx{2}) = B.x;
                    A.d(idx{1},idx{2}) = B.d;
                otherwise
                    error('Dual:subsref','Arrays with more than 2 dims not supported')
            end
        end
        % Concatenation operators
        function A = horzcat(varargin)
            for k = 1:length(varargin)
                tmp = varargin{k};
                xs{k} = tmp.x;
                ds{k} = tmp.d;
            end
            A = Dual(horzcat(xs{:}), horzcat(ds{:}));
        end
        function A = vertcat(varargin)
            for k = 1:length(varargin)
                tmp = varargin{k};
                xs{k} = tmp.x;
                ds{k} = tmp.d;
            end
            A = Dual(vertcat(xs{:}), vertcat(ds{:}));
        end
        % Plotting functions
        function plot(X,varargin)
            if length(varargin) < 1
                Y = X;
                X = 1:length(X.x);
            elseif isdual(X) && isdual(varargin{1})
                Y = varargin{1};
                varargin = varargin(2:end);
            elseif isdual(X)
                Y = X;
                X = 1:length(X);
            elseif isdual(varargin{1})
                Y = varargin{1};
                varargin = varargin(2:end);
            end
            if isdual(X)
                plot(X.x,[Y.x(:) Y.d(:)],varargin{:})
            else
                plot(X,[Y.x(:) Y.d(:)],varargin{:})
            end
            grid on
            legend({'Function','Derivative'})
        end
        % Comparison operators
        function res = eq(a,b)
            if isdual(a) && isdual(b)
                res = a.x == b.x;
            elseif isdual(a)
                res = a.x == b;
            elseif isdual(b)
                res = a == b.x;
            end
        end
        function res = neq(a,b)
            if isdual(a) && isdual(b)
                res = a.x ~= b.x;
            elseif isdual(a)
                res = a.x ~= b;
            elseif isdual(b)
                res = a ~= b.x;
            end
        end
        function res = lt(a,b)
            if isdual(a) && isdual(b)
                res = a.x < b.x;
            elseif isdual(a)
                res = a.x < b;
            elseif isdual(b)
                res = a < b.x;
            end
        end
        function res = le(a,b)
            if isdual(a) && isdual(b)
                res = a.x <= b.x;
            elseif isdual(a)
                res = a.x <= b;
            elseif isdual(b)
                res = a <= b.x;
            end
        end
        function res = gt(a,b)
            if isdual(a) && isdual(b)
                res = a.x > b.x;
            elseif isdual(a)
                res = a.x > b;
            elseif isdual(b)
                res = a > b.x;
            end
        end
        function res = ge(a,b)
            if isdual(a) && isdual(b)
                res = a.x >= b.x;
            elseif isdual(a)
                res = a.x >= b;
            elseif isdual(b)
                res = a >= b.x;
            end
        end
        function res = isnan(a)
            res = isnan(a.x);
        end
        function res = isinf(a)
            res = isinf(a.x);
        end
        function res = isfinite(a)
            res = isfinite(a.x);
        end
        % Unary operators
        function obj = uplus(a)
            obj = a;
        end
        function obj = uminus(a)
            obj = Dual(-a.x, -a.d);
        end
        function obj = transpose(a)
            obj = Dual(transpose(a.x), transpose(a.d));
        end
        function obj = ctranspose(a)
            obj = Dual(ctranspose(a.x), ctranspose(a.d));
        end
        function obj = reshape(a,ns)
            obj = Dual(reshape(a.x,ns), reshape(a.d,ns));
        end
        % Binary arithmetic operators
        function obj = plus(a,b)
            if isdual(a) && isdual(b)
                obj = Dual(a.x + b.x, a.d + b.d);
            elseif isdual(a)
                obj = Dual(a.x + b, a.d);
            elseif isdual(b)
                obj = Dual(a + b.x, b.d);
            end
        end
        function obj = minus(a,b)
            if isdual(a) && isdual(b)
                obj = Dual(a.x - b.x, a.d - b.d);
            elseif isdual(a)
                obj = Dual(a.x - b, a.d);
            elseif isdual(b)
                obj = Dual(a - b.x, -b.d);
            end
        end
        function obj = times(a,b)
            if isdual(a) && isdual(b)
                obj = Dual(a.x .* b.x, a.x .* b.d + a.d .* b.x);
            elseif isdual(a)
                obj = Dual(a.x .* b, a.d .* b);
            elseif isdual(b)
                obj = Dual(a .* b.x, a .* b.d);
            end
        end
        function obj = mtimes(a,b)
            % Matrix multiplication for dual numbers is elementwise
            obj = times(a,b);
        end
        function obj = rdivide(a,b)
            if isdual(a) && isdual(b)
                xpart = a.x ./ b.x;
                dpart = (a.d .* b.x - a.x .* b.d) ./ (b.x .* b.x);
                obj = Dual(xpart,dpart);
            elseif isdual(a)
                obj = Dual(a.x ./ b, a.d ./ b);
            elseif isdual(b)
                obj = Dual(a ./ b.x, (a .* b.d) ./ (b.x .* b.x));
            end
        end
        function obj = mrdivide(a,b)
            % All division is elementwise
            obj = rdivide(a,b);
        end
        function obj = power(a,b)
            % n is assumed to be a real value (not a dual)
            if isdual(a) && isdual(b)
                error('Dual:power','Power is not defined for a and b both dual')
            elseif isdual(a)
                obj = Dual(power(a.x,b), b .* a.d .* power(a.x,b-1));
            elseif isdual(b)
                ab  = power(a,b.x);
                obj = Dual(ab, b.d .* log(a) .* ab);
            end
        end
        function obj = mpower(a,n)
            % Elementwise power
            obj = power(a,n);
        end
        % Miscellaneous math functions
        function obj = sqrt(a)
            obj = Dual(sqrt(a.x), a.d ./ (2 * sqrt(a.x)));
        end
        function obj = abs(a)
            obj = Dual(abs(a.x), a.d .* sign(a.x));
        end
        function obj = sign(a)
            z = a.x == 0;
            x = sign(a.x);
            d = a.d .* ones(size(a.d)); d(z) = NaN;
            obj = Dual(x,d);
        end
        function obj = pow2(a)
            obj = Dual(pow2(a.x), a.d .* log(2) .* pow2(a.x));
        end
        function obj = erf(a)
            disp('Reached here')
            ds = 2/sqrt(pi) * exp(-(a.x).^2);
            obj = Dual(erf(a.x), a.d .* ds);
        end
        function obj = erfc(a)
            disp('Reached here')
            ds = -2/sqrt(pi) * exp(-(a.x).^2);
            obj = Dual(erfc(a.x), a.d .* ds);
        end
        function obj = erfcx(a)
            ds = 2 * a.x .* exp((a.x).^2) .* erfc(a.x) - 2/sqrt(pi);
            obj = Dual(erfcx(a.x), a.d .* ds);
        end
        % Exponential and logarithm
        function obj = exp(a)
            obj = Dual(exp(a.x), a.d .* exp(a.x));
        end
        function obj = log(a)
            obj = Dual(log(a.x), a.d ./ a.x);
        end
        % Trigonometric functions
        function obj = sin(a)
            obj = Dual(sin(a.x), a.d .* cos(a.x));
        end
        function obj = cos(a)
            obj = Dual(cos(a.x), -a.d .* sin(a.x));
        end
        function obj = tan(a)
            obj = Dual(tan(a.x), a.d .* sec(a.x).^2);
        end
        function obj = asin(a)
            obj = Dual(asin(a.x), a.d ./ sqrt(1-(a.x).^2));
        end
        function obj = acos(a)
            obj = Dual(acos(a.x), -a.d ./ sqrt(1-(a.x).^2));
        end
        function obj = atan(a)
            obj = Dual(atan(a.x), 1 ./ (1 + (a.x).^2));
        end
        % Hyperbolic trig functions
        function obj = sinh(a)
            obj = Dual(sinh(a.x), a.d .* cosh(a.x));
        end
        function obj = cosh(a)
            obj = Dual(cosh(a.x), a.d .* sinh(a.x));
        end
        function obj = tanh(a)
            obj = Dual(tanh(a.x), a.d .* sech(a.x).^2);
        end
        function obj = asinh(a)
            obj = Dual(asinh(a.x), 1 ./ sqrt((a.x).^2 + 1));
        end
        function obj = acosh(a)
            obj = Dual(acosh(a.x), 1 ./ sqrt((a.x).^2 - 1));
        end
        function obj = atanh(a)
            obj = Dual(atanh(a.x), 1./ (1 - (a.x).^2));
        end
    end
end