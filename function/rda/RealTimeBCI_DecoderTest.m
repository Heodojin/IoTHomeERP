function RealTimeBCI_DecoderTest(BCI)
global sig_vec
global trigger

sig_vec = [];
trigger = [];

PopMsgToUser(BCI);
% step 2-2 : get data
% try
[sig_vec, trigger] = ReceiveBlockData(BCI);
% catch ME
%     errordlg('Failed to receive data...! Please restart to this block.');
%     return;
% end

% step 2-4 : prediction
[sig, obj] = RealTimeBCI_PreProcess(sig_vec, BCI);
[EP] = RealTimeBCI_Epoching(sig, trigger, BCI);
[C] = RealTimeBCI_Classify(EP, 0, obj);

% result Out
switch BCI.decoderInfo.mode
    case 'Virtual'
        vidObj = VideoReader(fullfile('video',strcat(BCI.decoderInfo.whichCon, num2str(C), '.mp4')));
        myVideoReader(BCI, vidObj);
        
    case 'Real'
        socket_sender(BCI.tcpip.address,BCI.tcpip.port, C); % send result to controller
end

% step 3-5 : commanding
msg = {['Selected :' num2str(C)];...
    'If you want to save data during this block, Please click "Save."'};
msg  = MsgBoxManager(msg);
notify(BCI, 'UpdatingMsg',msg); 

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myVideoReader(BCI, vidObj)
h = figure('NumberTitle','off',...
    'ToolBar','none',...
    'units','pixels',...
    'position',[BCI.uiObj.Position(1) BCI.uiObj.Position(2) 640 360],...
    'menubar','none',...
    'resize','off');


while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    imshow(vidFrame,'InitialMagnification','fit');
    set(gca,'Position',[0 0 1 1])
    pause(1/(vidObj.FrameRate));
end

delete(h);
end

function PopMsgToUser(BCI)
fh = uifigure('NumberTitle','off',...
    'ToolBar','none',...
     'units','pixels',...
     'position', [BCI.uiObj.Position(1) BCI.uiObj.Position(2) 472 354],...
     'Color', 'k',...
     'menubar','none',...
     'resize','off',...
     'Visible','off');

figPos = fh.Position;

uilabel(fh, 'Position', [1 1 472 354],...
    'WordWrap','on',...
    'Text',{'See the icon' 'you want to command!'},...
    'HorizontalAlignment','center',...
    'FontSize',40,...
    'FontColor','w');

set(fh,'Visible','on');
pause(3);
delete(fh);
end