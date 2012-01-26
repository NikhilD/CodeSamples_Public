function varargout = Data_Display(varargin)
% DATA_DISPLAY M-file for Data_Display.fig
%      DATA_DISPLAY, by itself, creates a new DATA_DISPLAY or raises the existing
%      singleton*.
%
%      H = DATA_DISPLAY returns the handle to a new DATA_DISPLAY or the handle to
%      the existing singleton*.
%
%      DATA_DISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_DISPLAY.M with the given input arguments.
%
%      DATA_DISPLAY('Property','Value',...) creates a new DATA_DISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Display_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Display_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Display

% Last Modified by GUIDE v2.5 20-Jun-2008 19:29:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Display_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Display_OutputFcn, ...
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


% --- Executes just before Data_Display is made visible.
function Data_Display_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_Display (see VARARGIN)

% Choose default command line output for Data_Display
handles.output = hObject;

%%%%%%%%%%% graph population code 
axes(handles.graph);
cla;   
axis([0 inf 0 4250]);
grid on
hold on

% Update handles structure
handles.plot = plot(0,0,'LineStyle','-','Color','k');
handles.com = serial('COM1');
guidata(hObject, handles);

% UIWAIT makes Data_Display wait for user response (see UIRESUME)
% uiwait(handles.Data_Display);

% Redefining the graph axes properties
set(handles.graph,'YTick',0:250:4250);
set(get(handles.graph,'YLabel'),'String','Reading units');
set(get(handles.graph,'XLabel'),'String','Time / # of readings');

set(handles.slider,'Visible','off');  % Slider is used for Scrolling graph

% Initialize the Global variables used in the program
global nodes;
for m = 1:30
    nodes(m).data0 = [];    % piezo
    nodes(m).data1 = [];    % ir motion    
    nodes(m).data2 = [];    % microphone
    nodes(m).status = 0;
end

