function varargout = taxi(varargin)
% taxi - simulation for chemo-taxi, the movement of bacteria towards higher
% concentration of food based on biased random walk.
% By: Shmuel Ben-Ezra, Tel-Aviv, Israel. {shmuel.benezra@gmail.com}
% parameters:
%   number of particles {100},
%   particle velocity {0.2} - i am not sure about the validity of the units
%   selectable radio-button {Without}/With food
%   sensitivity - the smallest food variations that can be detected {0.00001}
%   [thresholds - tumbling occurs when random number exceeds the threshold]
%   threshold low - induces high tumbling rate {0.5}.
%   threshol normal - the normal tumbling rate {0.7}.
%   threshold high - the low tumbling rate {0.9}.
%   steps - how many step of simulation you want {200}. expect to see the
%   effect of the food after some 50 steps.
% general:
%   N particles (bacteria) performs random walk in the frame. They all
%   share the same magnitude of velocity but their directions are random.
%   Each step each particle get a random number, if it exceeds the particle's own
%   threshold then the particle perform a 'reset' - he picks some new
%   random direction.
%   The threshold can acquire three values: low, normal and high. If
%   conditions get better (more food) the threshold will be high, therefore
%   the probability to do a reset is low. If conditions get worst (less
%   food) the threshold gets low, therefore the probability to do a reset
%   is higher. If no change had been detected, the threshold returns to its normal
%   value (exact adaptation).
%   Changes larger than 'Sensitivity' in food concentration are detectable.
%   The food distribution is of the shape exp(-r^2) so higher concentration is close to [0,0] - the lower left corner of the frame.
%   * Run with Matlab 7 and higher


% TAXI M-file for taxi.fig
%      TAXI, by itself, creates a new TAXI or raises the existing
%      singleton*.
%
%      H = TAXI returns the handle to a new TAXI or the handle to
%      the existing singleton*.
%
%      TAXI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAXI.M with the given input arguments.
%
%      TAXI('Property','Value',...) creates a new TAXI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Taxi_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to taxi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help taxi

% Last Modified by Shmuel Ben-Ezra and GUIDE v2.5 18-Nov-2008 14:31:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @taxi_OpeningFcn, ...
    'gui_OutputFcn',  @taxi_OutputFcn, ...
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

% --- Executes just before taxi is made visible.
function taxi_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = taxi_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
delete(handles.figure1)

