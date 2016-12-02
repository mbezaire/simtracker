function varargout = ReviewAnalysis(varargin)
% REVIEWANALYSIS MATLAB code for ReviewAnalysis.fig
%      REVIEWANALYSIS, by itself, creates a new REVIEWANALYSIS or raises the existing
%      singleton*.
%
%      H = REVIEWANALYSIS returns the handle to a new REVIEWANALYSIS or the handle to
%      the existing singleton*.
%
%      REVIEWANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEWANALYSIS.M with the given input arguments.
%
%      REVIEWANALYSIS('Property','Value',...) creates a new REVIEWANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReviewAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReviewAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReviewAnalysis

% Last Modified by GUIDE v2.5 02-Apr-2015 11:17:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ReviewAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @ReviewAnalysis_OutputFcn, ...
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


% --- Executes just before ReviewAnalysis is made visible.
function ReviewAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath myInd AllCells threshparams DetailedData viewother
try
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReviewAnalysis (see VARARGIN)

% Choose default command line output for ReviewAnalysis
handles.output = hObject;
handles.ind = myInd;
handles.Analysis.Thresh_1_param = threshparams(1);
handles.Analysis.Thresh_2_param = threshparams(2);
handles.Analysis.Window = threshparams(3);
handles.viewother = viewother;
handles.step = length(DetailedData.AxoClampData.Currents);
handles.state = varargin{1}; % 1: choose threshold, 2: manually alter thresholds
guidata(hObject, handles);
set(handles.txt_cell,'String',[AllCells(handles.ind).CellName ': ' num2str(DetailedData.AxoClampData.Currents(handles.step)) ' pA'])



if handles.state == 1
    delete(handles.tbl_points);
    delete(handles.btn_clear);
    pos=get(handles.ax_display,'Position');
    set(handles.ax_display,'Position',[pos(1) pos(2) pos(3)*1.3 pos(4)])
    set(handles.txt_step,'String','Step 1: Choose threshold calculator')
    set(handles.menu_thresh,'Visible','On')
    set(handles.btn_adjust,'Visible','Off')
    set(handles.btn_remove,'Visible','Off')
    set(handles.menu_addpt,'Visible','Off')    
    set(handles.btn_trash,'Visible','Off')
    set(handles.btn_done,'Visible','Off')
    set(handles.btn_save,'String','Set Threshold Type')
    plotThresholdTrace(handles.step,handles)
    handles = guidata(hObject);
elseif handles.state == 2 
    set(handles.txt_step,'String','Step 2: Manually correct thresholds')
    set(handles.menu_thresh,'Visible','Off')
    set(handles.btn_adjust,'Visible','On')
    set(handles.btn_remove,'Visible','On')
    set(handles.menu_addpt,'Visible','On')    
    set(handles.btn_trash,'Visible','On')
    set(handles.btn_done,'Visible','On')
    set(handles.btn_save,'Visible','On','String','Done with Cell')
    plotTrace(handles.step,handles)
    handles = guidata(hObject);
end

for r=1:3
    mystr{r} = num2str(r);
end

set(handles.menu_thresh,'String',mystr,'Value',AllCells(myInd).ThresholdType)
% Update handles structure
guidata(hObject, handles);

ensureGUIfits(hObject)

catch ME
    handleME(ME)
end

% UIWAIT makes ReviewAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function plotThresholdTrace(z,handles)
global mypath AllCells DetailedData
try
axes(handles.ax_display)
hold off
if length(DetailedData.AxoClampData.Time)>1
    nz=z;
else
    nz=1;
end
plot(DetailedData.AxoClampData.Time(nz).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage,'k')

ind = handles.ind;

col = {'r.','go','b^','md','c*','ks','m.','gx'};
numThreshes = 3;
legstr{1} = 'Trace';

