function config = SetRealTimeMode(BCI)
config = 0;
% for tcp/ip connection
prompt = {'# Port : ', 'IP address : '};
definput = {'1668' '127.0.0.1'};
dlgtitle = '';
dims = [1 35];
answer = inputdlg(prompt, dlgtitle, dims,definput);
if ~isempty(answer)
    BCI.tcpip.port = str2num(answer{1});
    BCI.tcpip.address = answer{2};
else
    return;
end

config = 1;
% tcpsender
filename = fullfile(pwd, 'stimulus\server\exe\QtHue_v1.exe');
command = ['start ', filename];
system(command);

pause(5);



