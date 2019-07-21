function new_vals = Bilinear_Interpolation(xy_coord_pairs,coord_values,query_coord)

% Does Bilinear Interpolation for a given point specified by query_vals
% Given xy_ccord_pairs as a matrix of gridpoints, with x_values in the
% first column and y_values in the second column. 
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

x_vals = unique(xy_coord_pairs(:,1));
y_vals = unique(xy_coord_pairs(:,2));

% Determine surrounding gridpoint locations
near_x = abs(x_vals - query_coord(1));
near_y = abs(y_vals - query_coord(2));

[~, x_idx] = sort(near_x);
[~, y_idx] = sort(near_y);

X = sort(x_vals(x_idx(1:2)));
Y = sort(y_vals(y_idx(1:2)));

quad_loc = [X(1), Y(1); X(1), Y(2); X(2), Y(1); X(2), Y(2)];

% Get indices for these grid locations
for x = 1:4
    for y = 1:size(xy_coord_pairs,1)
        if quad_loc(x,1) == xy_coord_pairs(y,1) && quad_loc(x,2) == xy_coord_pairs(y,2)
            quad_loc(x,3) = y;
            break
        end
    end
end

% Double check indices
x = 1;
while x <= 4
    for y = 1:size(xy_coord_pairs,1)
        if quad_loc(x,1) == xy_coord_pairs(y,1) && quad_loc(x,2) == xy_coord_pairs(y,2)
            quad_loc(x,3) = y;
            break
        end
    end
    
    % Increasing square size if vertex not found in data
    if quad_loc(x,3) == 0
        
        if quad_loc(x,1) == max(x_vals) %Right edge - change y-vals
            if x == 3       %down
                quad_loc(x,2) = y_vals(find(y_vals == quad_loc(1,2)) - 1);
                quad_loc(1,2) = y_vals(find(y_vals == quad_loc(1,2)) - 1);
                
                x = 0;
            else
                if x == 4   %up
                    quad_loc(x,2) = y_vals(find(y_vals == quad_loc(2,2)) + 1);
                    quad_loc(2,2) = y_vals(find(y_vals == quad_loc(2,2)) + 1);
                    
                    x = 0;
                end
            end
        else
            if quad_loc(x,1) == min(x_vals) %Left edge - change y-vals
                if x == 1       %down
                    quad_loc(x,2) = y_vals(find(y_vals == quad_loc(3,2)) - 1);
                    quad_loc(3,2) = y_vals(find(y_vals == quad_loc(3,2)) - 1);
                    
                    x = 0;
                else
                    if x == 2   %up
                        quad_loc(x,2) = y_vals(find(y_vals == quad_loc(4,2)) + 1);
                        quad_loc(4,2) = y_vals(find(y_vals == quad_loc(4,2)) + 1);
                        
                        x = 0;
                    end
                end
            else
                if quad_loc(x,2) == max(y_vals) %Top edge - change x-vals
                    if x == 2       %Left
                        quad_loc(x,1) = x_vals(find(x_vals == quad_loc(1,1)) - 1);
                        quad_loc(1,1) = x_vals(find(x_vals == quad_loc(1,1)) - 1);
                        
                        x = 0;
                    else
                        if x == 4   %Right
                            quad_loc(x,1) = x_vals(find(x_vals == quad_loc(3,1)) + 1);
                            quad_loc(3,1) = x_vals(find(x_vals == quad_loc(3,1)) + 1);
                            
                            x = 0;
                        end
                    end
                else
                    if quad_loc(x,2) == min(y_vals) %Bottom edge - change x-vals
                        if x == 1   %Left
                            quad_loc(x,1) = x_vals(find(x_vals == quad_loc(2,1)) - 1);
                            quad_loc(2,1) = x_vals(find(x_vals == quad_loc(2,1)) - 1);
                            
                            x = 0;
                        else
                            if x == 3 %Right
                                quad_loc(x,1) = x_vals(find(x_vals == quad_loc(4,1)) + 1);
                                quad_loc(4,1) = x_vals(find(x_vals == quad_loc(4,1)) + 1);
                                
                                x = 0;
                            end
                        end
                    else        %This else determines that the value is not on the edge of the grid
                        switch x  % This determines what quadrant the value is in and thus how the box is expanded
                            case 1
                                quad_loc(x,1) = x_vals(find(x_vals == quad_loc(2,1)) - 1);
                                quad_loc(2,1) = x_vals(find(x_vals == quad_loc(2,1)) - 1);
                                
                                x = 0;
                            case 2
                                quad_loc(x,1) = x_vals(find(x_vals == quad_loc(1,1)) - 1);
                                quad_loc(1,1) = x_vals(find(x_vals == quad_loc(1,1)) - 1);
                                
                                x = 0;
                            case 3
                                quad_loc(x,1) = x_vals(find(x_vals == quad_loc(4,1)) + 1);
                                quad_loc(4,1) = x_vals(find(x_vals == quad_loc(4,1)) + 1);
                                
                                x = 0;
                            case 4
                                quad_loc(x,1) = x_vals(find(x_vals == quad_loc(3,1)) + 1);
                                quad_loc(3,1) = x_vals(find(x_vals == quad_loc(3,1)) + 1);
                                
                                x = 0;
                        end
                    end
                end
            end
        end
     end
                
    x = x + 1;
end

% quad_loc = sortrows(quad_loc,[1,2]);

% Get data for each grid location
V = coord_values(:,quad_loc(:,3));


% Bilinear Interpolation
a0 = (V(:,1).*X(2).*Y(2))./((X(1)-X(2))*(Y(1)-Y(2))) + (V(:,2).*X(2).*Y(1))./((X(1)-X(2))*(Y(2)-Y(1)))...
        + (V(:,3).*X(1).*Y(2))./((X(1)-X(2))*(Y(2)-Y(1))) + (V(:,4).*X(1).*Y(1))./((X(1)-X(2))*(Y(1)-Y(2)));

a1 = (V(:,1).*Y(2))./((X(1)-X(2))*(Y(2)-Y(1))) + (V(:,2).*Y(1))./((X(1)-X(2))*(Y(1)-Y(2)))...
        + (V(:,3).*Y(2))./((X(1)-X(2))*(Y(1)-Y(2))) + (V(:,4).*Y(1))./((X(1)-X(2))*(Y(2)-Y(1)));

a2 = (V(:,1).*X(2))./((X(1)-X(2))*(Y(2)-Y(1))) + (V(:,2).*X(2))./((X(1)-X(2))*(Y(1)-Y(2)))...
        + (V(:,3).*X(1))./((X(1)-X(2))*(Y(1)-Y(2))) + (V(:,4).*X(1))./((X(1)-X(2))*(Y(2)-Y(1)));

a3 = V(:,1)./((X(1)-X(2))*(Y(1)-Y(2))) + V(:,2)./((X(1)-X(2))*(Y(2)-Y(1)))...
        + V(:,3)./((X(1)-X(2))*(Y(2)-Y(1))) + V(:,4)./((X(1)-X(2))*(Y(1)-Y(2)));

new_vals = a0 + a1.*query_coord(1) + a2.*query_coord(2) + a3.*query_coord(1).*query_coord(2);

end