% Initialize all components to 'off' until the COM PORT is opened.
% Components will be made 'on' in the 'OPEN' button callback
set(handles.com_close,'Enable','off');
set(handles.plot_btn,'Enable','off');
set(handles.node_drop_down,'Enable','off');
set(handles.sensor_drop_down,'Enable','off');
set(handles.RxID,'Enable','off');
set(handles.RxData,'Enable','off');
set(handles.data_buf,'Enable','off');
set(handles.time_stamp,'Enable','off');
set(handles.data_log_btn,'Enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = Data_Display_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function RxID_Callback(hObject, eventdata, handles)
% hObject    handle to RxID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RxID as text
%        str2double(get(hObject,'String')) returns contents of RxID as a double
id_num=get(handles.node_drop_down, 'String');    % get the node drop down menu values
id = str2double(id_num);                         % as an array
index = get(handles.node_drop_down, 'Value');    % get the index of the values

id_value = 64 + id(index);
fwrite(handles.com, id_value, 'uchar', 'async'); %0x41
    
% --- Executes during object creation, after setting all properties.
function RxID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RxID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RxData_Callback(hObject, eventdata, handles)
% hObject    handle to RxData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RxData as text
%        str2double(get(hObject,'String')) returns contents of RxData as a double


% --- Executes during object creation, after setting all properties.
function RxData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RxData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_stamp_Callback(hObject, eventdata, handles)
% hObject    handle to time_stamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_stamp as text
%        str2double(get(hObject,'String')) returns contents of time_stamp as a double


% --- Executes during object creation, after setting all properties.
function time_stamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_stamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in node_drop_down.
function node_drop_down_Callback(hObject, eventdata, handles)
% hObject    handle to node_drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns node_drop_down contents as cell array
%        contents{get(hObject,'Value')} returns selected item from node_drop_down

id_num=get(handles.node_drop_down, 'String');    % get the node drop down menu values
id = str2double(id_num);                         % as an array
index = get(handles.node_drop_down, 'Value');    % get the index of the values

set(handles.data_buf, 'String', '');        % clear the data_buf text entry
set(handles.RxID, 'String', id(index));     % set the node id text to selected value
set(handles.RxData, 'String', '');          % clear the temperature value entry
set(handles.time_stamp, 'String', '');      % clear the time-stamp entry

initializeFigureData('k');                  % initialize the global variables and reset 
                                            % the graph to original
                                            % settings with Color black 'k'

% --- Executes during object creation, after setting all properties.
function node_drop_down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to node_drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function com_port_Callback(hObject, eventdata, handles)
% hObject    handle to com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of com_port as text
%        str2double(get(hObject,'String')) returns contents of com_port as a double


% --- Executes during object creation, after setting all properties.
function com_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in com_open.
function com_open_Callback(hObject, eventdata, handles)
% hObject    handle to com_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define the COM settings here
handles.com = serial(get(handles.com_port,'String'), 'BaudRate', 115200);   % get the COM port number from GUI and set baud
handles.com.BytesAvailableFcnCount = 26;                                     % 'number' of bytes to be read at a time
handles.com.BytesAvailableFcnMode = 'byte';                                 % incoming data format
handles.com.BytesAvailableFcn = {@serial_Callback, handles};                % 'callback' function to be executed
fopen(handles.com);                                                         % open COM port
guidata(hObject, handles);                                                  % update handles struct

% 'enable' all the components for functioning, 'disable' the 'open' button
set(handles.com_open,'Enable','off');
set(handles.node_drop_down,'Enable','on');
set(handles.sensor_drop_down,'Enable','on');
set(handles.RxID,'Enable','on');
set(handles.RxData,'Enable','on');
set(handles.data_buf,'Enable','on');
set(handles.time_stamp,'Enable','on');
set(handles.data_log_btn,'Enable','on');
%set(handles.plot_btn,'Enable','on');
set(handles.com_close,'Enable','on');

% --- Executes on button press in com_close.
function com_close_Callback(hObject, eventdata, handles)
% hObject    handle to com_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%---------
% disconnect the COM port, disable all the components, re-enable the
% 'open' button, re-initialize the figure data
global nodes;
comms = instrfind;
if ~isempty(comms)
    fclose(comms)
end
set(handles.com_open,'Enable','on');
set(handles.RxID, 'String', '');
set(handles.RxData, 'String', '');
set(handles.data_buf, 'String', '');
set(handles.time_stamp, 'String', '');
set(handles.node_drop_down,'Value',1);
set(handles.sensor_drop_down,'Value',1);
set(handles.com_close,'Enable','off');
set(handles.plot_btn,'Enable','off');
set(handles.node_drop_down,'Enable','off');
set(handles.sensor_drop_down,'Enable','off');
set(handles.RxID,'Enable','off');
set(handles.RxData,'Enable','off');
set(handles.data_buf,'Enable','off');
set(handles.time_stamp,'Enable','off');
set(handles.data_log_btn,'Enable','off');
initializeFigureData('r');
% for m = 1:30
%     nodes(m).data0 = [];
%     nodes(m).data1 = [];
%     nodes(m).data2 = [];
%     nodes(m).status = 0;
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function serial_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global nodes;
LOG_DONE = 101;
SENDING_LOG = 121;
SEND_DONE = 131;

temp = fread(hObject, 26, 'uchar');                          % read the incoming data
node = temp(1);                                          % format it
pktType = temp(2);

switch pktType 
    case LOG_DONE
        w = 1;
        nodes(node).status = 'green';
        set(handles.time_stamp, 'String', datestr(now,'HH:MM:SS:FFF'));
    case SENDING_LOG
        nodes(node).status = 'yellow';
        for m = 3:6:21
            data0 = (temp(m+1)*256 + temp(m));
            data1 = (temp(m+3)*256 + temp(m+2));
            data2 = (temp(m+5)*256 + temp(m+4));
            %data3 = (temp(m+7)*256 + temp(m+6));
            %data4 = (temp(m+9)*256 + temp(m+8));
        
            nodes(node).data0 = [nodes(node).data0 data0];                 % populate the proper structure for particular 'node'
            nodes(node).data1 = [nodes(node).data1 data1];
            nodes(node).data2 = [nodes(node).data2 data2];
            %nodes(node).data3 = [nodes(node).data3 data3];
            %nodes(node).data4 = [nodes(node).data4 data4];
        end
    case SEND_DONE
        w = 3;
        nodes(node).status = 'red';
end

switch node        
    case 1
        set(handles.grid_node1, 'BackgroundColor', nodes(node).status);
    case 2
        set(handles.grid_node2, 'BackgroundColor', nodes(node).status);
    case 3
        set(handles.grid_node3, 'BackgroundColor', nodes(node).status);
    case 4
        set(handles.grid_node4, 'BackgroundColor', nodes(node).status);
    case 5
        set(handles.grid_node5, 'BackgroundColor', nodes(node).status);
    case 6
        set(handles.grid_node6, 'BackgroundColor', nodes(node).status);
    case 7
        set(handles.grid_node7, 'BackgroundColor', nodes(node).status);
    case 8
        set(handles.grid_node8, 'BackgroundColor', nodes(node).status);
    case 9
        set(handles.grid_node9, 'BackgroundColor', nodes(node).status);
    case 10
        set(handles.grid_node10, 'BackgroundColor', nodes(node).status);
    case 11
        set(handles.grid_node11, 'BackgroundColor', nodes(node).status);
    case 12
        set(handles.grid_node12, 'BackgroundColor', nodes(node).status);
    case 13
        set(handles.grid_node13, 'BackgroundColor', nodes(node).status);
    case 14
        set(handles.grid_node14, 'BackgroundColor', nodes(node).status);
    case 15
        set(handles.grid_node15, 'BackgroundColor', nodes(node).status);
    case 16
        set(handles.grid_node16, 'BackgroundColor', nodes(node).status);
    case 17
        set(handles.grid_node17, 'BackgroundColor', nodes(node).status);        
    case 18
        set(handles.grid_node18, 'BackgroundColor', nodes(node).status);
    case 19
        set(handles.grid_node19, 'BackgroundColor', nodes(node).status);
    case 20
        set(handles.grid_node20, 'BackgroundColor', nodes(node).status);
    case 21
        set(handles.grid_node21, 'BackgroundColor', nodes(node).status);
    case 22
        set(handles.grid_node22, 'BackgroundColor', nodes(node).status);
    case 23
        set(handles.grid_node23, 'BackgroundColor', nodes(node).status);
    case 24
        set(handles.grid_node24, 'BackgroundColor', nodes(node).status);
    case 25
        set(handles.grid_node25, 'BackgroundColor', nodes(node).status);
    case 26
        set(handles.grid_node26, 'BackgroundColor', nodes(node).status);
    case 27
        set(handles.grid_node27, 'BackgroundColor', nodes(node).status);
    case 28
        set(handles.grid_node28, 'BackgroundColor', nodes(node).status);
    case 29
        set(handles.grid_node29, 'BackgroundColor', nodes(node).status);
    case 30
        set(handles.grid_node30, 'BackgroundColor', nodes(node).status);
end

set(handles.data_buf, 'String', length(nodes(node).data0));  % update the buffer length entry on GUI


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_buf_Callback(hObject, eventdata, handles)
% hObject    handle to data_buf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_buf as text
%        str2double(get(hObject,'String')) returns contents of data_buf as a double


% --- Executes during object creation, after setting all properties.
function data_buf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_buf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_btn.
function plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global nodes;
x=0;y=0;len=0;

id_num=get(handles.node_drop_down, 'String');        % get the node drop down menu values
id = str2double(id_num);                             % as an array
index = get(handles.node_drop_down, 'Value');        % get the index of the values

n = get(handles.sensor_drop_down, 'Value');        % get the index of the values

switch n        
    case 2
        y = nodes(id(index)).data0;                      % assign the values of the matrices of selected nodes 
    case 3
        y = nodes(id(index)).data1;                      % assign the values of the matrices of selected nodes 
    case 4
        y = nodes(id(index)).data2;                      % assign the values of the matrices of selected nodes 
%     case 5
%         y = nodes(id(index)).data3;                      % assign the values of the matrices of selected nodes 
%     case 6
%         y = nodes(id(index)).data4;                      % assign the values of the matrices of selected nodes     
end

len = length(y);

x = [1:1:len];

set(handles.data_buf, 'String', len);  % update the buffer length entry on GUI
set(handles.RxData, 'String', y(len));          % set the temperature text to the latest value in the buffer
scrollplot((len/20),x,y);                        % plot the graph allowing user scrolling

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scrollplot(dx, varargin)
% scrollplot	Linear plot with horizontal scrollbar
%               for the inspection of really long timeseries.
%
% scrollplot(dx, x1, y1)
%
% Designed to inspect long timeseries: it shows a section of the data and
% allows the user to horizontally scroll the view. A smart loading of the 
% data allows the inspection of otherwise untreatable long timeseries.
% 

handles = guidata(gcbo);    % get the gui handles
dxmem = 25;                 % how many times the size of the data sent to the plot is, with respect to the shown part
handles.Param = varargin;   % get the received variables
handles.dx = dx;            % 'dx' is the number of parts the 'x' axis data is split into.
xmax = -inf;                % used for comparisons
xmin = +inf;

x = handles.Param{1};
y = handles.Param{2};
xmax = max(xmax, max(x));   % assign the max & min of compared values
xmin = min(xmin, min(x));

handles.xmin = xmin;
handles.xmax = max(xmax, xmin + dx);
center = xmin;              % initial position of the slider is 'left' extreme
center1 = int16(fix(center)); % 'center1' is used for accessing elements of array, hence needs to be whole number

beginmem = center - fix(dxmem / 2) * handles.dx; % 
beginmem = max(beginmem, handles.xmin);
endmem = beginmem + dxmem * handles.dx;
endmem = min(endmem, handles.xmax);
handles.BeginMem = beginmem;        % starting value of plot on x-axis
handles.EndMem = endmem;            % last value in the x-data

x = handles.Param{1};
y = handles.Param{2};

% This ensures that the data used to plot is in row-vector form, regardless
% of incoming data format.
if size(x,1) > size(x,2)
  x = x';
end
if size(y,1) > size(y,2)
  y = y';
end

% the following statements obtain the indices to the first and last
% elements in the matrices for x-data and y-data
beginind = 1;
endind = size(x, 2);
beginind = fix(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, handles.BeginMem)) - 1;
beginind = max(1, beginind);
endind = ceil(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, handles.EndMem)) + 1;
endind = min(endind, size(x, 2));
% plot the graph and set the plot properties
set(handles.plot,'XData', x(beginind : endind),'YData',y(:,beginind : endind), 'Color', 'k');
set(handles.graph,'xlim',[center (center + handles.dx)]); % divide the graph into sections
%set(handles.graph,'ylim',[min(min(y)) max(max(y))]);
guidata(handles.Data_Display, handles);  % update the GUI handles struct                                                                               

