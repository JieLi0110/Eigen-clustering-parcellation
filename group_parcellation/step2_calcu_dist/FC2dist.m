% Function Name: FC2dist.m
%
% Description:
% This function calculates dist matrix from FC matrix.
%
% Input：
% - kk: The dimension of the normalized Laplacian eigenvectors.
% - FC_map: The FC matrix.
%
% Output:
% - dist: The dist matrix calculated.
%
% Date  : January 27, 2024

function dist = FC2dist(kk,FC_map)

% Process the abnormal values in FC matrix
nanind = isnan(max(FC_map));
infind = isinf(FC_map);
FC_map(infind) = 0;
FC_map(:,nanind) = [];

% Calculate the correlation matrix
n=size(FC_map,1);
W=zeros(n,n);
for i=1:n
    for j=i+1:n
        W(i,j)=(eta2_measure_plm(FC_map(i,:),FC_map(j,:)));
    end
end
W=W+W';

% Process the abnormal values in correlation matrix
[fc_row,~] = find(isnan(W));
W(fc_row,:) = [];
W(:,fc_row) = [];

% Laplace eigenvector dimensionality reduction
[Eigenvectors, ~] = Eigenmap(W,kk);

% Normalize the eigenvector matrix
[NcutEigenvectors] = spccut(kk,Eigenvectors);

% calculate the dist matrix
dist=pdist2(NcutEigenvectors,NcutEigenvectors, 'cityblock');

end