function varargout = Utah_DataDisplay(varargin)
% UTAH_DATADISPLAY M-file for Utah_DataDisplay.fig
%      UTAH_DATADISPLAY, by itself, creates a new UTAH_DATADISPLAY or raises the existing
%      singleton*.
%
%      H = UTAH_DATADISPLAY returns the handle to a new UTAH_DATADISPLAY or the handle to
%      the existing singleton*.
%
%      UTAH_DATADISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UTAH_DATADISPLAY.M with the given input arguments.
%
%      UTAH_DATADISPLAY('Property','Value',...) creates a new UTAH_DATADISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Utah_DataDisplay_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Utah_DataDisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Utah_DataDisplay

% Last Modified by GUIDE v2.5 03-Jun-2008 20:59:23
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Utah_DataDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @Utah_DataDisplay_OutputFcn, ...
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


% --- Executes just before Utah_DataDisplay is made visible.
function Utah_DataDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Utah_DataDisplay (see VARARGIN)

% Choose default command line output for Utah_DataDisplay
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

% UIWAIT makes Utah_DataDisplay wait for user response (see UIRESUME)
% uiwait(handles.Utah_DataDisplay);

% Redefining the graph axes properties
set(handles.graph,'YTick',0:250:4250);
set(get(handles.graph,'YLabel'),'String','Temperature units');
set(get(handles.graph,'XLabel'),'String','Time');

set(handles.slider,'Visible','off');  % Slider is used for Scrolling graph

% Initialize the Global variables used in the program
global a;
global c;
global d;
global e;
global f;
global nodes;
a=0;c=[];d=[];e=0;f=0;
for m = 1:30
    nodes(m).data = [];
    nodes(m).time = [];
end

