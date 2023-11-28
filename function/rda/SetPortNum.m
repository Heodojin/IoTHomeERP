function [config] = SetPortNum()
config = 0;

prompt = {'Parallel Port (Check in the "Device Manager"): '};
dlgtitle = '';
dims = [1 35];
answer = inputdlg(prompt, dlgtitle, dims);
if ~isempty(answer)
    % stimulus setting
    lines  = readlines('stimulus\singleshot_stimulus\setting\setting.txt');
    tmp = split(lines(3),'"');
    lines(3) = replace(lines(3), tmp(4), answer{:});
    writelines(lines,'stimulus\singleshot_stimulus\setting\setting.txt');

else
    return;
end

config = 1;

end