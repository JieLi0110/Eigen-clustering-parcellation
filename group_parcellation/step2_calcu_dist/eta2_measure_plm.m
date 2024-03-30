function eta2_value=eta2_measure_plm(X,Y)

% eta^2 - similarity measure
% X -- 1*p vector
% Y -- 1*p vector

p=size(X,2);
M=(X+Y)/2;
gmean=sum(X+Y)/(2*p);
sum_local = sum((X-M).^2+(Y-M).^2);
sum_total = sum((X-gmean).^2+(Y-gmean).^2);

eta2_value=1-(sum_local/sum_total);


