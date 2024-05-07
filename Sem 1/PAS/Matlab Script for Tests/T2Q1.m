% Given data
x_bar = 98.7;
s = 6;
interval_width = 10.2;

% Solve for n_min
n_min = ceil((interval_width / (s / sqrt(20)))^2);

% Display the result
disp(['Minimal number of samples that belong to the interval: ' num2str(n_min)]);
