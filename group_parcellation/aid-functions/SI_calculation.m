% Description: Calculate symmetry index

function SI = SI_calculation(cl_label,area,sym,DK)

ind_left = find(DK==area);
ind_right = find(DK==area+35);
ind_all = [ind_left;ind_right];
temp = DK;
temp(:) = 0;
temp(ind_all) = 1;
temp = temp.*DK;

label_left = cl_label(1:length(ind_left));
label_right = cl_label(length(ind_left)+1:length(ind_all));

temp(ind_left) = label_left;
temp(ind_right) = label_right;

SI = sum(temp(sym.left_index)==temp(sym.right_index))/length(sym.left_index);







