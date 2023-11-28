function PushedButtons(src, evnt, BCI, buttontype)
switch buttontype
    case 'set'
        tmp = uigetdir('C:W', 'set path');

        if ischar(tmp)
            BCI.PATH = tmp;
            msg = {BCI.PATH;...
                repmat('-',1,100);...
                'Please insert EEG device and Subject information (Click the "Setting" Button)'};

        else
            msg = {'Cancel to set path!'};
        end
        msg  = MsgBoxManager(msg);
        notify(BCI, 'UpdatingMsg',msg);

    case 'setting'
        if isempty(BCI.PATH)
            msg = {'You need to click "Set" button!'};
            msg  = MsgBoxManager(msg);
            notify(BCI, 'UpdatingMsg',msg);
            return;
        end
        [config] = PushedSetting(BCI);   
        
        if BCI.decoderInfo.IsSetting && config
            msg = {'You set';...
                ['Subject ID : ' BCI.subjname];...
                % ['Sample Rate (Hz) :' num2str(BCI.param.Fs)];...
                ['ISI conditions: ' BCI.param.ISI{1} ' / ' BCI.param.ISI{2}];...
                ['Number of trial repetition : ' num2str(BCI.param.Numiter)];...
                ['Reference channel you selected is ' num2str(BCI.param.ref)]
                ['Your number of training blocks is ' num2str(BCI.param.NumTrainBlock)];...
                repmat('-',1,100);...
                ['Now you are in ' BCI.decoderState];...}
                'Please select the Mode (Virtual or Real)'};
            msg  = MsgBoxManager(msg);
            notify(BCI, 'UpdatingMsg',msg);
        end

    case 'mode'
        BCI.decoderInfo.mode = src.Value;  

        if strcmp(BCI.decoderInfo.mode,'Real')
            [config] = SetRealTimeMode(BCI);           
        elseif strcmp(BCI.decoderInfo.mode,'Virtual')
            config = 1;
        else
            config = 0;
            return;
        end

        if ~strcmp(BCI.decoderInfo.mode, '')
            if config
                msg = {['You select mode as ' BCI.decoderInfo.mode];...
                    ['IP address is : ' BCI.tcpip.address];...
                    ['Port # : ' num2str(BCI.tcpip.port)];...
                    repmat('-',1,100);...
                    'Please click the "Connect" button'};
                msg  = MsgBoxManager(msg);
                notify(BCI, 'UpdatingMsg',msg);    
            else
                BCI.decoderInfo.mode = '';        
                hmat = findobj(BCI.uiObj,'Position',[320 130 120 40]);
                set(hmat, 'Value','');
    
                msg = {'Failed to select mode...! Please try again.'};
                msg = MsgBoxManager(msg);
                notify(BCI, 'UpdatingMsg',msg);
            end
        end


    case 'con'
        if BCI.decoderInfo.IsSetting
            TMP = BCI;
            switch src.Text
                case 'Connect'
                    [config] = Connect2Device(BCI);
    
                    % which home appliance you want to control?
                    list = {'aircon' 'light' 'doorlock' 'music player' 'blind' 'fan' 'styler'};
                    prompt = {'Select home appliance to control.'};
                    [idx, tf] = listdlg('ListString',list, 'SelectionMode','single',...
                        'OKString','OK',...
                        'CancelString','Cancel',...
                        'PromptString',prompt,...
                        'ListSize',[160 80]);
                    
                    if tf
                        BCI.decoderInfo.whichCon = list{idx};
                    else
                        BCI = TMP;
                    end

                    if config 
                        BCI.decoderInfo.IsConnected = true;

                        prompt = {'\fontsize{10}\fontname{Helvetica} Sampling Rate:',...
                            '\fontsize{10}\fontname{Helvetica} #Channel:'};
                        dlgtitle = 'options';
                        dims = [1 35];
                        definput = {'500', '32'};
                        opts.Interpreter = 'tex';
                        opts.Resize = 'off';
                        opts.WindowStyle = 'modal';
                    
                    answer = inputdlg(prompt, dlgtitle, dims, definput,opts);
                            BCI.param.Fs = str2num(answer{1});
                            BCI.param.NumCh = str2num(answer{2});
                            BCI.param.Ch = string(num2str([1:BCI.param.NumCh]'))'
                            BCI.param.Ch{BCI.param.ref} = [];
                            BCI.param.Ch = BCI.param.Ch(~cellfun('isempty',BCI.param.Ch));
                    else
                        msg = {'Failed to connect to device!'};
                    end

                if BCI.decoderInfo.IsConnected
                    set(src, 'Text', 'Disconnect');
                    set(src, 'FontColor','r');
                    set(src, 'BackgroundColor','w');

                    msg = {'Success to connect!';...
                        repmat('-',1,100);...
                        ['Sample Rate (Hz) :' num2str(BCI.param.Fs)];...
                        ['Number of channel your device :' num2str(BCI.param.NumCh)];...
                        ['Control home appliance : ' BCI.decoderInfo.whichCon];...
                        repmat('-',1,100);...
                        'Now you may start. Please click the "Start" button!. Enjoy :)'};
                end

            case 'Disconnect'
                BCI.decoderInfo.IsConnected = false;
                BCI.decoderInfo.whichCon = [];

                set(src, 'Text', 'Connect');
                set(src, 'FontColor','w');
                set(src, 'BackgroundColor',[.15 .15 .18]);

                msg = {'Disconnected to device...!'};
        
            end
        else
            msg = {'You need to click setting! '};
        end
        msg  = MsgBoxManager(msg);
        notify(BCI, 'UpdatingMsg',msg);    
        
    case 'start'
        PushedStart(BCI);

    case 'save'
        PushedSave(BCI);
        
    case 'help'
        prompt = {'Step 1 : Set Path, select the folder where you want to save.';...
            'Step 2 : Setting, to get subject information, please give a subject name and sampling rate.';...
            'If you want to use the existing dataset, click the "load", then you can start to control!';...
            'Step 3 : Mode, you need to select virtual or real mode (virtual mode gives result as a figure)';...
            'Step 4 : Click "Connect"';...
            'Step 5 : Click "Start" if you want to start a new block.';...
            'Step 6 : Save, If you want to save data during the testing session, click this button!';...
            'If you don"t want to, just start a new block by clicking the "Start".';...
            'Step 7 : Repeat the step 5-6.';...
            '';...
            'During the training session, the dataset would be saved automatically!';...
            'And if you want to click "Save" during the training session, it will save the "param" (it needs for loading the data.)'};
        helpdlg(prompt,'Help');

end
end