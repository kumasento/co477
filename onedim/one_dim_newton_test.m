function one_dim_newton_test
% ONE_DIM_NEWTON_TEST test bench for one_dim_newton algorithm
    f = @(x) x.^4 - 14*x.^3 + 60*x.^2 - 70*x;
    X = linspace(-1, 5, 100);
    Y = f(X);
    plot(X, Y); hold on;
    
    disp('evaluating from left');
    x0 = 0.; % from left
    minimiser = one_dim_newton(f, x0);
    plot(minimiser, f(minimiser), 'go');
    
    disp('evaluating from right');
    x0 = 1.; % from right
    minimiser = one_dim_newton(f, x0);
    plot(minimiser, f(minimiser), 'rx');
    
    disp('evaluating from right');
    x0 = 2.5; % from right
    minimiser = one_dim_newton(f, x0);
    plot(minimiser, f(minimiser), 'rx'); hold off;
end