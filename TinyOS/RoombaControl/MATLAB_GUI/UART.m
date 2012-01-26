function varargout = UART(varargin)
% UART M-file for UART.fig
%      UART, by itself, creates a new UART or raises the existing
%      singleton*.
%
%      H = UART returns the handle to a new UART or the handle to
%      the existing singleton*.
%
%      UART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UART.M with the given input arguments.
%
%      UART('Property','Value',...) creates a new UART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UART_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UART_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UART

% Last Modified by GUIDE v2.5 20-Jan-2011 08:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UART_OpeningFcn, ...
                   'gui_OutputFcn',  @UART_OutputFcn, ...
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


% --- Executes just before UART is made visible.
function UART_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UART (see VARARGIN)

% Choose default command line output for UART
handles.output = hObject;
% Update handles structure
handles.s1 = serial('COM1');
guidata(hObject, handles);

% UIWAIT makes PER wait for user response (see UIRESUME)
% uiwait(handles.UART_Fig);

% Initialize all components to 'off' until the COM PORT is opened.
% Components will be made 'on' in the 'OPEN' button callback
set(handles.open_comm,'Enable','off');
set(handles.close_comm,'Enable','off');
set(handles.test_uart,'Enable','off');

% UIWAIT makes UART wait for user response (see UIRESUME)
% uiwait(handles.UART_Fig);


% --- Outputs from this function are returned to the command line.
function varargout = UART_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function LPwm_Callback(hObject, eventdata, handles)
% hObject    handle to LPwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LPwm as text
%        str2double(get(hObject,'String')) returns contents of LPwm as a double


% --- Executes during object creation, after setting all properties.
function LPwm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LPwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test_uart.
function test_uart_Callback(hObject, eventdata, handles)
% hObject    handle to test_uart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.writeByte,'String');
fwrite(handles.s1,str2double(val),'uchar');



% --- Executes on button press in open_comm.
function open_comm_Callback(hObject, eventdata, handles)
% hObject    handle to open_comm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.s1 = serial(get(handles.port_comm,'String'), 'BaudRate', handles.baud);%, 'terminator', 13);
handles.rwBytes = str2double(get(handles.numBytes,'String'));
handles.s1.BytesAvailableFcnCount = handles.rwBytes;
handles.s1.BytesAvailableFcnMode = 'byte';
handles.s1.BytesAvailableFcn = {@serial_Callback, handles};
fopen(handles.s1);
guidata(hObject, handles);
set(handles.port_comm,'Enable','off');
set(handles.open_comm,'Enable','off');
set(handles.close_comm,'Enable','on');
set(handles.test_uart,'Enable','on');
set(handles.baudList,'Enable','off');
set(handles.numBytes,'Enable','off');
set(handles.baudSelectBtn,'Enable','off');

% --- Executes on button press in close_comm.
function close_comm_Callback(hObject, eventdata, handles)
% hObject    handle to close_comm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
comms = instrfind;
if ~isempty(comms)
    fclose(comms)
end
set(handles.port_comm,'Enable','on');
set(handles.open_comm,'Enable','off');
set(handles.close_comm,'Enable','off');
set(handles.test_uart,'Enable','off');
set(handles.baudList,'Enable','on');
set(handles.numBytes,'Enable','on');
set(handles.baudSelectBtn,'Enable','on');

function port_comm_Callback(hObject, eventdata, handles)
% hObject    handle to port_comm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port_comm as text
%        str2double(get(hObject,'String')) returns contents of port_comm as a double


% --- Executes during object creation, after setting all properties.
function port_comm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port_comm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function serial_Callback(hObject, eventdata, handles)
temp = fread(hObject, handles.rwBytes, 'uchar');
displ = ['RAW: ' num2str(temp')];   disp(displ);


% --- Executes when user attempts to close UART_Fig.
function UART_Fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to UART_Fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comms = instrfind;
if ~isempty(comms)
    fclose(comms)
end

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on selection change in baudList.
function baudList_Callback(hObject, eventdata, handles)
% hObject    handle to baudList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns baudList contents as cell array
%        contents = {get(hObject,'Value')} returns selected item from baudList
num = {get(hObject,'Value')};
contents = cellstr(get(hObject,'String'));
handles.baud = str2double(cell2mat(contents(cell2mat(num))));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function baudList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in baudSelectBtn.
function baudSelectBtn_Callback(hObject, eventdata, handles)
% hObject    handle to baudSelectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.open_comm,'Enable','on');
% set(hObject,'Enable','off');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over baudSelect.
function baudSelect_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to baudSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function numBytes_Callback(hObject, eventdata, handles)
% hObject    handle to numBytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numBytes as text
%        str2double(get(hObject,'String')) returns contents of numBytes as a double


% --- Executes during object creation, after setting all properties.
function numBytes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numBytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function writeByte_Callback(hObject, eventdata, handles)
% hObject    handle to writeByte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of writeByte as text
%        str2double(get(hObject,'String')) returns contents of writeByte as a double


% --- Executes during object creation, after setting all properties.
function writeByte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to writeByte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

