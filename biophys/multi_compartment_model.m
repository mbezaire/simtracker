function varargout = multi_compartment_model(varargin)
% MULTI_COMPARTMENT_MODEL M-file for multi_compartment_model.fig
%      MULTI_COMPARTMENT_MODEL, by itself, creates a new MULTI_COMPARTMENT_MODEL or raises the existing
%      singleton*.
%
%      H = MULTI_COMPARTMENT_MODEL returns the handle to a new MULTI_COMPARTMENT_MODEL or the handle to
%      the existing singleton*.
%
%      MULTI_COMPARTMENT_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTI_COMPARTMENT_MODEL.M with the given input arguments.
%
%      MULTI_COMPARTMENT_MODEL('Property','Value',...) creates a new MULTI_COMPARTMENT_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multi_compartment_model_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multi_compartment_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help multi_compartment_model

% Last Modified by GUIDE v2.5 28-Jan-2005 09:20:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multi_compartment_model_OpeningFcn, ...
                   'gui_OutputFcn',  @multi_compartment_model_OutputFcn, ...
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


% --- Executes just before multi_compartment_model is made visible.
function multi_compartment_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multi_compartment_model (see VARARGIN)

% Choose default command line output for multi_compartment_model
handles.output = hObject;

% Default Parameters
handles.C_m      = 1;
handles.V_Na     = 50;
handles.V_K      = -77;
handles.V_L      = -54.4;
handles.G_Na_Max = 120;
handles.G_K_Max  = 36;
handles.G_L      = 0.3;
handles.V_0      = -65;
handles.t_end    = 15;
handles.J_app    = 100;
handles.J_app_z  = 0;
handles.J_n_dz   = 5;
handles.J_app_t  = 2;
handles.L        = 3;
handles.dz       = 0.01;
handles.a        = 25e-3;
handles.rho      = 35;

% Initialize Parameter Boxes
set(handles.C_m_edit,'string',num2str(handles.C_m));
set(handles.V_Na_edit,'string',num2str(handles.V_Na));
set(handles.V_K_edit,'string',num2str(handles.V_K));
set(handles.V_L_edit,'string',num2str(handles.V_L));
set(handles.G_Na_Max_edit,'string',num2str(handles.G_Na_Max));
set(handles.G_K_Max_edit,'string',num2str(handles.G_K_Max));
set(handles.G_L_edit,'string',num2str(handles.G_L));
set(handles.V_0_edit,'string',num2str(handles.V_0));
set(handles.t_end_edit,'string',num2str(handles.t_end));
set(handles.J_app_edit,'string',num2str(handles.J_app));
set(handles.J_app_z_edit,'string',num2str(handles.J_app_z));
set(handles.J_app_t_edit,'string',num2str(handles.J_app_t));
set(handles.L_edit,'string',num2str(handles.L));
set(handles.dz_edit,'string',num2str(handles.dz));
set(handles.a_edit,'string',num2str(handles.a));
set(handles.rho_edit,'string',num2str(handles.rho));

% Initialize Internal Variables
handles.N = max([1 round(handles.L/handles.dz)]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multi_compartment_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multi_compartment_model_OutputFcn(hObject, eventdata, handles) 
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


function J_app_edit_Callback(hObject, eventdata, handles)
% hObject    handle to J_app_z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of J_app_z_edit as text
%        str2double(get(hObject,'String')) returns contents of J_app_z_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.J_app));
else
    handles.J_app = str2double(get(hObject,'string'));
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function J_app_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to J_app_z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function J_app_z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_V_0_label_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_V_0_label_edit as text
%        str2double(get(hObject,'String')) returns contents of z_V_0_label_edit as a double
J_app_z = str2double(get(hObject,'string'));
if isnan(J_app_z)
    set(hObject,'string',num2str(handles.J_app_z));
elseif J_app_z > handles.J_n_dz * handles.dz
    warndlg('J_app_z must be <= 5 * dz', 'Bad parameter value');
    set(handles.J_app_z_edit,'string',num2str(handles.J_app_z));
else
    handles.J_app_z = J_app_z;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function J_app_z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_V_0_label_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function J_app_t_edit_Callback(hObject, eventdata, handles)
% hObject    handle to J_app_t_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of J_app_t_edit as text
%        str2double(get(hObject,'String')) returns contents of J_app_t_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.J_app_t));
else
    handles.J_app_t = str2double(get(hObject,'string'));
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function J_app_t_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to J_app_t_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function L_edit_Callback(hObject, eventdata, handles)
% hObject    handle to L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L_edit as text
%        str2double(get(hObject,'String')) returns contents of L_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.L));
else
    handles.L = str2double(get(hObject,'string'));
    handles.N = max([1 round(handles.L/handles.dz)]);
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function L_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz_edit as text
%        str2double(get(hObject,'String')) returns contents of dz_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.dz));
else
    handles.dz = str2double(get(hObject,'string'));
    handles.N = max([1 round(handles.L/handles.dz)]);
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function dz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_edit as text
%        str2double(get(hObject,'String')) returns contents of a_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.a));
else
    handles.a = str2double(get(hObject,'string'));
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rho_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rho_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rho_edit as text
%        str2double(get(hObject,'String')) returns contents of rho_edit as a double
if isnan(str2double(get(hObject,'string')))
    set(hObject,'string',num2str(handles.rho));
else
    handles.rho = str2double(get(hObject,'string'));
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function rho_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tic

