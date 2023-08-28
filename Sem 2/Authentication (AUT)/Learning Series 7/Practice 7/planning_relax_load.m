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
NN = 1;
if NN==1 
    disp(['with normalisation']);
    [G,F,G,F] = prelim_NORM(G,F,G,F);
    disp(' ')
    disp(['Statistics after normalisation:']);disp(['Means (class G):']);
    disp(num2str(mean(G)));disp(['Standard deviations (class G):']);
    disp(num2str(std(G)))
    disp(' ')
    disp(['Means (class F):']);disp(num2str(mean(F)))
    disp(['Standard deviations (class F):']);disp(num2str(std(F)))
else
    disp(['without normalisation']);
end
