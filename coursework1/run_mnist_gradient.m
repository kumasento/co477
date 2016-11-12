function run_mnist_gradient(max_iter, run)
% RUN_MNIST_GRADIENT run the mnist gradient descent with different 
%   strategies, like golden section, secant, backtracking, etc.
% INPUTS:   max_iter    - max number of iterations for each strategy
%           run         - 0 means no run, 1 means re-run

% maximum strategy index
max_mode = 3;

mode_names = { 'Constant'; 'Golden'; 'Secant'; 'Backtracking' };

if run
    fprintf('Running MNIST gradient for %d iterations\n', max_iter);
    for i=0:max_mode
        SolveMNIST_Gradient(1e-4, max_iter, 1e-4, 1, i);
    end
else
    fprintf('Loading data from snapshots ...\n');
end

fprintf('Finished running all strategies\n');

% Pre-allocate arrays to store data read from snapshots
fcn_val_iters   = zeros(max_mode+1, max_iter);
step_size_iters = zeros(max_mode+1, max_iter);
total_num_iters = zeros(max_mode+1, 1);
total_times     = zeros(max_mode+1, 1);

for i=0:max_mode
    % load data from temporary files
    if i == 0
        load(construct_snapshot_name('constant', max_iter));
    elseif i == 1
        load(construct_snapshot_name('golden_section', max_iter));
    elseif i == 2
        load(construct_snapshot_name('secant', max_iter));
    elseif i == 3
        load(construct_snapshot_name('backtracking', max_iter));
    end

    % caching data
    fcn_val_iters(i+1, :)   = fcn_val_iter;
    step_size_iters(i+1, :) = step_size_iter;
    total_num_iters(i+1)    = total_num_iter;
    total_times(i+1)        = total_time;
end

if max_iter <= 10
    % only when max_iter is small show the result
    disp(fcn_val_iters);
    disp(step_size_iters);
end

% show the table of run time
T = table(total_num_iters, total_times, total_times./total_num_iters,...
  'RowNames', mode_names, 'VariableNames', ...
  { 'TotalNumIter'; 'TotalTime'; 'TimePerIter' });
disp(T);

% plot the comparison between all methods
fprintf('Plotting ...\n');

fig = figure;
for i=0:max_mode
    plot(1:total_num_iters(i+1), ...
        fcn_val_iters(i+1,1:total_num_iters(i+1)));
    hold on;
end
hold off;

legend(mode_names);
xlabel('Iteration');
ylabel('Function Value');
title('Comparison of Convergence');

print(fig, strcat('figures/line_search_', num2str(max_iter)), '-depsc');

end

function file_name = construct_snapshot_name(method_name, max_iter)
    file_name = strcat('tmp/', method_name, '_snapshot_',...
        num2str(max_iter));
end
