clear all;close all

DATA = importdata('Sensorless_drive_diagnosis.txt');

feat = 1:48;

%  class row:
cl = 49;

%  indicators for two classes are
i1 = 1;i2 = 6;

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
disp('************ Motor Drive Diagnosis ***************') 
disp('SAMPLE SIZE : ')
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES: ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(G(:,1))/length(F(:,1)))]);

%% State-of-the-art classifiers
type = 'LDA';
[classifier,err,initial,vector] = parameters(G,F,type);
disp(['Accuracy of ',type,': ',num2str(ERRS(G,F,classifier)),'%'])
disp(' ')

type = 'SVM';
if type=='SVM' disp('You have to wait!');end
[classifier,err,initial,vector] = parameters(G,F,type);
disp(['Accuracy of ',type,': ',num2str(ERRS(G,F,classifier)),'%'])
disp(' ')

