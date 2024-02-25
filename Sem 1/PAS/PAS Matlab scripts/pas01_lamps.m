clear;
rng(1);
data = random('Normal',1500,300,1,1000);
%data = 300*norminv(rand(1,1000)) + 1500;
%data = max(0,300*norminv(rand(1,1000)) + 1000);

color = [0.5,0,0.5];
figure('Name','Data Set')
plot(data,'*', 'Color',color);
a = axis();
a(3) = 0;
a(4) = a(4)*1.1;
axis(a);
pbaspect([2 1 1])


%%
% -------------------------------------------------------------------
figure('Name','Histogram')
h = histogram(data);
h.FaceColor = color;
h.FaceAlpha = 0.15;
grid on
pbaspect([2 1 1])


%%
% -------------------------------------------------------------------
% Generating a Cumulative Relative Frequency Plot with 
% Matlab's histcounts function.
figure('Name','Cumulative Relative Frequency Plot')
xMin = 300;
xMax = 2700;
[cc,xe] = histcounts(data, xMin:0.01:xMax, 'Normalization','cumcount');
xe = xe(1:length(xe)-1);
% plot(xe,cc,'b--','Linewidth',0.2)

plot(xe,cc,'.','Color',color)
axis([xMin, xMax, 0, max(cc)*1.1]);
grid on
pbaspect([2 1 1])

% Uncomment the following code, if you like to zoom into the graph to
% find the exact x-values of the data set (where the jumps occur).
%
% hold on
% ds = sort(data);
% plot(ds,1:length(ds), '.','MarkerSize',15,'Color',color);


%%
% -------------------------------------------------------------------
figure('Name','Quantiles')
% quantile function (as defined in the lecture)
x = sort(data);
n = length(x);
d = 1/n;

hold on
for i=1:n;
    plot1 = plot([(i-1)*d,i*d],[x(i),x(i)],'Color',color);
end
for i=1:n-1;
    plot([i*d],[(x(i)+x(i+1))/2],'.', 'Color',color,'MarkerSize', 5);
end
plot([0],[x(1)],'.', 'Color',color,'MarkerSize', 5);
plot([1],[x(n)],'.', 'Color',color,'MarkerSize', 5);

grid on
pbaspect([2 1 1])

% -------------------------------------------------------------------
% Matlab's quantile function uses linear interpolation
%
% x = 0:0.001:1;
% q = quantile(data,x);
% plot(x,q,'r--');
% 
% q = quantile(data,0:d:1);
% plot(0:d:1,q,'r*');


%%
% -------------------------------------------------------------------
figure
% boxplot(data,'orientation','horizontal')
% boxplot(data,'orientation','horizontal','boxstyle','filled')
boxplot(data,'orientation','horizontal','whisker',1000);
ax = axis();
ax(3) = 0.8;
ax(4) = 1.2;
axis(ax);
pbaspect([2 0.5 1])

data = sort(data);
fprintf('data(500):          %f\n', data(500));
fprintf('data(501):          %f\n', data(501));
fprintf('Median:             %f\n', (data(500)+data(501))/2);
fprintf('Median:             %f\n', median(data));
fprintf('1st Quartil:        %f\n', (data(250)+data(251))/2);
fprintf('1st Quartil:        %f\n', quantile(data,0.25));
fprintf('3rd Quartil:        %f\n', (data(750)+data(751))/2);
fprintf('3rd Quartil:        %f\n', quantile(data,0.75));

fprintf('Mean:               %f\n', mean(data));
fprintf('Variance:           %f\n', var(data));
fprintf('Standard Deviation: %f\n', std(data));
