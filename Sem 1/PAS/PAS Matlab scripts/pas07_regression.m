%% -------------------------------------------------------------------
%  Scatter plot
%  -------------------------------------------------------------------
clear;
clc;
format compact;

x = 100:10:190;
y = [41 49 45 57 61 62 69 76 87 91];

scatter(x,y,'b*')
grid on;

% add some margin to the plot
d = 0.1;
a = axis();
w = a(2)-a(1);
a(1) = a(1)-d*w;
a(2) = a(2)+d*w;
w = a(4)-a(3);
a(3) = a(3)-d*w;
a(4) = a(4)+d*w;
axis(a);

pause
%% -------------------------------------------------------------------
%  Line of best fit
%  -------------------------------------------------------------------
hold on

n = length(x)
x_bar = mean(x)
s_x = x*x' - n*x_bar^2
y_bar = mean(y)
s_xy = x*y' - n*x_bar*y_bar

B = s_xy/s_x
A = y_bar - B*x_bar

x = [a(1) x a(2)];
plot(x,A + B*x,'b')

pause
%% -------------------------------------------------------------------
%  Lines through mean values: x = x_bar, y = y_bar
%  -------------------------------------------------------------------
plot([x_bar, x_bar], [a(3), a(4)], 'b--');
plot([a(1), a(2)], [y_bar, y_bar], 'b--');

pause
%% -------------------------------------------------------------------
%  Confidence intervals for expected response values 
%  (mean values of response values) 
%  for confidence level 1-gamma
%  -------------------------------------------------------------------
gamma = 0.1;

s_y = y*y' - n*y_bar^2
s_R = (s_x*s_y - s_xy^2)/s_x

delta = sqrt(s_R*(s_x + n*(x-x_bar).^2)/(n*(n-2)*s_x))...
    * tinv(1-gamma/2,n-2);
plot(x,A + B*x + delta, '-. m')
plot(x,A + B*x - delta, '-. m')

pause
%% -------------------------------------------------------------------
%  Prediction intervals for response values 
%  for confidence level 1-gamma
%  -------------------------------------------------------------------
delta = sqrt(s_R*((n+1)*s_x + n*(x-x_bar).^2)/(n*(n-2)*s_x))...
    * tinv(1-gamma/2,n-2);
plot(x,A + B*x + delta, '-. r')
plot(x,A + B*x - delta, '-. r')