thresh=AllCells(ind).ThreshCheck;
spikes = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(1:end-1)<thresh & DetailedData.AxoClampData.Data(z).RecordedVoltage(2:end)>thresh);
if sum(spikes)>0
    hold on
    for s=1:length(spikes)
        if s==1
            if spikes(s)<DetailedData.AxoClampData.Injection(nz).OnIdx
                prevspike = 1;
            else
                prevspike = round(mean([DetailedData.AxoClampData.Injection(nz).OnIdx DetailedData.AxoClampData.Injection(nz).OnIdx DetailedData.AxoClampData.Injection(nz).OnIdx spikes(s)]));
            end
        end
        if s<length(spikes)
            nextspike = spikes(s+1);
        else
            if spikes(s)>DetailedData.AxoClampData.Injection(nz).OffIdx
                nextspike = length(DetailedData.AxoClampData.Time(nz).Data);
            else
                nextspike = DetailedData.AxoClampData.Injection(nz).OffIdx;
            end
        end

        for r=1:numThreshes
            try
                rez = (DetailedData.AxoClampData.Time(nz).Data(2)-DetailedData.AxoClampData.Time(nz).Data(1))*1000;
                threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param];
                [~,spktop]=max(DetailedData.AxoClampData.Data(z).RecordedVoltage(spikes(s):spikes(s)+5));
                Point(s).Threshers(r) = getThreshold(DetailedData.AxoClampData.Data(z).RecordedVoltage,spikes(s)+spktop-1,prevspike,rez,r,threshparams);
            catch ME
                [~, thr] = max(DetailedData.AxoClampData.Data(z).RecordedVoltage(prevspike:nextspike));
                Point(s).Threshers(r) = thr + prevspike -1;
            end
            try
            plot(DetailedData.AxoClampData.Time(nz).Data(Point(s).Threshers(r)),DetailedData.AxoClampData.Data(z).RecordedVoltage(Point(s).Threshers(r)),col{r})
            legstr{1+r} = num2str(r);
            catch
                Point(s).Threshers(r)
            end
        end
        [~, maxi]=max(DetailedData.AxoClampData.Data(z).RecordedVoltage(Point(s).Threshers(r):nextspike));
        prevspike = maxi+Point(s).Threshers(r)-1;
    end
    legend(legstr)
    xlabel('Time (s)')
    ylabel('Potential (mV)')
end
catch ME
    handleME(ME)
end




function plotTrace(z,handles)
global mypath DetailedData
try
handles.markers = LoadMarkers(handles,z);
guidata(handles.ax_display, handles);

axes(handles.ax_display)
hold off
if length(DetailedData.AxoClampData.Time)>1
    plot(DetailedData.AxoClampData.Time(z).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage)
else
    plot(DetailedData.AxoClampData.Time.Data,DetailedData.AxoClampData.Data(z).RecordedVoltage)
end

hold on
for m=1:length(handles.markers)
    handles.markers(m).h = plot(handles.markers(m).x,handles.markers(m).y,'Marker','o','Color',handles.markers(m).color,'MarkerFaceColor',handles.markers(m).color);
end
xlabel('Time (s)')
ylabel('Potential (mV)')

updatePtTable(handles);

guidata(handles.ax_display, handles);
catch ME
    handleME(ME)
end

function updatePtTable(handles)
global mypath tbldata myvec

if handles.state==1
    %set(handles.tbl_points,'Data',{})
else
    midx=0;
    tbldata={};
    SpikeNum=0;
    for m=1:length(handles.markers)
        if ~isempty(handles.markers(m).x) && ~isnan(handles.markers(m).x)
            midx=midx+1;
            tbldata{midx,1}=logical(0);
            b=strfind(handles.markers(m).Name,'.');
            tbldata{midx,3}=handles.markers(m).Name(b(end)+1:end-3);
            if strcmp(tbldata{midx,3},'Thresh')
                SpikeNum=SpikeNum+1;
            elseif strcmp(tbldata{midx,3},'Start')
                tbldata{midx,3}='Sag';
            elseif isempty(tbldata{midx,3})
                tbldata{midx,3}='SteadyState';
            end
            tbldata{midx,2}=SpikeNum;
            tbldata{midx,4}=handles.markers(m).x;
            tbldata{midx,5}=m;
            set(handles.markers(m).h,'MarkerEdgeColor',handles.markers(m).color);
        end
    end
    set(handles.tbl_points,'Data',tbldata(:,1:4))
end
myvec=[];

function Markers = LoadMarkers(handles,z)
global mypath AllCells DetailedData
try
ind = handles.ind;
points = {['DetailedData.OtherData.Sag(' num2str(z) ').StartIdx'], ...
['DetailedData.OtherData.Peak(' num2str(z) ').PeakIdx'], ...
['DetailedData.OtherData.SteadyStates(' num2str(z) ').Idx']};

colors = {'c','c','m','m','k'};

myp = length(points);

if isfield(DetailedData,'SpikeData') && length(DetailedData.SpikeData)>=z && isfield(DetailedData.SpikeData(z),'Spikes')
    for s=1:length(DetailedData.SpikeData(z).Spikes)
