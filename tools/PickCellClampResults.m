function varargout = PickCellClampResults(varargin)
% PICKCELLCLAMPRESULTS MATLAB code for PickCellClampResults.fig
%      PICKCELLCLAMPRESULTS, by itself, creates a new PICKCELLCLAMPRESULTS or raises the existing
%      singleton*.
%
%      H = PICKCELLCLAMPRESULTS returns the handle to a new PICKCELLCLAMPRESULTS or the handle to
%      the existing singleton*.
%
%      PICKCELLCLAMPRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKCELLCLAMPRESULTS.M with the given input arguments.
%
%      PICKCELLCLAMPRESULTS('Property','Value',...) creates a new PICKCELLCLAMPRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PickCellClampResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PickCellClampResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PickCellClampResults

% Last Modified by GUIDE v2.5 22-Dec-2014 12:54:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PickCellClampResults_OpeningFcn, ...
                   'gui_OutputFcn',  @PickCellClampResults_OutputFcn, ...
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


% --- Executes just before PickCellClampResults is made visible.
function PickCellClampResults_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PickCellClampResults (see VARARGIN)

% Choose default command line output for PickCellClampResults
handles.output = hObject;
if ispc
    sl='\';
else
    sl='/';
end

% Update handles structure
guidata(hObject, handles);

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end

handles.directoryname = myrepos(q).dir;

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')

gidx=1;
for g=1:length(mydesc)
    if exist([handles.directoryname sl 'cellclamp_results' sl mydesc(g).name sl 'GUIvalues.mat'],'file')
        load([handles.directoryname sl 'cellclamp_results' sl mydesc(g).name sl 'GUIvalues.mat'],'GUIvalues');
        if (GUIvalues.chk_cellclamp.value==1)
            tabledata{gidx,1}=false;
            tabledata{gidx,2}=mydesc(g).name;
            tabledata{gidx,3}=mydesc(g).desc;
            tabledata{gidx,4}=sprintf('%s;',GUIvalues.list_cell(1).value{GUIvalues.list_cell(2).value});
            gidx = gidx + 1;
        end
    end
end

set(handles.table_runs,'data',sortrows(tabledata,-2))
% UIWAIT makes PickCellClampResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PickCellClampResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_submit.
function btn_submit_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.table_runs,'data');
ridx=1;
for r=1:size(tabledata,1)
    if tabledata{r,1}==true
        MyCells(ridx).Run=tabledata{r,2};
        MyCells(ridx).Cells=tabledata{r,4};
        ridx = ridx + 1;
    end
end

save([mypath sl 'data' sl 'MyCells.mat'],'MyCells','-v7.3')
close(handles.output);


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist([mypath sl 'data' sl 'MyCells.mat'],'file')
    system(['rm ' mypath sl 'data' sl 'MyCells.mat']);
end
close(handles.output);

