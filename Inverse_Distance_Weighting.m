function new_vals = Inverse_Distance_Weighting(xy_coord_pairs,coord_values,query_coord, varargin)

% Does Inverse Distance Weighting Interpolation for a given point specified by query_vals
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
% The varargin allows for the defining of a radius of allowable points
% The input can be a number, whic will be assigned as the radius or the
% string 'Inf' which allows all points in the data set to be counted. 
% If there is no input into varargin, the radius is set at the mean distance
% of all the points.

D = sqrt((query_coord(1) - xy_coord_pairs(:,1)).^2 + (query_coord(2) - xy_coord_pairs(:,2)).^2);

if isempty(varargin)
    radius = mean(D);
else
    if strcmp(varargin{1}, 'Inf')
        radius = max(D);
    else
        radius = varargin{1};
    end
end

if radius >= max(D)
    numer = sum(coord_values./D.',2);
    denom = sum(1./D);
else
    idx = find(D <= radius);
    D = D(idx);
    coord_values = coord_values(:,idx);
    
    numer = sum(coord_values./D.',2);
    denom = sum(1./D);
end

new_vals = numer./denom;

end
    
     