% --- Executes on button press in pbStart.
function pbStart_Callback(hObject, eventdata, handles)
%get the label on push-button to switch between START and STOP
label = get(hObject, 'string');
switch label
    case 'START',
        set(hObject, 'string', 'STOP'); % change label
        limit=str2double(get(handles.edSteps, 'string'));
        dt = str2double(get(handles.ed_dt, 'string')); % pause between frame to frame [sec]
        set(handles.checkbox_plot, 'enable', 'off');
        set(handles.checkbox_plotR, 'enable', 'off');
        to_plot = get(handles.checkbox_plot, 'value');
        to_plotRrms = get(handles.checkbox_plotR, 'value');
        guidata(hObject, handles);
        % clear existing plot
        old = get(handles.axes1, 'children');
        delete(old);
        % graphics settings...
        set(handles.axes1, 'alimmode', 'manual');
        set(handles.axes1, 'xlim', [0 1], 'ylim', [0 1]);
        set(handles.axes1, 'xlimmode', 'manual', 'ylimmode', 'manual');
        set(handles.axes1, 'box', 'on');
        set(handles.axes1, 'xtick', [], 'ytick', []);
        set(handles.axes1, 'xtickmode', 'manual', 'ytickmode', 'manual');
        set(handles.axes1, 'nextplot', 'add');
        %initializing:
        Sensitivity = str2double(get(handles.edSensitivity, 'string')); % sensitivity for food concentration variations
        N = str2double(get(handles.edNumberOfParticles, 'string'));
        V = str2double(get(handles.edV, 'string'));
        ThresholdNormal = str2double(get(handles.edThreshold, 'string'));
        ThresholdLow = str2double(get(handles.edThresholdLow, 'string'));
        ThresholdHigh = str2double(get(handles.edThresholdHigh, 'string'));
        handles.p = struct([]);
        %we have to initialilze N particles p(i)
        for i=1:N,
            handles.p(i).x=rand;
            handles.p(i).y=rand;
            handles.p(i).v=V;
            handles.p(i).teta=rand*360;
            handles.p(i).color=i*1/N;
            handles.p(i).threshold=ThresholdNormal; % Low threshold - frequent resets (selecting a new direction to go); High threshold - rare resets
            handles.p(i).food = food(handles, i);
        end
        %displaying:
        handles.scatter = scatter([handles.p(:).x], [handles.p(:).y], 6, [handles.p(:).color]);
        guidata(gcbo, handles);
        % plotDisplay
        if to_plot || to_plotRrms, % if I have to plot any graph - I have to prepare the vector of distances
            p_r2=zeros(size(handles.p));
            %plotDisplay
            for ii = 1:length(p_r2),
                x_ii=handles.p(ii).x-0.5;
                y_ii=handles.p(ii).y-0.5;
                p_r2(ii)=x_ii*x_ii+y_ii*y_ii;
            end

        end
        if to_plot,
            %define the figure...
            f2_name = 'Radial density of bacteria';
            f2=findobj('name', f2_name);
            if isempty(f2),
                f2=figure('name', f2_name);
            end
            %prepare the histogram...
            edges = [0:0.05:0.5];
            areas = zeros(1, length(edges)-1);
            for ii = 1:length(areas),
                areas(ii)=edges(ii+1)*edges(ii+1)-edges(ii)*edges(ii); % in arbitrary units (*pi...)
            end
            p_r=sqrt(p_r2);
            n2 = histc(p_r, edges);
            n2=n2(1:end-1);
            nn2=n2./areas;
            nn2=nn2/max(nn2);
            figure(f2);
            plot2=bar(edges(1:end-1)+0.025, nn2,1,'edgecolor', 'w');
            set(gca, 'xlim', [0,0.5]);
            set(gca,'xtick',[0 0.5])
            set(gca,'xticklabel',[0 1])
            set(gca, 'ylim', [0,1.2]);
            set(gca,'ytick',[0 0.5 1])
            set(gca,'yticklabel',[0 0.5 1])
            xlabel('Distance from center [arbitrary units]');
            ylabel('#-bacteria per unit area [arbitrary normalized units]')
            title('Radial distribution of density of bacteria', 'fontsize', 12)
            grid on
        end %end plotDisplay

        % plot of R_rms
        if to_plotRrms,
            %define the figure...
            f3_name = 'RMS of bacteria distance from food';
            f3=findobj('name', f3_name);
            if isempty(f3),
                f3=figure('name', f3_name);
            end
            rms = sqrt(sum(p_r2)/length(p_r2));
            figure(f3);
            plot3=plot([0], [rms], 'linewidth', 2.0);
            set(gca, 'xlim', [0,limit*dt]);
            set(gca, 'ylim', [0,0.5]);
            xlabel('[sec.]');
            ylabel('[cm]')
            title('RMS of bacteria distance from food', 'fontsize', 12)
            grid on
        end
        % end of plot R_rms

        %run the movie:
        count=0;
        while(count<limit)
            pause(dt);
            if strcmp( get(hObject, 'string'), 'START'), break, end; % check the state of the label of the push-button
            count=count+1;
            % perform one step for N particles
            for i=1:N,
                %reset direction (only inside the boundaries)
                if handles.p(i).x > 0 & handles.p(i).x < 1 & handles.p(i).y > 0 & handles.p(i).y < 1,
                    if handles.p(i).threshold < rand, handles.p(i).teta = rand * 360; end % reset occurs if a random number is larger than threshold
                end
                old_food = handles.p(i).food; % food concentration in the previous location
                dx(i) = [handles.p(i).v] * cosd([handles.p(i).teta]) * dt; %step in x direction
                dy(i) = [handles.p(i).v] * sind([handles.p(i).teta]) * dt; %step in y direction
                handles.p(i).x = handles.p(i).x + dx(i);
                handles.p(i).y = handles.p(i).y + dy(i);
                %detect food concentration on new location
                handles.p(i).food = food(handles, i);
                if abs(handles.p(i).food - old_food) < Sensitivity,
                    handles.p(i).threshold = ThresholdNormal;
                elseif (handles.p(i).food - old_food) > Sensitivity,
                    handles.p(i).threshold = ThresholdHigh;  % more food increase threshold thus less frequent resets
                elseif (handles.p(i).food - old_food) < -1*Sensitivity,
                    handles.p(i).threshold = ThresholdLow; % less food decrease threshold thus more frequent resets
                end
                %boudary bouncing
                if handles.p(i).x > 1 | handles.p(i).x < 0,
                    handles.p(i).teta = mod( (180-handles.p(i).teta), 360);
                end
                if handles.p(i).y > 1 | handles.p(i).y < 0,
                    handles.p(i).teta = mod( (-handles.p(i).teta), 360);
                end
            end
            set(handles.scatter, 'xdata', [handles.p(:).x], 'ydata', [handles.p(:).y]); %update the locations of the particles

            %plotDisplay
            if to_plot || to_plotRrms, % if I have to plot any graph - I have to prepare the vector of distances
                p_r2=zeros(size(handles.p));
                %plotDisplay
                for ii = 1:length(p_r2),
                    x_ii=handles.p(ii).x-0.5;
                    y_ii=handles.p(ii).y-0.5;
                    p_r2(ii)=x_ii*x_ii+y_ii*y_ii;
                end
            end
            if to_plot,
                p_r=sqrt(p_r2);
                n2 = histc(p_r, edges);
                n2=n2(1:end-1);
                nn2=n2./areas;
                nn2=nn2/max(nn2);
                figure(f2);
                set(plot2, 'ydata', nn2);
            end % end plotDisplay
            %plot R rms
            if to_plotRrms,
                rms = sqrt(sum(p_r2)/length(p_r2));
                figure(f3);
                x3=get(plot3, 'xdata');
                y3=get(plot3, 'ydata');
                set(plot3, 'xdata', [x3, count*dt],'ydata', [y3,rms]);
            end
            % end of plot R rms
            set(handles.edStepNumber, 'string', count);
            guidata(gcbo, handles);
            %debug:
            %plotDistribution(handles);
        end
        set(hObject, 'string', 'START'); %if we have completed N steps
        set(handles.checkbox_plot, 'enable', 'on');
        set(handles.checkbox_plotR, 'enable', 'on');
    case 'STOP',
        %if the push-button had been pressed while it is labeled STOP
        set(hObject, 'string', 'START');
        set(handles.checkbox_plot, 'enable', 'on');
        set(handles.checkbox_plotR, 'enable', 'on');
        guidata(gcbo, handles);
