clear;
x = [318.7,334.1,322.9,346.7,331.8,329.5,331.3,328.5,322.8,332.5,319.1,316.8];
n = length(x)
mu = mean(x)
std = std(x)
%std=8

delta95 = (std/sqrt(n))*tinv(1-0.05/2,n)
delta99 = std/sqrt(n)*tinv(1-0.01/2,n)
delta99_9 = std/sqrt(n)*tinv(1-0.001/2,n)


std = 8

delta95 = (std/sqrt(n))*tinv(1-0.05/2,n)
delta99 = std/sqrt(n)*tinv(1-0.01/2,n)
delta99_9 = std/sqrt(n)*tinv(1-0.001/2,n)

b1=chi2inv(0.05/2,n-1)
b2=chi2inv(1-0.05/2,n-1)
sig1 = sqrt((n-1)/b2*var(x))
sig2 = sqrt((n-1)/b1*var(x))

b1=chi2inv(0.01/2,n-1)
b2=chi2inv(1-0.01/2,n-1)
sig1 = sqrt((n-1)/b2*var(x))
sig2 = sqrt((n-1)/b1*var(x))

b1=chi2inv(0.001/2,n-1)
b2=chi2inv(1-0.001/2,n-1)
sig1 = sqrt((n-1)/b2*var(x))
sig2 = sqrt((n-1)/b1*var(x))


