clc
clear all; close all

load iris_data.dat
x = iris_data; % dataset has 4 features

% features are: 'sepal length', 'sepal width', 'petal length', 'petal
% width'

% classes/species for 'iris' are : 'setosa', 'versicolor', 'virginica' 

x1 = x(1:50,:);% 'setosa'
x2 = x(51:100,:);% 'versicolor'
x3 = x(101:end,:);% 'virginica'
% 3 species for classification

% CLASSES 
C1 = x1;C2 = x2;

%%
G = C1;F = C2; % two classes named: G and F 
disp('************   iris  ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);
x3
pause

Feature = 3; % good Feature = 3
histogram(x1(:,Feature),10); hold on
histogram(x2(:,Feature),10); hold on

