% Examples for LDA and SVM 2D visualisation

clear all; %close all

addpath('C:\Users\Helene Dörksen\Desktop\DATA\Mein Computer\MATLAB\MyMatlab\Margin\DATASETS')

load 'seeds.dat'
DATA = seeds;
% 1-7th rows: feature values
% 8th row : class labels 1,2 or 3

% INFO: classes 2&3 "simply" linearly separable
% classification rule:
% if f(x)>0 -> S2|S1; if f(x)<=0 -> S3|S1

% for the sake of simplicity, examples are considered for classes 2&3
feat = 1:7;
cl = 8;
i1 = 2;i2 = 3;

% CLASSES
C1 = [];% class 1
for i=1:length(DATA(:,1))
    if DATA(i,cl)==i1
        C1 = [C1;DATA(i,feat)];
    end
end

C2 = [];% class 2
for i=1:length(DATA(:,1))
    if DATA(i,cl)==i2
        C2 = [C2;DATA(i,feat)];
    end
end

C1 = C1(:,feat);C2 = C2(:,feat);

%%
G = C1;F = C2; % two classes named: G and F 
disp('************   seeds  ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

%%
% normalisation to mean=0 and standard deviation=1 with respect to class G
NN = 1;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
else
    disp(['without normalisation']);
end

IND = [2 5]; % examples for 2 features are considered
%IND = [4 5]; 
%IND = [6 7]; 

figure
plot(G(:,IND(1)),G(:,IND(2)),'g*');hold on
plot(F(:,IND(1)),F(:,IND(2)),'r*');hold on

type = 'LDA';
[classifier,err,type,vector] = parameters_ext(G(:,IND),F(:,IND),type);

% straight line equation: a*x+b*y+bias=0 
% -> y = (-bias-a*x)/b
% for classifier holds:

a = classifier(1);
b = classifier(2);
bias = -classifier(3);
x = [min([G(:,IND(1));F(:,IND(1))]) max([G(:,IND(1));F(:,IND(1))])];
y = (-bias-a*x)./b;
plot(x,y,'k');hold on

type = 'SVM';
[classifier,err,type,vector] = parameters_ext(G(:,IND),F(:,IND),type);

% straight line equation: a*x+b*y+bias=0 
% -> y = (-bias-a*x)/b
% for classifier holds:

a = classifier(1);
b = classifier(2);
bias = -classifier(3);
x = [min([G(:,IND(1));F(:,IND(1))]) max([G(:,IND(1));F(:,IND(1))])];
y = (-bias-a*x)./b;
plot(x,y,'k--');hold on

SV = [G(:,IND);F(:,IND)];
for i=length(vector):-1:1
      if vector(i)==0 SV(i,:) = [];end
end
plot(SV(:,1),SV(:,2),'mo');hold on

legend('class G','class F','LDA classifier','SVM classifier','support vectors of SVM')
axis equal

