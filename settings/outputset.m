function varargout = outputset(varargin)
% OUTPUTSET MATLAB code for outputset.fig
%      OUTPUTSET, by itself, creates a new OUTPUTSET or raises the existing
%      singleton*.
%
%      H = OUTPUTSET returns the handle to a new OUTPUTSET or the handle to
%      the existing singleton*.
%
%      OUTPUTSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTPUTSET.M with the given input arguments.
%
%      OUTPUTSET('Property','Value',...) creates a new OUTPUTSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before outputset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to outputset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help outputset

% Last Modified by GUIDE v2.5 15-Feb-2013 09:14:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @outputset_OpeningFcn, ...
                   'gui_OutputFcn',  @outputset_OutputFcn, ...
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


% --- Executes just before outputset is made visible.
function outputset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to outputset (see VARARGIN)

% Choose default command line output for outputset
handles.output = hObject;
    set(handles.tbl_output,'Data',[])
    set(handles.tbl_needs,'Data',[])

% Update handles structure
guidata(hObject, handles);
btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes outputset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = outputset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs')

for r=1:length(myoutputs)
    tabledata{r,1} = myoutputs(r).output;
    tabledata{r,2} = myoutputs(r).function;
    tabledata{r,3} = myoutputs(r).description;
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores
    
set(handles.tbl_output,'Data',tabledata)
set(handles.list_myoutputs,'String',{myoutputs(:).output});




% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs')


tabledata=get(handles.tbl_output,'Data');

for r=1:size(tabledata,1)
    if ~isempty(tabledata{r,1}) && ~isempty(tabledata{r,2}) && ~isempty(tabledata{r,3})
        idx = strmatch(tabledata{r,1}, {myoutputs(:).output});
        if isempty(idx)
            idx = length(myoutputs)+1;
        end
        myoutputs(idx).output=tabledata{r,1};
        myoutputs(idx).function=tabledata{r,2};
        myoutputs(idx).description=tabledata{r,3};
    end
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores



%%%% Save Queues %%%%
tabledata=get(handles.tbl_needs,'Data');

contents = cellstr(get(handles.list_myoutputs,'String'));
idx = strmatch(contents{get(handles.list_myoutputs,'Value')}, {myoutputs(:).output});

if ~isempty(idx)
    for r=1:size(tabledata,1)
        if ~isempty(tabledata{r,1})
            myoutputs(idx).needs(r).eval=tabledata{r,1};
        end
    end
end

save([mypath sl 'data' sl 'MyOrganizer.mat'],'myoutputs','-append')
set(handles.list_myoutputs,'String',{myoutputs(:).output});


% --- Executes on button press in btn_addline.
function btn_addline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_output,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';
tabledata{y,2}='';
tabledata{y,3}='';

set(handles.tbl_output,'Data',tabledata)


% --- Executes on button press in btn_addqueueline.
function btn_addqueueline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addqueueline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledata=get(handles.tbl_needs,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';

set(handles.tbl_needs,'Data',tabledata)


% --- Executes on selection change in list_myoutputs.
function list_myoutputs_Callback(hObject, eventdata, handles)
% hObject    handle to list_myoutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_myoutputs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_myoutputs

load data/MyOrganizer.mat myoutputs

contents = cellstr(get(handles.list_myoutputs,'String'));

idx = strmatch(contents{get(handles.list_myoutputs,'Value')}, {myoutputs(:).output});

if isfield(myoutputs(idx),'needs') && ~isempty(myoutputs(idx).needs)
    for r=1:length(myoutputs(idx).needs)
        tabledata{r,1} = myoutputs(idx).needs(r).eval;
    end

    set(handles.tbl_needs,'Data',tabledata)
else
    set(handles.tbl_needs,'Data',[])
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores


% --- Executes during object creation, after setting all properties.
function list_myoutputs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_myoutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
