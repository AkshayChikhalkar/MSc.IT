% Define the value of p
p = normcdf(3.9*10^6, 4.8*10^6,3.7*10^5)

% Initialize the sum
sumi = 0;

% Loop from 0 to 3
for i = 0:3
    % Calculate the term and add it to the sum
    sumi = sumi + nchoosek(100, i) * p^i * (1 - p)^(100 - i);
end

% Display the result
disp(sumi);
