function varargout = PickOutputs(varargin)
% PICKOUTPUTS MATLAB code for PickOutputs.fig
%      PICKOUTPUTS, by itself, creates a new PICKOUTPUTS or raises the existing
%      singleton*.
%
%      H = PICKOUTPUTS returns the handle to a new PICKOUTPUTS or the handle to
%      the existing singleton*.
%
%      PICKOUTPUTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKOUTPUTS.M with the given input arguments.
%
%      PICKOUTPUTS('Property','Value',...) creates a new PICKOUTPUTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PickOutputs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PickOutputs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PickOutputs

% Last Modified by GUIDE v2.5 22-Dec-2014 11:43:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PickOutputs_OpeningFcn, ...
                   'gui_OutputFcn',  @PickOutputs_OutputFcn, ...
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


% --- Executes just before PickOutputs is made visible.
function PickOutputs_OpeningFcn(hObject, eventdata, handles, varargin)
global outputs cellproperties
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PickOutputs (see VARARGIN)

% Choose default command line output for PickOutputs
handles.output = hObject;

possfigformats = {'jpeg','png','tiff','bmp','pdf'};
possfigtypes = cellproperties;

set(handles.list_figformats,'String',possfigformats)
set(handles.list_figtypes,'String',possfigtypes)

if exist('Analysis.mat','file')
    load('Analysis.mat'); %,'Analysis','Defaults')
    if exist('outputs','var') && ~isempty(outputs)
        set(handles.chk_matlab,'Value',outputs.matlab_figures)
        set(handles.chk_images,'Value',outputs.other_figures)
        set(handles.chk_excel,'Value',outputs.figure_data)
        v=[];
        try
        for b=1:length(outputs.figformats)
            v=[v strmatch(outputs.figformats{b},possfigformats)];
        end
        catch
            b
        end
        set(handles.list_figformats,'Value',v)
        
        v=[];
        for b=1:length(outputs.figtypes)
            v=[v strmatch(outputs.figtypes{b},possfigtypes)];
        end
        set(handles.list_figtypes,'Value',v)
    end
end
chk_images_Callback(handles.chk_images, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PickOutputs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PickOutputs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chk_matlab.
function chk_matlab_Callback(hObject, eventdata, handles)
% hObject    handle to chk_matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_matlab


% --- Executes on selection change in list_figformats.
function list_figformats_Callback(hObject, eventdata, handles)
% hObject    handle to list_figformats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_figformats contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_figformats


% --- Executes during object creation, after setting all properties.
function list_figformats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_figformats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_figtypes.
function list_figtypes_Callback(hObject, eventdata, handles)
% hObject    handle to list_figtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_figtypes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_figtypes


% --- Executes during object creation, after setting all properties.
function list_figtypes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_figtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_images.
function chk_images_Callback(hObject, eventdata, handles)
% hObject    handle to chk_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_images

if get(hObject,'Value')==1
    set(handles.list_figformats,'Visible','On')
else
    set(handles.list_figformats,'Visible','Off')
end


% --- Executes on button press in chk_excel.
function chk_excel_Callback(hObject, eventdata, handles)
% hObject    handle to chk_excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_excel


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
global outputs
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputs.matlab_figures = get(handles.chk_matlab,'Value');
outputs.other_figures = get(handles.chk_images,'Value');
outputs.figure_data = get(handles.chk_excel,'Value');
outputs.possfigformats = get(handles.list_figformats,'String');
outputs.figformats = outputs.possfigformats(get(handles.list_figformats,'Value'));
outputs.possfigtypes = get(handles.list_figtypes,'String');
outputs.figtypes = outputs.possfigtypes(get(handles.list_figtypes,'Value'));
outputs.figidx = get(handles.list_figtypes,'Value');
if exist('Analysis.mat','file')
    save('Analysis.mat','outputs','-append');
else
    save('Analysis.mat','outputs','-v7.3');
end
close(handles.output);


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
global outputs
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputs=[];
close(handles.output);
