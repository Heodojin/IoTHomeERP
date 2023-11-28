function [ config ] = PushedSetting(BCI)
config = 0;
TMP = BCI;
BCI.param = RealTimeBCI__INIT__;

prompt = {'\fontsize{10}\fontname{Helvetica} Subject ID:',...
    '\fontsize{10}\fontname{Helvetica} Inter-stimulus interval (msec):',...
    '\fontsize{10}\fontname{Helvetica} Highlight interval (msec):',...
    '\fontsize{10}\fontname{Helvetica} Trial repetition: ',...
    '\fontsize{10}\fontname{Helvetica} Reference channel (#):'};

dlgtitle = 'options';
dims = [1 35];
definput = {'noname', '66' '66' '10' '24'};
opts.Interpreter = 'tex';
opts.Resize = 'off';
opts.WindowStyle = 'modal';

answer = inputdlg(prompt, dlgtitle, dims, definput,opts);

if ~isempty(answer)
    BCI.subjname = answer{1};
    % make path
    mkdir(fullfile(BCI.PATH, BCI.subjname));
    % initializing decoder parameter
    BCI.param.ISI = {answer{2} answer{3}};
    BCI.param.Numiter = str2num(answer{4});
    BCI.param.ref = str2num(answer{5});
else
    BCI = TMP;
    return;
end

[config] = loadORnew(BCI);
if config 
    tmp{1} = BCI.param.ISI{1};
    tmp{2} = BCI.param.ISI{2};
    tmp{3} = num2str(BCI.param.Numiter);

    writeStimulusOpt(tmp);

    BCI.decoderInfo.IsSetting = true;
else
    BCI = TMP;
    msg = {'Failed to setting!'};
    msg  = MsgBoxManager(msg);
    notify(BCI, 'UpdatingMsg',msg); 
end
end
% -------------------------------------------------------------------------
function [config] = loadORnew(BCI)
config = 0;
while 1
txt = 'Choose whether you load a train data set or get new.';
title = '';
answer = questdlg(txt, title, 'LOAD', 'NEW', 'CANCEL');
switch answer
    case 'LOAD'
        [config] = PushedLoad(BCI);
    case 'NEW'
        [config] = PushedNew(BCI);  
    otherwise 
          config = 0;
        break;
end
% repeat until correct choose.
if config
    break;
end
end
end
% -------------------------------------------------------------------------
function [config] = PushedLoad(BCI)
config = 0;
try
    [PATH] = uigetdir;

    PARAM = dir(fullfile(PATH, 'param.mat'));
    F = dir(fullfile(PATH, '*training*.mat'));

    if isempty(PARAM)
        error('PushedLoad:NoParamFile','File not found.');
    end

    if isempty(F)
        error('PushedLoad:NoMatFile','File not found.');
    end
    
catch ME
    switch ME.identifier
        case 'PushedLoad:NoParamFile'
            f = errordlg('Not found *param* file for training!',...
                'WindowStyle','modal');
        case 'PushedLoad:NoMatFile'
            f = errordlg('Not found mat file for training!',...
                'WindowStyle','modal');
    end
    uiwait(f);
    return;
end
config = 1;

load(fullfile(PARAM.folder, PARAM.name));
BCI.param = param;
BCI.decoderState = 'training';
BCI.param.asr.do = true;
evtdata.PATH = {F(1:param.NumTrainBlock).folder};
evtdata.FILE = {F(1:param.NumTrainBlock).name};
evtdata = TrainEventData(evtdata);
notify(BCI, 'DecoderTraingOn', evtdata)
end
% -------------------------------------------------------------------------
function [config] = PushedNew(BCI)
config = 0;
output = questdlg("Are you sure to get newly?",'',...
    'Yes', 'No', 'No');

if strcmp(output, 'Yes')
    prompt = 'Number of training Block';
    dlgtitle = 'New';
    dims = [1 38];
    definput = {'40'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);  

    if ~isempty(answer)
        BCI.param.NumTrainBlock = str2num(answer{1});
        BCI.decoderState = 'training';
        BCI.decoderInfo.iBlock = 0; % reset
    end

    % notify(BCI, 'CalibrationOn');
    config = 1;
end
end

function writeStimulusOpt(opts)
lines  = readlines('stimulus\singleshot_stimulus\testlist\example.txt');
whichline = [4,5,7];
pat = digitsPattern;
for i = 1:size(whichline,2)
    aline = whichline(i);
    lines(aline) = replace(lines(aline),extract(lines(aline),pat), opts{i});
end

writelines(lines,'stimulus\singleshot_stimulus\testlist\example.txt');
end
