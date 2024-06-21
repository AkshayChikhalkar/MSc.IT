clear all; close all

% 50 Amazon Customers: 
% Agresti,Ashbacher,Auken,Blankenship,Brody,Brown,Bukowsky,CFH,Calvinnme,Chachra
% Chandler,Chell,Cholette,Comdet,Corn,Cutey,Davisson,Dent,Engineer,Goonan,Grove,Harp
% Hayes,Janson,Johnson,Koenig,Kolln,Lawyeraau,Lee,Lovitt,Mahlers2nd,Mark,McKee,Merritt
% Messick,Mitchell,Morrison,Neal,Nigam,Peterson,Power,
% Riley,Robert,Shea,Sherwin,Taylor,Vernon
% Vision,Walters,Wilson

% execution of feature values for single customers
DATA = importdata('AmazonCommerce.txt');
DD = [];
for i=9423:10922
    temp = DATA{i};NUM = [];
    j1 = 1;j2 = j1;
    for k=1:10000
        while temp(j2)~=','
            j2 = j2+1;
        end
       NUM = [NUM str2num(DATA{i}(j1:j2-1))];
        j1 = j2+1;
        j2 = j1;
    end
    DD = [DD;NUM];  
end
DATA = DD;

feat = 1:10000;
label = [];temp = 1;
for i=0:49
    label(i*30+1:i*30+30) = temp;
    temp = temp+1;
end

% class row
cl = 10001;
DATA(:,cl) = label';

% permutation vector for classification of all possible customer pairs
P = nchoosek(1:50,2); 

II = 1;
%  indicators for two classes are
i1 = P(II,1);i2 = P(II,2);

%% CLASSES
C1 = [];% class 1
ind = [];
for i=1:length(DATA(:,1))
    if DATA(i,cl)==i1
        ind = [ind;i];
    end
end
C1 = DATA(ind,:);

C2 = [];% class 2
ind = [];
for i=1:length(DATA(:,1))
    if DATA(i,cl)~=i1
        ind = [ind;i];
    end
end
C2 = DATA(ind,:);

C1 = C1(:,feat);C2 = C2(:,feat);

%%
G = C1;F = C2;  
disp('************  Amazon ***************') 
disp('SAMPLE SIZE : ')
disp(['CUSTOMER ',num2str(i1),' vs. all remaining'])
disp(['  # OBJECTS : ',num2str(length([G(:,1);F(:,1)]))]);
disp(['  # FEATURES : ',num2str(length(G(1,:)))]);

disp([' BALANCE :',num2str(length(F(:,1))/length(G(:,1)))]);
