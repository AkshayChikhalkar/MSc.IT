function [C1,C2,C1_test,C2_test] = prelim_NORM(C1,C2,C1_test,C2_test)
% normalisation to mean=0 and standard deviation=1 with respect to
% one of the classes (here: C1)
% 
% the fuction is suitable for normalisation of training (C1,C2) and 
% test sets (C1_test.C2_test) at ones (with respect to C1)


help = C1; 
norm_std = std(help);
for i=1:length(norm_std)
    if abs(norm_std(i))<1e-8 
        norm_std(i) = 1;
        disp('ATTENTION: STD setting not optimal');
    end
end
for i=1:length(norm_std) help(:,i) = help(:,i)./norm_std(i);end
norm_mean = mean(help);
for i=1:length(C1(:,1))
    C1(i,:) = C1(i,:)./norm_std-norm_mean;
end
for i=1:length(C1_test(:,1))
    C1_test(i,:) = C1_test(i,:)./norm_std-norm_mean;
end
for i=1:length(C2(:,1))
    C2(i,:) = C2(i,:)./norm_std-norm_mean;
end
for i=1:length(C2_test(:,1))
    C2_test(i,:) = C2_test(i,:)./norm_std-norm_mean;
end

end

