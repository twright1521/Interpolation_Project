function new_vals = Barnes_Interpolation(xy_coord_pairs,coord_values,query_coord)

% Does Barnes Interpolation for a given point specified by query_vals
% Given xy_ccord_pairs as a matrix of gridpoints, with x_values in the
% first column and y_values in the second column
%
% xy_coord_pairs = [ x1, y1; x2, y2; x3, y3; ... ; xN, yN]
%
% coord_values are the values corresponding to the xy_coord_pairs matrix,
% where columns in coord_values correspond to rows in xy_coord_pairs
% columns can be column vectors of tthe same length
%
% coord_values = [ V1, V2, V3, ... , VN]
%
% query_coord is the coordinates at which values will be interpolated
% and is a row vector with x and y as shown below
%
% query_coord = [x, y]
%
% Barnes Interpolation parameters are preset in the function
% gamma is constrained between 0.2 and 1.0
% del_n is calculated from the xy_coord_pairs, taking the median between 
% the average nearest neighbor distance of the xy_coord_pairs (del_n_c) and
% the average square data spacing of the given area (del_n_r)

gamma = 0.2;

del_n_c = 0;
m = size(xy_coord_pairs,1);

for x = 1:m
    d = sqrt((xy_coord_pairs(:,1) - xy_coord_pairs(x,1)).^2 + (xy_coord_pairs(:,2) - xy_coord_pairs(x,2)).^2);
    d = sort(d);
    del_n_c = del_n_c + d(2)/m;
end

A = (max(xy_coord_pairs(:,1)) - min(xy_coord_pairs(:,1)))*(max(xy_coord_pairs(:,2)) - min(xy_coord_pairs(:,2)));

del_n_r = (A^(1/2))*((1+m^(1/2))/(m-1));

del_n = (del_n_r - del_n_c)/2 + del_n_c;

D = sqrt((query_coord(1) - xy_coord_pairs(:,1)).^2 + (query_coord(2) - xy_coord_pairs(:,2)).^2);

k = 5.052.*(2*del_n/pi).^2;

weight = exp(-(D.^2)/k);

g0 = sum(coord_values.*weight.',2)/sum(weight);

new_vals = g0 + sum((coord_values - g0).*(exp(-(D.^2)/(gamma*k))).',2);

end


