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
%                    0: constant step size (same as step_size),
%                    1: golden section search
%                    2: secant method
%                    3: backtracking

%% Initialise the training set --------------------------------------------
load mnist.mat
n   = 1000; % Input features
m   = 1000; % Test cases
dim =   10;

%% Decide the step size strategy to use -----------------------------------
if nargin < 5
    % default setting is to use constant as step size
    mode = 0;
end

% golden section hyper parameters
golden_a0 = 1e-6;
golden_b0 = 1e-2;

% secant method hyper parameters
secant_a0 = 1e-4;
secant_a_1 = 1e-4-1e-6;

% general information
file_prefix = 'tmp/';

if mode == 0
    fprintf('Using constant step size strategy, step size is %f\n', ...
        step_size);
    file_prefix = strcat(file_prefix, 'constant_');
elseif mode == 1
    fprintf('Using golden section, search interval is [%f, %f]\n', ...
        golden_a0, golden_b0);
    file_prefix = strcat(file_prefix, 'golden_section_');
elseif mode == 2
    fprintf('Using secant, a(0)=%f, a(-1)=%f\n', ...
        secant_a0, secant_a_1);
    file_prefix = strcat(file_prefix, 'secant_');
elseif mode == 3
    fprintf('Using backtracking ...\n');
    file_prefix = strcat(file_prefix, 'backtracking_');
else
    fprintf('Not implemented yet, exiting ...\n');
    return;
end

%% Initialise parameters --------------------------------------------------
% l-2 Regulariser
norm_type = 2;

%% Initialise a starting point for the algorithm --------------------------

% Pre-allocate other arrays
convgsd              = zeros(num_iter, 1);
lenXsd               = zeros(num_iter, 1);
diffFsd              = zeros(num_iter, 1);
step_size_iter       = zeros(num_iter, 1);

% start timer
tic;

beta_guess = zeros(1,n*dim);
beta_eval  = evaluate_gB(beta_guess, X, y, n, m, dim, lambda, ...
    0, norm_type);
beta_grad  = evaluate_gB(beta_guess, X, y, n, m, dim, lambda, ...
    1, norm_type);

% Store beta guesses at each iteration
beta_guess_iter(1,:) = beta_guess; 

% Store the function value at each iteration
fcn_val_iter         = zeros(num_iter, 1);
fcn_val_iter(1)      = beta_eval;  
                     
fprintf('iter=%d; Func Val=%f; FONC Residual=%f\n',...
        0, beta_eval, norm(beta_grad));

% simple wrapper for the function and the gradient
f    = @(beta) evaluate_gB(beta, X, y, n, m, dim, lambda, 0, norm_type);
grad = @(beta) evaluate_gB(beta, X, y, n, m, dim, lambda, 1, norm_type);

%% Iterative algorithm begins ---------------------------------------------
for i = 1:num_iter    

    %% Step for gradient descent ------------------------------------------
    
    % *** Insert gradient descent code here ***
    % decide the step size
    if mode >= 1
        % phi and grad_phi are two anonymous functions for line search
        % construct the line search objective function
        phi = @(alpha) evaluate_gB(beta_guess_iter(i,:)-alpha.*beta_grad, ...
            X, y, n, m, dim, lambda, 0, norm_type);
        % construct the phi' for secant method (rather than numerically 
        % calculate it
        grad_phi = @(alpha) -dot(...
            evaluate_gB(beta_guess_iter(i,:)-alpha.*beta_grad, X, y,...
            n, m, dim, lambda, 1, norm_type), ...
            beta_grad);
        % decide the step size based on different algorithms
        if mode == 1        % golden section search
            step_size = golden_section_search(phi, 1e-6, 1e-2);
        elseif mode == 2    % secant
            step_size = secant(phi, secant_a0, secant_a_1, grad_phi);
        elseif mode == 3
            step_size = backtracking(f, grad, beta_guess_iter(i,:), ...
                0.5, 0.8);
        else
            fprintf('Error mode number, exiting ...\n');
            return;
        end
        fprintf('step size=%f\n', step_size);
    end
    
    step_size_iter(i) = step_size;
    
    beta_guess(1, :) = beta_guess_iter(i, :) - step_size.*beta_grad;
    
    %% Update with the new iteration --------------------------------------
    
    beta_guess_iter(i+1,:) = beta_guess;
    
    beta_eval              = evaluate_gB(beta_guess, X, y, n, m, dim, ...
                                         lambda, 0, norm_type);
                                     
    fcn_val_iter(i+1)      = beta_eval;
    
    beta_grad              = evaluate_gB(beta_guess, X, y, n, m, dim, ...
                                         lambda, 1, norm_type);
                         
    %% Check if it's time to terminate ------------------------------------

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

    fprintf('iter=%d; Func Val=%f; FONC Residual=%f; Sqr Diff=%f\n',...
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

%% Finished time ----------------------------------------------------------
total_num_iter = i + 1;
total_time = toc;

fprintf('Total number of iterations: %d\n', total_num_iter);
fprintf('Total time:                 %f s\n', total_time);
fprintf('Time per iteration:         %f s\n', total_time/total_num_iter);

%% Save gradient descent variables ----------------------------------------
save(strcat(file_prefix, 'variables'), 'fcn_val_iter');
save(strcat(file_prefix, 'variables'), 'step_size_iter', '-append');
save(strcat(file_prefix, 'variables'), 'total_num_iter', '-append');
save(strcat(file_prefix, 'variables'), 'total_time', '-append');

%% Return -----------------------------------------------------------------
ReturnVal = beta_guess;

end
