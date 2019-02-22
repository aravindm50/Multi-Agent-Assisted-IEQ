function varargout = mytestgui(varargin)
% MYTESTGUI M-file for mytestgui.fig
%      MYTESTGUI, by itself, creates a new MYTESTGUI or raises the existing
%      singleton*.
%
%      H = MYTESTGUI returns the handle to a new MYTESTGUI or the handle to
%      the existing singleton*.
%
%      MYTESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYTESTGUI.M with the given input arguments.
%
%      MYTESTGUI('Property','Value',...) creates a new MYTESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mytestgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mytestgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mytestgui

% Last Modified by GUIDE v2.5 27-Aug-2018 17:03:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mytestgui_OpeningFcn, ...
                   'gui_OutputFcn',  @mytestgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mytestgui is made visible.
function mytestgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mytestgui (see VARARGIN)

% Choose default command line output for mytestgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mytestgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mytestgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function curState_Callback(hObject, eventdata, handles)
% hObject    handle to curState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curState as text
%        str2double(get(hObject,'String')) returns contents of curState as a double


% --- Executes during object creation, after setting all properties.
function curState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonstart.
function pushbuttonstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%start the model with the standard Simulink API command
set_param('mytestmdl','SimulationCommand','start');


% --- Executes on button press in pushbuttonstop.
function pushbuttonstop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%start the model with the standard Simulink API command
set_param('mytestmdl','SimulationCommand','stop')


function gain_Callback(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain as text
%        str2double(get(hObject,'String')) returns contents of gain as a double

%get the user entered value for gain and convert it to a string
val = str2num(get(hObject,'String'));

%update both the model and the current string in the gain window.
if(val)
    assignin('base','a',val);
    set_param('mytestmdl','SimulationCommand','update');
else
    val = evalin('base','a');
    set(hObject,'String',num2str(val));
end


% --- Executes during object creation, after setting all properties.
function gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set the default gain to be 1
set(hObject,'String','1');
evalin('base','a=1;');
set_param('mytestmdl','SimulationCommand','update');
