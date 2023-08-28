clc
clear all; close all

load fisheriris
x = [meas(:,1),meas(:,2),meas(:,3),meas(:,4)]; % dataset has 4 features

% features are: 'sepal length', 'sepal width', 'petal length', 'petal
% width'

y = species; % classes
% species for 'iris' are : 'setosa', 'versicolor', 'virginica' 

x1 = x(1:50,:);y1 = y(1:50); % 'setosa'
x2 = x(51:100,:);y2 = y(51:100); % 'versicolor'
x3 = x(101:end,:);y3 = y(101:end); % 'virginica'
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
x1
pause

Feature = 1; % good Feature = 3
histogram(x1(:,Feature),10); hold on
histogram(x2(:,Feature),10); hold on

