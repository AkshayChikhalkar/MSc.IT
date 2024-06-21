function [C1,C2,C1_test,C2_test] = prelim_SOFTMAX(C1,C2,C1_test,C2_test,IND)
% applying elementary function "exp" on classes for softmax manipulation

for i=IND
    C1(:,i) = 1./(1+exp(-C1(:,i)));
end
for i=IND
    C1_test(:,i) = 1./(1+exp(-C1_test(:,i)));
end
for i=IND
    C2(:,i) = 1./(1+exp(-C2(:,i)));
end
for i=IND
    C2_test(:,i) = 1./(1+exp(-C2_test(:,i)));
end

end