%         points{myp+(s-1)*5+1} = ['AllCells(' num2str(ind) ').SpikeData(' num2str(z) ').Spikes(length(AllCells(' num2str(ind) ').SpikeData(' num2str(z) ').Spikes)+1).ThreshIdx'];
%         points{myp+(s-1)*5+2} = ['AllCells(' num2str(ind) ').SpikeData(' num2str(z) ').Spikes(length(AllCells(' num2str(ind) ').SpikeData(' num2str(z) ').Spikes)).PeakIdx'];

        points{myp+(s-1)*5+1} = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).ThreshIdx']; % s = ' num2str(s) '
        points{myp+(s-1)*5+2} = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).PeakIdx'];
        points{myp+(s-1)*5+3} = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).AHPIdx'];
        points{myp+(s-1)*5+4} = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).ADPIdx'];
        points{myp+(s-1)*5+5} = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).fAHPIdx'];
        
        colors{myp+(s-1)*5+1} = 'g';
        colors{myp+(s-1)*5+2} = 'b';
        colors{myp+(s-1)*5+3} = 'r';
        colors{myp+(s-1)*5+4} = 'y';
        colors{myp+(s-1)*5+5} = 'c';
    end
end

s=0;
for p=1:length(points)
    if ~isempty(strfind(points{p},'ThreshIdx'))
        s=s+1;
    end
    try
    Markers(p).Name = points{p};
    Markers(p).Idx = eval(points{p});
    catch
        %Markers(p).Name = '';
        eval([points{p} '=NaN;']);
        Markers(p).Idx = NaN;
    end
    try
        Markers(p).x = eval(['DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(' points{p} ')']);
        Markers(p).y = eval(['DetailedData.AxoClampData.Data(z).RecordedVoltage(' points{p} ')']);
    catch
        Markers(p).x = NaN;
        Markers(p).y = NaN;
    end
    Markers(p).color = colors{p};
end
for t=1:length(Markers)
    if isempty(Markers(t).x)
        Markers(t).x=NaN;
    end
    if isempty(Markers(t).y)
        Markers(t).y=NaN;
    end
end
catch ME
    handleME(ME)
end

function saveMarkers(handles,varargin)
global mypath AllCells DetailedData %#ok<NUSED>
try
ind = handles.ind;
z = handles.step;
Markers = handles.markers;
for m=1:length(Markers)
    if isempty(Markers(m).Idx)
        Markers(m).Idx=NaN;
    end
end

[~, sortI]=sort([Markers(:).Idx]);
newvec=~isnan([Markers(sortI).Idx]);
Markers = Markers(sortI(newvec));
s=0;
DetailedData.SpikeData(z).Spikes=[];

for p=1:length(Markers)
    if ~isempty(strfind(Markers(p).Name,'ThreshIdx'))
        s=s+1;
    end
    if isnan(Markers(p).Idx)
        eval([Markers(p).Name ' = NaN;']);
    else
        try
        eval([Markers(p).Name '='  num2str(Markers(p).Idx) ';']);
        catch
            p
        end
    end
end
handles.markers = Markers;
guidata(handles.btn_adjust,handles);
if isempty(varargin) || varargin{1}>0
    saveCells(handles)
end
catch ME
    handleME(ME)
end

function mini=findMarker(handles,x,y)
try
    set(gca,'Units','inches')
    pos=get(gca,'Position');
    dist = sqrt((([handles.markers(:).x]-x)./diff(xlim).*pos(3)).^2 + (([handles.markers(:).y]-y)./diff(ylim).*pos(4)).^2);
    [~, mini] = min(dist);
catch ME
    handleME(ME)
end

function updateMarker(handles,z,x,y)
global mypath AllCells DetailedData TrashMode
try
AllCells(handles.ind).ManuallyChanged = 1;

if length(DetailedData.AxoClampData.Time)>1
    zi=z;
else
    zi=1;
end

if TrashMode
    handles.markers(z).Idx = NaN;
    handles.markers(z).x = NaN;
    handles.markers(z).y = NaN;
    delete(handles.markers(z).h);
    handles.markers(z).h = [];
else
    [~, mini] = min(abs(DetailedData.AxoClampData.Time(zi).Data - x));
    handles.markers(z).Idx = mini;
    handles.markers(z).x = DetailedData.AxoClampData.Time(zi).Data(handles.markers(z).Idx);
    handles.markers(z).y = DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(handles.markers(z).Idx);
    delete(handles.markers(z).h);
    handles.markers(z).h = plot(handles.markers(z).x,handles.markers(z).y,'Marker','o','Color',handles.markers(z).color,'MarkerFaceColor',handles.markers(z).color);
end
guidata(handles.ax_display, handles);
catch ME
    handleME(ME)
end


