clear all; close all

%addpath('C:\Users\Helene Dörksen\Desktop\DATA\Mein Computer\MATLAB\MyMatlab\Margin\DATASETS')

load 'breast_cancer.dat'
DATA = breast_cancer;
DATA(:,1) = []; 
% missing data have values -1
feat = 1:9;
cl = 10;
i1 = 2;i2 = 4;
  
for i=length(DATA(:,1)):-1:1
    if min(DATA(i,:))<0 DATA(i,:) = [];end
end

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

disp('************   breast cancer  ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

% random permutation of objects in data (MATLAB function: randperm)

PP = 0;
if PP==1
    G = G(randperm(length(G(:,1)))',:);
    F = F(randperm(length(F(:,1)))',:);
    disp('within random permutation of objects');
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

%% Part a) without visualisation and b) 

type = 'LDA';
disp(['Initial classifier: ',type])
disp(['Refinement classifier: SVM'])

[classifier,err,initial,vector] = parameters(G,F,type);
disp(['Initial accuracy:   ',num2str(ERRS(G,F,classifier)),'%'])

classifier_ini = classifier;

% possible settings for k = 1,...,d/2, if d is even number, otherwise k = 1,...,(d-1)/2
% to achieve all dimensinality reductions to 2D
k = 1;P = nchoosek(1:length(G(1,:)),k); % all possible combinations of k elements from 1:d 

RESULTS = [];RESULTS_CH = []; % vector with results of original refinement and refinement on convex hull
for i=1:length(P(:,1))
    
    I1 = P(i,:); I2 = 1:length(G(1,:)); 
    I2(I1) = [];

    REF_G = [sum(G(:,I1).*classifier_ini(I1),2) sum(G(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class G
    REF_F = [sum(F(:,I1).*classifier_ini(I1),2) sum(F(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class F
    
    [classifier,err,type,vector] = parameters(REF_G,REF_F,'SVM');

    RESULTS = [RESULTS;I1 ERRS(REF_G,REF_F,classifier)];

    k1 = convhull(REF_G(:,1),REF_G(:,2));
    k2 = convhull(REF_F(:,1),REF_F(:,2));

    [classifier,err,type,vector] = parameters(REF_G(k1,:),REF_F(k2,:),'SVM'); % accuracy of refinenemt on vertices of convex hull
    
    RESULTS_CH = [RESULTS_CH;I1 ERRS(REF_G(k1,:),REF_F(k2,:),classifier)];
end
disp(['Maximal accuracy achived by refinement:']) 
disp(max(RESULTS(:,end)))
disp(['Maximal accuracy achived by refinement on vertices of convex hull:']) 
disp(max(RESULTS_CH(:,end)))


%% Part a) visualisation and c)

for i=8 % some i<length(P(:,1))
    
    I1 = P(i,:); I2 = 1:length(G(1,:)); 
    I2(I1) = [];

    REF_G = [sum(G(:,I1).*classifier_ini(I1),2) sum(G(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class G
    REF_F = [sum(F(:,I1).*classifier_ini(I1),2) sum(F(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class F

    plot(REF_G(:,1),REF_G(:,2),'g*');hold on % visualisation
    plot(REF_F(:,1),REF_F(:,2),'r*');hold on

    tic
    [classifier,err,type,vector] = parameters(REF_G,REF_F,'SVM');
    toc
    disp(['Accuracy of refinement:   ',num2str(ERRS(REF_G,REF_F,classifier)),'%'])

    tic
    k1 = convhull(REF_G(:,1),REF_G(:,2));
    k2 = convhull(REF_F(:,1),REF_F(:,2));
    [classifier,err,type,vector] = parameters(REF_G(k1,:),REF_F(k2,:),'SVM');
    toc
    
    disp(['Accuracy of refinenemt on vertices:   ',num2str(ERRS(REF_G(k1,:),REF_F(k2,:),classifier)),'%'])
    plot(REF_G(k1,1),REF_G(k1,2),'g');hold on
    plot(REF_F(k2,1),REF_F(k2,2),'r');hold on
    legend('class G','class F','vertices of convex hull of G','vertices of convex hull of F')

end

