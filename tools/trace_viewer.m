function varargout = trace_viewer(varargin)
% TRACE_VIEWER MATLAB code for trace_viewer.fig
%      TRACE_VIEWER, by itself, creates a new TRACE_VIEWER or raises the existing
%      singleton*.
%
%      H = TRACE_VIEWER returns the handle to a new TRACE_VIEWER or the handle to
%      the existing singleton*.
%
%      TRACE_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACE_VIEWER.M with the given input arguments.
%
%      TRACE_VIEWER('Property','Value',...) creates a new TRACE_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trace_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trace_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trace_viewer

% Last Modified by GUIDE v2.5 05-Jan-2014 15:04:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trace_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @trace_viewer_OutputFcn, ...
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


% --- Executes just before trace_viewer is made visible.
function trace_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl expcells
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trace_viewer (see VARARGIN)

% Choose default command line output for trace_viewer
handles.output = hObject;


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);
handles.directoryname = myrepos(q).dir;

% a=dir([handles.directoryname sl 'cellclamp_results' sl]);
% a=a([a(:).isdir]==1);
% 
% handles.resultsnum=a(end-1).name;
% handles.celltype='pvbasketcell';
% handles.idx=0;

load([handles.directoryname sl 'cellclamp_results' sl 'experimental' sl 'expcells.mat']);

for r=1:length(expcells)
    mycells{r,1}=expcells(r).celltype;
    mycells{r,2}=true;
    mycells{r,3}=14.6;
    mycells{r,4}=expcells(r).name;
end

set(handles.tbl_biocells,'Data',mycells);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trace_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function loadcell(handles)
global mypath sl expcells
colorvec={'b','r','c','m','g'};
load([handles.directoryname sl 'cellclamp_results' sl handles.resultsnum sl 'rundata.mat']);
modelcurrent=round(iclamp.current(handles.idx)*1000); %pA
modeldelay=4; %ms
set(handles.txt_curr,'String',[num2str(modelcurrent) ' pA']);
tr=importdata([handles.directoryname sl 'cellclamp_results' sl handles.resultsnum sl 'trace_' handles.celltype '.soma(0.5).' num2str(handles.idx-1) '.dat']);
axes(handles.ax_trace)
plot(tr.data(:,1),tr.data(:,2),'k')
legstr{1}=['Model ' handles.celltype];
hold on
mycells=get(handles.tbl_biocells,'Data');
myi=0;
for r=1:size(mycells,1)
    if mycells{r,2}
        jpcorr=mycells{r,3};
        mycurr=find([expcells(r).structured.ivec]==modelcurrent);
        if ~isempty(mycurr)
            myi=myi+1;
            legstr{myi+1}=['Bio. ' expcells(r).name];
            startidx=find(expcells(r).structured.TimeVec>=(expcells(r).structured.TimeVec(expcells(3).structured.betterdata(1).TestStart)-(iclamp.c_start+modeldelay)/1000),1,'first');       
            plot(expcells(r).structured.TimeVec(1:end-startidx+1)*1000,expcells(r).structured.betterdata(mycurr).ResultData(startidx:end)-jpcorr,colorvec{myi})
            %ff=sgolayfilt(expcells(r).structured.betterdata(mycurr).ResultData(startidx:end)-jpcorr,2,555);
            %myi=myi+1;
            %legstr{myi+1}=['Bio. Filt ' expcells(r).name];
            %plot(expcells(r).structured.TimeVec(1:end-startidx+1)*1000,ff,colorvec{myi})
        end
    end
end
hold off
legend(legstr)
xlabel('Time (ms)')
ylabel('Potential (mV)')
title(['Comparison of Experimental Data with Run #' handles.resultsnum])
guidata(handles.btn_hyper, handles);

% --- Outputs from this function are returned to the command line.
function varargout = trace_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_choosemodelcell.
function btn_choosemodelcell_Callback(hObject, eventdata, handles)
% hObject    handle to btn_choosemodelcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_hyper.
function btn_hyper_Callback(hObject, eventdata, handles)
% hObject    handle to btn_hyper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.idx=handles.idx-1;
if handles.idx<1, handles.idx=handles.numcurr; end
guidata(hObject, handles);
loadcell(handles)

% --- Executes on button press in btn_depol.
function btn_depol_Callback(hObject, eventdata, handles)
% hObject    handle to btn_depol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.idx=handles.idx+1;
if handles.idx>handles.numcurr, handles.idx=1; end
guidata(hObject, handles);
loadcell(handles)
% --- Executes on selection change in pop_chooserun.
function pop_chooserun_Callback(hObject, eventdata, handles)
% hObject    handle to pop_chooserun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_chooserun contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_chooserun
contents = cellstr(get(hObject,'String'));
handles.resultsnum=contents{get(hObject,'Value')};

guidata(hObject, handles);
handles.resultsnum=handles.resultsnum(1:findstr(handles.resultsnum,':')-1);
pop_choosecell_CreateFcn(handles.pop_choosecell, [], handles)

% --- Executes during object creation, after setting all properties.
function pop_chooserun_CreateFcn(hObject, eventdata, handles)
global mypath sl

% hObject    handle to pop_chooserun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);
handles.directoryname = myrepos(q).dir;

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'])


for r=1:length(mydesc)
    run_list{r}=[mydesc(r).name ': ' mydesc(r).desc];
end

set(hObject,'String',run_list(end:-1:1),'Value',1)
guidata(hObject, handles);

if isfield(handles,'pop_choosecell')
    %pop_choosecell_CreateFcn(handles.pop_choosecell, [], handles)
end

% --- Executes on selection change in pop_choosecell.
function pop_choosecell_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to pop_choosecell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_choosecell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_choosecell

contents = cellstr(get(hObject,'String')) ;
handles.celltype=contents{get(hObject,'Value')};

b=dir([handles.directoryname sl 'cellclamp_results' sl handles.resultsnum sl 'trace_' handles.celltype '.soma(0.5).*.dat']);
handles.idx=1;
handles.numcurr=length(b);
guidata(hObject, handles);
loadcell(handles)

% --- Executes during object creation, after setting all properties.
function pop_choosecell_CreateFcn(hObject, eventdata, handles)
global mypath sl
% hObject    handle to pop_choosecell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%try
     %handles = guidata(hObject);
if ~isempty(handles) && isfield(handles,'resultsnum')
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

    q=find([myrepos(:).current]==1);
    handles.directoryname = myrepos(q).dir;
    guidata(hObject, handles);

    b=dir([handles.directoryname sl 'cellclamp_results' sl handles.resultsnum sl 'trace_*.soma(0.5).0.dat']);

    for r=1:length(b)
        starti=length('trace_')+1;
        endi=length('.soma(0.5).0.dat');
        cell_list{r}=b(r).name(starti:end-endi);
    end
    set(hObject,'String',cell_list,'Value',1)
end
%5catch ME
%    ME.message
%end


% --- Executes on button press in btn_refresh.
function btn_refresh_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);
handles.directoryname = myrepos(q).dir;

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'])


for r=1:length(mydesc)
    run_list{r}=[mydesc(r).name ': ' mydesc(r).desc];
end

set(handles.pop_chooserun,'String',run_list(end:-1:1),'Value',1)
guidata(hObject, handles);

if isfield(handles,'pop_choosecell')
    pop_choosecell_CreateFcn(handles.pop_choosecell, [], handles)
end