% --- Outputs from this function are returned to the command line.
function varargout = ReviewAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_hyper.
function btn_hyper_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData EditMode
% hObject    handle to btn_hyper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
if EditMode ~= 0
    EditMode = 0;
    %saveMarkers(handles)
end
if handles.state==2
saveMarkers(handles)
handles=guidata(hObject);
end

handles.step = handles.step-1;
if (handles.step<1)
    handles.step = length(DetailedData.AxoClampData.Currents);
end
set(handles.txt_cell,'String',[AllCells(handles.ind).CellName ': ' num2str(DetailedData.AxoClampData.Currents(handles.step)) ' pA'])

guidata(hObject, handles);


if handles.state == 1
    plotThresholdTrace(handles.step,handles)
else %handles.state == 1
    plotTrace(handles.step,handles)
end
catch ME
    handleME(ME)
end

% --- Executes on button press in btn_depol.
function btn_depol_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData EditMode
% hObject    handle to btn_depol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
if EditMode ~= 0
    EditMode = 0;
    %saveMarkers(handles)
end
if handles.state==2
saveMarkers(handles)
handles=guidata(hObject);
end

handles.step = handles.step+1;
if (handles.step>length(DetailedData.AxoClampData.Currents))
    handles.step = 1;
end
guidata(hObject, handles);
set(handles.txt_cell,'String',[AllCells(handles.ind).CellName ': ' num2str(DetailedData.AxoClampData.Currents(handles.step)) ' pA'])

if handles.state == 1
    plotThresholdTrace(handles.step,handles)
else %handles.state == 1
    plotTrace(handles.step,handles)
end
catch ME
    handleME(ME)
end


% --- Executes on button press in btn_adjust.
function btn_adjust_Callback(hObject, eventdata, handles)
global mypath EditMode myvec tbldata
% hObject    handle to btn_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
EditMode = 1;TrashMode = 0;
set(handles.btn_adjust,'BackgroundColor',[1 0 0])

%set(handles.btn_adjust,'Enable','On')
set(handles.btn_trash,'Enable','Off')
set(handles.btn_remove,'Enable','Off')
set(handles.menu_addpt,'Enable','Off')    
set(handles.btn_done,'Enable','Off')
set(handles.btn_save,'Enable','Off')

if isempty(myvec)
[x y]=ginput(1);
yl=get(gca,'yLim');
xl=get(gca,'xLim');
if min(x)<xl(1) | max(x)>xl(2) | min(y)<yl(1) | max(y)>yl(2) 
    set(handles.btn_adjust,'BackgroundColor',[0.941 0.941 0.941])
    EditMode = 0;
    return
end
z=findMarker(handles,x(1),y(1));
set(handles.markers(z).h,'MarkerEdgeColor','k')
g=find([tbldata{:,5}]==z);
if ~isempty(g)
seltbldata=get(handles.tbl_points,'Data');
seltbldata{g,1}=logical(1);
set(handles.tbl_points,'Data',seltbldata);
else
    z
end
else
    z=myvec(1);
end

[x y]=ginput(1);
yl=get(gca,'yLim');
xl=get(gca,'xLim');
if min(x)<xl(1) | max(x)>xl(2) | min(y)<yl(1) | max(y)>yl(2) 
    set(handles.markers(z).h,'MarkerEdgeColor',handles.markers(z).color)
    set(handles.btn_adjust,'BackgroundColor',[0.941 0.941 0.941])
    EditMode = 0;
    set(handles.btn_trash,'Enable','On')
    set(handles.btn_remove,'Enable','On')
    set(handles.menu_addpt,'Enable','On')    
    set(handles.btn_done,'Enable','On')
    set(handles.btn_save,'Enable','On')
    updatePtTable(handles)
    return
end
updateMarker(handles,z,x(1),y(1));
handles = guidata(handles.btn_adjust);
set(handles.markers(z).h,'MarkerEdgeColor',handles.markers(z).color)

set(handles.btn_adjust,'BackgroundColor',[0.941 0.941 0.941])
EditMode = 0;
set(handles.btn_trash,'Enable','On')
set(handles.btn_remove,'Enable','On')
set(handles.menu_addpt,'Enable','On')    
set(handles.btn_done,'Enable','On')
set(handles.btn_save,'Enable','On')
updatePtTable(handles)

catch ME
    handleME(ME)
    set(handles.btn_trash,'Enable','On')
    set(handles.btn_remove,'Enable','On')
    set(handles.menu_addpt,'Enable','On')    
    set(handles.btn_done,'Enable','On')
    set(handles.btn_save,'Enable','On')