% establish the relation between the slider and the graph
stepratio = 0.1;
set(gcf,'doublebuffer','on');
if (handles.xmax - handles.xmin - dx) > 0
    steptrough = dx / (handles.xmax - handles.xmin - dx);   % movement of the slider when clicked in the 'trough' areas between the arrows
    steparrow = stepratio * steptrough;                     % movement of the slider when arrows on either side are pressed
    set(handles.slider,'units','normalized','callback',{@slider_Callback, handles},...
        'min', handles.xmin, 'max', handles.xmax - dx, 'value', handles.xmin, 'sliderstep', [steparrow steptrough]); 
    set(handles.slider,'Visible','on'); 
end

% --- Executes on button press in data_log_btn.
function data_log_btn_Callback(hObject, eventdata, handles)
% hObject    handle to data_log_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
log_data(handles);         % call the function to log data

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function log_data(dat_struct)         % function to log data to a *.mat file for records 

global nodes;
sendata = [];

for m = 1:1  %30
    sendata = [sendata nodes(m).data0' nodes(m).data1' nodes(m).data2'];% nodes(m).data3' nodes(m).data4'];      % gather the data in a single matrix
end

[file,path] = uiputfile('*.mat','Save Data to File');         % call 'save' pop-up

%%% If selected a file.
if(~strcmp(class(file),'double'))
    filename = fullfile(path,file);       
    save(filename,'sendata');      %%%< save to file
    % clear data history
    m=0;
    for m = 1:30
        nodes(m).data0 = [];
        nodes(m).data1 = [];
        nodes(m).data2 = [];
        %nodes(m).data3 = [];
        %nodes(m).data4 = [];
        nodes(m).status = 0;
    end
    set(dat_struct.data_buf, 'String', length(nodes(1).data0));  % update the buffer length entry on GUI
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%--------
% executes similar to the initial 'scrollplot'
% redraws the graph every time the slider is clicked using the same
% variables as the 'scrollplot' function

dxmem = 25;
center = get(handles.slider,'Value');  % 'position' of the slider's leftmost end 
center1 = int16(fix(center));          % with respect to the 'xmax' and 'xmin' values

if (center1<1)
    center1=1;
end    
dlim = int16(handles.dx);
if (center > handles.BeginMem) && (center + handles.dx < handles.EndMem)
    h = findobj(gcf, 'Type', 'axes');
    for i = 1 : size(h, 1)
        set(h(i), 'xlim', center + [0 handles.dx]);        
    end
    return;
end	

% this portion is executed only on the last click of the slider arrows when
% the slider travel is finised in either direction.
beginmem = center - fix(dxmem / 2) * handles.dx;
beginmem = max(beginmem, handles.xmin);
endmem = beginmem + dxmem * handles.dx;
endmem = min(endmem, handles.xmax);
handles.BeginMem = beginmem;
handles.EndMem = endmem;

x = handles.Param{1};
y = handles.Param{2};
% must be row-vectors
if size(x,1) > size(x,2)
  x = x';
end
if size(y,1) > size(y,2)
  y = y';
end
beginind = 1;
endind = size(x, 2);
beginind = fix(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, handles.BeginMem)) - 1;
beginind = max(1, beginind);
endind = ceil(fminbnd(inline('abs(m(fix(x))-xx)', 'x', 'm', 'xx'), 1, size(x, 2), optimset('TolX', 1), x, handles.EndMem)) + 1;
endind = min(endind, size(x, 2));
set(handles.plot,'XData', x(beginind : endind), 'YData',y(:,beginind : endind), 'Color', 'k');
set(handles.graph,'xlim',[center (center + handles.dx)]);
%set(handles.graph,'ylim',[min(min(y)) max(max(y))]);

