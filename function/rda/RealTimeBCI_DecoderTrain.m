function RealTimeBCI_DecoderTrain(BCI)
CheckFinTrain(BCI)
% block counting
BCI.decoderInfo.iBlock = BCI.decoderInfo.iBlock + 1;

try
% step 2-1 : target indicating
notify(BCI, 'DisplayTarget');
% step 2-2 : get data
[sig_vec, trigger] = ReceiveBlockData(BCI);
catch ME
    BCI.decoderInfo.iBlock = BCI.decoderInfo.iBlock - 1;
    errordlg({ME.identifier; ME.message});
    return;
end

% step 2-3 : save data
filename = [BCI.subjname, '_' BCI.decoderState, num2str(BCI.decoderInfo.iBlock,'%02d')];
save(fullfile(BCI.PATH,BCI.subjname,filename), 'sig_vec', 'trigger');

% step 2-4 : notify block
msg = {[BCI.decoderState ' | #Block : ' num2str(BCI.decoderInfo.iBlock,'%02d')]};
msg  = MsgBoxManager(msg);
notify(BCI, 'UpdatingMsg',msg);

% step 2-4 : check fin training
CheckFinTrain(BCI)
end

function CheckFinTrain(BCI)
if BCI.decoderInfo.iBlock == BCI.param.NumTrainBlock   
    DIR = dir(fullfile(BCI.PATH, BCI.subjname, '*training*.mat'));
    evnt.FILE = {DIR(1:BCI.param.NumTrainBlock).name};
    evnt.PATH = {DIR(1:BCI.param.NumTrainBlock).folder};

    evnt = TrainEventData(evnt);
    notify(BCI, 'DecoderTraingOn',evnt);

    msg = {'...training is done!'};
    msg  = MsgBoxManager(msg);
    notify(BCI, 'UpdatingMsg',msg);

    return;
end
end