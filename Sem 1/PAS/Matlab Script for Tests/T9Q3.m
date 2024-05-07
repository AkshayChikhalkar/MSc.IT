clear;
mu = 109;
sig = 53;
x = 2 * mu;
cdfa = zeros(10, 1);
str = '';
for n = 1:1:10
    cdfa(n) = 1 - normcdf(x, mu, sig/sqrt(n));
    str = [str, ', ', num2str(cdfa(n))];
end

fprintf('%.2e,%.2e,%.2e,%.2e,%.2e,%.2e,%.2e,%.2e,%.2e,%.2e', cdfa(1), cdfa(2), cdfa(3), cdfa(4), cdfa(5), cdfa(6), cdfa(7), cdfa(8), cdfa(9), cdfa(10))


mu = 109;
sig = 53;
x = 2 * mu;
n = 1:10;
cdfa = 1 - normcdf(x, mu, sig./sqrt(n));
fprintf('\n')
fprintf('%s', sprintf('%.2e,', cdfa));
