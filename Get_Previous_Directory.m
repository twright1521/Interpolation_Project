function Prev_Dir = Get_Previous_Directory()

% Returns the directory previous to the current directory

% For example, if the current directory is
% Current_Dir = 'C:/Users/Documents/MATLAB'

% This program will return
% Prev_Dir = 'C:/Users/Documents

Current_Dir = strsplit(pwd, filesep);

Prev_Dir = [];

for x = 1:length(Current_Dir)-1
    if x == 1
        Prev_Dir = Current_Dir{x};
    else
        Prev_Dir = strcat(Prev_Dir,filesep,Current_Dir{x});
    end
end

end