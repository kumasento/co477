function minimiser = secant(f, x0, x1, varargin)
% SECANT quasi-newton method
    p = inputParser;
    p.addRequired('f', @(x) validateattributes(x, {'function_handle'}, {'scalar'}));
    p.addRequired('x0', @isscalar);
    p.addRequired('x1', @isscalar);
    p.addOptional('bound', 0.0001, @isscalar);
    p.addOptional('maxIter', 100);
    p.parse(f, x0, x1, varargin{:});

    inputs = p.Results;
    f  = inputs.f;
    x0 = inputs.x0;
    x1 = inputs.x1;
    
    iterCount = 0;
    while iterCount < inputs.maxIter
        g0 = grad(f, x0);
        g1 = grad(f, x1);
     
        x2 = x0 - g0 / ((g0 - g1)/(x0 - x1));
        x0 = x1;
        x1 = x2;
        fprintf('x0 = %.6f, x1 = %.6f\n', x0, x1);
        if abs(f(x0) - f(x1)) < inputs.bound
            break;
        end
        
        iterCount = iterCount + 1;
    end
    minimiser = x0;
end