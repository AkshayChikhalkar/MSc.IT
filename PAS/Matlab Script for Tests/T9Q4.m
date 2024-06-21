n=148;
p=0.63;
x=83;

pB = binocdf(x,n,p)

mu=n*p;
sig=sqrt(mu*(1-p));
pN=normcdf(x,mu,sig)

c = (pB-pN)/pB

%pNbar= binocdf(x,n,p)

x=x+0.5
%pB = binocdf(x,n,p)
pNbar=normcdf(x,mu,sig)

d = (pB-pNbar)/pB

% Define the parameter lambda
lambda = 4; % Average number of events

% Generate x values (number of events)
x = 0:15;

% Calculate the corresponding Poisson probabilities
poisson_probs = exp(-lambda) * (lambda.^x) ./ factorial(x);

% Plot the Poisson distribution
bar(x, poisson_probs, 'b')
xlabel('Number of Events (k)')
ylabel('Probability (P(X=k))')
title('Poisson Distribution (\lambda=4)')
grid on

