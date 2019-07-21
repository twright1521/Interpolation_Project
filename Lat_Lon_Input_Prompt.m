function lon_lat_input = Lat_Lon_Input_Prompt(lon_lat_data)

% Finds the max and min values of Latitude and Longitude from an array of
% latitude and longitude pairs.
%
% Then displays a dialogue box prompting a latitude and longitude input
% within the max and min values for each.
%
% If the input is outside these bounds the dialogue box is displayed again,
% describing the error, and requesting input again


% Determining Maximum Longitude and Latitude
lon = unique(lon_lat_data(:,1));
lat = unique(lon_lat_data(:,2));

max_lon = max(lon);
max_lat = max(lat);

min_lon = min(lon);
min_lat = min(lat);

% Latitude and Longitude Input Prompt
prompt{1} = sprintf('Enter Desired Longitude:\nMust be in Range:\n %g E to %g E\n',...
                    min_lon, max_lon);
                
prompt{2} = sprintf('Enter Desired Latitude:\nMust be in Range:\n %g N to %g N\n',...
                    min_lat, max_lat);

title_str = 'Input';
dims = [1 30];
lon_lat_input = str2double(inputdlg(prompt,title_str,dims));

% Error if inputs are not within bounds

error_flag = true;

while(error_flag == true)
    
    error_flag = false;
    error_num = 1;
    
    if lon_lat_input(1) > max_lon
        error_prompt{1} = sprintf('Longitude exceeds upper limit\n');
        error_flag = true;
    else
        if lon_lat_input(1) < min_lon
             error_prompt{1} = sprintf('Longitude exceeds lower limit\n');
             error_flag = true;
        else
            error_prompt{1} = '';
        end
    end
    
    if lon_lat_input(2) > max_lat
        error_prompt{2} = sprintf('Latitude exceeds upper limit\n');
        error_flag = true;
    else
        if lon_lat_input(2) < min_lat
            error_prompt{2} = sprintf('Latitude exceeds lower limit\n');
            error_flag = true;
        else
            error_prompt{2} = '';
        end
    end

    

    if error_flag == true
        new_prompt = {sprintf('%s%s',error_prompt{1},prompt{1}),sprintf('%s%s',error_prompt{2},prompt{2})};
        lon_lat_input = str2double(inputdlg(new_prompt,title_str,dims));
    end
    
    clearvars error_prompt error_num
end

end
