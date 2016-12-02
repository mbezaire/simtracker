function varargout = errorset(varargin)
% ERRORSET MATLAB code for errorset.fig
%      ERRORSET, by itself, creates a new ERRORSET or raises the existing
%      singleton*.
%
%      H = ERRORSET returns the handle to a new ERRORSET or the handle to
%      the existing singleton*.
%
%      ERRORSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERRORSET.M with the given input arguments.
%
%      ERRORSET('Property','Value',...) creates a new ERRORSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before errorset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to errorset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help errorset

% Last Modified by GUIDE v2.5 08-Feb-2013 13:25:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @errorset_OpeningFcn, ...
                   'gui_OutputFcn',  @errorset_OutputFcn, ...
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


% --- Executes just before errorset is made visible.
function errorset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to errorset (see VARARGIN)

% Choose default command line output for errorset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes errorset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = errorset_OutputFcn(hObject, eventdata, handles) 
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

load([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors')

for r=1:length(myerrors)
    tabledata{r,1} = myerrors(r).category;
    tabledata{r,2} = myerrors(r).errorphrase;
    tabledata{r,3} = myerrors(r).description;
end

set(handles.tbl_error,'Data',tabledata)


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_error,'Data');

for r=1:size(tabledata,1)
    if ~isempty(tabledata{r,1}) && ~isempty(tabledata{r,2}) && ~isempty(tabledata{r,3})
        myerrors(r).category=tabledata{r,1};
        myerrors(r).errorphrase=tabledata{r,2};
        myerrors(r).description=tabledata{r,3};
    end
end

save([mypath sl 'data' sl 'MyOrganizer.mat'],'myerrors','-append')


% --- Executes on button press in btn_addline.
function btn_addline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_error,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';
tabledata{y,2}='';
tabledata{y,3}='';

set(handles.tbl_error,'Data',tabledata)


