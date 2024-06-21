clear all; close all
clc

load 'planning_relax.dat'
DATA = planning_relax;

feat = 1:12;

%  class is (for calculations below should be last feature)
cl = 13;

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

G = C1;F = C2;  

disp('************  planning relax ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

%% Part a)
disp('********************************************') 
% random permutation of objects in data (MATLAB function: randperm)

PP = 1;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects')
else disp('without random permutation of objects');
end

% normalisation to mean=0 and standard deviation=1 with respect to class G
NN = 1;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
%     disp(' ')
%     disp(['Statistics after normalisation:']);disp(['Means (class G):']);
%     disp(num2str(mean(G)));disp(['Standard deviations (class G):']);
%     disp(num2str(std(G)))
%     disp(' ')
%     disp(['Means (class F):']);disp(num2str(mean(F)))
%     disp(['Standard deviations (class F):']);disp(num2str(std(F)))
else
    disp(['without normalisation']);
end

type = 'SVM';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Accuracy of classifier:   ',num2str(ERRS(G,F,classifier)),'%'])

type = 'LDA';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(G,F,type);
disp(['Accuracy of classifier:   ',num2str(ERRS(G,F,classifier)),'%'])

%% Part c)
disp('********************************************') 
PP = 1;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects')
else disp('without random permutation of objects');
end

disp('Holdout Method:')
n = 2; % for 50/50 
%n = 3; % for 33/66

i1 = round(length(G(:,1))/n);
i2 = round(length(F(:,1))/n);

test_G = G(1:i1,:);train_G = G(i1+1:end,:); % for 66/33 n=3 and replace train/test
test_F = F(1:i2,:);train_F = F(i2+1:end,:);

type = 'LDA';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(train_G,train_F,type);
disp(['Accuracy for TRAIN:   ',num2str(ERRS(train_G,train_F,classifier)),'%'])
disp(['Accuracy for TEST:   ',num2str(ERRS(test_G,test_F,classifier)),'%'])

type = 'SVM';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(train_G,train_F,type);
disp(['Accuracy for TRAIN:   ',num2str(ERRS(train_G,train_F,classifier)),'%'])
disp(['Accuracy for TEST:   ',num2str(ERRS(test_G,test_F,classifier)),'%'])

%% Part d)
% disp('********************************************') 
% disp('k-fold cross validation')
% 
% k = 2;
% disp(['k = ',num2str(k)]);
% 
% i1 = round(length(G(:,1))/k);
% i2 = round(length(F(:,1))/k);
% 
% IND1 = 0;
% for i=1:k-1
%       IND1(i+1) = i1*i; 
% end
% IND1 = [IND1 length(G(:,1))];
% 
% IND2 = 0;
% for i=1:k-1
%       IND2(i+1) = i2*i; 
% end
% IND2 = [IND2 length(F(:,1))];
% 
% type = 'SVM';
% disp(type)
% 
% RESULTS = [];
% for i=1:k
%       test_G = G(IND1(i)+1:IND1(i+1),:);
%       test_F = F(IND2(i)+1:IND2(i+1),:);
%       
%       IND = 1:length(G(:,1));
%       IND(IND1(i)+1:IND1(i+1)) = [];
%       train_G = G(IND,:);
%       
%       IND = 1:length(F(:,1));
%       IND(IND2(i)+1:IND2(i+1)) = [];
%       train_F = F(IND,:);   
%       
%       [classifier,err,type,vector] = parameters(train_G,train_F,type);
% 
%       RESULTS = [RESULTS ERRS(test_G,test_F,classifier)];
% end
% disp(['ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['DEVIATION: ',num2str(std(RESULTS))]);

%% PART e)
% disp('********************************************') 
% disp('Leave-one-out')
% 
% type = 'SVM';
% disp(type)
% 
% RESULTS = [];
% for i=1:length(G(:,1))
%       for j=1:length(F(:,1))
%            IND = 1:length(G(:,1));
%            IND(i) = [];
%            test_G = G(i,:);
%            train_G = G(IND,:);
%            
%            IND = 1:length(F(:,1));
%            IND(j) = [];
%            test_F = F(j,:);
%            train_F = F(IND,:);
%            
%            [classifier,err,type,vector] = parameters(train_G,train_F,type);
%            RESULTS = [RESULTS ERRS(test_G,test_F,classifier)];          
%       end
% end
% 
% disp(['ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['DEVIATION: ',num2str(std(RESULTS))]);

%% PART f)
disp('********************************************') 
disp('McNemar Test')

type = 'LDA';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(train_G,train_F,type);
disp(['Accuracy for TEST:   ',num2str(ERRS(test_G,test_F,classifier)),'%'])
classifier1 = classifier;

type = 'SVM';
disp(' ');disp(type)
[classifier,err,type,vector] = parameters(train_G,train_F,type);
disp(['Accuracy for TEST:   ',num2str(ERRS(test_G,test_F,classifier)),'%'])
classifier2 = classifier;

[e01,e10] = ERRS_McNemar(test_G,test_F,classifier1,classifier2);

X = (abs(e01-e10)-1)^2/(e01+e10)