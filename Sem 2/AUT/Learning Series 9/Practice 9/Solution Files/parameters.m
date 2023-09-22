function [classifier,err,type,vector] = parameters(x2,x3,type);
% calculation of classification parameters of type 'LDA' or 'SVM' for
% classes x2 and x3
%
% results are:
% 'classifier' : parameters for linear classification of features (incl.
% bias)
%
% 'err' : classification accuracy
%
% 'type' : s. above
%
% 'vector' : empty


vector = [];
err = 0;

clear y2;y2(1:length(x2(:,1))) = 0;y2 = y2';
clear y3;y3(1:length(x3(:,1))) = 1;y3 = y3';

if type=='LDA'

    [c,err,post,logl,weights] = classify([x2;x3],[x2;x3],[y2;y3],'linear');
    classifier = [weights(1,2).linear' -weights(1,2).const];
    
    count = 0;
    for i=1:length(x2(:,1))
        if x2(i,:)*classifier(1:(end-1))'-classifier(end)<0 
            count = count+1;
        end
    end
    for i=1:length(x3(:,1))
        if x3(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
            count = count+1;
        end
    end
    count = count/(length(x2(:,1))+length(x3(:,1)));
    
    err = (1-count)*100;
    
elseif type=='SVM'
    svmStruct = fitcsvm([x2;x3],[y2;y3],'KernelFunction','linear');
    classifier = [-svmStruct.Beta' svmStruct.Bias];

    count = 0;
    for i=1:length(x2(:,1))
        if x2(i,:)*classifier(1:(end-1))'-classifier(end)<0 
            count = count+1;
        end
    end
    for i=1:length(x3(:,1))
        if x3(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
            count = count+1;
        end
    end
    count = count/(length(x2(:,1))+length(x3(:,1)));
    
    err = (1-count)*100;
    
end
end

