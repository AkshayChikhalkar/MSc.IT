%clear all; close all

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
disp(' ')
temp = [];
for i=1:length(G(1,:))
      D = discriminate(G(:,i),F(:,i));
      temp = [temp D];
end
disp(['Discriminants (FDR) of single features : ',num2str(temp)]);

weights = []; % random weights for linear combination of features
for i=1:length(G(1,:))
      weights = [weights rand(1,1)];
end
disp(['Random weights: ',num2str(weights)]);
D = discriminate_dim(G,F,weights);
disp(['Discriminant of feature combination within above weights : ',num2str(D)]);
disp(' ')
weights = []; % random weights for linear combination of features
for i=1:length(G(1,:))
      weights = [weights rand(1,1)];
end
disp(['Random weights 1: ',num2str(weights)]);
D = discriminate_dim(G,F,weights);
disp(['Discriminant of feature combination within above weights : ',num2str(D)]);
disp(' ')
weights = []; % random weights for linear combination of features
for i=1:length(G(1,:))
      weights = [weights rand(1,1)];
end
disp(['Random weights 2: ',num2str(weights)]);
D = discriminate_dim(G,F,weights);
disp(['Discriminant of feature combination within above weights : ',num2str(D)]);

%% LDA classification
disp(' ') 
disp(['LDA classification:'])
type = 'LDA';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
disp(['Bias: ',num2str(classifier(end))]);

disp(['Accuracy of LDA:   ',num2str(ERRS(G,F,classifier)),'%'])
discriminate_dim(G,F,classifier(1:end-1))


%% SVM classification
disp(' ') 
disp(['SVM classification:'])
type = 'SVM';
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Feature weights: ',num2str(classifier(1:(end-1)))]);
disp(['Bias: ',num2str(classifier(end))]);

disp(['Accuracy of SVM:   ',num2str(ERRS(G,F,classifier)),'%'])

