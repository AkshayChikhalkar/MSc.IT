clear all; close all

%addpath('C:\Users\Helene Dörksen\Desktop\DATA\Mein Computer\MATLAB\MyMatlab\Margin\DATASETS')

load 'MAGIC_gamma.dat'
DATA = MAGIC_gamma;

feat = 1:10; 
cl = 11;
i1 = 1;i2 = 0; 

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

disp('************  MAGIC gamma ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);


%% Histograms
i = 9;
histogram(G(:,i));hold on
histogram(F(:,i));hold on
legend('- class G','- class F') 


%% Idea: split classes in parts (and perform PARTITIONED CLASSIFICATION)

C1 = [];C2 = [];
for i=1:length(G(:,1))
    if G(i,9)>=40&G(i,9)<50 C1 = [C1;G(i,:)];end
end
for i=1:length(F(:,1))
    if F(i,9)>=40&F(i,9)<50 C2 = [C2;F(i,:)];end
end

G = C1;F = C2;
disp(' ')
disp(['  # OBJECTS after splitting: ',num2str(length([G(:,1);F(:,1)]))]);

%% 
type = 'LDA';
disp(['Initial classifier: ',type])
disp(['Refinement classifier: SVM'])
[classifier,err,initial,vector] = parameters(G,F,type);
disp(['Initial accuracy:   ',num2str(ERRS(G,F,classifier)),'%'])

classifier_ini = classifier;

% k = 1,...,10/2
k = 5;P = nchoosek(1:length(G(1,:)),k); % all possible combinations of k elements from 1:d 

RESULTS = [];RESULTS_CH = [];
for i=1:length(P(:,1))
    
    I1 = P(i,:); I2 = 1:length(G(1,:)); 
    I2(I1) = [];

    REF_G = [sum(G(:,I1).*classifier_ini(I1),2) sum(G(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class G
    REF_F = [sum(F(:,I1).*classifier_ini(I1),2) sum(F(:,I2).*classifier_ini(I2),2)]; % fusion of summands leading to 2D for class F

    [classifier,err,type,vector] = parameters(REF_G,REF_F,'SVM');
    RESULTS = [RESULTS;I1 ERRS(REF_G,REF_F,classifier)];

    k1 = convhull(REF_G(:,1),REF_G(:,2));
    k2 = convhull(REF_F(:,1),REF_F(:,2));
    [classifier,err,type,vector] = parameters(REF_G(k1,:),REF_F(k2,:),'SVM');
   
    RESULTS_CH = [RESULTS_CH;I1 ERRS(REF_G(k1,:),REF_F(k2,:),classifier)];
end
disp(['Maximal accuracy achived by refinement:']) 
disp(max(RESULTS(:,end)))

disp(['Maximal accuracy achived by refinement on vertices of convex hull:']) 
disp(max(RESULTS_CH(:,end)))