end

% --- Executes on button press in btn_done.
function btn_done_Callback(hObject, eventdata, handles)
global mypath AllCells

% hObject    handle to btn_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% EditMode = 0;
% 
%     set(handles.btn_adjust,'Visible','On')
%     set(handles.btn_trash,'Visible','Off')
%     set(handles.btn_remove,'Visible','On')
%     set(handles.menu_addpt,'Visible','On')    
%     set(handles.btn_done,'Visible','Off')
%     set(handles.btn_save,'Visible','On')

saveMarkers(handles)

% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
thresh=AllCells(handles.ind).ThreshCheck;
if handles.state == 1
    % handles.state = 2;
    guidata(handles.txt_step,handles);
%     set(handles.txt_step,'String','Step 2: Manually correct thresholds')
%     set(handles.menu_thresh,'Visible','Off')
%     set(handles.btn_adjust,'Visible','On')
%     set(handles.btn_trash,'Visible','On')
%     set(handles.btn_done,'Visible','On')
    contents = get(handles.menu_thresh,'String');
    AllCells(handles.ind).ThresholdType = str2num(contents{get(handles.menu_thresh,'Value')});
    ind = handles.ind;
    for z=1:length(DetailedData.AxoClampData.Data)        
        if length(DetailedData.AxoClampData.Time)>1
            zi=z;
        else
            zi=1;
        end
        spikes = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(1:end-1)<thresh & DetailedData.AxoClampData.Data(z).RecordedVoltage(2:end)>thresh);
        DetailedData.SpikeData(z).NumSpikes = length(spikes);
        DetailedData.SpikeData(z).Spikes = [];
        if sum(spikes)>0
            for s=1:length(spikes)
                if s==1
                    if spikes(s)<DetailedData.AxoClampData.Injection(zi).OnIdx
                        prevspike = 1;
                    else
                        prevspike = round(mean([DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx spikes(s)]));
                    end
                end
                if s<length(spikes)
                    nextspike = spikes(s+1);
                else
                    if spikes(s)>DetailedData.AxoClampData.Injection(zi).OffIdx
                        nextspike = length(DetailedData.AxoClampData.Time(zi).Data);
                    else
                        nextspike = DetailedData.AxoClampData.Injection(zi).OffIdx;
                    end
                end
                ThreshType = AllCells(ind).ThresholdType;
                Point = plotPoint(handles,spikes(s),prevspike,nextspike,[],DetailedData.AxoClampData.Time(zi).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage,ThreshType);
                if s==1 && (Point.Thresh-DetailedData.AxoClampData.Injection(zi).OnIdx)<5 && spikes(s)>(prevspike+5)
                    Point = plotPoint(handles,spikes(s),prevspike+5,nextspike,[],DetailedData.AxoClampData.Time(zi).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage,ThreshType);
                elseif s==length(spikes) && ~isempty(Point.AHP) && Point.AHP>=DetailedData.AxoClampData.Injection(zi).OffIdx && ~isnan(Point.fAHP)
                    Point.AHP=Point.fAHP;
                    Point.fAHP=NaN;
                    Point.ADP=NaN;
                end
                DetailedData.SpikeData(z).Spikes(s).ThreshIdx = Point.Thresh;
                DetailedData.SpikeData(z).Spikes(s).PeakIdx = Point.Peak;
                DetailedData.SpikeData(z).Spikes(s).AHPIdx = Point.AHP;
                DetailedData.SpikeData(z).Spikes(s).ADPIdx = Point.ADP;
                DetailedData.SpikeData(z).Spikes(s).fAHPIdx = Point.fAHP;
                prevspike = DetailedData.SpikeData(z).Spikes(s).PeakIdx;
            end
        end
    end
%     saveCells(handles)
%     set(handles.btn_save,'String','Done with Cell')
%     plotTrace(handles.step,handles)
    set(gca,'Color','k')
    for z=1:length(DetailedData.AxoClampData.Currents)
        handles.step = z;% length(DetailedData.AxoClampData.Currents);
        plotTrace(z,handles)
        handles=guidata(handles.ax_display);
        saveMarkers(handles,0)
        handles=guidata(hObject);
    end
    AllCells(handles.ind).ThresholdsVerified = 1;
    AllCells(handles.ind).Analyzed = 0;
    saveMarkers(handles); %handles.markers ...
    handles=guidata(hObject);
    close(handles.output);
else
    AllCells(handles.ind).ManuallyChanged = 1;
    AllCells(handles.ind).Analyzed = 0;
    saveMarkers(handles); %handles.markers ...
    handles=guidata(hObject);
    % saveCells(handles)
    close(handles.output);