% Initialize all components to 'off' until the COM PORT is opened.
% Components will be made 'on' in the 'OPEN' button callback
set(handles.latest_data,'Value',0);
set(handles.Latest_Graph,'Value',0);
set(handles.com_close,'Enable','off');
set(handles.latest_data,'Enable','off');
set(handles.plot_btn,'Enable','off');
set(handles.Latest_Graph,'Enable','off');
set(handles.drop_down,'Enable','off');
set(handles.RxID,'Enable','off');
set(handles.RxData,'Enable','off');
set(handles.data_buf,'Enable','off');
set(handles.time_stamp,'Enable','off');
set(handles.data_log_btn,'Enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = Utah_DataDisplay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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




% --- Executes when user attempts to close Utah_DataDisplay.
function Utah_DataDisplay_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Utah_DataDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
comms = instrfind;
if ~isempty(comms)
    fclose(comms);
end
%close(handles.conn);
% Hint: delete(hObject) closes the figure
delete(hObject);





function RxID_Callback(hObject, eventdata, handles)
% hObject    handle to RxID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RxID as text
%        str2double(get(hObject,'String')) returns contents of RxID as a double


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




% --- Executes during object creation, after setting all properties.
function graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph




% --- Executes on selection change in drop_down.
function drop_down_Callback(hObject, eventdata, handles)
% hObject    handle to drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drop_down contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drop_down

id_num=get(handles.drop_down, 'String');    % get the drop down menu values
id = str2double(id_num);                    % as an array
index = get(handles.drop_down, 'Value');    % get the index of the values

set(handles.data_buf, 'String', '');        % clear the data_buf text entry
set(handles.RxID, 'String', id(index));     % set the node id text to selected value
set(handles.RxData, 'String', '');          % clear the temperature value entry
set(handles.time_stamp, 'String', '');      % clear the time-stamp entry

initializeFigureData('k');                  % initialize the global variables and reset 
                                            % the graph to original settings with Color black 'k'
                                            
% --- Executes during object creation, after setting all properties.
function drop_down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drop_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in plot_btn.
function plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global time;
global nodes;
x=0;y=0;time=0;len=0;

set(handles.latest_data,'Value',0);             % clear the radio button selections
set(handles.Latest_Graph,'Value',0);

id_num=get(handles.drop_down, 'String');        % get the drop down menu values
id = str2double(id_num);                        % as an array
index = get(handles.drop_down, 'Value');        % get the index of the values

y = nodes(id(index)).data;                      % assign the values of the matrices of selected nodes 
time = nodes(id(index)).time;                   % to the variables for plotting

len1 = length(y);
len2 = length(time);
len = len2;                                     % use the length variable to access the matrix elements        

x = [1:1:len];

set(handles.data_buf, 'String', len);           % set the data_buf text to the current length of the buffer
set(handles.RxData, 'String', y(len));          % set the temperature text to the latest value in the buffer
set(handles.time_stamp, 'String', time(len));   % set the time-stamp text to the latest value in the buffer
scrollplot((len/4),x,y);                        % plot the graph allowing user scrolling

%set(handles.plot_btn,'Enable','off');

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
global time;                % used for the the 'time' axis
handles = guidata(gcbo);    % get the gui handles
dxmem = 15;                 % how many times the size of the data sent to the plot is, with respect to the shown part
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
set(handles.graph,'xlim',[center (center + handles.dx)], 'XTick', center:(handles.dx/3):(center + handles.dx)); % divide the graph into 4 sections
%set(handles.graph,'ylim',[min(min(y)) max(max(y))]);
set(handles.graph,'XTickLabel',{time{1}, time{center1+(int16(fix(handles.dx/3)))},...       % replaces the x-data with the 
                                time{center1+(int16(fix((2*handles.dx)/3)))},...            % corresponding time-stamp values
                                time{center1+(int16(fix(handles.dx)))}});
guidata(handles.Utah_DataDisplay, handles);  % update the GUI handles struct                                                                               

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

% --- Executes on slider movement --- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% executes similar to the initial 'scrollplot'
% redraws the graph every time the slider is clicked using the same
% variables as the 'scrollplot' function
global time;
dxmem = 15;
center = get(handles.slider,'Value');  % 'position' of the slider's leftmost end 
center1 = int16(fix(center));          % with respect to the 'xmax' and 'xmin' values

if (center1<1)
    center1=1;
end    
dlim = int16(handles.dx);
if (center > handles.BeginMem) && (center + handles.dx < handles.EndMem)
    h = findobj(gcf, 'Type', 'axes');
    for i = 1 : size(h, 1)
        set(h(i), 'xlim', center + [0 handles.dx], 'XTick', center:(handles.dx/3):(center + handles.dx));
        set(h(i),'XTickLabel',{time{center1},time{center1+(int16(fix(handles.dx/3)))},...
                                time{center1+(int16(fix((2*handles.dx)/3)))},...
                                time{center1+(int16(fix(handles.dx)))}}); 
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
set(handles.graph,'xlim',[center (center + handles.dx)], 'XTick', center:(handles.dx/3):(center + handles.dx));
%set(handles.graph,'ylim',[min(min(y)) max(max(y))]);
set(handles.graph,'XTickLabel',{time{center1},time{center1+(int16(fix(handles.dx/3)))},...
                                time{center1+(int16(fix((2*handles.dx)/3)))},...
                                time{center1+(int16(fix(handles.dx)))}});

guidata(handles.Utah_DataDisplay, handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initializeFigureData(Color)      % initialize all the global 
global a;                                 % variables and the graph
global c;
global d;
global e;
global f;
global nodes;
a=0;c=[];d=[];e=0;f=0;
handles = guidata(gcbo);

set(handles.slider,'Visible','off');
cla(handles.graph,'reset');   
axis(handles.graph,[0 inf 0 4250]);
grid on
hold on
set(handles.graph,'YTick',0:250:4250);
set(get(handles.graph,'YLabel'),'String','Temperature units');
set(get(handles.graph,'XLabel'),'String','Time');
handles.plot = plot(0,0,'LineStyle','-','Color',Color);
set(handles.graph,'XTickMode','auto','XTickLabelMode','auto');
handles.com.BytesAvailableFcn = {@serial_Callback, handles};
guidata(handles.Utah_DataDisplay, handles);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in com_open.
function com_open_Callback(hObject, eventdata, handles)
% hObject    handle to com_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define the COM settings here
handles.com = serial(get(handles.com_port,'String'), 'BaudRate', 115200);   % get the COM port number from GUI and set baud
handles.com.BytesAvailableFcnCount = 4;                                     % 'number' of bytes to be read at a time
handles.com.BytesAvailableFcnMode = 'byte';                                 % incoming data format
handles.com.BytesAvailableFcn = {@serial_Callback, handles};                % 'callback' function to be executed
fopen(handles.com);                                                         % open COM port
guidata(hObject, handles);                                                  % update handles struct

% 'enable' all the components for functioning, 'disable' the 'open' button
set(handles.com_open,'Enable','off');
set(handles.Latest_Graph,'Enable','on');
set(handles.drop_down,'Enable','on');
set(handles.RxID,'Enable','on');
set(handles.RxData,'Enable','on');
set(handles.data_buf,'Enable','on');
set(handles.time_stamp,'Enable','on');
set(handles.data_log_btn,'Enable','on');
set(handles.plot_btn,'Enable','on');
set(handles.com_close,'Enable','on');
set(handles.latest_data,'Enable','on');


% --- Executes on button press in com_close.
function com_close_Callback(hObject, eventdata, handles)
% hObject    handle to com_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disconnect the COM port, disable all the components, re-enable the
% 'open' button, re-initialize the figure data
global nodes;
comms = instrfind;
if ~isempty(comms)
    fclose(comms)
end
set(handles.com_open,'Enable','on');
set(handles.RxData, 'String', '');
set(handles.data_buf, 'String', '');
set(handles.time_stamp, 'String', '');
set(handles.latest_data,'Value',0);
set(handles.Latest_Graph,'Value',0);
set(handles.com_close,'Enable','off');
set(handles.latest_data,'Enable','off');
set(handles.plot_btn,'Enable','off');
set(handles.Latest_Graph,'Enable','off');
set(handles.drop_down,'Enable','off');
set(handles.RxID,'Enable','off');
set(handles.RxData,'Enable','off');
set(handles.data_buf,'Enable','off');
set(handles.time_stamp,'Enable','off');
set(handles.data_log_btn,'Enable','off');
initializeFigureData('r');
for m = 1:30
    nodes(m).data = [];
    nodes(m).time = [];
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function serial_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;
global c;
global d;
global e;
global f;
global nodes;
b=0;
temp = fread(hObject, 4, 'uchar');                          % read the incoming data
node = (temp(2)*256 + temp(1));                             % format it
data = (temp(4)*256 + temp(3));
timer = datestr(now,'mm-dd-yyyy HH.MM.SS');                 % time-stamp of data arrival
        
nodes(node).data = [nodes(node).data data];                 % populate the proper structure for particular 'node'
nodes(node).time = [nodes(node).time {timer}];              

set(handles.data_buf, 'String', length(nodes(node).data));  % update the buffer length entry on GUI 

id_num=get(handles.drop_down, 'String');                    % get the drop down menu values
id = str2double(id_num);                                    % as an array
index = get(handles.drop_down, 'Value');                    % get the index of the values

% display data and time-stamp if 'Show Latest Data' radio-button is clicked
if ((isequal(id(index),node)==1) && (get(handles.latest_data,'Value') == get(handles.latest_data,'Max')))
    set(handles.RxData, 'String', data);
    set(handles.time_stamp, 'String', timer);
end
% display data and time-stamp and plot real-time graph if 'Plot Latest Data on Graph' radio-button is clicked
if ((isequal(id(index),node)==1) && (get(handles.Latest_Graph,'Value') == get(handles.Latest_Graph,'Max')))    
    set(handles.RxData, 'String', data);
    set(handles.time_stamp, 'String', timer);
    %h = str2num(datestr(now, 'SS'));
    %a = e + h;    
    a = a + 1;
    b = data;
    c = [c a];
    d = [d b];    
    set(handles.plot,'XData',c,'YData',d, 'Color', 'r');
%     if((h>=59) && (f==0))
%         %c=a;d=b;        % clearing the x & y arrays after a certain value                                     
%         c=[];d=[];
%         %e=(e+60);
%         f=1;
%     else
%         f=0;
%     end
end

% --- Executes on button press in latest_data.
function latest_data_Callback(hObject, eventdata, handles)
% hObject    handle to latest_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of latest_data


% --- Executes on button press in Latest_Graph.
function Latest_Graph_Callback(hObject, eventdata, handles)
% hObject    handle to Latest_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Latest_Graph
initializeFigureData('r');


% --- Executes on button press in data_log_btn.
function data_log_btn_Callback(hObject, eventdata, handles)
% hObject    handle to data_log_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
log_data();         % call the function to log data

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function log_data()         % function to log data to a *.mat file for records 

global nodes;
sendata = [];

for m = 1:2
    sendata = [sendata nodes(m).data' {nodes(m).time'}];      % gather the data in a single matrix
end

[file,path] = uiputfile('*.mat','Save Data to File');         % call 'save' pop-up

%%% If selected a file.
if(~strcmp(class(file),'double'))
    filename = fullfile(path,file);       
    save(filename,'sendata');      %%%< save to file
end

% clear data history
m=0;
for m = 1:30
    nodes(m).data = [];
    nodes(m).time = [];
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

