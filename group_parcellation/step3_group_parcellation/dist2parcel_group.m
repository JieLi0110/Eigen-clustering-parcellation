% Function Name: dist2parcel_group.m
%
% Description:
% This function performs the group parcellation using the dist matrix.
%
% Input：
% - dist: Dist matrix.
%
% Output:
% - cl: The parcellation result.
% - icl: The index of cluster centers.
%
% Date  : January 27, 2024

function [cl,icl] = dist2parcel_group(dist)

%% calculate the local density and its distance and neighbor
% calculate the cutoff distance
ND=size(dist,1);
percent=2.0;
sda=sort(dist); 
position=round(size(sda,1)*percent/100)+1;
dc = mean(sda(position,:));

rho = zeros(1,ND);
% Gaussian kernel
for i=1:ND-1
    for j=i+1:ND
        rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
        rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
    end
end
% "Cut off" kernel
%
% for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
% end

delta = zeros(1,ND);
nneigh = zeros(1,ND);
maxd=max(dist(:));
[~,ordrho]=sort(rho,'descend');
delta(ordrho(1))=max(dist(ordrho(1),:));
nneigh(ordrho(1))=0;
for ii=2:ND
    delta(ordrho(ii))=maxd;
    for jj=1:ii-1
        if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
            delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
            nneigh(ordrho(ii))=ordrho(jj);
        end
    end
end

%% draw the decision graph and choose the cluster center
disp('Generated file:DECISION GRAPH')
disp('column 1:Density')
disp('column 2:Delta')
disp('Select a rectangle enclosing cluster centers')
figure(1);
subplot(2,1,1)
plot(rho(:),delta(:),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k'); %作出决策图
box off;
title ('Decision Graph','FontSize',13.0)
xlabel ('\rho')
ylabel ('\delta')

% Select the rectangular area where the cluster center is located
fig=subplot(2,1,1);
rect = getrect(fig);

rhomin=rect(1);
deltamin=rect(2);
NCLUST=0;
cl = -ones(1,ND);
icl = zeros(1,NCLUST);
for i=1:ND
    if ( (rho(i)>rhomin) && (delta(i)>deltamin))
        NCLUST=NCLUST+1;
        cl(i)=NCLUST;
        icl(NCLUST)=i;
    end
end

%% Assigning the labels of vertices not cluster centers
for i=1:ND
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end

disp('Parcellation completed!')

close all