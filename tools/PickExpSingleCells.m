function varargout = PickExpSingleCells(varargin)
% PICKEXPSINGLECELLS MATLAB code for PickExpSingleCells.fig
%      PICKEXPSINGLECELLS, by itself, creates a new PICKEXPSINGLECELLS or raises the existing
%      singleton*.
%
%      H = PICKEXPSINGLECELLS returns the handle to a new PICKEXPSINGLECELLS or the handle to
%      the existing singleton*.
%
%      PICKEXPSINGLECELLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKEXPSINGLECELLS.M with the given input arguments.
%
%      PICKEXPSINGLECELLS('Property','Value',...) creates a new PICKEXPSINGLECELLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PickExpSingleCells_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PickExpSingleCells_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PickExpSingleCells

% Last Modified by GUIDE v2.5 23-Dec-2014 21:12:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PickExpSingleCells_OpeningFcn, ...
                   'gui_OutputFcn',  @PickExpSingleCells_OutputFcn, ...
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


% --- Executes just before PickExpSingleCells is made visible.
function PickExpSingleCells_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PickExpSingleCells (see VARARGIN)

% Choose default command line output for PickExpSingleCells
handles.output = hObject;

if ispc
    sl='\';
else
    sl='/';
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

disp('about to load all cells')
tic

load([mypath sl 'data' sl 'AllCellsData.mat'])
toc

mytabledata={};
nidx=1;
for n=1:length(AllCells)
    if strcmp(AllCells(n).Experimenter,'Model')==0
        tmp=load([mypath sl 'data' sl 'DetailedData' sl AllCells(n).DetailedData '.mat']);
        DetailedData = tmp.(AllCells(n).DetailedData);
        clear tmp
        mytabledata{nidx,1} = false;
        mytabledata{nidx,2} = AllCells(n).CellType;
        mytabledata{nidx,3} = AllCells(n).CellName;
        mytabledata{nidx,4} = [num2str(DetailedData.AxoClampData.Currents(1)) ':' num2str(DetailedData.AxoClampData.CurrentStepSize) ':' num2str(DetailedData.AxoClampData.Currents(end))];
        mytabledata{nidx,5} = AllCells(n).Notes;
        nidx = nidx + 1;
    end
end


set(handles.table_cells,'data',mytabledata);

system(['rm ' mypath sl  'data' sl 'CompExpCells.mat'])




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PickExpSingleCells wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PickExpSingleCells_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mytabledata = get(handles.table_cells,'data');
save([mypath sl 'data' sl 'CompExpCells.mat'],'mytabledata','-v7.3')
close(handles.output)


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
