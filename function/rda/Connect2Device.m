function [config] = Connect2Device(BCI)
if isempty(BCI.inlet)
lib = lsl_loadlib();

f = msgbox({'Now connecting with Device.'; 'Please Wait!'; 'If you want to stop, click "Cancel".'},...
    'WindowStyle','modal');
set(f,'Visible','off');
fobjBtns = findobj(f,'Style','pushbutton');
fobjAxes = findobj(f,'Type','Axes');
set(fobjBtns, 'String', 'Cancel');
set(f,'Visible','on')
pause(0.05);

clear stream
stream = {};
while 1
    stream = lsl_resolve_byprop(lib,'type','EEG');
    % marker = lsl_resolve_byprop(lib,'type','Markers',100000);

    if ~isempty(stream)
        set(get(fobjAxes,'Children'),'String',{'Wait...'});
        break;
    end
end
        
inlet = lsl_inlet(stream{1});

% get data for preview
tStart = tic;
while true
        % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    if ~isempty(chunk)
        config = true;
        break;
    end

    if toc(tStart) > 10
        errordlg('Unfortunately find error!');
        config = false;
        break;
    end
end


% get device information
% inf = inlet.info;
% devc.Fs = inf.nominal_srate();
% devc.Nch = inf.channel_count();
% ch = inf.desc().child('channels').child('channel');
% for ich = 1:devc.Nch
%     devc.chname{ich} = ch.child_value('label');
%     ch = ch.next_sibling();
% end
% idx = strfind(devc.chname,'Markers');
% idx = ~cellfun(@isempty, idx);
% devc.chname(idx) = [];
% devc.Nch = size(devc.chname,2);

set(get(fobjAxes,'Children'),'String',{'Done!'});
pause(0.5);
delete(f);

BCI.inlet = stream{1};
else
    config = 1;
    devc = [];
end
% BCI.marker = marker{2};
% BCI.inlet{1}.close_stream(); % temporally close
% BCI.inlet{2}.close_stream(); % temporally close