end
return

function edNumberOfParticles_Callback(hObject, eventdata, handles)
n=str2double(get(hObject, 'string'));
n=min(1000,max(1,round(n)));
set(hObject, 'string', n);

% --- Executes during object creation, after setting all properties.
function edNumberOfParticles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edV_Callback(hObject, eventdata, handles)
n=str2double(get(hObject, 'string'));
n=min(0.8,max(0.1,n));
set(hObject, 'string', n);

% --- Executes during object creation, after setting all properties.
function edV_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edStepNumber_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edStepNumber_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edSteps_Callback(hObject, eventdata, handles)
n=str2double(get(hObject, 'string'));
n=min(1e6,max(1,round(n)));
set(hObject, 'string', n);

% --- Executes during object creation, after setting all properties.
function edSteps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edThreshold_Callback(hObject, eventdata, handles)
t = str2num(get(hObject, 'string'));
if t < 0, set(hObject, 'string', '0'); end
if t > 1, set(hObject, 'string', '1'); end
return

% --- Executes during object creation, after setting all properties.
function edThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edThresholdHigh_Callback(hObject, eventdata, handles)
t = str2num(get(hObject, 'string'));
if t < 0, set(hObject, 'string', '0'); end
if t > 1, set(hObject, 'string', '1'); end
return