end
catch ME
    handleME(ME)
end

function Point = plotPoint(handles,spkidx,previdx,nextidx,h,Time,Data,tmpThreshType)
try
ThreshType = round(tmpThreshType);

myFlag = tmpThreshType - ThreshType;
rez = (Time(2)-Time(1))*1000;
threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param];
Point.Thresh = getThreshold(Data,spkidx,previdx,rez,ThreshType,threshparams); %1);
if isempty(Point.Thresh)
    [~, tmpstidx]=max(Data(previdx:spkidx));
    [~, tmpspkidx]=max(Data((previdx+tmpstidx-1):nextidx));
    tmpspkidx=tmpspkidx+previdx+tmpstidx-2;
    Point.Thresh = getThreshold(Data,tmpspkidx,previdx,rez,ThreshType,threshparams);
    minusme=10;
    while isempty(Point.Thresh) && minusme<100 && (tmpspkidx-minusme)>previdx
        minusme=minusme+10;
        Point.Thresh = getThreshold(Data,spkidx,tmpspkidx-minusme,rez,ThreshType,threshparams);
    end
    if isempty(Point.Thresh)
        Point.Thresh = spkidx;
    end
end

[~, maxi]=max(Data(Point.Thresh:nextidx));
try
    Point.Peak = maxi+Point.Thresh-1;
catch ME
    ME
end


if (nextidx-Point.Peak)<2
    Point.AHP = NaN;
    Point.fAHP = NaN;
    Point.ADP = NaN;
else
    try
g = gausswin(round(handles.Analysis.Window));
g = g/sum(g);
y3=conv(Data(Point.Peak:nextidx),g,'same');
    tmppeaks=findpeaks(y3);
    if isstruct(tmppeaks)
        y=tmppeaks.loc;
        t=tmppeaks.loc;
    else
        [t, y]=findpeaks(y3);
    end
catch
    y=[];
end
for mym=length(y):-1:1
    if abs(Data(Point.Peak+y(mym)-1)-y3(y(mym)))>5
        y(mym)=[];
    end
end
tmpidx=min([Point.Peak+round(.2/(Time(2)-Time(1))) nextidx]);
if isempty(y)
    [~, mini]=min(Data(Point.Peak:tmpidx));
    Point.AHP = mini+Point.Peak-1;
    Point.fAHP = NaN;
    Point.ADP = NaN;
else
    Point.ADP = y(1) + Point.Peak-1;
    [~, mini]=min(Data(Point.Peak:Point.ADP));
    Point.fAHP = Point.Peak+mini-1;
    [~, mini]=min(Data(Point.ADP:tmpidx));
    Point.AHP = Point.ADP+mini-1;
    
    if (Data(Point.fAHP)-Data(Point.AHP))>5 % mV
        if (Data(Point.Peak)-Data(Point.fAHP))<10
            Point.fAHP=NaN;
            Point.ADP=NaN;
        else
            Point.AHP=Point.fAHP;
            Point.fAHP=NaN;
            Point.ADP=NaN;
        end
    end
end
end
catch ME
    handleME(ME)
end

% --- Executes on button press in btn_trash.
function btn_trash_Callback(hObject, eventdata, handles)
global mypath TrashMode myvec tbldata
% hObject    handle to btn_trash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
EditMode = 1;TrashMode = 1;
set(handles.btn_trash,'BackgroundColor',[1 0 0])

set(handles.btn_adjust,'Enable','Off')
%set(handles.btn_trash,'Enable','Off')
set(handles.btn_remove,'Enable','Off')
set(handles.menu_addpt,'Enable','Off')    
set(handles.btn_done,'Enable','Off')
set(handles.btn_save,'Enable','Off')

if isempty(myvec)
[x y]=ginput(1);
yl=get(gca,'yLim');
xl=get(gca,'xLim');
if min(x)<xl(1) | max(x)>xl(2) | min(y)<yl(1) | max(y)>yl(2) 
    set(handles.btn_trash,'BackgroundColor',[0.941 0.941 0.941])
    EditMode = 0;TrashMode = 0;
    set(handles.btn_adjust,'Enable','On')
    set(handles.btn_remove,'Enable','On')
    set(handles.menu_addpt,'Enable','On')    
    set(handles.btn_done,'Enable','On')
    set(handles.btn_save,'Enable','On')
    updatePtTable(handles)
    return
end

