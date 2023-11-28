classdef (ConstructOnLoad) MsgBoxManager < event.EventData
    properties
        msg
    end

    methods (Static)
         function obj = MsgBoxManager(msg)
             if size(msg,2)>1
                msg = msg';
            end
             obj.msg = msg;
         end

         function CreatemessageBox(BCI)
            msg = {'Welcome to home appliance control BCI system using ERP!',...
                'If you want to start, Please click the "Help" Button :-)',...
                '',...
                'First, you have to set the path where you want to save ("Set Path" Button)'};
            
            BCI.msgbox.box = uitextarea(BCI.uiObj,...
                'Value',msg,...
                'WordWrap', 'on',...
                'Position',[20 220 420 300],...
                'FontName', 'Helvetica',...
                'FontSize',12,...
                'FontColor','w',...
                'BackgroundColor',[.15 .15 .18],...
                'Editable','off');

            scroll(BCI.msgbox.box,'bottom')           
         end

         
        function whatIsMsgToSend(BCI,msg)

            old_msg = BCI.msgbox.box.Value;
            new_msg = cat(1,old_msg,msg.msg);
            % only show 100 lines
            if length(new_msg) > 200
                new_msg = new_msg(end-201:end);
            end
            BCI.msgbox.box.Value = new_msg;
            scroll(BCI.msgbox.box,'bottom')

        end
    end
end