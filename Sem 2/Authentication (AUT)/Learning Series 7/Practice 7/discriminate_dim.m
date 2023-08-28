function D = discriminate_dim(C1,C2,weights)
% Computation of Fischer Discriminate for linear combination (given by
% weights) of features in two classes C1 and C2

    hist1 = zeros(1,length(C1(:,1)))';hist2 = zeros(1,length(C2(:,1)))';
    for i=1:length(C1(1,:))
        hist1 = hist1+weights(i).*C1(:,i);
        hist2 = hist2+weights(i).*C2(:,i);
    end
    A = hist1;
    B = hist2;


    D = (mean(A)-mean(B))^2/(std(A)^2+std(B)^2);

end

