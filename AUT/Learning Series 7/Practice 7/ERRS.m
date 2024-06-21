function main = ERRS(C1_test,C2_test,classifier)
% calculateing classification accuracy ( = main) for classes 
% C1_test and C2_test

count = 0;
for i=1:length(C2_test(:,1))
    if C2_test(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
    else
        count = count+1;
    end
end
for i=1:length(C1_test(:,1))
    if C1_test(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
        count = count+1;
    else
    end
end

main = count/(length(C1_test(:,1))+length(C2_test(:,1)))*100;

end

