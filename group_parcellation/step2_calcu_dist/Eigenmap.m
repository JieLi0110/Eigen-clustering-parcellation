function [Y, eigvalue] = Eigenmap(W, ReducedDim, bEigs)
%function [Y, eigvalue] = Eigenmap(W, ReducedDim, bEigs)                  
%                   W       -  the affinity matrix.  关联矩阵，相似度矩阵
%           ReducedDim      -  the dimensionality of the reduced subspace.
%                bEigs      -  whether to use eigs to speed up. If not
%                              specified, this function will automatically
%                              decide based on the size of W.
%
%   version 2.1 --November/2011
%   version 2.0 --May/2009
%   version 1.5 --Dec./2005
%   version 1.0 --Aug./2003
%
%   Written by Deng Cai (dengcai AT gmail.com)

MAX_MATRIX_SIZE = 1600; % You can change this number according your machine computational power
EIGVECTOR_RATIO = 0.1; % You can change this number according your machine computational power


[row,col] = size(W);
if row ~= col
    error('W must square matrix!!'); 
end 

nSmp = row; %W的行数

if ~exist('ReducedDim','var')
    ReducedDim = 10; %ReducedDim缺省值为10
end
ReducedDim = min(ReducedDim+1,row); %如果给了ReducedDim,就取ReducedDim+1和行数row的最小值

D_mhalf = full(sum(W,2).^-.5); %计算W每行的和,再开平方，然后倒数
D_mhalfMatrix = spdiags(D_mhalf,0,nSmp,nSmp); %生成一个row x row的对角线矩阵，对角线元素为D_mhalf的第一列
W = D_mhalfMatrix*W*D_mhalfMatrix;

W = max(W,W');


dimMatrix = size(W,2); %W的列数（维数）
if ~exist('bEigs','var')
    if (dimMatrix > MAX_MATRIX_SIZE && ReducedDim < dimMatrix*EIGVECTOR_RATIO)
        bEigs = 1;
    else
        bEigs = 0;
    end
end

if bEigs
    option = struct('disp',0);
    [Y, eigvalue] = eigs(W,ReducedDim,'la',option); %'la'表示最大特征值，eigvalue为6个最大特征值对角阵，Y的列向量为对应特征向量
    eigvalue = diag(eigvalue); %eigvalue为特征值
else
    [Y, eigvalue] = eig(full(W));
    eigvalue = diag(eigvalue);
    
    [junk, index] = sort(-eigvalue);
    eigvalue = eigvalue(index); %eigvalue特征值按照从大到小排列
    Y = Y(:,index); %特征值对应的特征向量
    if ReducedDim < length(eigvalue)
        Y = Y(:, 1:ReducedDim);
        eigvalue = eigvalue(1:ReducedDim);
    end
end


eigIdx = find(abs(eigvalue) < 1e-6); %把特征值为0的列和对应的特征向量删掉
eigvalue (eigIdx) = [];
Y (:,eigIdx) = [];

nGotDim = length(eigvalue); %得到特征值的个数

idx = 1;
while(abs(eigvalue(idx)-1) < 1e-12) %从特征值向量中第一个特征值开始，满足特征值为1跳到下一个特征值
    idx = idx + 1;
    if idx > nGotDim
        break;
    end
end
idx = idx - 1; %不满足特征值为1则跳到前一个特征值

if(idx > 1)  % more than one eigenvector of 1 eigenvalue 一个特征值有不只一个特征向量，idx即为该特征值对应特征向量的个数
    u = zeros(size(Y,1),idx); %u矩阵大小为Y's row x idx
    
    d_m = 1./D_mhalf; %d_m为W每行的和,再开平方，列数为1
    cc = 1/norm(d_m); %norm(d_m)为d_m每行的平方和开根号，即W所有元素的和开根号
    u(:,1) = cc./D_mhalf; %u(:,1)为d_m归一化
    
    bDone = 0;
    for i = 1:idx
        if abs(Y(:,i)' * u(:,1) - 1) < 1e-14
            Y(:,i) = Y(:,1);
            Y(:,1) = u(:,1);
            bDone = 1;
        end
    end
    
    if ~bDone
        for i = 2:idx
            u(:,i) = Y(:,i);
            for j= 1:i-1
                u(:,i) = u(:,i) - (u(:,j)' * Y(:,i))*u(:,j);
            end
            u(:,i) = u(:,i)/norm(u(:,i));
        end
        Y(:,1:idx) = u;
    end
end

Y = D_mhalfMatrix*Y;

Y(:,1) = [];
eigvalue(1) = [];