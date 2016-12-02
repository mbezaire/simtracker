function varargout = groupset(varargin)
% GROUPSET MATLAB code for groupset.fig
%      GROUPSET, by itself, creates a new GROUPSET or raises the existing
%      singleton*.
%
%      H = GROUPSET returns the handle to a new GROUPSET or the handle to
%      the existing singleton*.
%
%      GROUPSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUPSET.M with the given input arguments.
%
%      GROUPSET('Property','Value',...) creates a new GROUPSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before groupset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to groupset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help groupset

% Last Modified by GUIDE v2.5 12-Feb-2013 11:54:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @groupset_OpeningFcn, ...
                   'gui_OutputFcn',  @groupset_OutputFcn, ...
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


% --- Executes just before groupset is made visible.
function groupset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to groupset (see VARARGIN)

% Choose default command line output for groupset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes groupset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = groupset_OutputFcn(hObject, eventdata, handles) 
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

load([mypath sl 'data' sl 'MyOrganizer.mat'],'groups')

for r=1:length(groups)
    tabledata{r,1} = groups(r).name;
    tabledata{r,2} = groups(r).date;
end

set(handles.tbl_group,'Data',tabledata)


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_group,'Data');

for r=1:size(tabledata,1)
    if ~isempty(tabledata{r,1}) && ~isempty(tabledata{r,2})
        groups(r).name=tabledata{r,1};
        groups(r).date=tabledata{r,2};
    end
end

save([mypath sl 'data' sl 'MyOrganizer.mat'],'groups','-append')


% --- Executes on button press in btn_addline.
function btn_addline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_group,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';
tabledata{y,2}=datestr(now);

set(handles.tbl_group,'Data',tabledata)
