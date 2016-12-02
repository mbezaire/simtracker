function varargout = single_compartment_model(varargin)
% SINGLE_COMPARTMENT_MODEL M-file for single_compartment_model.fig
%      SINGLE_COMPARTMENT_MODEL, by itself, creates a new SINGLE_COMPARTMENT_MODEL or raises the existing
%      singleton*.
%
%      H = SINGLE_COMPARTMENT_MODEL returns the handle to a new SINGLE_COMPARTMENT_MODEL or the handle to
%      the existing singleton*.
%
%      SINGLE_COMPARTMENT_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_COMPARTMENT_MODEL.M with the given input arguments.
%
%      SINGLE_COMPARTMENT_MODEL('Property','Value',...) creates a new SINGLE_COMPARTMENT_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_compartment_model_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_compartment_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help single_compartment_model

% Last Modified by GUIDE v2.5 02-Feb-2005 14:58:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                  'gui_Singleton',  gui_Singleton, ...
                  'gui_OpeningFcn', @single_compartment_model_OpeningFcn, ...
                  'gui_OutputFcn',  @single_compartment_model_OutputFcn, ...
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

% --- Executes just before single_compartment_model is made visible.
function single_compartment_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_compartment_model (see VARARGIN)

% Choose default command line output for single_compartment_model
handles.output = hObject;

% Default Parameters
handles.C_m      = 1;
handles.V_Na     = 50;
handles.V_K      = -77;
handles.V_L      = -54.4;
handles.G_Na_Max = 120;
handles.G_K_Max  = 36;
handles.G_L      = 0.3;
handles.I_app    = 10;
handles.V_0      = -65;
handles.t_end    = 10;
handles.taun_x   = 1;
handles.color    = 'b';

% Initial Parameter Boxes
set(handles.C_m_edit,'string',num2str(handles.C_m));
set(handles.V_Na_edit,'string',num2str(handles.V_Na));
set(handles.V_K_edit,'string',num2str(handles.V_K));
set(handles.V_L_edit,'string',num2str(handles.V_L));
set(handles.G_Na_Max_edit,'string',num2str(handles.G_Na_Max));
set(handles.G_K_Max_edit,'string',num2str(handles.G_K_Max));
set(handles.G_L_edit,'string',num2str(handles.G_L));
set(handles.I_app_edit,'string',num2str(handles.I_app));
set(handles.V_0_edit,'string',num2str(handles.V_0));
set(handles.t_end_edit,'string',num2str(handles.t_end));
set(handles.taun_x_edit,'string',num2str(handles.taun_x));
set(handles.hold,'value',true);
hold on

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_compartment_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = single_compartment_model_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function C_m_edit_Callback(hObject, eventdata, handles)
% hObject    handle to C_m_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of C_m_edit as text
%        str2double(get(hObject,'String')) returns contents of C_m_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.C_m));
else
   handles.C_m = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function C_m_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_m_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function V_Na_edit_Callback(hObject, eventdata, handles)
% hObject    handle to V_Na_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_Na_edit as text
%        str2double(get(hObject,'String')) returns contents of V_Na_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.V_Na));
else
   handles.V_Na = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function V_Na_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_Na_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function V_K_edit_Callback(hObject, eventdata, handles)
% hObject    handle to V_K_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_K_edit as text
%        str2double(get(hObject,'String')) returns contents of V_K_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.V_K));
else
   handles.V_K = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function V_K_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_K_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function V_L_edit_Callback(hObject, eventdata, handles)
% hObject    handle to V_L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_L_edit as text
%        str2double(get(hObject,'String')) returns contents of V_L_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.V_L));
else
   handles.V_L = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function V_L_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function G_Na_Max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to G_Na_Max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G_Na_Max_edit as text
%        str2double(get(hObject,'String')) returns contents of G_Na_Max_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.G_Na_Max));
else
   handles.G_Na_Max = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function G_Na_Max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_Na_Max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function G_K_Max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to G_K_Max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G_K_Max_edit as text
%        str2double(get(hObject,'String')) returns contents of G_K_Max_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.G_K_Max));
else
   handles.G_K_Max = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function G_K_Max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_K_Max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function G_L_edit_Callback(hObject, eventdata, handles)
% hObject    handle to G_L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G_L_edit as text
%        str2double(get(hObject,'String')) returns contents of G_L_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.G_L));
else
   handles.G_L = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function G_L_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function I_app_edit_Callback(hObject, eventdata, handles)
