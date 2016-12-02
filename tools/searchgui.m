function varargout = searchgui(varargin)
% SEARCHGUI MATLAB code for searchgui.fig
%      SEARCHGUI, by itself, creates a new SEARCHGUI or raises the existing
%      singleton*.
%
%      H = SEARCHGUI returns the handle to a new SEARCHGUI or the handle to
%      the existing singleton*.
%
%      SEARCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEARCHGUI.M with the given input arguments.
%
%      SEARCHGUI('Property','Value',...) creates a new SEARCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before searchgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to searchgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help searchgui

% Last Modified by GUIDE v2.5 15-Feb-2013 11:26:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @searchgui_OpeningFcn, ...
                   'gui_OutputFcn',  @searchgui_OutputFcn, ...
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


% --- Executes just before searchgui is made visible.
function searchgui_OpeningFcn(hObject, eventdata, handles, varargin)
global searchterms
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to searchgui (see VARARGIN)

% Choose default command line output for searchgui
handles.output = hObject;

% Update handles structure
tmp = varargin{1};

for r=1:length(tmp)
    b=length(tmp{r});
    z=min(b,50);
    tmp{r}=tmp{r}(1:z);
end

set(handles.tbl_search,'RowName',tmp)
set(handles.tbl_search,'Data',repmat({''},length(tmp),2))
set(handles.tbl_search,'ColumnEditable',logical(1))
handles.tmp=tmp;
guidata(hObject, handles);

% UIWAIT makes searchgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = searchgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_OK.
function btn_OK_Callback(hObject, eventdata, handles)
global searchterms
% hObject    handle to btn_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(handles.tbl_search,'Data');
for r=1:size(tmp,1);
    if strcmp(tmp{r,1},' ')
        tmp{r,1}='';
    end
end

g=size(handles.tmp(:),1);
tmp=tmp(1:g,:);

searchterms = tmp(:,1);
close(handles.figure1)
