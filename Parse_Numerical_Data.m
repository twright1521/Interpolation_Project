function data = Parse_Numerical_Data(file_name_str)

% This function parses the data in a text file into an array of numbers
% Any text is not copied into the array

% Outputs the entire data array

fid = fopen(file_name_str);   
c = textscan(fid,'%s','delimiter','\n');
fclose(fid);
lines = c{1};

data = [];

for x = 1:length(lines)
    if ~isempty(lines{x})
        parsenumbers = textscan(lines{x},'%f');
        numbers = parsenumbers{1};
        if ~isempty(numbers)
            data = [data;numbers.'];
        end
    end
    clearvars parsenumbers numbers
end

end