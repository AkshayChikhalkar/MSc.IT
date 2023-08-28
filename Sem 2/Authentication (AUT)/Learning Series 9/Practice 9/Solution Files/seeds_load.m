%clear all; close all

load 'seeds.dat'
DATA = seeds;
% 1-7th rows: feature values
% 8th row : class labels 1,2 or 3

% INFO: classes 2&3 "simply" linearly separable
% classification rule:
% if f(x)>0 -> S2|S1; if f(x)<=0 -> S3|S1

feat = 1:7;
cl = 8;
i1 = 1;i2 = 2;

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


