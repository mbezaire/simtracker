function varargout = archive_gui(varargin)
% ARCHIVE_GUI MATLAB code for archive_gui.fig
%      ARCHIVE_GUI, by itself, creates a new ARCHIVE_GUI or raises the existing
%      singleton*.
%
%      H = ARCHIVE_GUI returns the handle to a new ARCHIVE_GUI or the handle to
%      the existing singleton*.
%
%      ARCHIVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARCHIVE_GUI.M with the given input arguments.
%
%      ARCHIVE_GUI('Property','Value',...) creates a new ARCHIVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before archive_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to archive_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help archive_gui

% Last Modified by GUIDE v2.5 12-Feb-2013 08:56:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @archive_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @archive_gui_OutputFcn, ...
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


% --- Executes just before archive_gui is made visible.
function archive_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to archive_gui (see VARARGIN)
global mypath sl

% Choose default command line output for archive_gui
handles.output = hObject;

if ~isempty(varargin)
    handles.showalloptions=varargin{1};
    if handles.showalloptions==0
        set(handles.btn_append ,'Visible','off')
        set(handles.btn_view ,'Visible','off')
        set(handles.btn_cancel ,'Visible','off')
        set(handles.list_archive ,'Visible','off')
    end
end
handles.loadtype='';
handles.val=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes archive_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


q=getcurrepos(handles,1);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

backupfolder = getbackup(myrepos(q).dir);

d=dir([backupfolder sl '*_*']);

mylist = {d.name};

% find last underscore in name
% harvest name before that underscore
for r=1:length(mylist)
    uspl = strfind(mylist{r},'_');
    mylist{r}=mylist{r}(1:uspl(end)-1);
end

% get unique names
uniqlist = unique(mylist);

% make them the list
if ~isempty(uniqlist)
    set(handles.list_archive,'String',uniqlist);
else
    set(handles.list_archive,'Style','text','String','No archives/backups found');
end

for r=1:length(myrepos)
    dirlist{r}=[myrepos(r).name ': ' myrepos(r).dir];
end

set(handles.list_current,'String',dirlist);
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = archive_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.loadtype;
varargout{3} = handles.val;
delete(handles.figure1)

% --- Executes on selection change in list_current.
function list_current_Callback(hObject, eventdata, handles)
% hObject    handle to list_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_current contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_current


% --- Executes during object creation, after setting all properties.
function list_current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_archive.
function list_archive_Callback(hObject, eventdata, handles)
% hObject    handle to list_archive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_archive contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_archive

% --- Executes during object creation, after setting all properties.
function list_archive_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_archive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.btn_view, 'Value')==1 || get(handles.btn_append, 'Value')==1
    contents = cellstr(get(handles.list_archive,'String'));
    handles.loadtype = contents{get(handles.list_archive,'Value')};
    handles.val=2;
    if get(handles.btn_view, 'Value')==1
        handles.val=3;
    end
else
    contents = cellstr(get(handles.list_current,'String'));
    handles.loadtype = contents{get(handles.list_current,'Value')};
    handles.val=1;
    
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos');
    
    for q=1:length(myrepos)
        myrepos(q).current=0;
    end
    r=get(handles.list_current,'Value');
    myrepos(r).current=1;
    save([mypath sl 'data' sl 'myrepos.mat'],'myrepos','-append')
end

guidata(hObject, handles);
uiresume()

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.loadtype = 'Cancel';
handles.val = 0;
guidata(hObject, handles);
uiresume()


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
