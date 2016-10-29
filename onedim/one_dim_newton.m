function minimiser = one_dim_newton(f, x0, varargin)
% ONE_DIM_NEWTON 1-dim newton method to get the minimiser for function f
% with starting point x0

    p = inputParser;
    p.addRequired('f', @(x) validateattributes(x, {'function_handle'}, {'scalar'}));
    p.addRequired('x0', @isscalar);
    p.addOptional('bound', 0.0001, @isscalar);
    p.addOptional('maxIter', 100);
    p.parse(f, x0, varargin{:});

    inputs = p.Results;
    f  = inputs.f;
    x0 = inputs.x0;
    x1 = x0;
    h  = 1e-03;
    
    iterCount = 0;
    while iterCount < inputs.maxIter
        % manually calculate second order derivative
        g0 = grad(f, x0);
        g1 = grad(f, x0 + 2*h);
        gg = (g1 - g0) / (2*h); % might not be precise, sort of quasi
        x1 = x0 - g0 / gg;
        fprintf('iter=%d x0=%.6f g0=%.6f g1=%.6f gg=%.6f g0/gg=%.6f\n',...
            iterCount, x0, g0, g1, gg, g0/gg);

        if abs(f(x1) - f(x0)) < inputs.bound
            break;
        end
        x0 = x1; % update
        iterCount = iterCount + 1;
    end
    
    minimiser = x1;
end