% --- Executes during object creation, after setting all properties.
function edThresholdHigh_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edThresholdLow_Callback(hObject, eventdata, handles)
t = str2num(get(hObject, 'string'));
if t < 0, set(hObject, 'string', '0'); end
if t > 1, set(hObject, 'string', '1'); end
return

% --- Executes during object creation, after setting all properties.
function edThresholdLow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function res = food(handles, i)
%returns the concentration of food in (x,y)
x0=0.5; % position of food source
y0=0.5;
isFood = get(handles.rbWithFood, 'Value');
switch isFood,
    case 1,
        x1=handles.p(i).x-x0;
        y1=handles.p(i).y-y0;
        res=exp(-0.05*(x1*x1+y1*y1));
    case 0,
        res = 0;
end
return


function edSensitivity_Callback(hObject, eventdata, handles)
n=str2double(get(hObject, 'string'));
n=min(1,max(0,n));
set(hObject, 'string', n);

% --- Executes during object creation, after setting all properties.
function edSensitivity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in rbWithoutFood.
function rbWithoutFood_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function TheoryMenuItem_Callback(hObject, eventdata, handles)
theoryText = 'Chemo-taxis, the movement of bacteria towards locations with higher concentration of food, is performed by adjusting the tumbling rate to variations in food concentration: normally, a bacterium moves freely with constant velocity until it tumbles; when tumbling occurs, the bacterium forgets its original direction and picks up a new direction for free movement until the next tumbling. The tumbling events occur in some rate R_normal (tumbles per second). If a bacterium detects positive gradient of atractor (more food) it lowers the tumbling rate from R_normal to R_low. If it detects negative gradient of atractor it increases the tumbling rate to R_high (R_low<R_normal<R_high). If the bacterium detects no change in food concentration it returns to R_normal (exact adaptation).';
theoryTitle = 'Chemo-Taxi theory';
msgbox(theoryText, theoryTitle, 'replace')
% --------------------------------------------------------------------
function AlgorithmMenuItem_Callback(hObject, eventdata, handles)
algorithmText='A particle (bacterium) possesses position (X,Y), velocity-magnitude V, velocity orientation theta, threshold, food-concentration and sensitivity. Each step, a particle decides whether it tumbles or not: it picks up a random number and compares to threshold. If it exceeds threshold then it tumbles by picking arbitrary new theta. Next it calculates and updates its new position [X,Y]. Next, it detects the food concentration in its position and determines threshold: if food increased from last step by more than sensitivity, threshold = HIGH (less probability to tumble). If food decreased by more than sensitivity, then threshold = LOW. Otherwise threshold = NORMAL. Food distribution is centered in the middle of the box and decays with the distance r in the form of: exp(-a*r^2). (more details in the code)';
algorithmTitle='Chemo-Taxi algorithm';
msgbox(algorithmText, algorithmTitle, 'replace')
% --------------------------------------------------------------------
function UsageMenuItem_Callback(hObject, eventdata, handles)
usageText='Upon launching the application, press START. Particles start moving freely with NORMAL rate of tumbling and without any food around. By selcting the with-food radio button you add a food distribution. All other parameters are self-explanatory or explained in the theory and algorithms help sections. Enjoy! ';
usageTitle='Chemo-Taxi usage';
msgbox(usageText, usageTitle, 'replace')

%% --------------------------------------------------------------------
function CreditMenuItem_Callback(hObject, eventdata, handles)
creditText='By: Shmuel Ben-Ezra, 2006, Israel, Shmuel.Benezra@gmail.com';
creditTitle='Chemo-Taxi';
msgbox(creditText, creditTitle, 'replace')
return
%%

% --- Executes on button press in checkbox_plot.
function checkbox_plot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plot




% --- Executes on button press in checkbox_plotR.
function checkbox_plotR_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_plotR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_plotR



function ed_dt_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dt as text
%        str2double(get(hObject,'String')) returns contents of ed_dt as a double


% --- Executes during object creation, after setting all properties.
function ed_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


