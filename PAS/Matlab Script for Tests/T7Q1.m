n=0:1500;
p=0.5;
m=n*p;
d=n*0.01;
x_min=ceil(m-d);
x_max=floor(m+d);
%s=zero(1,length(n))
for i=1:length(n)
    x=x_min(i):1:x_max(i);
    s(i)=sum(binopdf(x,n(i),p));
    %k(i)=binocdf(x_max(i), n(i),p)-binocdf(x_min(i)-1, n(i),p);
end
disp(length(s))
