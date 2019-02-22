function varargout = updategui(varargin)

%create a run time object that can return the value of the gain block's
%output and then put the value in a string.
rto = get_param('mytestmdl/Gain','RuntimeObject');
str = num2str(rto.OutputPort(1).Data);

%get a handle to the GUI's 'current state' window
statestxt = findobj('Tag','curState');

%update the gui
set(statestxt,'string',str);

