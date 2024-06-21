% Total number of resistors in the batch
N = 109000;

% Number of resistors outside tolerance in the batch
K = 2400;

% Sample size
n = 100;

% Number of resistors outside tolerance in the sample
k = 2;



% Probability of exactly 2 resistors outside tolerance in the sample
p = exp(logBinomialCoefficient(K, k) + logBinomialCoefficient(N - K, n - k) - logBinomialCoefficient(N, n));

% Display the probability
disp(['Probability of exactly 2 resistors outside tolerance: ' num2str(p)]);

% Function to calculate binomial coefficient using logarithmic form
function result = logBinomialCoefficient(n, k)
    result = gammaln(n+1) - gammaln(k+1) - gammaln(n-k+1);
end

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
