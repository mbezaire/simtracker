function varargout = PairPicker(varargin)
% PAIRPICKER MATLAB code for PairPicker.fig
%      PAIRPICKER, by itself, creates a new PAIRPICKER or raises the existing
%      singleton*.
%
%      H = PAIRPICKER returns the handle to a new PAIRPICKER or the handle to
%      the existing singleton*.
%
%      PAIRPICKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAIRPICKER.M with the given input arguments.
%
%      PAIRPICKER('Property','Value',...) creates a new PAIRPICKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PairPicker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PairPicker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PairPicker

% Last Modified by GUIDE v2.5 23-Dec-2014 23:29:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PairPicker_OpeningFcn, ...
                   'gui_OutputFcn',  @PairPicker_OutputFcn, ...
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


% --- Executes just before PairPicker is made visible.
function PairPicker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PairPicker (see VARARGIN)

% Choose default command line output for PairPicker
handles.output = hObject;

expsyns = expsyndata();

prefields = fieldnames(expsyns);

mytabledata={};
nidx=1;
for n=1:length(prefields)
    pr = prefields{n};
    postfields = fieldnames(expsyns(1).(pr));
    for p=1:length(postfields)
        po = postfields{p};
        for t=1:length(expsyns)
            if ~isempty(expsyns(t).(pr)) && isfield(expsyns(t).(pr),po) &&  ~isempty(expsyns(t).(pr).(po))                
                mytabledata{nidx,1} = false;
                mytabledata{nidx,2} = pr;
                mytabledata{nidx,3} = po;
                mytabledata{nidx,4} = expsyns(t).(pr).(po).Clamp;
                mytabledata{nidx,5} = expsyns(t).(pr).(po).ref;
                mytabledata{nidx,6} = t;
                nidx = nidx + 1;
            end
        end
    end
end

set(handles.table_pairs,'data',mytabledata);

system('rm data/CompPairs.mat')



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PairPicker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PairPicker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.output)


% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mytabledata = get(handles.table_pairs,'data');

save([mypath sl 'data' sl 'CompPairs.mat'],'mytabledata','-v7.3')
close(handles.output)
