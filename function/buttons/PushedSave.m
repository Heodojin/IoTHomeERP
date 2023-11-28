function PushedSave(BCI)
global sig_vec
global trigger
config = 0;
if isempty(BCI.PATH)
    msg = {'Set your path!', 'If you need help, click the "Help" button.'};
elseif ~BCI.decoderInfo.IsSetting
    msg = {'Check your setting!', 'If you need help, click the "Help" button.'};
else
    config = 1;
end

if config
    % save online decoder
    param = BCI.param;
    save(fullfile(BCI.PATH, BCI.subjname,'param.mat'),'param');
    
    msg = {'Saved RealTime BCI options as name of "param.mat."'};
    
    if ~isempty(sig_vec) || ~isempty(trigger)
        if strcmp(BCI.decoderState,'testing')
            filename = [BCI.subjname, '_' BCI.decoderState, num2str(BCI.decoderInfo.iBlock,'%02d')];
            save(fullfile(BCI.PATH,BCI.subjname,filename), 'sig_vec', 'trigger');
            msg{end+1} = 'Saved data...!';

            BCI.decoderInfo.iBlock = BCI.decoderInfo.iBlock + 1;    

            sig_vec = [];
            trigger = [];
        end
    else
        msg{end+1} = 'You need to start a new block!';
    end
end
msg = MsgBoxManager(msg);
notify(BCI, 'UpdatingMsg',msg);  
end
  

