clear;
mean = 12700
n=40

b1=chi2inv(0.02/2,n*2);
b2=chi2inv(1-0.02/2,n*2);
sig1 = (2*n*mean)/b2
sig2 = (2*n*mean)/b1

fprintf('%2f, %2f', sig2, sig1)


b3=chi2inv(0.02,n*2);
sig3 = (2*n*mean)/b3

b4=chi2inv(1-0.02,n*2);
sig4 = (2*n*mean)/b4

fprintf('%2f, %2f', sig3, sig4)
