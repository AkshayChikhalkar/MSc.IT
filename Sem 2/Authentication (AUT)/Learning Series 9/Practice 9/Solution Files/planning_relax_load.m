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
PP = 0;
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

%% Example: Refinement in 2 dimensional space

% initial classifier s. above

I1 = [1 2 3]; I2 = 1:length(G(1,:));
I2(I1) = [];

REF_G = [sum(G(:,I1).*classifier(I1),2) sum(G(:,I2).*classifier(I2),2)];
REF_F = [sum(F(:,I1).*classifier(I1),2) sum(F(:,I2).*classifier(I2),2)];

disp(['Accuracy of initial classifier in 2D:   ',num2str(ERRS(REF_G,REF_F,[1 1 classifier(end)])),'%'])

plot(REF_G(:,1),REF_G(:,2),'g*');hold on
plot(REF_F(:,1),REF_F(:,2),'ro');hold on

a = 1;
b = 1;
bias = -classifier(end);
x = [min([REF_G(:,1);REF_F(:,1)]) max([REF_G(:,1);REF_F(:,1)])];
y = (-bias-a*x)./b;
plot(x,y,'k');hold on

[classifier,err,type,vector] = parameters(REF_G,REF_F,type);
disp(['Accuracy of refinement:   ',num2str(ERRS(REF_G,REF_F,classifier)),'%'])