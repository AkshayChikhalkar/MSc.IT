clear all; close all
addpath('C:\Users\Helene Dörksen\Desktop\DATA\Mein Computer\MATLAB\MyMatlab\Margin\DATASETS')

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

% normalisation to mean=0 and standard deviation=1 with respect to class G
NN = 1;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
else
    disp(['without normalisation']);
end

% random permutation of objects in data (MATLAB function: randperm)
PP = 1;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects')
else disp('without random permutation of objects');
end

initial = 'LDA';disp(['Initial classifier: ',initial])
ref = 'SVM';disp(['Refinement classifier: ',ref])

%% Example for visualisation for refinement in 2D reduced space

disp('Refinement in 2 dimensional space')
% initial classifier
[classifier,err,initial,vector] = parameters(G,F,initial);
disp(['Accuracy of classifier:   ',num2str(ERRS(G,F,classifier)),'%'])

I1 = [2 3 4]; I2 = 1:length(G(1,:)); % example for defining indices I1 and I2 
I2(I1) = [];
disp(['Indexsubset I1: ',num2str(I1)]);
disp(['Indexsubset I2: ',num2str(I2)]);

% dimensionality reduction
REF_G = [sum(G(:,I1).*classifier(I1),2) sum(G(:,I2).*classifier(I2),2)]; % fusion of summands for class G
REF_F = [sum(F(:,I1).*classifier(I1),2) sum(F(:,I2).*classifier(I2),2)]; % fusion of summands for class F

disp(['Accuracy of initial classifier in 2D:',num2str(ERRS(REF_G,REF_F,[1 1 classifier(end)])),'%'])

plot(REF_G(:,1),REF_G(:,2),'g*');hold on
plot(REF_F(:,1),REF_F(:,2),'ro');hold on

a = 1;
b = 1;
bias = -classifier(end);
x = [min([REF_G(:,1);REF_F(:,1)]) max([REF_G(:,1);REF_F(:,1)])];
y = (-bias-a*x)./b;
plot(x,y,'k');hold on

% refinement
[classifier,err,ref,vector] = parameters(REF_G,REF_F,ref);
disp(['Accuracy of refinement:   ',num2str(ERRS(REF_G,REF_F,classifier)),'%'])

a = classifier(1);
b = classifier(2);
bias = -classifier(end);
y = (-bias-a*x)./b;
plot(x,y,'k--');hold on

legend('class G in 2D','class F in 2D','initial classifier in 2D','refinement')

%% Part a) & b)

% disp('Refinement in d-1 dimensional space')
% 
% [classifier,err,initial,vector] = parameters(G,F,initial);
% classifier_ini = classifier;
% disp(['Initial Accuracy:   ',num2str(ERRS(G,F,classifier_ini)),'%'])
% 
% k = 2;P = nchoosek(1:length(G(1,:)),k); % all possible combinations of k elements from 1:d 
% % to reduce exactly one dimention we need to set k = 2 !!!
% 
% RESULTS = [];
% for i=1:length(P(:,1))
%     I1 = P(i,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
%     I2(I1) = [];
%     
%     % dimensionality reduction
%     REF_G = [sum(G(:,I1).*classifier_ini(I1),2) G(:,I2)]; % fusion of summands for class G
%     REF_F = [sum(F(:,I1).*classifier_ini(I1),2) F(:,I2)]; % fusion of summands for class F
%     
%     [classifier,err,ref,vector] = parameters(REF_G,REF_F,ref);
%     RESULTS = [RESULTS;P(i,:) ERRS(REF_G,REF_F,classifier)];  
% end
% disp(' ')
% disp('Results of refinement:')
% disp(RESULTS)

%% Part c) Holdout Method

