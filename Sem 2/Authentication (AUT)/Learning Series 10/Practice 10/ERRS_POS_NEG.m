function main = ERRS_POS_NEG(C1_test,C2_test,classifier)

% calculation of F-measures, which are scores based 
% on correctly and not correctly classified objects for each class 


count = 0;
for i=1:length(C2_test(:,1))
    if C2_test(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
    else
        count = count+1;
    end
end
TN = count;
count = 0;
for i=1:length(C1_test(:,1))
    if C1_test(i,:)*classifier(1:(end-1))'-classifier(end)>=0 
        count = count+1;
    else
    end
end
TP = count;

main = [TP/length(C1_test(:,1))*100 TN/length(C2_test(:,1))*100]; % main(1:2) are scores in %
main = [main 2*TP/(2*TP+length(C2_test(:,1))-TN+length(C1_test(:,1))-TP) 2*TN/(2*TN+length(C2_test(:,1))-TN+length(C1_test(:,1))-TP)];
% F-Measures are main(3:4)

end

