function [NcutEigenvectors] = spccut(~,Eigenvectors)

X=Eigenvectors;
[m,n] = size(X);
A = zeros(m, 1);

for i = 1:m
    A(i,1) = norm(X(i,:));
end
A = repmat(A,1,n);

NcutEigenvectors = X./A;
end

