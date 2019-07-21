%% Location Interpolation

% Generates and plots data for a desired latitude and longitude
% within the available grid by interpolating between model gridpoints

% Latitude and Longitude are input in a window prompt
% Prompt will display available Latitude and Longitude Ranges

% Takes annual mean precipitation data 
% Output by "Create_Annual_Mean_Array.m"

clearvars

%% Inputs

% Data Folder
Data_Fol = 'Model Data';

% Model Folder 
Model_Fol = '7.1_ncar_ccsm4_output';  

% File Name - must exclude ".mat"
file_name = 'pr_day_CCSM4_historical_r1i1p1_FULL_NE_ts';

%% Program Start

% Main Directory
Main_Dir = Get_Previous_Directory();

% File Directory
File_Dir = strcat(Main_Dir,filesep,Data_Fol,filesep,Model_Fol);

file_path = strcat(File_Dir,filesep,file_name,'.mat');

% Load Data Array and Take Annual Mean
[val_array, yr_array] = Annual_Mean_Array(file_path, 0.8);
            
% Create a 10 yr Running MEan to remove White Noise
[val_array, yr_array] = Middle_Running_Mean_10_Yr(val_array, yr_array);

% Getting the static file
static_file_path = Get_Static_File(File_Dir);

% Parsing the Static Data for location info
static_data = Parse_Numerical_Data(static_file_path);

static_data = static_data(:,1:2);

% Latitude and Longitude Input Prompt
lon_lat_input = Lat_Lon_Input_Prompt(static_data);

% Calculate new values through Bilinear Interpolation
Bilin_Interp_vals = Bilinear_Interpolation(static_data,val_array,lon_lat_input);

% Calculate new values using Inverse Distance Weighting
Inv_Dist_vals = Inverse_Distance_Weighting(static_data,val_array,lon_lat_input,'Inf');

% Calculate new values using Barnes Interpolation
Barns_Interp_vals = Barnes_Interpolation(static_data,val_array,lon_lat_input);

% Finding the average and Standard Deviation of the three
Val_Mat = [Bilin_Interp_vals, Inv_Dist_vals, Barns_Interp_vals];
Avg_Vals = mean(Val_Mat,2);
St_Dev = std(Val_Mat,0,2);

% Statistical Analysis
data_array = Model_Statistycal_Analysis(static_data,val_array);

% Making the table
temp_mat = data_array(:,5);
row_names = data_array(:,1);
var_names = {'MSE'};

Data_Table = table(temp_mat,'VariableNames',var_names);

Data_Table.Properties.RowNames = row_names;
    
%% Plotting

figure(1)
hold on
plot(yr_array,Bilin_Interp_vals,'b')
plot(yr_array,Inv_Dist_vals,'g')
plot(yr_array,Barns_Interp_vals,'m')
plot(yr_array,Avg_Vals,'r')
title(strcat('Annual Mean Precipitation:',32,num2str(lon_lat_input(2)),32,'N',32,num2str(lon_lat_input(1)),32,'E'))
xlabel('Year')
ylabel('Precipitation - mm')
legend('Bilinear Interpolation','Inverse Distance Weighting','Barnes Interpolation','Average')

figure(2)
hold on
plot(yr_array,Avg_Vals,'r')
plot(yr_array,Avg_Vals + St_Dev,'k--')
plot(yr_array,Avg_Vals - St_Dev,'k--')
title(strcat('Annual Mean Precipitation:',32,num2str(lon_lat_input(2)),32,'N',32,num2str(lon_lat_input(1)),32,'E'))
xlabel('Year')
ylabel('Precipitation - mm')
legend('Average','Standard Deviation')

figure(3)
hold on
plot(yr_array,Avg_Vals,'r')
title(strcat('Annual Mean Precipitation:',32,num2str(lon_lat_input(2)),32,'N',32,num2str(lon_lat_input(1)),32,'E'))
xlabel('Year')
ylabel('Precipitation - mm')
legend('Average')


figure('OuterPosition',[400 700 1000 250])
uitable('Data',Data_Table{:,:},'ColumnName',...
    Data_Table.Properties.VariableNames,'RowName',Data_Table.Properties.RowNames,'Units',...
    'Normalized','Position',[0 0 1 1],'ColumnWidth',{'auto'});


