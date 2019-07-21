function [avg_array, yr_array] = Annual_Mean_Array(file_path, percent_of_year)

% file_path is the path for the file including the file name
% File must be a .mat matrix file

% percent_of_year = [0 : 1]
% the number of data points required per year to compute
% an average for that year. If the number of data points is less than this
% number, the average is saved as a NaN value.
% This is a number between zero and one, where one is 100% and zero is 0%

array = struct2cell(load(file_path));
array = array{1};

m = size(array,1);

% Vecter of each year in data array 
a = array(2:end,1);

[temp_yr_array,m1,~] = unique(a,'first');
[~,d1] = sort(m1);
yr_array = temp_yr_array(d1);

clearvars a m1 d1 temp_yr_array

% Calculate Annual Average for each location
y = 2;
avg_array = [];

for x = 1:length(yr_array)

    val_array = [];

    while (str2double(array{y,1}) == str2double(yr_array{x}))
        vals = str2double(array(y,6:end));
        val_array = [val_array; vals];

        clearvars vals
        if (y == m)
            break
        else
            y = y + 1;
        end

    end

    % Tests for completeness of data
    % Only accepts years with percent_of_year usable data
    test_nan = ~isnan(val_array);

    for z = 1:size(test_nan,2)
        sum_test_nan = sum(test_nan(:,z));
        if (sum_test_nan >= percent_of_year*365) % Determines the amount of days with data required
            temp_avg_array(1,z) = mean(val_array(:,z),'omitnan');
        else
            temp_avg_array(1,z) = NaN;
        end
        clearvars sum_test_nan
    end

    avg_array = [avg_array; temp_avg_array];

    clearvars val_array temp_avg_array  test_nan
end

yr_array = str2double(yr_array);

end