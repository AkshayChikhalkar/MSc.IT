
x=24;

p = poisscdf(x,20);

pN= normcdf(x, 20, sqrt(20));

c = (p-pN)/p


%pB = binocdf(x,n,p)

x=x+0.5;
%p = poisscdf(x,20);
pN=normcdf(x,20,sqrt(20));

d = (p-pN)/p;
fprintf('%2f', d)

%pNbar= binocdf(x,n,p)