guidata(handles.Data_Display, handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close Data_Display.
function Data_Display_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Data_Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comms = instrfind;
if ~isempty(comms)
    fclose(comms);
end
% Hint: delete(hObject) closes the figure
delete(hObject);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initializeFigureData(Color)      % initialize all the global 
                                          % variables and the graph
handles = guidata(gcbo);

set(handles.slider,'Visible','off');
cla(handles.graph,'reset');   
axis(handles.graph,[0 inf 0 4250]);
grid on
hold on
set(handles.graph,'YTick',0:250:4250);
set(get(handles.graph,'YLabel'),'String','Reading units');
set(get(handles.graph,'XLabel'),'String','Time / # of readings');
set(handles.graph,'XTickMode','auto','XTickLabelMode','auto');
handles.plot = plot(0,0,'LineStyle','-','Color',Color);
handles.com.BytesAvailableFcn = {@serial_Callback, handles};
guidata(handles.Data_Display, handles);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph




% --- Executes on selection change in sensor_drop_down.
function sensor_drop_down_Callback(hObject, eventdata, handles)
% hObject    handle to sensor_drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sensor_drop_down contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sensor_drop_down
n = get(handles.sensor_drop_down,'Value');
if (n==1)
    set(handles.plot_btn,'Enable','off');
else
    set(handles.plot_btn,'Enable','on');
end
set(handles.data_buf, 'String', '');        % clear the data_buf text entry
set(handles.RxData, 'String', '');          % clear the temperature value entry
set(handles.time_stamp, 'String', '');      % clear the time-stamp entry

initializeFigureData('r');                  % initialize the global variables and reset 
                                            % the graph to original
                                            % settings with Color red 'r'

% --- Executes during object creation, after setting all properties.
function sensor_drop_down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensor_drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function grid_node1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grid_node1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in grid_node1.
function grid_node1_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node1,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 65, 'uchar', 'async'); %0x41
end
if(isequal(get(handles.grid_node1,'BackgroundColor'),[1 0 0]))
    fwrite(handles.com, 129, 'uchar', 'async'); %0x81
    set(handles.grid_node1, 'BackgroundColor', 'blue');
    set(handles.time_stamp, 'String', datestr(now,'HH:MM:SS:FFF'));
