clear;
rng(1);
data = randi(6,1,60); % die
s(1,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,',data(1, 1:10));
s(2,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,',data(1,11:20));
s(3,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,',data(1,21:30));
s(4,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,',data(1,31:40));
s(5,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,',data(1,41:50));
s(6,:) = sprintf('%d, %d, %d, %d, %d, %d, %d, %d, %d, %d ',data(1,51:60));
disp(s);

figure('Name','Data Set')
% plot(data,'*');
stem(data, 'b');
axis([0 (length(data)+1) 0 (max(data)+1)]);

%%
% -------------------------------------------------------------------
figure('Name','Histogram')
h = histogram(data); % for the data set given: = histogram(data,0.5:6.5);
h.FaceColor = [0.8,0.9,1];
a = axis();
a(2) = 7;
a(4) = max(h.Values)*1.1;
axis(a);
yticks(2:2:16);
ax = gca;
ax.YGrid = 'on';

%%
% -------------------------------------------------------------------
figure('Name','Relative Frequency Plots')
%h = histogram(data,'Normalization','pdf', 'FaceColor', [1,0.5,0.5]);
 
[n,xe] = histcounts(data,'Normalization','pdf');
midpoints = (xe(1:length(xe)-1) + xe(2:length(xe)))/2;
bar(midpoints, n, 'BarWidth', 0.7, 'FaceColor', [0.8,0.9,1])

%%
% -------------------------------------------------------------------
figure('Name','Cumulative Relative Frequency Plot')
xMin = -0.5;
xMax = 7.5;
h = histogram(data, xMin:0.001:xMax, 'Normalization','cumcount');
xh = h.BinEdges(1:length(h.BinEdges)-1);
ch = [h.Values];
plot(xh,ch,'b--','Linewidth',0.2)

hold on
plot(xh,ch,'b.','Linewidth',2)
axis([xMin, xMax, 0, max(ch)*1.1]);
grid on

[c,xe] = histcounts(data,1:7,'Normalization','cumcount')
plot(xe(1:length(xe)-1),c, 'b.', 'MarkerSize', 15);
pbaspect([2 1 1])

%%
% -------------------------------------------------------------------
figure('Name','Quantiles')
% quantile function (as defined in the lecture)
x = sort(data);
n = length(x);
d = 1/n;

hold on
for i=1:n;
    plot1 = plot([(i-1)*d,i*d],[x(i),x(i)],'b','Linewidth',1);
end
for i=1:n-1;
    plot([i*d],[(x(i)+x(i+1))/2],'b.', 'MarkerSize', 13);
end
plot([0],[x(1)],'b.', 'MarkerSize', 13);
plot([1],[x(n)],'b.', 'MarkerSize', 13);

grid on
a = axis();
a(3) = 0.5;
a(4) = 6.5;
axis(a);
pbaspect([2 1 1])

% -------------------------------------------------------------------
% Matlab's quantile function uses linear interpolation
% x = 0:0.001:1;
% q = quantile(data,x);
% plot(x,q,'r--');
% 
% q = quantile(data,0:d:1);
% plot(0:d:1,q,'r*');


%%
% -------------------------------------------------------------------
s = sum(data);
fprintf('Sum:                %f\n', s);
fprintf('Mean:               %f\n', s/length(data));
m = mean(data);
fprintf('Mean:               %f\n', m);


v = ((data-m)*(data-m)')/(length(data)-1);
fprintf('Variance:           %f\n', v);
v = (data*data' - length(data)*m^2)/(length(data)-1);
fprintf('Variance:           %f\n', v);
v = var(data);
fprintf('Variance:           %f\n', v);

s = sqrt(v);
fprintf('Standard Deviation: %f\n', s);
s = std(data);
fprintf('Standard Deviation: %f\n', s);

%%
% -------------------------------------------------------------------
figure
boxplot(data,'orientation','horizontal');

data = sort(data);
fprintf('Median:             %f\n', (data(30)+data(31))/2);
fprintf('Median:             %f\n', median(data));
fprintf('1st Quartil:        %f\n', (data(15)+data(16))/2);
fprintf('1st Quartil:        %f\n', quantile(data,0.25));
fprintf('3rd Quartil:        %f\n', (data(45)+data(46))/2);
fprintf('3rd Quartil:        %f\n', quantile(data,0.75));
