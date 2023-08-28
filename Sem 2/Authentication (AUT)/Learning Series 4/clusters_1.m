%% Example for k-means Clustering with k = 2 und k = 3 
clear all;close all

% X: random generated data in 2D space
X = [randn(20,2)+ones(20,2); randn(20,2)-ones(20,2)];

k = 2;
[cidx, ctrs] = kmeans(X, k);
figure
plot(X(cidx==1,1),X(cidx==1,2),'r.', X(cidx==2,1),X(cidx==2,2),'b.', ctrs(:,1),ctrs(:,2),'kx'); 
grid
legend(' - 1. Cluster',' - 2. Cluster',' - Cluster Centers'); 
title('2-means Clustering')

% X: random generated data in 3D space
X = [randn(40,3)+ones(40,3); randn(40,3)-ones(40,3);[randn(20,3)-2*ones(20,3);randn(20,3)+2*ones(20,3)]];

k = 3;
[cidx, ctrs] = kmeans(X, k);
figure
plot3(X(cidx==1,1),X(cidx==1,2),X(cidx==1,3),'r.', X(cidx==2,1),X(cidx==2,2),X(cidx==2,3),'b.',...
    X(cidx==3,1),X(cidx==3,2),X(cidx==3,3),'g.',ctrs(:,1),ctrs(:,2),ctrs(:,3),'kx'); 
grid
legend(' - 1. Cluster',' - 2. Cluster',' - 3. Cluster',' - Cluster Centers'); 
title('3-means Clustering')