% hObject    handle to I_app_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I_app_edit as text
%        str2double(get(hObject,'String')) returns contents of I_app_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.I_app));
else
   handles.I_app = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function I_app_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I_app_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function V_0_edit_Callback(hObject, eventdata, handles)
% hObject    handle to V_0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_0_edit as text
%        str2double(get(hObject,'String')) returns contents of V_0_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.V_0));
else
   handles.V_0 = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function V_0_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_0_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function t_end_edit_Callback(hObject, eventdata, handles)
% hObject    handle to t_end_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_end_edit as text
%        str2double(get(hObject,'String')) returns contents of t_end_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.t_end));
else
   handles.t_end = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function t_end_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_end_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in color_list.
function color_list_Callback(hObject, eventdata, handles)
% hObject    handle to color_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns color_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from color_list
switch get(hObject,'value');
   case 1
       handles.color = 'b';
   case 2
       handles.color = 'r';
   case 3
       handles.color = 'g';
   case 4
       handles.color = 'y';
   case 5
       handles.color = 'k';
   case 6
       handles.color = 'm';
   case 7
       handles.color = 'c';
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function color_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in hold.
function hold_Callback(hObject, eventdata, handles)
% hObject    handle to hold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hold
if get(hObject,'value')
   hold on
else
   hold off
end

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

V_0   = handles.V_0;
m_0   = m_inf(V_0);
h_0   = h_inf(V_0);
n_0   = n_inf(V_0);
t_end = handles.t_end;

[ t y ] = ode15s(@dydt,[0 t_end],[V_0 m_0 h_0 n_0],[],handles);
axes(handles.display);
plot(t,y(:,1),handles.color);
ylabel('V_m (mV)');
xlabel('Time (ms)');
save scm_out t y;

function a = alpha_m(V)
a = -0.1*(V+40)/(exp(-(V+40)/10)-1);

function b = beta_m(V)
b = 4*exp(-(V+65)/18);

function a = alpha_h(V)
a = 0.07*exp(-(V+65)/20);

function b = beta_h(V)
b = 1/(1+exp(-(V+35)/10));

function a = alpha_n(V)
a = -0.01*(V+55)/(exp(-(V+55)/10)-1);

function b = beta_n(V)
b = 0.125*exp(-(V+65)/80);

function inf = m_inf(V)
inf = alpha_m(V)*tau_m(V);

function tau = tau_m(V)
tau = 1/(alpha_m(V)+beta_m(V));

function inf = h_inf(V)
inf = alpha_h(V)*tau_h(V);

function tau = tau_h(V)
tau = 1/(alpha_h(V)+beta_h(V));

function inf = n_inf(V)
inf = alpha_n(V)/(alpha_n(V)+beta_n(V));

function tau = tau_n(V,scale_tau)
tau = scale_tau/(alpha_n(V)+beta_n(V));

function dy = dydt(t,y,handles)
V        = y(1);
m        = y(2);
h        = y(3);
n        = y(4);
G_Na_Max = handles.G_Na_Max;
G_K_Max  = handles.G_K_Max;
G_L      = handles.G_L;
V_Na     = handles.V_Na;
V_K      = handles.V_K;
V_L      = handles.V_L;
C_m      = handles.C_m;
I_app    = handles.I_app;
I_app_t  = .05;
scale_tau= handles.taun_x;

dy = [
   -(G_Na_Max*m^3*h*(V-V_Na) + G_K_Max*n^4*(V-V_K) + G_L*(V-V_L))/C_m;
   (m_inf(V)-m)/tau_m(V);
   (h_inf(V)-h)/tau_h(V);
   (n_inf(V)-n)/tau_n(V,scale_tau);
   ];

%if t < I_app_t, dy(1) = dy(1) + I_app/C_m; end
dy(1) = dy(1) + I_app/C_m; 

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla

function taun_x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to taun_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of taun_x_edit as text
%        str2double(get(hObject,'String')) returns contents of taun_x_edit as a double
if isnan(str2double(get(hObject,'string')))
   set(hObject,'string',num2str(handles.taun_x));
else
   handles.taun_x = str2double(get(hObject,'string'));
   guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function taun_x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to taun_x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
   set(hObject,'BackgroundColor','white');
else
   set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --------------------------------------------------------------------
function menu_file_print_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H = figure('visible','off');
copyobj(handles.display,H)
set(get(H,'currentaxes'),'units','normalized')
set(get(H,'currentaxes'),'position',[0.13 0.11 0.775 0.815])
printdlg(H)
close(H)

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
