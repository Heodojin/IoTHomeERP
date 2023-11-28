function PushedStart(BCI)
config = 0;
if isempty(BCI.PATH)
    msg = {'Set your path!', 'If you need help, click the "Help" button.'};
elseif ~BCI.decoderInfo.IsSetting
    msg = {'Check your setting!', 'If you need help, click the "Help" button.'};
elseif strcmp(BCI.decoderInfo.mode,'')
    msg = {'Check your mode!', 'If you need help, click the "Help" button.'};
elseif ~BCI.decoderInfo.IsConnected 
    msg = {'Please connect with device!', 'If you need help, click the "Help" button.'};
else
    config = 1;
end


if config
    % stimulus image setting
    SetStimImage(BCI.decoderState, BCI.decoderInfo.whichCon);

    % step2. decoderState?
    switch BCI.decoderState
        case 'training'
            % Step1. 기본적인 셋팅 체크
            if BCI.param.asr.do
                notify(BCI, 'CalibrationOn');
                BCI.param.asr.do = false;
            end
            RealTimeBCI_DecoderTrain(BCI);
            
        case 'testing'
            RealTimeBCI_DecoderTest(BCI);
    end
else
    msg  = MsgBoxManager(msg);
    notify(BCI, 'UpdatingMsg',msg);    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SetStimImage(decoderstate, whichCon)
lines  = readlines('stimulus\singleshot_stimulus\testlist\example.txt');
whichline = [38,39; 47,48; 56,57; 65,66];

switch decoderstate
    case 'training'
        stimImg = repmat({'new.png', 'on.png'},4,1);

    case 'testing'
        tmp = {'1A' '1B'; '2A' '2B'; '3A' '3B'; '4A' '4B'};
        stimImg = cellfun(@(S)strcat(whichCon, [S '.png']), tmp, 'UniformOutput', false);
end

for i = 1:size(whichline,1)
    for j = 1:size(whichline,2)
        tmp = split(lines(whichline(i,j)), '"');
        lines(whichline(i,j)) = replace(lines(whichline(i,j)), tmp(4), stimImg{i,j});
    end
end
writelines(lines,'stimulus\singleshot_stimulus\testlist\example.txt');
end



