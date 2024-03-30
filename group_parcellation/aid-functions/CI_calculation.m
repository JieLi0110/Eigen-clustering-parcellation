% Description: Calculate cluster validity index

function cluster_validity = CI_calculation(cl_label,center_index,dist)

NCLUST = max(cl_label);
%% Inter distance
dist_inter=dist(center_index,center_index);
aa = zeros(1,NCLUST*(NCLUST-1)/2);
num=1;
for i=1:NCLUST
    for j=i+1:NCLUST
        aa(num)=dist_inter(i,j);
        num=num+1;
    end
end
inter=mean(aa);

%% Intra distance
dist_intra=zeros(1,NCLUST);
for i=1:NCLUST
    aa=dist(center_index(i),setdiff(find(cl_label==i),center_index(i)));
    dist_intra(i)=mean(aa);
end
intra=mean(dist_intra);

cluster_validity = intra/inter;
end




