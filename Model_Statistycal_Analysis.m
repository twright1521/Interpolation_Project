function data_array = Model_Statistycal_Analysis(xy_coord_pairs,coord_values)

% This function statistically analyzes the three interpolation functions
% Bilinear_Interpolation, Inverse_Distance_Weighting, and Barnes_Interpolation
% through the leave-one-out cross-validation method. Due to the nature of
% bilinear interpolation, the corners of the gridset are removed from the
% analysis.
%
% It computes the R-squared and adjusted R-squared values as well as
% calculating the slope and intercept of a linear regression line
%
% It does this for each function individually and each combination of
% functions including all three
%
% So if the functions are designated
%
% A = Bilinear_Interpolation
% B = Inverse_Distance_Weighting
% C = Barnes_Interpolation
%
% The output matrix's rows would be formatted as 
%
% 1 - A
% 2 - B
% 3 - C
% 4 - A & B
% 5 - A & C
% 6 - B & C
% 7 - A, B, & C
%
% Columns are formatted as 
%
% 1 - Function names
% 2 - Matrix of calculated values
% 3 - Matrix of the known values, matches the calculated matrix
% 4 - Matrix of location data for the above two matrices
% 5 - Expected Mean Square Error of training set
%
% Note: columns 3 and 4 will be the same matrices in every row


A = 'Bilinear_Interpolation';
B = 'Inverse_Distance_Weighting';
C = 'Barnes_Interpolation';

% Determining Available Coordinate values
% i.e Removing the gridpoint corners
x_vals = unique(xy_coord_pairs(:,1));
y_vals = unique(xy_coord_pairs(:,2));

X = [min(x_vals),max(x_vals)];
Y = [min(y_vals),max(y_vals)];

quad_loc = [X(1), Y(1); X(1), Y(2); X(2), Y(1); X(2), Y(2)];


for x = 1:4
    for y = 1:size(xy_coord_pairs,1)
        if quad_loc(x,1) == xy_coord_pairs(y,1) && quad_loc(x,2) == xy_coord_pairs(y,2)
            quad_loc(x,3) = y;
            break
        end
    end
end

avail_coord = xy_coord_pairs;
avail_vals = coord_values;

avail_coord(quad_loc(:,3),:) = [];
avail_vals(:,quad_loc(:,3)) = [];

data_array = cell(7,5);

% Looping through each Case
for x = 1:7
    
    test_vals = [];
    
    % Testing each xy coordinate
    for y = 1:size(avail_coord,1)
        
        % Test point
        query_coord = avail_coord(y,:);

        % All other points
        known_coord = avail_coord;
        known_coord(y,:) = [];
        known_coord = [known_coord; xy_coord_pairs(quad_loc(:,3),:)];
        [known_coord,idx] = sortrows(known_coord,[1,2]);
        
        known_vals = avail_vals;
        known_vals(:,y) = [];
        known_vals = [known_vals, coord_values(:,quad_loc(:,3))];
        known_vals = known_vals(:,idx);
        
        switch x
            case 1
                if y == 1
                    data_array{x,1} = A;
                end
                new_vals = Bilinear_Interpolation(known_coord,known_vals,query_coord);
                
            case 2
                if y == 1
                    data_array{x,1} = B;
                end
                new_vals = Inverse_Distance_Weighting(known_coord,known_vals,query_coord,'Inf');
                
            case 3
                if y == 1
                    data_array{x,1} = C;
                end
                new_vals = Barnes_Interpolation(known_coord,known_vals,query_coord);
                
            case 4 
                if y == 1
                    data_array{x,1} = strcat(A,32,'&',32,B);
                end
                vals_1 = Bilinear_Interpolation(known_coord,known_vals,query_coord);
                vals_2 = Inverse_Distance_Weighting(known_coord,known_vals,query_coord,'Inf');
                
                new_vals = mean([vals_1,vals_2],2);
                
            case 5
                if y == 1
                    data_array{x,1} = strcat(A,32,'&',32,C);
                end
                vals_1 = Bilinear_Interpolation(known_coord,known_vals,query_coord);
                vals_2 = Barnes_Interpolation(known_coord,known_vals,query_coord);
                
                new_vals = mean([vals_1,vals_2],2);
                
            case 6
                if y == 1
                    data_array{x,1} = strcat(B,32,'&',32,C);
                end
                vals_1 = Inverse_Distance_Weighting(known_coord,known_vals,query_coord,'Inf');
                vals_2 = Barnes_Interpolation(known_coord,known_vals,query_coord);
                
                new_vals = mean([vals_1,vals_2],2);
                
            case 7
                if y == 1
                    data_array{x,1} = strcat(A,32,'&',32,B,32,'&',32,C);
                end
                vals_1 = Bilinear_Interpolation(known_coord,known_vals,query_coord);
                vals_2 = Inverse_Distance_Weighting(known_coord,known_vals,query_coord,'Inf');
                vals_3 = Barnes_Interpolation(known_coord,known_vals,query_coord);
                
                new_vals = mean([vals_1,vals_2,vals_3],2);
        end
        
        test_vals = [test_vals, new_vals];
        
        clearvars query_coord known_coord known_vals new_vals vals_1 vals_2 vals_3
        
    end
    
    n = size(test_vals,2);
    
    MSE = mean(sum((avail_vals - test_vals).^2,2)/(size(test_vals,2)- 3));

    MSE_exp = MSE*(n-3)/(n+3);
    
    data_array{x,2} = test_vals;
    data_array{x,3} = avail_vals;
    data_array{x,4} = avail_coord;
    data_array{x,5} = MSE_exp;
    
end

end
    
        



