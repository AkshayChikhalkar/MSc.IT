clear all; close all

addpath('C:\Users\Helene Dörksen\Desktop\DATA\Mein Computer\MATLAB\MyMatlab\Margin\DATASETS')


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


% random permutation of objects in data (MATLAB function: randperm)

PP = 1;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects')
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

%% Part a) & b)

disp('Refinement in d-1 dimensional space')
type = 'SVM';disp(['Initial classifier: ',type])
[classifier,err,type,vector] = parameters(G,F,type);
classifier_ini = classifier;
disp(['Accuracy:   ',num2str(ERRS(G,F,classifier_ini)),'%'])

P = nchoosek(1:length(G(1,:)),2); % all possible combinations of two elements from 1:d  
k = 2;P = nchoosek(1:length(G(1,:)),k); % all possible combinations of k elements from 1:d 

type = 'SVM';disp(['Refinement classifier: ',type])
RESULTS = [];
for i=1:length(P(:,1))
    I1 = P(i,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
    I2(I1) = [];
    
    % Dimensionality reduction
    REF_G = [sum(G(:,I1).*classifier_ini(I1),2) G(:,I2)]; % fusion of summands for class G
    REF_F = [sum(F(:,I1).*classifier_ini(I1),2) F(:,I2)]; % fusion of summands for class F
    
    [classifier,err,type,vector] = parameters(REF_G,REF_F,type);
    RESULTS = [RESULTS;P(i,:) ERRS(REF_G,REF_F,classifier)];  
end

%% Part c)
% disp('Comparing generalisation abilities of initial classifier and refinement')
% 
% disp('Holdout Method 50/50%')
% 
% n = 2; % for 50/50 
% 
% i1 = round(length(G(:,1))/n);
% i2 = round(length(F(:,1))/n);
% 
% test_G = G(1:i1,:);train_G = G(i1+1:end,:); 
% test_F = F(1:i2,:);train_F = F(i2+1:end,:);
% 
% % initial classifer
% type = 'LDA';disp(['Initial classifier: ',type])
% [classifier,err,type,vector] = parameters(train_G,train_F,type);
% disp(['Accuracy of TEST (initial):   ',num2str(ERRS(test_G,test_F,classifier)),'%'])
% P = nchoosek(1:length(G(1,:)),2); % all possible combinations of two elements from 1:d  
% % loop is constructed for exactly one FUSION, e.g. 
% FUSION = 4;
% for i=FUSION
%     I1 = P(i,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
%     I2(I1) = [];
%     
%     % Dimensionality reduction
%     REF_G = [sum(G(:,I1).*classifier(I1),2) G(:,I2)]; % fusion of summands for class G
%     REF_F = [sum(F(:,I1).*classifier(I1),2) F(:,I2)]; % fusion of summands for class F
%     
%     test_REF_G = REF_G(1:i1,:);train_REF_G = REF_G(i1+1:end,:); 
%     test_REF_F = REF_F(1:i2,:);train_REF_F = REF_F(i2+1:end,:);
%     
%     type = 'SVM';disp(['Refinement classifier: ',type])
%     [classifier,err,type,vector] = parameters(train_REF_G,train_REF_F,type);
% 
%     disp(['Accuracy of TEST (refinement):   ',num2str(ERRS(test_REF_G,test_REF_F,classifier)),'%'])  
% end
% 
% %
% disp(' ');
% disp('k-fold cross validation')
% 
% k = 5;
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
% % initial classifer
% type = 'LDA';disp(['Initial classifier: ',type])
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
%       RESULTS = [RESULTS ERRS(test_G,test_F,classifier)];    
% end
% disp(['ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['DEVIATION: ',num2str(std(RESULTS))]);
% 
% type = 'SVM';disp(['Refinement classifier: ',type])
% RESULTS = [];
% P = nchoosek(1:length(G(1,:)),2); % all possible combinations of two elements from 1:d  
% % loop is constructed for exactly one FUSION
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
%       % initial
%       [classifier,err,type,vector] = parameters(train_G,train_F,type);     
%       I1 = P(FUSION,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
%       I2(I1) = [];
%       
%       % Dimensionality reduction for train/test sets
%       train_REF_G = [sum(train_G(:,I1).*classifier(I1),2) train_G(:,I2)]; 
%       train_REF_F = [sum(train_F(:,I1).*classifier(I1),2) train_F(:,I2)]; 
% 
%       test_REF_G = [sum(test_G(:,I1).*classifier(I1),2) test_G(:,I2)]; 
%       test_REF_F = [sum(test_F(:,I1).*classifier(I1),2) test_F(:,I2)]; 
%       
%       [classifier,err,type,vector] = parameters(train_REF_G,train_REF_F,type);
%       RESULTS = [RESULTS ERRS(test_REF_G,test_REF_F,classifier)];   
% end
% disp(['ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['DEVIATION: ',num2str(std(RESULTS))]);


