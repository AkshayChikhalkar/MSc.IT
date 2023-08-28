clear all; close all

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