end

% --- Executes on button press in grid_node11.
function grid_node11_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node11,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 11, 'uchar', 'async');
end

% --- Executes on button press in grid_node21.
function grid_node21_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node21,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 21, 'uchar', 'async');
end

% --- Executes on button press in grid_node2.
function grid_node2_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node2,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 66, 'uchar', 'async'); %0x42
end
if(isequal(get(handles.grid_node2,'BackgroundColor'),[1 0 0]))
    fwrite(handles.com, 130, 'uchar', 'async'); %0x82
    set(handles.grid_node2, 'BackgroundColor', 'blue');
end

% --- Executes on button press in grid_node12.
function grid_node12_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node12,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 12, 'uchar', 'async');
end

% --- Executes on button press in grid_node22.
function grid_node22_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node22,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 22, 'uchar', 'async');
end

% --- Executes on button press in grid_node3.
function grid_node3_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node3,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 67, 'uchar', 'async'); %0x43
end
if(isequal(get(handles.grid_node3,'BackgroundColor'),[1 0 0]))
    fwrite(handles.com, 131, 'uchar', 'async'); %0x83
    set(handles.grid_node3, 'BackgroundColor', 'blue');
end

% --- Executes on button press in grid_node13.
function grid_node13_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node13,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 13, 'uchar', 'async');
end

