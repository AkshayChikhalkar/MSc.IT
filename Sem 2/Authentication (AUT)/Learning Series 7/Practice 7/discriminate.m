function D = discriminate( A,B )
% Computation of Fischer Discriminate between distributions A and B

if std(A)^2+std(B)^2~=0
    D = (mean(A)-mean(B))^2/(std(A)^2+std(B)^2);
else D = 0;
end

end