N     = handles.N;
dz    = handles.dz;
t_end = handles.t_end;

% Setup Initial Conditions
y_0 = [];
for i = 1:N
    y_0(4*i-3) = handles.V_0;
    y_0(4*i-2) = m_inf(handles.V_0);
    y_0(4*i-1) = h_inf(handles.V_0);
    y_0(4*i-0) = n_inf(handles.V_0);
end

% Specify fields important to the Jacobian
jac = sparse(4*N,4*N);
jac(1,1:5) = 1;
jac(2,2) = 1;
jac(3,3) = 1;
jac(4,4) = 1;
for i = 2:N-1
    jac(4*i-3,4*i-7) = 1;
    jac(4*i-3,4*i-3:4*i+1) = 1;
    jac(4*i-2,4*i-2) = 1;
    jac(4*i-1,4*i-1) = 1;
    jac(4*i,4*i) = 1;
end
jac(4*N-3,4*N-7) = 1;
jac(4*N-3,4*N-3:4*N) = 1;
jac(4*N-2,4*N-2) = 1;
jac(4*N-1,4*N-1) = 1;
jac(4*N,4*N) = 1;

options = odeset('JPattern',jac);
[ t y ] = ode15s(@dydt,[0 t_end],y_0,options,handles);

V = zeros(N,length(t));
for i = 1:N
    for j = 1:length(t)
        V(i,j) = y(j,4*i-3);
    end
end

imagesc(t,dz*(1:N),V)
colorbar('EastOutside')
title('Voltage (mV) vs. Space & Time')
xlabel('Time (ms)')
ylabel('Space (cm)')
save mcm_output V t dz
toc

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
inf = alpha_n(V)*tau_n(V);

function tau = tau_n(V)
tau = 1/(alpha_n(V)+beta_n(V));

function V = get_V(y,z)
V = y(4*z-3);

function m = get_m(y,z)
m = y(4*z-2);

function h = get_h(y,z)
h = y(4*z-1);

function n = get_n(y,z)
n = y(4*z);

function dy = dydt(t,y,handles)
% dynamical system equations passed to ODE
dy = zeros(size(y));

% disp(['t = ' num2str(t)])

% Setup local variables from GUI form
G_Na_Max = handles.G_Na_Max;
G_K_Max  = handles.G_K_Max;
G_L      = handles.G_L;
V_Na     = handles.V_Na;
V_K      = handles.V_K;
V_L      = handles.V_L;
C_m      = handles.C_m;
a        = handles.a;
rho      = handles.rho;
L        = handles.L;
dz       = handles.dz;
N        = handles.N;
J_app = handles.J_app;
J_app_t = handles.J_app_t_edit;
J_app_z = handles.J_app_z;
J_n_dz = handles.J_n_dz;

% Solve First Compartment
% equations from Hodgkin-Huxley 1952 
V = get_V(y,1);
m = get_m(y,1); % Na activn
h = get_h(y,1); % Na inactv 
n = get_n(y,1); % K+ activn
G_Na = G_Na_Max * m^3 * h;  % HH eq. 14
G_K  = G_K_Max * n^4;	    % HH eq. 6 
d2Vdz2 = (get_V(y,2)-V)/dz^2;  % partial deriv. [area]
dy(1) = ((a/(2*rho*1.e-3)) * d2Vdz2 - G_Na*(V-V_Na) - G_K*(V-V_K) - G_L*(V-V_L))/C_m;
dy(2) = (m_inf(V)-m)/tau_m(V);
dy(3) = (h_inf(V)-h)/tau_h(V);
dy(4) = (n_inf(V)-n)/tau_n(V);

% Solve Middle Compartments
for i = 2:N-1
    V = get_V(y,i);
    m = get_m(y,i);
    h = get_h(y,i);
    n = get_n(y,i);

    G_Na = G_Na_Max * m^3 * h;  % HH eq. 14
    G_K  = G_K_Max * n^4;	% HH eq. 6 
    d2Vdz2 = (get_V(y,i-1)-2*V+get_V(y,i+1))/dz^2;
    
    dy(4*i-3) = ((a/(2*rho*1.e-3)) * d2Vdz2 - G_Na*(V-V_Na) - G_K*(V-V_K) - G_L*(V-V_L))/C_m;
    dy(4*i-2) = (m_inf(V)-m)/tau_m(V);
    dy(4*i-1) = (h_inf(V)-h)/tau_h(V);
    dy(4*i)   = (n_inf(V)-n)/tau_n(V);
end

% Solve Last Compartment
V = get_V(y,N);
m = get_m(y,N);
h = get_h(y,N);
n = get_n(y,N);
G_Na = G_Na_Max * m^3 * h; % HH eq. 14
G_K  = G_K_Max * n^4;      % HH eq. 6
d2Vdz2 = (get_V(y,N-1)-V)/dz^2;
dy(4*N-3) = ((a/(2*rho*1.e-3)) * d2Vdz2 - G_Na*(V-V_Na) - G_K*(V-V_K) - G_L*(V-V_L))/C_m;
dy(4*N-2) = (m_inf(V)-m)/tau_m(V);
dy(4*N-1) = (h_inf(V)-h)/tau_h(V);
dy(4*N)   = (n_inf(V)-n)/tau_n(V);

% Inject Current
if t < J_app_t
    i = max([1 min([N round(J_app_z*N/L)])]);
    for ij = i:J_n_dz
       dy(4*ij-3) = dy(4*ij-3) + J_app/C_m;
    end
end
