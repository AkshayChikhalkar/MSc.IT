x = [51, 120, 123, 127, 103, 137, 163, 115, 123, 132,...
160, 136, 0, 87, 182, 173, 55, 181, 186, 0];

y = [5.0, 3.3, 3.0, 3.3, 3.7, 2.3, 1.7, 2.7, 2.7, 2.7,...
2.3, 3.3, 5.0, 3.3, 1.0, 2.3, 4.0, 1.7, 1.7, 5.0];

scatter(x,y,'*');
xLim = [-10 210];
axis([xLim 0.8 5.2]);
grid on;
xlabel('Homework Pts.');
ylabel('Exam Grade');

% Calculation of the line of best fit
N = length(x);
m_x = 1/N*sum(x);
m_y = 1/N*sum(y);
b = sum((x-m_x)*(y-m_y)')/sum((x-m_x)*(x-m_x)');
a = m_y - b*m_x;
hold on;
plot(xLim,b*xLim+a,'m');

% Normalized data sets
x = x-m_x;
y = y-m_y;
s_x = sqrt(1/(N-1)*sum(x*x'));
s_y = sqrt(1/(N-1)*sum(y*y'));
x = 1/s_x*x;
y = 1/s_y*y;
r = sum(x*y')/sum(x*x')

figure('Name','Scatter diagram of normalized data sets');
hs = scatter(x,y,'*');
axis equal;
grid on;
hold on;
plot(x,r*x,'m');
