function [avg_array, new_yrs] = Middle_Running_Mean_10_Yr(val_array, yr_vector)

% This function calculates the 10-yr Middle Runninng Mean
% for the data in val_array that corresponds to the yr_vector
%
% val_array is an array where each row represents a year and each column
% represents a set of data.
%
% yr_vector must be the same length as the number of rows in val_array

avg_array = [];

for x = yr_vector(6):yr_vector(end-4)

    yr_idx = find(yr_vector == x);
    temp_array = [];

    for y = yr_idx-5:yr_idx+4
        vals = val_array(y,:);
        temp_array = [temp_array; vals];
    end

    test_nan = ~isnan(temp_array);

    for z = 1:size(test_nan,2)
        sum_test_nan = sum(test_nan(:,z));
        if (sum_test_nan >= 7)
            temp_avg_array(1,z) = mean(temp_array(:,z),'omitnan');
        else
            temp_avg_array(1,z) = NaN;
        end
        clearvars sum_test_nan
    end

    % Array of the mean values
    avg_array = [avg_array; temp_avg_array];

    clearvars temp_array temp_avg_array test_nan
end

new_yrs = yr_vector(6:end-4);

end
