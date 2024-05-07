

% Given lambda
lambda = 12.06;

% Values of t for calculating pt,0.1
t_values = [1, 5, 10, 50];

% Calculate pt,0.1 for different values of t
delta = 0.1;
fprintf('Calculating pt,0.1 for different values of t:\n');
for i = 1:length(t_values)
    t = t_values(i);
    pt = calculate_pt(t, lambda, delta);
    fprintf('p%d,0.1 = %.5f\n', t, pt);
end

% Find the smallest t0 such that pt0,0.05 >= 0.95
delta = 0.05;
threshold = 0.95;
t0 = find_smallest_t0(lambda, delta, threshold);
fprintf('Smallest t0 such that pt0,0.05 >= 0.95: %d\n', t0);


% Function to calculate pt,0.1 for given t
function pt = calculate_pt(t, lambda, delta)
    lower_bound = (1 - delta) * lambda * t;
    upper_bound = (1 + delta) * lambda * t;
    pt = poisscdf(floor(upper_bound), lambda * t) - poisscdf(ceil(lower_bound) - 1, lambda * t);
end

% Function to find the smallest t0 such that pt0,0.05 >= 0.95
function t0 = find_smallest_t0(lambda, delta, threshold)
    % Set initial bounds for binary search
    lower_bound = 1;
    upper_bound = 10000;  % Choose a sufficiently large upper bound

    % Perform binary search
    while lower_bound < upper_bound
        mid = floor((lower_bound + upper_bound) / 2);
        pt = calculate_pt(mid, lambda, delta);
        if pt >= threshold
            upper_bound = mid;
        else
            lower_bound = mid + 1;
        end
    end

    t0 = lower_bound;
end