% Given probabilities
p_binomial = 0.450;
p_geometric = 0.630;
p_poisson = 0.497;

% Binomial distribution
syms n;
eq_binomial = (1 - 0.45/n)^n == p_binomial;
n_binomial = vpasolve(eq_binomial, n);
p1_binomial = 0.45 / double(n_binomial);

% Geometric distribution
p2_geometric = p_geometric;

% Poisson distribution
lambda_poisson = -log(p_poisson);

% Display results
fprintf('Binomial distribution:\n');
fprintf('n = %.6f\n', double(n_binomial));
fprintf('p1 = %.6f\n', p1_binomial);

fprintf('\nGeometric distribution:\n');
fprintf('p2 = %.6f\n', p2_geometric);

fprintf('\nPoisson distribution:\n');
fprintf('lambda = %.6f\n', lambda_poisson);
