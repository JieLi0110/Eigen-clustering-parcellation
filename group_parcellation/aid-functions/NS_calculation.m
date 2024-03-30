% Description: Calculate the number of scatters in the parcellation result

function total_scatter = NS_calculation(cl_label,adjacentmat)

num_left = size(adjacentmat.neighbour_value_left,1);
num_right = size(adjacentmat.neighbour_value_right,1);
num_all = num_left+num_right;

NCLUST = max(cl_label);

%% Calculate the number of scatters in the left area
num_scatter_left = zeros(1,NCLUST);
for i=1:NCLUST
    b_left=zeros(num_left);
    ind_left=find(cl_label(1:num_left)==i);
    b_left(ind_left,ind_left)=adjacentmat.neighbour_value_left(ind_left,ind_left);
    remain = ind_left;
    jishu = 1;
    seed_index = 1;
    close_club = cell(1,30);
    while ~isempty(remain)
        seed = remain(seed_index);
        flag = 0;
        initial = b_left(seed,:);
        [~,y] = find(initial==1);
        newthing = unique(y);
        while flag == 0
            oldthing = newthing;
            gg = b_left(oldthing,:);
            [~,y] = find(gg == 1);
            newthing = unique(y);
            newthing = union(newthing,oldthing);
            if isempty(newthing)
                flag = 2;
                seed_index = seed_index+1;
            else
                if length(newthing) == length(oldthing)
                    flag = 1;
                end
             end
        end
        if seed_index>length(remain)
            flag = 1;
            newthing = remain;
        end
        if flag == 1
            close_club{jishu} = newthing;
            remain = setdiff(remain,newthing);
            jishu = jishu+1;
            seed_index = 1;
        end
    end
    close_club = close_club(1:jishu);
    scatter_matrix = zeros(1,jishu);
    for mm = 1:jishu
        scatter_matrix(mm) = length(close_club{mm});
    end
    biggest = max(scatter_matrix);
    num_scatter_left(i)= length(ind_left) - biggest;
end

%% Calculate the number of scatters in the right area in the same way
num_scatter_right = zeros(1,NCLUST);
for i=1:NCLUST
    b_right=zeros(num_right);
    ind_right=find(cl_label(num_left+1:num_all)==i);
    b_right(ind_right,ind_right)=adjacentmat.neighbour_value_right(ind_right,ind_right);
    remain = ind_right;
    jishu = 1;
    seed_index = 1;
    close_club = cell(1,30);
    while ~isempty(remain)
        seed = remain(seed_index);
        flag = 0;
        initial = b_right(seed,:);
        [~,y] = find(initial==1);
        newthing = unique(y);
        while flag == 0
            oldthing = newthing;
            gg = b_right(oldthing,:);
            [~,y] = find(gg == 1);
            newthing = unique(y);
            newthing = union(newthing,oldthing);
            if isempty(newthing)
                flag = 2;
                seed_index = seed_index+1;
            else
                if length(newthing) == length(oldthing)
                    flag = 1;
                end
            end
        end
        if seed_index>length(remain)
            flag = 1;
            newthing = remain;
        end
        if flag == 1
            close_club{jishu} = newthing;
            remain = setdiff(remain,newthing);
            jishu = jishu+1;
            seed_index = 1;
        end
    end
    close_club = close_club(1:jishu);
    scatter_matrix = zeros(1,jishu);
    for mm = 1:jishu
        scatter_matrix(mm) = length(close_club{mm});
    end
    biggest = max(scatter_matrix);
    num_scatter_right(i)= length(ind_right) - biggest;
end

%% Calculate the total scatters
total_scatter_left=sum(num_scatter_left);
total_scatter_right=sum(num_scatter_right);
total_scatter=total_scatter_left+total_scatter_right;
