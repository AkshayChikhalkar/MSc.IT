%% -------------------------------------------------------------------
%  Resetting the environment
%  -------------------------------------------------------------------
clear;
clc;
format;

% Some formatting options
format long;
format compact;


%% -------------------------------------------------------------------
%  Data sets: Arrays of datapoints x = [x1, x2, ... , xN]
%  -------------------------------------------------------------------
x = [1, 2, 3, 4, 5]

x = 1:0.7:pi

N = 4;
x = linspace(pi, 1, N)

x = sort(x)

n = numel(x)

% Formatted output (example):
fprintf('The list is: [');
fprintf('%g, ', x(1:end-1));
fprintf('%g]\n', x(end));


%% -------------------------------------------------------------------
%  Rounding
%  -------------------------------------------------------------------
round(5*x, 3)
round(5*x, 3, "significant")
ceil(x)
floor(x)

%% -------------------------------------------------------------------
%  Loops and Function Handles
%  -------------------------------------------------------------------
% For-Loop from 0 to 100, step size 1
for j=0:1:100
    % some code
end 

% Functions of one variable or two variables
F_x   = @(x) -1./(x+1);
F_x_y = @(x,y) 1./(x+y+1);

z1 = F_x(x)
z2 = F_x_y(x, pi)


%% -------------------------------------------------------------------
%  Combinatorial functions
%  -------------------------------------------------------------------
factorial_5 = factorial(5)

% binomial coefficient
bino_5_3 = nchoosek(5, 3)


%% -------------------------------------------------------------------
%  Statistical key figures of a data set
%  -------------------------------------------------------------------
m  = mean(x)
q2 = median(x)
s2 = var(x)
s  = std(x)

% Warning: The definition of a quantile function in PAS (1.8) is
%          different to Matlab's quantile and prctile functions!  
q1 = quantile(x,0.25)
q2 = quantile(x,0.5)
q3 = quantile(x,0.75)

p75 = prctile(x, 75)

%% -------------------------------------------------------------------
%  Discrete Distributions
%  -------------------------------------------------------------------
n = 10; p = 0.5; lambda = 2; i = 5;

% binomial(n, p)
binopdf(i,n,p)
binocdf(i,n,p)

% geometric(p)
geopdf(i-1,p)
geocdf(i-1,p)

% nbino(n, p)
nbinpdf(i-n,n,p)
nbincdf(i-n,n,p)

% Poisson(lambda)
poisspdf(i,lambda)
poisscdf(i,lambda)

%% -------------------------------------------------------------------
%  Continous Distributions
%  -------------------------------------------------------------------
% normal distribution
x = -3:0.1:3; mu = 0; sigma = 1; p = 0.01:0.01:0.99;
f_norm    = normpdf(x,mu,sigma);
F_norm    = normcdf(x,mu,sigma);
Finv_norm = norminv(p,mu,sigma);

% t-distribution
n = 5;
f_t    = tpdf(x,n);
F_t    = tcdf(x,n);
Finv_t = tinv(p,n);

% gamma distribution
alpha = 2; beta = 0.5;
f_gama    = gampdf(x,alpha,1/beta);
F_gama    = gamcdf(x,alpha,1/beta);
Finv_gama = gaminv(p,alpha,1/beta);

% chi2 distribution
n = 4;
f_chi2    = chi2pdf(x,n);
F_chi2    = chi2cdf(x,n);
Finv_chi2 = chi2inv(p,n);

% Illustration of the values calculated above:
tiledlayout(4,2)
nexttile, plot(x, f_norm, x, F_norm), nexttile, plot(p, Finv_norm);
nexttile, plot(x, f_t, x, F_t), nexttile, plot(p, Finv_t);
nexttile, plot(x, f_gama, x, F_gama), nexttile, plot(p, Finv_gama);
nexttile, plot(x, f_chi2, x, F_chi2), nexttile, plot(p, Finv_chi2);
