% clear all; 
close all
clc

load 'banknote.dat'
DATA = banknote;

feat = 1:4;

%  class row:
cl = 5;

%  indicators for two classes are
i1 = 0;i2 = 1;

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

%%
G = C1;F = C2; % class C1: Genuine; class C2: Forgery  
disp('************  banknote ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

%% SVM classification
disp(' ') 
disp(['SVM classification:'])
type = 'SVM';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G,F,classifier(1:(end-1)));
disp(['Accuracy of SVM:   ',num2str(ERRS(G,F,classifier)),'%'])

%% Histograms and normalisation
IND = 1; % indicator for feature
histogram(G(:,IND));hold on
disp('Mean and std without normalisation :')
disp(['G :',num2str([mean(G(:,IND)) std(G(:,IND))])])

help = G(:,IND); % for calculations below you will need help variable 
% calculating normalisation value
% norm_std: for the reason to bring feature G(:,1) to have std = 1 
norm_std = std(help); 
help = help/norm_std;

% calculating normalisation value
% norm_mean: for the reason to bring feature G(:,1) to have  mean = 0
norm_mean = mean(help);

% Applying normalisation values to feature G(:,1) 
G(:,IND) = G(:,IND)./norm_std-norm_mean;
F(:,IND) = F(:,IND)./norm_std-norm_mean;
% Control
disp('Mean and std with normalisation :')
disp(['G :',num2str([mean(G(:,IND)) std(G(:,IND))])])
disp(['F :',num2str([mean(F(:,IND)) std(F(:,IND))])])

%% SVM classification
disp(' ') 
disp(['SVM classification after normalisation of one feature:'])
type = 'SVM';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G,F,classifier(1:(end-1)));
disp(['Accuracy of SVM:   ',num2str(ERRS(G,F,classifier)),'%'])

