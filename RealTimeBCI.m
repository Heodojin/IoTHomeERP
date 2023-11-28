classdef RealTimeBCI < handle
    properties (Access = ?MsgBoxManager)
        msgbox = [];
    end

    properties (SetAccess = public)
        PATH
        subjname
        param
        decoderState
        decoderInfo
        decoder
        inlet
        marker
        tcpip
    end


    properties (SetAccess = private)
        uiObj
    end

    properties (Transient)
    end

    events
        % any event want to catch?
        % please define i the listener
        CalibrationOn
        DisplayTarget
        DecoderTraingOn
        UpdatingMsg
    end
% ------------------------------------------------------------------------
methods (Access = public)
    function obj = RealTimeBCI() % init
        addlistener(obj,'CalibrationOn',@(src,evnt)calibrating(src,evnt));
        addlistener(obj,'DisplayTarget',@(src,evnt)whatIsYourTarget(src,evnt));
        addlistener(obj,'DecoderTraingOn',@(src,evnt)trainingDecoder(src,evnt));
        addlistener(obj,'UpdatingMsg',@(src,evnt)MsgBoxManager.whatIsMsgToSend(src,evnt));
        
        obj = InitDecoderInfo(obj);

        obj.uiObj = CreateBackground(obj);
        MsgBoxManager.CreatemessageBox(obj);
        
        % setting stimulus windowstate
        DefWindowSize2Stimulus();
    end
end

methods (Access = private)       
    function calibrating(obj,evnt)
        t = 60; %sec
        wb = waitbar(0,...
            {'Now decoder need to get your rest brain state.',...
            'It takes 1min. Please do not move!', '0s'},...;
            'WindowStyle','modal');

        % open
        inlet = lsl_inlet(obj.inlet);
        inlet.open_stream();

        cal_sig = [];
        tStart = tic;
        while 1
            pause(1);
            % device와 connect 되었는지 확인 필요
            [chunk] = inlet.pull_chunk();
            cal_sig = cat(2,cal_sig, chunk);

            tCount = toc(tStart);
            if tCount > t
                wb = waitbar(1, wb, ...
                    {'Almost done. Wait...!'},...
                    'WindowStyle','modal');
                break;
            end

            wb = waitbar(tCount/t,wb,...
                {'Now decoder need to get your rest brain state.', ...
                'It takes 1min. Please do not move!',...
                [num2str(floor(tCount)) ' s']},...
                'WindowStyle','modal');
            if isempty(chunk)
                break;
            end
        end

        % subtract reference
        cal_sig = cal_sig(1:obj.param.NumCh,:);
        cal_sig =  cal_sig - cal_sig(obj.param.ref,:);
        cal_sig(obj.param.ref,:) = [];

        % obj.param = preASR(cal_sig,obj.param);
        save(fullfile(obj.PATH, obj.subjname, 'cal_sig.mat'),'cal_sig','-mat');

        close(wb);
    end

    function whatIsYourTarget(obj, evnt)
        if isempty(obj.param.target)
            psuedo = psuedoRandomGenerater(obj.param.NumTrainBlock,[1:4]);
            obj.param.target = psuedo;
        end

        fh = uifigure('NumberTitle','off',...
            'ToolBar','none',...
             'units','pixels',...
             'position', floor([obj.uiObj.Position(3)/2 obj.uiObj.Position(4)/2 472 354]),...
             'menubar','none',...
             'resize','off',...
             'Visible','off');

        figPos = fh.Position;

        bg = uiimage(fh);
        bg.Position = [0 0 figPos(3) figPos(4)];
        t = obj.param.target(obj.decoderInfo.iBlock);
        bg.ImageSource = imread(['img\' num2str(t) '.png']);

        set(fh,'Visible','on');
        pause(2);

        delete(fh);
    end


    function [obj] = trainingDecoder(obj,evnt)    
        global cal_sig
        PATH = evnt.PATH;
        FILE = evnt.FILE;
        % get decoder
        wb = waitbar(0, 'Please wait...','WindowStyle','modal');
        wb = waitbar(0.01, wb, 'Load data...');

        [sig, trig] = LoadData(FILE,PATH,obj);
        assert(obj.param.NumTrainBlock == size(FILE,2));
        load(fullfile(PATH{1}, 'cal_sig.mat'));
        
        wb = waitbar(0.05, wb, 'Preprocessing...');
        [sig, obj] = RealTimeBCI_PreProcess(sig, obj);
        
        wb = waitbar(0.33, wb, 'Epoching...');
        [EP] = RealTimeBCI_Epoching(sig, trig, obj);
        
        wb = waitbar(0.66, wb, 'Training decoder...');
        [C, mdl] = RealTimeBCI_Classify(EP, obj.param.target, obj);
        wb = waitbar(0.99, wb, 'Done...!');
        
        % get other infos
        obj.decoderState = 'testing';
        obj.decoder = mdl;
        obj.decoderInfo.iBlock = 1;

        wb = waitbar(1, wb, 'Done...!');
        
        close(wb);
    end
end
end




