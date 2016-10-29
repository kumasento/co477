function golden_section_search_test()
% GOLDEN_SECTION_SEARCH_TEST test basic functionality of the golden section
% search function's implementation.
    
    % create test function and data
    f = @(x) x.^4 - 14*x.^3 + 60*x.^2 - 70*x;
    X = linspace(0, 2, 100);
    Y = f(X);
    
    plot(X, Y); hold on;
    
    minimum = golden_section_search(f, 0, 2);
    
    fprintf('Found local minimum: %f, f_min=%f\n', minimum, f(minimum));
    plot(minimum, f(minimum), 'o'); hold off;
end