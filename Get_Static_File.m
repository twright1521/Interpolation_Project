function static_file_path = Get_Static_File(file_dir)

% file_dir - the full directory name in which the data file and its
% static.txt file should be

dir_contents = dir(file_dir);

for x = 1:length(dir_contents)
    name_test = dir_contents(x).name;
    name_test = strsplit(name_test, '_');
    if strcmp(name_test{end}, 'static.txt')
        static_file = dir_contents(x).name;
        break
    end
end

static_file_path = strcat(file_dir,filesep,static_file);

end