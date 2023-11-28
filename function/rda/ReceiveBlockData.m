function [data,trig] = ReceiveBlockData(BCI)
lib = lsl_loadlib();
% inlet open
stream = lsl_inlet(BCI.inlet);

% step 2-2 : open stimulus
filename = fullfile(pwd, 'stimulus\singleshot_stimulus\singleshot_stimulus.exe');
command = ['start ', filename];
system(command);

% trigger
tmp = []; tStart = tic;
while isempty(tmp)
    tmp = lsl_resolve_byprop(lib,'name','BioSemi');
    if toc(tStart) > 5
        error('Not found the marker stream!');
    end
end
marker = lsl_inlet(tmp{1});

marker.open_stream();
stream.open_stream();


delay = 1e-3*(str2num(BCI.param.ISI{1}) + str2num(BCI.param.ISI{2})) * BCI.param.NumCondi * BCI.param.Numiter + 7;
data = [];
config = 0;
[dat] = stream.pull_chunk();
[mkr] = marker.pull_chunk();
tStart = tic;
while 1
    [dat] = stream.pull_chunk();
    [mkr] = marker.pull_chunk();
    data = cat(2,data,dat);

    if ~isempty(mkr)
        trig(1,size(data,2)) = mkr;
    end

    if toc(tStart) > delay
        break;
    end
end


stream.close_stream();
marker.close_stream();

% subtract reference channel
len = size(find(trig),2);
% data = data(:,end-len+1:end);

data = data - data(BCI.param.ref,:);
data = data(1:BCI.param.NumCh,:);
data(BCI.param.ref,:) = []; 
end
