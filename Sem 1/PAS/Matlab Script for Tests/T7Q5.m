% Parameters
lambda_beneficial = 1.2;
lambda_no_effect = 2.2;
p_beneficial = 0.78;
p_no_effect = 0.22;

% Calculate P(B)
p_b = exp(-lambda_beneficial) * p_beneficial + exp(-lambda_no_effect) * p_no_effect;

% Calculate P(A|B)
p_a_given_b = exp(-lambda_beneficial) * p_beneficial / p_b;

disp(['Probability that the drug is beneficial given 0 colds: ', num2str(p_a_given_b)]);

lambda = 123.55;
k = 130;

% Calculate P(X >= 130)
p_ge_130 = 1 - poisscdf(k-1, lambda);

disp(['Proportion of weeks having 130 deaths or more: ', num2str(p_ge_130)]);

lambda = 123.55;
k = 100;

% Calculate P(X <= 100)
p_le_100 = poisscdf(k, lambda);

disp(['Proportion of weeks having 100 deaths or less: ', num2str(p_le_100)]);