% disp(' ')
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
% [classifier,err,initial,vector] = parameters(train_G,train_F,initial);
% classifier_ini = classifier;
% disp(['Accuracy of TEST (initial):   ',num2str(ERRS(test_G,test_F,classifier)),'%'])
% 
% k = 2;P = nchoosek(1:length(G(1,:)),k); % all possible combinations (FUSIONS) of k elements from 1:d 
% % to reduce exactly one dimention we need to set k = 2 !!!
% 
% % loop is constructed for exactly one FUSION, e.g. 
% FUSION = 4;
% for i=FUSION
%     I1 = P(i,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
%     I2(I1) = [];
%     
%     % dimensionality reduction
%     REF_G = [sum(G(:,I1).*classifier_ini(I1),2) G(:,I2)]; % fusion of summands for class G
%     REF_F = [sum(F(:,I1).*classifier_ini(I1),2) F(:,I2)]; % fusion of summands for class F
%     
%     test_REF_G = REF_G(1:i1,:);train_REF_G = REF_G(i1+1:end,:); 
%     test_REF_F = REF_F(1:i2,:);train_REF_F = REF_F(i2+1:end,:);
%     
%     [classifier,err,ref,vector] = parameters(train_REF_G,train_REF_F,ref);
% 
%     disp(['Accuracy of TEST (refinement):   ',num2str(ERRS(test_REF_G,test_REF_F,classifier)),'%'])  
% end


%% Part c) k-fold cross validation

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
%       [classifier,err,initial,vector] = parameters(train_G,train_F,initial);
%       RESULTS = [RESULTS ERRS(test_G,test_F,classifier)];    
% end
% disp(['AVERAGED INITIAL ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['AVERAGED DEVIATION: ',num2str(std(RESULTS))]);
% 
% RESULTS = [];
% kk = 2;P = nchoosek(1:length(G(1,:)),kk); % all possible combinations (FUSIONS) of kk elements from 1:d 
% % to reduce exactly one dimention we need to set kk = 2 !!!
% 
% % loop is constructed for exactly one FUSION, e.g. 
% FUSION = 2;
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
%       % initial classification
%       [classifier,err,initial,vector] = parameters(train_G,train_F,initial);  
%       classifier_ini = classifier;
%       I1 = P(FUSION,:); I2 = 1:length(G(1,:)); % defining indices I1 and I2 for reducing exactly one dimension 
%       I2(I1) = [];
%       
%       % dimensionality reduction for train/test sets
%       train_REF_G = [sum(train_G(:,I1).*classifier_ini(I1),2) train_G(:,I2)]; 
%       train_REF_F = [sum(train_F(:,I1).*classifier_ini(I1),2) train_F(:,I2)]; 
% 
%       test_REF_G = [sum(test_G(:,I1).*classifier_ini(I1),2) test_G(:,I2)]; 
%       test_REF_F = [sum(test_F(:,I1).*classifier_ini(I1),2) test_F(:,I2)]; 
%       
%       % refinement
%       [classifier,err,ref,vector] = parameters(train_REF_G,train_REF_F,ref);
%       RESULTS = [RESULTS ERRS(test_REF_G,test_REF_F,classifier)];   
% end
% disp(['AVERAGED REFINEMENT ACCURACY: ',num2str(mean(RESULTS))]);
% disp(['AVERAGED DEVIATION: ',num2str(std(RESULTS))]);

    %% Best performance: 
    %
    % without normalisation: initial LDA (FUSION 2); refinement SVM
    % with normalisation: initial SVM (FUSION 4); refinement SVM


%% Part d) Visualisation for refinement in 2D reduced space

% disp('Refinement in 2 dimensional space')
% % initial classifier
% [classifier,err,initial,vector] = parameters(G,F,initial);
% disp(['Accuracy of classifier:   ',num2str(ERRS(G,F,classifier)),'%'])
% 
% % all possible combinations (FUSIONS) of k elements from 1:d 
% % for this dataset k can be set 2 or 3
% k = 2;P = nchoosek(1:length(G(1,:)),k); 
% FUSION = 2;
% I1 = P(FUSION,:); I2 = 1:length(G(1,:));
% I2(I1) = [];
% 
% disp(['Indexsubset I1: ',num2str(I1)]);
% disp(['Indexsubset I2: ',num2str(I2)]);
% 
% % dimensionality reduction
% REF_G = [sum(G(:,I1).*classifier(I1),2) sum(G(:,I2).*classifier(I2),2)]; % fusion of summands for class G
% REF_F = [sum(F(:,I1).*classifier(I1),2) sum(F(:,I2).*classifier(I2),2)]; % fusion of summands for class F
% 
% disp(['Accuracy of initial classifier in 2D:',num2str(ERRS(REF_G,REF_F,[1 1 classifier(end)])),'%'])
% 
% plot(REF_G(:,1),REF_G(:,2),'g*');hold on
% plot(REF_F(:,1),REF_F(:,2),'ro');hold on
% 
% a = 1;
% b = 1;
% bias = -classifier(end);
% x = [min([REF_G(:,1);REF_F(:,1)]) max([REF_G(:,1);REF_F(:,1)])];
% y = (-bias-a*x)./b;
% plot(x,y,'k');hold on
% 
% % refinement
% [classifier,err,ref,vector] = parameters(REF_G,REF_F,ref);
% disp(['Accuracy of refinement:   ',num2str(ERRS(REF_G,REF_F,classifier)),'%'])
% 
% a = classifier(1);
% b = classifier(2);
% bias = -classifier(end);
% y = (-bias-a*x)./b;
% plot(x,y,'k--');hold on
% 
% legend('class G in 2D','class F in 2D','initial classifier in 2D','refinement')
