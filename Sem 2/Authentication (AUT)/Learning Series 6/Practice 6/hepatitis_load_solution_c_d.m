%clear all; 
close all

load 'hepatitis.dat'
DATA = hepatitis;
% missing data have values -1
% class is feature 1 (DIE/LIVE : 1/2)

% eliminating object with missing values
for i=length(DATA(:,1)):-1:1
    if min(DATA(i,[4 6:19]))<0 DATA(i,:) = [];end
end

feat = 2:20;
% some feature rows are eliminated:
feat([2 7 8]) = [];

%  class row:
cl = 1;

%  indicators for two classes are
i1 = 1;i2 = 2;

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
G = C1;F = C2; % two classes named: G and F 
disp('************  hepatitis ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);


disp(' ')
temp = [];
for i=1:length(G(1,:))
      D = discriminate(G(:,i),F(:,i));
      temp = [temp D];
end
disp(['Discriminants (FDR) of single features : ',num2str(temp)]);
% searching for feature with lowest FDR
low = 1e16;
for i=1:length(G(1,:))
      if temp(i)<low low = temp(i);index = i;
      end
end
disp(['Feature with lowest FDR is: ',num2str(index)]);

%% Comparing classifiers and corresponding FDR 
% 1. for all features 
% 2. without weakest feature (with respect to FDR)

IND = 1:length(G(1,:)); 
IND(index) = []; % eliminating weakest feature

%% LDA classification
disp(' ') 
disp(['LDA classification for ALL features:'])
type = 'LDA';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['LDA based feature weights: ',num2str(classifier(1:(end-1)))]);
%disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G,F,classifier(1:(end-1)));
disp(['FDR (for LDA solution and all features) = ',num2str(D)]);
disp(['Accuracy of LDA:   ',num2str(ERRS(G,F,classifier)),'%'])
disp(' ')
disp(['LDA classification without weakest feature:'])
[classifier,err,type,vector] = parameters(G(:,IND),F(:,IND),type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
%disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G(:,IND),F(:,IND),classifier(1:(end-1)));
disp(['FDR (for LDA without weakest feature)= ',num2str(D)]);
disp(['Accuracy of LDA (without weakest feature):   ',num2str(ERRS(G(:,IND),F(:,IND),classifier)),'%'])
disp(' ')

%% SVM classification
disp('********************************') 
disp(' ')
type = 'SVM';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['SVM based feature weights: ',num2str(classifier(1:(end-1)))]);
%disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G,F,classifier(1:(end-1)));
disp(['FDR (for SVM solution and all features) = ',num2str(D)]);
disp(['Accuracy of SVM:   ',num2str(ERRS(G,F,classifier)),'%'])
disp(' ')
disp(['SVM classification without weakest feature:'])
[classifier,err,type,vector] = parameters(G(:,IND),F(:,IND),type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
%disp(['Bias: ',num2str(classifier(end))]);
D = discriminate_dim(G(:,IND),F(:,IND),classifier(1:(end-1)));
disp(['FDR (for SVM solution without weakest feature)= ',num2str(D)]);
disp(['Accuracy of SVM without weakest feature:   ',num2str(ERRS(G(:,IND),F(:,IND),classifier)),'%'])
