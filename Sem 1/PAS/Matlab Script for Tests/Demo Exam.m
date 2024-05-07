x = [8.26,8.21,8.25,8.25,8.24,8.25,8.24,8.23,8.28,8.2];
n=10;
ms = mean(x);
mo = mode(x);

sig = 0.02;

v = sqrt(n)/sig*(abs(ms-mo));
ax=2*(1-normcdf(v))



%-----------
% Q2
%-----------
x = [30.0,35.0,40.0,45.0,50.0,55.0,60.0,65.0,70.0,75.0];
y = [76.0,80.0,84.0,85.4,83.3,86.1,88.9,82.1,86.2,95.1];

n=10;

xm = mean(x);
%sx=std(x)
sx= var(x)*(n-1);

ym = mean(y);
sy=var(y)*(n-1);

Sxy = 0;

for i = 1:1:n
    Sxy=Sxy + (x(i)-xm)*(y(i)-ym);
end

B = Sxy/sx
A = ym-B*xm

x0=42;

A+B*x0

Sr = (sx*sy-(Sxy)^2)/sx;

sqrt(Sr*(sx+n*(x0-xm)^2)/(n*(n-2)*sx)) * tinv(1-0.1/2,n-2)

sqrt(Sr*(sx*(n+1)+n*(x0-xm)^2)/(n*(n-2)*sx)) * tinv(1-0.1/2, n-2)
