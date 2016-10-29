function g = grad(f, x)
% GRAD get function f's gradient at x
    p = inputParser;
    p.addRequired('f', @(x) validateattributes(x, {'function_handle'}, {'scalar'}));
    p.addRequired('x', @isscalar);
    p.parse(f, x);
    
    f = p.Results.f;
    x = p.Results.x;
    h = 1e-4; % delta for gradient
    
    g = (f(x + h) - f(x)) / h;
end