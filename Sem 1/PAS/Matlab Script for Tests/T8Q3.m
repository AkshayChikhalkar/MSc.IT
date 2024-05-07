syms x t c

% Define the function
f = exp(t*x) * (c/2) * exp(-c*abs(x));

% Compute the integral
integral_result = int(f, x, -Inf, Inf);

% Display the result
disp('The result of the integral is:')
disp(integral_result)


a = normcdf(1.69,1.7,0.005) +1-normcdf(1.71,1.7,0.005)