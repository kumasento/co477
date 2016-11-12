function run_mnist_gradient(max_iter, run)
% RUN_MNIST_GRADIENT run the mnist gradient descent with different 
%   strategies, like golden section, secant, backtracking, etc.
% INPUTS:   max_iter    - max number of iterations for each strategy
%           run         - 0 means no run, 1 means re-run


% maximum strategy index
max_mode = 3;

if run
    fprintf('Running MNIST gradient for %d iterations\n', max_iter);
    for i=0:max_mode
        SolveMNIST_Gradient(1e-4, max_iter, 1e-4, 1, i);
    end
end

fprintf('Finished running all strategies\n');

fcn_val_iters = zeros(max_mode+1, max_iter);
step_size_iters = zeros(max_mode+1, max_iter);
for i=0:max_mode
    % load data from temporary files
    if i == 0
        load('tmp/constant_variables.mat');
    elseif i == 1
        load('tmp/golden_section_variables.mat');
    elseif i == 2
        load('tmp/secant_variables.mat');
    elseif i == 3
        load('tmp/backtracking_variables.mat');
    end
    fcn_val_iters(i+1, :) = fcn_val_iter;
    step_size_iters(i+1, :) = step_size_iter;
end

disp(fcn_val_iters);
disp(step_size_iters);

fprintf('Plotting ...\n');


end