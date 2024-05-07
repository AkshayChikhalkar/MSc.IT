% Given data
x = [700.7, 711.4, 717.4, 715.7, 747.9, 726.9, 712.3, 719.9, 716.7, 717.8, ...
    706.1, 734.6, 746.1, 776.1, 726.0, 713.5, 759.0, 716.4, 720.2, 725.4, ...
    744.2, 700.3, 732.0, 708.9, 698.8, 728.7, 732.8, 741.1, 714.6, 717.1, ...
    701.5, 726.5, 738.3, 743.1, 747.7, 692.9, 751.6, 723.4, 725.8, 742.1, ...
    761.2, 730.5, 742.5, 748.6, 735.1, 757.3, 720.9, 715.6, 731.4, 763.7, ...
    696.5, 755.6, 725.8, 707.5, 750.5, 720.2, 739.8, 732.7, 736.7, 707.9, ...
    720.4, 704.6, 720.1, 717.9, 740.0, 721.0, 743.2, 721.8, 744.3, 724.5, ...
    710.6, 714.5, 787.9, 692.5, 722.1, 740.7, 711.0, 719.1, 701.2, 718.6, ...
    747.2, 711.2, 753.9, 737.0, 694.2, 765.5, 758.4, 760.0, 726.3, 695.4, ...
    713.5, 719.4, 749.1, 719.4, 714.4, 746.3, 758.1, 718.0, 741.8, 749.2];

% Calculate required values
%x_sorted = sort(x);
%n = length(x_sorted);
%median_val = median(x_sorted);
%q1 = median(x_sorted(1:n/2));
%q3 = median(x_sorted((n+1)/2:end));
%p5 = prctile(x_sorted, 5);
%x_bar = mean(x_sorted);
%s_squared = var(x_sorted);
%s = sqrt(s_squared);
%c1 = sum(abs(x_sorted - x_bar) <= s) / n;
%c1_5 = sum(abs(x_sorted - x_bar) <= 1.5 * s) / n;
%c2 = sum(abs(x_sorted - x_bar) <= 2 * s) / n;



% Calculate required values
median_val = median(x);
q1 = prctile(x, 25);
q3 = prctile(x, 75);
p5 = prctile(x, 5);
x_bar = mean(x);
s_squared = var(x);
s = std(x);
c1 = sum(abs(x - x_bar) <= s) / length(x);
c1_5 = sum(abs(x - x_bar) <= 1.5 * s) / length(x);
c2 = sum(abs(x - x_bar) <= 2 * s) / length(x);


% Output the results
fprintf('Median: %.2f\n', median_val);
fprintf('1st Quartile: %.2f\n', q1);
fprintf('3rd Quartile: %.2f\n', q3);
fprintf('5th Percentile: %.2f\n', p5);
fprintf('x-bar: %.2f\n', x_bar);
fprintf('s^2: %.2f\n', s_squared);
fprintf('s: %.2f\n', s);
fprintf('c1: %.2f\n', c1);
fprintf('c1.5: %.2f\n', c1_5);
fprintf('c2: %.2f\n', c2);