% --- Executes on button press in grid_node23.
function grid_node23_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node23,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 23, 'uchar', 'async');
end

% --- Executes on button press in grid_node4.
function grid_node4_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node4,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 68, 'uchar', 'async'); %0x44
end
if(isequal(get(handles.grid_node4,'BackgroundColor'),[1 0 0]))
    fwrite(handles.com, 132, 'uchar', 'async'); %0x84
    set(handles.grid_node4, 'BackgroundColor', 'blue');
end

% --- Executes on button press in grid_node14.
function grid_node14_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node14,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 14, 'uchar', 'async');
end

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node20,'BackgroundColor'),[1 0 0]))
%    fwrite(handles.com, 20, 'uchar', 'async');
end

% --- Executes on button press in grid_node5.
function grid_node5_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node5,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 69, 'uchar', 'async'); %0x45
end
if(isequal(get(handles.grid_node5,'BackgroundColor'),[1 0 0]))
    fwrite(handles.com, 133, 'uchar', 'async'); %0x85
    set(handles.grid_node5, 'BackgroundColor', 'blue');
end

% --- Executes on button press in grid_node15.
function grid_node15_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node15,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 15, 'uchar', 'async');
end

% --- Executes on button press in grid_node25.
function grid_node25_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node25,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 25, 'uchar', 'async');
end

% --- Executes on button press in grid_node6.
function grid_node6_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node6,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 6, 'uchar', 'async');
end

% --- Executes on button press in grid_node16.
function grid_node16_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node16,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 16, 'uchar', 'async');
end

% --- Executes on button press in grid_node26.
function grid_node26_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node26,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 26, 'uchar', 'async');
end

% --- Executes on button press in grid_node7.
function grid_node7_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node7,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 7, 'uchar', 'async');
end

% --- Executes on button press in grid_node17.
function grid_node17_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node17,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 17, 'uchar', 'async');
end

% --- Executes on button press in grid_node27.
function grid_node27_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node27,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 27, 'uchar', 'async');
end

% --- Executes on button press in grid_node8.
function grid_node8_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node8,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 8, 'uchar', 'async');
end

% --- Executes on button press in grid_node18.
function grid_node18_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node18,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 18, 'uchar', 'async');
end

% --- Executes on button press in grid_node28.
function grid_node28_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node28,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 28, 'uchar', 'async');
end

% --- Executes on button press in grid_node9.
function grid_node9_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node9,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 9, 'uchar', 'async');
end

% --- Executes on button press in grid_node19.
function grid_node19_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node19,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 19, 'uchar', 'async');
end

% --- Executes on button press in grid_node29.
function grid_node29_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node29,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 29, 'uchar', 'async');
end

% --- Executes on button press in grid_node10.
function grid_node10_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node10,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 10, 'uchar', 'async');
end

% --- Executes on button press in grid_node20.
function grid_node20_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node20,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 20, 'uchar', 'async');
end

% --- Executes on button press in grid_node30.
function grid_node30_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node30,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 30, 'uchar', 'async');
end

% --- Executes on button press in grid_node24.
function grid_node24_Callback(hObject, eventdata, handles)
% hObject    handle to grid_node24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isequal(get(handles.grid_node24,'BackgroundColor'),[0 1 0]))
    fwrite(handles.com, 24, 'uchar', 'async');
end