z=findMarker(handles,x(1),y(1));
set(handles.markers(z).h,'MarkerEdgeColor','k')
g=find([tbldata{:,5}]==z);
seltbldata=get(handles.tbl_points,'Data');
seltbldata{g,1}=logical(1);
set(handles.tbl_points,'Data',seltbldata);

myans=questdlg('Is this the correct marker to delete?','Confirm deletion','Yes','No','Yes');
switch myans
    case 'Yes'
        updateMarker(handles,z,x(1),y(1));
    case 'No'
        set(handles.markers(z).h,'MarkerEdgeColor',handles.markers(z).color)
end
else
    for k=1:length(myvec)
        z=myvec(k);
        updateMarker(handles,z,0,0);
        handles=guidata(handles.btn_trash);
    end
end
handles = guidata(handles.btn_trash);
set(handles.btn_trash,'BackgroundColor',[0.941 0.941 0.941])
EditMode = 0;TrashMode = 0;
set(handles.btn_adjust,'Enable','On')
set(handles.btn_remove,'Enable','On')
set(handles.menu_addpt,'Enable','On')    
set(handles.btn_done,'Enable','On')
set(handles.btn_save,'Enable','On')
updatePtTable(handles)

catch ME
    set(handles.btn_adjust,'Enable','On')
    set(handles.btn_remove,'Enable','On')
    set(handles.menu_addpt,'Enable','On')    
    set(handles.btn_done,'Enable','On')
    set(handles.btn_save,'Enable','On')
    handleME(ME)
end


% --- Executes on selection change in menu_thresh.
function menu_thresh_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData
% hObject    handle to menu_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_thresh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_thresh
try
ind = handles.ind;
contents = cellstr(get(hObject,'String'));
mythresh = str2double(contents{get(hObject,'Value')});
axes(handles.ax_display);
hold on

if isfield(handles,'threshline') && ~isempty(handles.threshline)
    try
        delete(handles.threshline);
        handles.threshline = [];
        guidata(handles.ax_display,handles);
    catch ME
        ME
    end
end
threshline = [];
thresh=AllCells(ind).ThreshCheck;

if length(DetailedData.AxoClampData.Time)>1
    zi=handles.step;
else
    zi=1;
end
 
spikes = find(DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(1:end-1)<thresh & DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(2:end)>thresh);
if sum(spikes)>0
    hold on
    for s=1:length(spikes)
        if s==1
            if spikes(s)<DetailedData.AxoClampData.Injection(zi).OnIdx
                prevspike = 1;
            else
                prevspike = round(mean([DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx spikes(s)]));
            end
        end
        if s<length(spikes)
            nextspike = spikes(s+1);
        else
            if spikes(s)>DetailedData.AxoClampData.Injection(zi).OffIdx
                nextspike = length(DetailedData.AxoClampData.Time(zi).Data);
            else
                nextspike = DetailedData.AxoClampData.Injection(zi).OffIdx;
            end
        end
        rez = (DetailedData.AxoClampData.Time(zi).Data(2)-DetailedData.AxoClampData.Time(zi).Data(1))*1000;
        threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param];
        [~,spktop]=max(DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(spikes(s):spikes(s)+5));
        tmp = getThreshold(DetailedData.AxoClampData.Data(handles.step).RecordedVoltage,spikes(s)+spktop-1,prevspike,rez,mythresh,threshparams);
        if isempty(tmp)
            [~, maxi]= max(DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(spikes(s):nextspike));
            threshline(s) = maxi + spikes(s);
        else
            threshline(s) = tmp;
        end
        [~, maxi]=max(DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(threshline(s):nextspike));
        prevspike = maxi + threshline(s) - 1;
    end
end

if ~isempty(threshline)
    handles.threshline = plot(DetailedData.AxoClampData.Time(zi).Data(threshline),DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(threshline),'Color',[.5 .5 .5],'LineWidth',2);
    guidata(handles.ax_display,handles);
end
catch ME
    handleME(ME)
end

% --- Executes during object creation, after setting all properties.
function menu_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_remove.
function btn_remove_Callback(hObject, eventdata, handles)
% hObject    handle to btn_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove all ADPs

% move AHP point to fAHP location after deleting fAHP point?
myans=questdlg('Move AHP point to fAHP location after deleting fAHP point?');
switch myans
    case 'Yes'
        moveflag=1;
    case 'No'
        moveflag=0;
    otherwise
        return;
end

