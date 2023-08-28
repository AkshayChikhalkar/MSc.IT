%clear all; close all

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

