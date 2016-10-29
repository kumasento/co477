function minimum = golden_section_search(f, a0, b0, varargin)
% GOLDEN_SECTION_SEARCH search a local minimum by golden section search
% algorithm
%   minimum = GOLDEN_SECTION_SEARCH(@sin, 0, 2, 0.001); find minimum of sin
%   between [a0, b0], accepted bound is 0.001
    
    p = inputParser;
    p.addRequired('f', @(x) true);              % no validate here
    p.addRequired('a0', @isscalar);             % scalar value
    p.addRequired('b0', @isscalar);             % scalar value
    p.addOptional('bound', 0.001, @isscalar);   % scalar value
    p.addOptional('varrho', 0.382, @isscalar);  % scalar value
    p.addOptional('maxIter', 100, @isscalar);   % scalar value
    p.parse(f, a0, b0, varargin{:});
    
    % initialize with input variables
    inputs = p.Results;
    f = inputs.f;
    a0 = inputs.a0;
    b0 = inputs.b0;
    % initial calculation
    a1 = a0 + inputs.varrho * (b0 - a0);
    b1 = b0 - inputs.varrho * (b0 - a0);
    f_a = f(a1);
    f_b = f(b1);
    
    iterCount = 0;
    while iterCount < inputs.maxIter % prevent infinite loop
        fprintf('a1 = %.6f b1 = %.6f f_a=%.6f f_b = %.6f\n',...
            a1, b1, f_a, f_b);
        if abs(f_a - f_b) < inputs.bound
            % if satisfies the condition, break the loop
            break;
        end
        if f_a >= f_b
            % update boundary
            a0 = a1; % move left bound
            % update next a, b
            a1 = b1;
            b1 = b0 - inputs.varrho * (b0 - a0);
            % update function evaluation
            f_a = f_b; % f(a2) = f(b1)
            f_b = f(b1);
        else
            % update boundary
            b0 = b1; % move right bound
            % update next a, b
            b1 = a1;
            a1 = a0 + inputs.varrho * (b0 - a0);
            % update function evaluation
            f_b = f_a;
            f_a = f(a1);
        end
        iterCount = iterCount + 1;
    end
    minimum = a1;
end