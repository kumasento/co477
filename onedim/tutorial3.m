function tutorial3
    exercise1;
end

function exercise1
    f = @(x) x.^2 + 4 * cos(x);
    minimiser = golden_section_search(f, 1., 2., 0.2);
    fprintf('minimiser=%.6f f(min)=%.6f\n', minimiser, f(minimiser));
    
    minimiser = one_dim_newton(f, 1, 0.2, 2);
    fprintf('minimiser=%.6f f(min)=%.6f\n', minimiser, f(minimiser));
end