for z=1:length(handles.markers)
    nameseg = handles.markers(z).Name;
    g=findstr(nameseg,'.');
    nameseg = nameseg(g(end)+1:end);
    if strcmp(nameseg,'ADPIdx')==1 && ~isempty(handles.markers(z).x) && ~isnan(handles.markers(z).x)
        handles.markers(z).Idx = NaN;
        handles.markers(z).x = NaN;
        handles.markers(z).y = NaN;
        delete(handles.markers(z).h);
        handles.markers(z).h = [];
    elseif strcmp(nameseg,'fAHPIdx')==1 && ~isempty(handles.markers(z).x) && ~isnan(handles.markers(z).x)
        if moveflag
            p=z-2;
            handles.markers(p).Idx = handles.markers(z).Idx;
            handles.markers(p).x = handles.markers(z).x;
            handles.markers(p).y = handles.markers(z).y;
            delete(handles.markers(p).h);
            handles.markers(p).h = plot(handles.markers(p).x,handles.markers(p).y,'Marker','o','Color',handles.markers(p).color,'MarkerFaceColor',handles.markers(p).color);
        end
        handles.markers(z).Idx = NaN;
        handles.markers(z).x = NaN;
        handles.markers(z).y = NaN;
        delete(handles.markers(z).h);
        handles.markers(z).h = [];
    end
end
guidata(handles.btn_remove, handles);
saveMarkers(handles,0)
handles=guidata(handles.btn_remove);
updatePtTable(handles)


% --- Executes on selection change in menu_addpt.
function menu_addpt_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData
% hObject    handle to menu_addpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_addpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_addpt


contents = get(handles.menu_addpt,'String');
val = get(handles.menu_addpt,'Value');

btntype=contents{val};

if strcmp(btntype,'Add point...')==1
    return
end

ind = handles.ind;
z = handles.step;

set(handles.menu_addpt,'BackgroundColor',[1 0 0])

markstr={'Threshold','Peak','Fast AHP','ADP','Slow AHP','Peak Transient','Sag Peak','Steady State'};
namestr={'ThreshIdx','PeakIdx','fAHPIdx','ADPIdx','AHPIdx','Peak Transient','Sag Peak','Steady State'};
btncolors={'g','b','c','y','r','c','c','m'};
w=strmatch(btntype,markstr,'exact');

nz=1;
if length(DetailedData.AxoClampData.Time)>=z
    nz=z;
end
[x, y]=ginput(1);
[~, mini] = min(abs(DetailedData.AxoClampData.Time(nz).Data - x));
%z=find([handles.markers(:).Idx]>mini,1,'first');
%if isempty(z)
    myz=length(handles.markers)+1;
%else
%    handles.markers(z+1:length(handles.markers)+1) = handles.markers(z:end);
%end
%msgbox('Marker Name!')
if length(DetailedData.AxoClampData.Time)>1
    nz=handles.step;
else
    nz=1;
end
handles.markers(myz).Name = ['DetailedData.SpikeData(' num2str(z) ').Spikes(s).' namestr{w}]; % ' num2str(s) '
handles.markers(myz).Idx = mini;
handles.markers(myz).x = DetailedData.AxoClampData.Time(nz).Data(handles.markers(myz).Idx);
handles.markers(myz).y = DetailedData.AxoClampData.Data(handles.step).RecordedVoltage(handles.markers(myz).Idx);
handles.markers(myz).color=btncolors{w};
handles.markers(myz).h = plot(handles.markers(myz).x,handles.markers(myz).y,'Marker','o','Color',handles.markers(myz).color,'MarkerFaceColor',handles.markers(myz).color);
guidata(handles.menu_addpt, handles);
saveMarkers(handles,0)
set(handles.menu_addpt,'BackgroundColor',[1 1 1],'Value',1)
handles=guidata(handles.menu_addpt);
updatePtTable(handles)


% --- Executes during object creation, after setting all properties.
function menu_addpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_addpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
seltbldat=get(handles.tbl_points,'Data');
for r=1:size(seltbldat,1)
    seltbldat{r,1}=0;
end
set(handles.tbl_points,'Data',seltbldat)

% --- Executes when entered data in editable cell(s) in tbl_points.
function tbl_points_CellEditCallback(hObject, eventdata, handles)
global mypath tbldata myvec
% hObject    handle to tbl_points (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
myvec=[];
seltbldat=get(handles.tbl_points,'Data');
for r=1:size(seltbldat,1)
    if seltbldat{r,1}
        set(handles.markers(tbldata{r,5}).h,'MarkerEdgeColor','k')
        uistack(handles.markers(tbldata{r,5}).h,'top')
        myvec=[myvec tbldata{r,5}];
    else
        set(handles.markers(tbldata{r,5}).h,'MarkerEdgeColor',handles.markers(tbldata{r,5}).color)
    end
end
