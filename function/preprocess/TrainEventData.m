classdef (ConstructOnLoad) TrainEventData < event.EventData
   properties
      PATH
      FILE
   end
   
   methods
      function data = TrainEventData(newState)
         data.PATH = newState.PATH;
         data.FILE = newState.FILE;
      end
   end
end