% Given data
x = [160, 165, 176, 146, 120, 0, 192, 64, 133, 127, ...
    111, 137, 124, 9, 188, 123, 92, 131, 187, 59];
y = [2.3, 1.3, 2.7, 2.3, 2.7, 5.0, 1.3, 4.0, 2.3, 3.3, ...
    4.0, 3.7, 2.7, 5.0, 2.0, 2.3, 3.7, 3.3, 1.0, 5.0];

% Calculate mean of x and y
x_bar = mean(x);
y_bar = mean(y);

% Calculate coefficients a and b for the line of best fit
b = sum((x - x_bar) .* (y - y_bar)) / sum((x - x_bar) .^ 2);
a = y_bar - b * x_bar;

% Calculate correlation coefficient r
r = sum((x - x_bar) .* (y - y_bar)) / sqrt(sum((x - x_bar) .^ 2) * sum((y - y_bar) .^ 2));

% Normalize data sets
x_0 = (x - mean(x)) / std(x);
y_0 = (y - mean(y)) / std(y);

% Round off to two decimal places
x_0 = round(x_0, 2);
y_0 = round(y_0, 2);

% Display calculated values
disp(['Mean of x: ' num2str(round(x_bar, 2))]);
disp(['Mean of y: ' num2str(round(y_bar, 2))]);
disp(['Coefficient a: ' num2str(round(a, 2))]);
disp(['Coefficient b: ' num2str(round(b, 2))]);
disp(['Correlation coefficient r: ' num2str(round(r, 2))]);

% Display normalized data
disp('Normalized Homework Bonus Points (x^0):');
disp(x_0);
disp('Normalized Exam Grade (y^0):');
disp(y_0);

% Create scatter plots
figure;
subplot(1, 2, 1);
scatter(x, y);
xlabel('Homework Bonus Points');
ylabel('Exam Grade');
title('Scatter Plot of x and y');

subplot(1, 2, 2);
scatter(x_0, y_0);
xlabel('Normalized Homework Bonus Points');
ylabel('Normalized Exam Grade');
title('Scatter Plot of x_0 and y_0');


% Given probabilities
Pr_A = 0.73;
Pr_B = 0.56;
Pr_C = 0.75;

% Compute upper bound for Pr(A ∩ B)
Pr_A_intersect_B_upper = min(Pr_A, Pr_B);

% Compute lower bound for Pr(A ∩ B)
% If A and B are independent, lower bound is Pr(A) + Pr(B) - 1
% If A and B are mutually exclusive, lower bound is 0
% We assume independence for lower bound
Pr_A_intersect_B_lower = Pr_A + Pr_B - 1;

% Compute upper bound for Pr(A ∩ B ∩ C)
Pr_A_intersect_B_intersect_C_upper = min([Pr_A, Pr_B, Pr_C]);

% Compute lower bound for Pr(A ∩ B ∩ C)
% If A, B, and C are independent, lower bound is Pr(A) * Pr(B) * Pr(C)
% If A, B, and C are mutually exclusive, lower bound is 0
% We assume independence for lower bound
Pr_A_intersect_B_intersect_C_lower = Pr_A * Pr_B * Pr_C;

% Display results
fprintf('Bounds for Pr(A ∩ B):\n');
fprintf('Upper Bound: %f\n', Pr_A_intersect_B_upper);
fprintf('Lower Bound: %f\n\n', Pr_A_intersect_B_lower);

fprintf('Bounds for Pr(A ∩ B ∩ C):\n');
fprintf('Upper Bound: %f\n', Pr_A_intersect_B_intersect_C_upper);
fprintf('Lower Bound: %f\n', Pr_A_intersect_B_intersect_C_lower);
