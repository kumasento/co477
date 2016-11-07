function ReturnVal = SolveMNIST_Gradient(tol, num_iter, step_size, ...
                                         lambda, mode)
% Build a classifier for recognising hand-written digits from images
%
% Ruth Misener, 01 Feb 2016
%
% INPUTS: tol:       Optimality tolerance; check if algorithm converged
%         num_iter:  Maximum number of iterations
%         step_size: Step size
%         lambda:    Regularisation parameter
%         mode       if 1 then use exact line search

% Initialise the training set --------------------------------------------
load mnist.mat
n   = 1000; % Input features
m   = 1000; % Test cases
dim =   10;

if nargin < 5
    mode = 0;
end

% l-2 Regulariser
norm_type = 2;

% Initialise a starting point for the algorithm --------------------------
beta_guess = zeros(1,n*dim);

beta_eval  = evaluate_gB(beta_guess, X, y, n, m, dim, lambda, ...
                         0, norm_type);
beta_grad  = evaluate_gB(beta_guess, X, y, n, m, dim, lambda, ...
                         1, norm_type);

% Store beta guesses at each iteration
beta_guess_iter(1,:) = beta_guess; 

% Store the function value at each iteration
fcn_val_iter(1)      = beta_eval;  

fprintf('\niter=%d; Func Val=%f; FONC Residual=%f',...
        0, beta_eval, norm(beta_grad));

% Iterative algorithm begins ---------------------------------------------
for i = 1:num_iter    
    if mode == 1
        g = @(alpha) evaluate_gB(beta_guess_iter(i, :) - alpha.*beta_grad, ...
                                 X, y, n, m, dim, lambda, 0, norm_type);
        step_size = golden_section_search(g, 5e-6, 1e-2);
        fprintf('\nstep size=%f', step_size);
    end
    % Step for gradient descent ------------------------------------------
    % *** Insert gradient descent code here ***
    beta_guess(1, :) = beta_guess_iter(i, :) - step_size.*beta_grad;
    
    % Update with the new iteration --------------------------------------
    beta_guess_iter(i+1,:) = beta_guess;
    
    beta_eval              = evaluate_gB(beta_guess, X, y, n, m, dim, ...
                                         lambda, 0, norm_type);
                                     
    fcn_val_iter(i+1)      = beta_eval;
    
    beta_grad              = evaluate_gB(beta_guess, X, y, n, m, dim, ...
                                         lambda, 1, norm_type);
                         
    % Check if it's time to terminate ------------------------------------

    % Check the FONC?
    % Store the norm of the gradient at each iteration
    convgsd(i) = sqrt(dot(beta_grad, beta_grad));
    
    % Check that the vector is changing from iteration to iteration?
    % Stores length of the difference between the current beta and the 
    % previous one at each iteration
    beta_guess_diff = beta_guess - beta_guess_iter(i);
    lenXsd(i)  = sqrt(dot(beta_guess_diff, beta_guess_diff));
    
    % Check that the objective is changing from iteration to iteration?
    % Stores the absolute value of the difference between the current 
    % function value and the previous one at each iteration
    diffFsd(i) = abs(beta_eval - fcn_val_iter(i));
    
    fprintf('\niter=%d; Func Val=%f; FONC Residual=%f; Sqr Diff=%f',...
            i, beta_eval, convgsd(i), lenXsd(i));
    
    % Check the convergence criteria?
    if (convgsd(i) <= tol)
        fprintf('\nFirst-Order Optimality Condition met\n');
        break; 
    elseif (lenXsd(i) <= tol)
        fprintf('\nExit: Design not changing\n');
        break;
    elseif (diffFsd(i) <= tol)
        fprintf('\nExit: Objective not changing\n');
        break;
    elseif (i + 1 >= num_iter)
        fprintf('\nExit: Done iterating\n');
        break;
    end
    
end

% plot the gradient process
plot(1:num_iter, fcn_val_iter);
xlabel('Iteration');
ylabel('Function value');
title('Gradient Descent with Constant Step Size');

% disp(beta_guess_iter);

ReturnVal = beta_guess;

end

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
        fprintf('\na1 = %.6f b1 = %.6f f_a=%.6f f_b = %.6f',...
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