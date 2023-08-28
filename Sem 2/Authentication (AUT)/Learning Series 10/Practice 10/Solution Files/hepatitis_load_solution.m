clc
clear all; close all

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

% normalisation to mean=0 and standard deviation=1 with respect to class G
NN = 0;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
else
    disp(['without normalisation']);
end

% random permutation of objects in data (MATLAB function: randperm)
PP = 0;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects')
else disp('without random permutation of objects');
end

% softmax manipulation
SM = 0;
if SM==1 
    IND = [1 2 11 13]; % IND describes feature, which will be softmax manipulated
    disp(['with softmax manipulation']);
    [G,F,G,F] = prelim_SOFTMAX(G,F,G,F,IND);
else
    disp(['without softmax manipulation']);
end

disp(' ')
disp('NOTICE: margin-based refinement works best for incomplete/small and not well-balanced samples')
disp('results can be best seen by generalisation tests, e.g. k-fold cross-validations')
disp(' ')

%% Part a)
initial = 'SVM';
ref = 'SVM';

disp(['Initial classifier: ',initial])
[classifier,err,initial,vector] = parameters(G,F,initial);
disp(['Accuracy of initial classifier:   ',num2str(ERRS(G,F,classifier)),'%'])
disp(' ')

% initial margin
rho = 2/norm(classifier(1:end-1));
disp(['Initial margin: ',num2str(rho)])


rule = 'MAX'; % Rule for Margin-based Refinement

if rule=='MIN';
    help = abs(classifier(1:end-1));
    IND(1) = 1e10;ind1 = 0;
    run = 1:length(help);
    for i=run
        if help(i)<IND(1) IND(1) = help(i);ind1 = i;end
    end
    run(ind1) = [];
    IND(2) = 1e10;ind2 = 0;
    for i=run
        if help(i)<IND(2) IND(2) = help(i);ind2 = i;end
    end
    disp(['Summands for MIN rule: ',num2str([ind1 ind2])])

    % dimensionality reduction 
    I1 = [ind1 ind2]; I2 = 1:length(G(1,:)); 
    I2(I1) = [];

    REF_G = [sum(G(:,I1).*classifier(I1),2) G(:,I2)]; % fusion of summands for class G
    REF_F = [sum(F(:,I1).*classifier(I1),2) F(:,I2)]; % fusion of summands for class F

    disp(' ')
    disp(['Refinement classifier: ',ref])
    [refinement,err,ref,vector] = parameters(REF_G,REF_F,ref);
    disp(['Accuracy of refinement within MIN rule: ',num2str(ERRS(REF_G,REF_F,refinement)),'%'])

    % refinement margin
    help = refinement(1:end-1).^2;
    rho_ref = 2/sqrt(sum(help.*[sum(classifier(I1).^2,2) classifier(I2).^2],2));
    disp(['Refinement margin: ',num2str(rho_ref)])
    disp(' ')

elseif rule=='MAX'

    help = abs(classifier(1:end-1));
    IND(1) = 1e-10;ind1 = 0;
    run = 1:length(help);
    for i=run
        if help(i)>IND(1) IND(1) = help(i);ind1 = i;end
    end
    run(ind1) = [];
    IND(2) = 1e-10;ind2 = 0;
    for i=run
        if help(i)>IND(2) IND(2) = help(i);ind2 = i;end
    end
    disp(['Summands for MAX rule: ',num2str([ind1 ind2])])

    % dimensionality reduction 
    I1 = [ind1 ind2]; I2 = 1:length(G(1,:)); 
    I2(I1) = [];

    REF_G = [sum(G(:,I1).*classifier(I1),2) G(:,I2)]; % fusion of summands for class G
    REF_F = [sum(F(:,I1).*classifier(I1),2) F(:,I2)]; % fusion of summands for class F

    [refinement,err,ref,vector] = parameters(REF_G,REF_F,ref);
    disp(['Accuracy of refinement within MAX rule: ',num2str(ERRS(REF_G,REF_F,refinement)),'%'])

    % refinement margin
    help = refinement(1:end-1).^2;
    rho_ref = 2/sqrt(sum(help.*[sum(classifier(I1).^2,2) classifier(I2).^2]));
    disp(['Refinement margin: ',num2str(rho_ref)])
end

%% Part b)

% F-measures
disp('Initial classifier:')
F_meas = ERRS_POS_NEG(G,F,classifier);
disp('Accuracies for both classes in %:')
disp(F_meas(1:2))
disp('F-measures for both classes in %:')
disp(F_meas(3:4))

disp('Refinement with above rule:')
F_meas = ERRS_POS_NEG(REF_G,REF_F,refinement);
disp('Accuracies for both classes in %:')
disp(F_meas(1:2))
disp('F-measures for both classes in %:')
disp(F_meas(3:4))

%% Part c) will not be provided
