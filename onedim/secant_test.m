function secant_test
% ONE_DIM_NEWTON_TEST test bench for one_dim_newton algorithm
    f = @(x) x.^4 - 14*x.^3 + 60*x.^2 - 70*x;
    X = linspace(-1, 5, 100);
    Y = f(X);
    plot(X, Y); hold on;
    
    disp('evaluating from left');
    x0 = 0.; % from left
    x1 = -0.1;
    minimiser = secant(f, x0, x1);
    plot(minimiser, f(minimiser), 'go');
    
    disp('evaluating from right');
    x0 = 1.; % from right
    x1 = 0.9;
    minimiser = secant(f, x0, x1);
    plot(minimiser, f(minimiser), 'rx');
    
    disp('evaluating from right');
    x0 = 2.5; % from right
    x1 = 2.4;
    minimiser = secant(f, x0, x1);
    plot(minimiser, f(minimiser), 'rx'); hold off;
end