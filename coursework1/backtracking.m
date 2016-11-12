function minimiser = backtracking(f, grad, x, alpha, beta, start)
% BACKTRACKING An implementation for the backtracking algorithm
% 
% INPUTS:   f       - the function to be optimised
%           grad    - the gradient of function f (analytical)
%           alpha   - constant alpha for backtracking algorithm
%           x       - current step function input
%           beta    - constant beta for backtracking algorithm
%           start   - starting point

step_size   = start;                    % initialised with 1
grad_val    = grad(x);                  % gradient for current input
grad_norm   = dot(grad_val, grad_val);  % *cached* gradient vector norm
fun_x       = f(x);                     % *cached* function value at x
fun_val     = f(x-step_size.*grad_val); % function value after update

% line approximate function value
aprox_val   = fun_x - alpha*step_size*grad_norm;

while fun_val > aprox_val
    fprintf('shrink step size from %f to %f\n', step_size, ...
        beta * step_size);
    step_size   = beta * step_size;
    fun_val     = f(x-step_size.*grad_val);
    aprox_val   = fun_x - alpha*step_size*grad_norm;
end

minimiser = step_size;

end
