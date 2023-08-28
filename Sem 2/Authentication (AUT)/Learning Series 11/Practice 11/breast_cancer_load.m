clear all; close all

load 'breast_cancer.dat'
DATA = breast_cancer;
DATA(:,1) = []; 
% missing data have values -1
feat = 1:9;
cl = 10;
i1 = 2;i2 = 4;
  
for i=length(DATA(:,1)):-1:1
    if min(DATA(i,:))<0 DATA(i,:) = [];end
end

%% CLASSES
C1 = [];% class 1
for i=1:length(DATA(:,1))
    if DATA(i,cl)==i1
        C1 = [C1;DATA(i,:)];
    end
end

C2 = [];% class 2
for i=1:length(DATA(:,1))
    if DATA(i,cl)==i2
        C2 = [C2;DATA(i,:)];
    end
end
C1 = C1(:,feat);C2 = C2(:,feat);

G = C1;F = C2;  

disp('************   breast cancer  ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

% random permutation of objects in data (MATLAB function: randperm)

PP = 0;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects');
else disp('without random permutation of objects');
end

% normalisation to mean=0 and standard deviation=1 with respect to class G
NN = 0;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
else
    disp(['without normalisation']);
end

%% Example for convex hull calculation in 2D

% give number of elements I1 in class X
% give number of elements I2 in class Y
I1 = 100; I2 = 75;

X = [rand(I1,1) rand(I1,1)];
Y = [rand(I2,1)-1 rand(I2,1)-1];

plot(X(:,1),X(:,2),'g*');hold on % visualisation
plot(Y(:,1),Y(:,2),'r*');hold on

k1 = convhull(X(:,1),X(:,2));
k2 = convhull(Y(:,1),Y(:,2));
plot(X(k1,1),X(k1,2),'g');hold on
plot(Y(k2,1),Y(k2,2),'r');hold on
plot(X(k1,1),X(k1,2),'go');hold on
plot(Y(k2,1),Y(k2,2),'ro');hold on
title('Example for convex hull calculation in 2D')
legend('class X','class Y','convex hull of X','convex hull of Y','vertices of convex hull of X','vertices of convex hull of Y')




