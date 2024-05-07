% Illustration of the central limit theorem for X = X_1 + ... + X_n
% for X_i ~ X_u, where X_u has a uniform distribution
%  mu = E(X_u) = 0 and sigma = Var(X_u) = 1.

rect = @(x) (sign(x+1/2)- sign(x-1/2))/2;
s = sqrt(12);
% pdf for the uniform distribution X_u with mu = 0 and sigma = 1:
f = @(x) rect(x/s)/s;

d = 0.0001;
x = -15:d:15;

y = f(x);
plot(x,y);
grid on;
hold on;
axis([-5 5 0 0.45]);

% Plot 2^i fold convolution f_i = f*...*f = f_{i-1}*f_{i-1}
for i = 1:4
    pause;
    y = conv(y,y,'same')*d; 
    plot(x/sqrt(2^i),sqrt(2^i)*y, 'Linewidth',2   );
end

pause;
plot(x,normpdf(x),'--m');

return

