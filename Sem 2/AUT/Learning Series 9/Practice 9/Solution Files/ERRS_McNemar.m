function [e01,e10] = ERRS_McNemar(C1_test,C2_test,classifier1,classifier2)

count = 0; % from function ERRS, not needed here

e01 = 0;e10 = 0; 

for i=1:length(C1_test(:,1))
      
    misClass1 = 0;rightClass1 = 0;
    
    if C1_test(i,:)*classifier1(1:(end-1))'-classifier1(end)>=0
          % misclassified by 1
          misClass1 = 1;
    else
        count = count+1;
        
         rightClass1 = 1;   
    end
    
    if C1_test(i,:)*classifier2(1:(end-1))'-classifier2(end)>=0
          % misclassified by 2
          if rightClass1==1 e10 = e10+1;end
    else
          if misClass1==1 e01 = e01+1;end
                
          count = count+1;
    end   
end

for i=1:length(C2_test(:,1))
      
    misClass1 = 0;rightClass1 = 0;
    
    if C2_test(i,:)*classifier1(1:(end-1))'-classifier1(end)>=0
          % misclassified by 1
          misClass1 = 1;
    else
        count = count+1;
        
         rightClass1 = 1;   
    end
    
    if C2_test(i,:)*classifier2(1:(end-1))'-classifier2(end)>=0
          % misclassified by 2
          if rightClass1==1 e10 = e10+1;end
    else
          if misClass1==1 e01 = e01+1;end
                
          count = count+1;
    end   
end

%main = count/(length(C1_test(:,1))+length(C2_test(:,1)))*100;

end

