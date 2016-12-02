function varargout = generalset(varargin)
% GENERALSET MATLAB code for generalset.fig
%      GENERALSET, by itself, creates a new GENERALSET or raises the existing
%      singleton*.
%
%      H = GENERALSET returns the handle to a new GENERALSET or the handle to
%      the existing singleton*.
%
%      GENERALSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERALSET.M with the given input arguments.
%
%      GENERALSET('Property','Value',...) creates a new GENERALSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generalset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generalset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generalset

% Last Modified by GUIDE v2.5 15-Jul-2016 11:11:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generalset_OpeningFcn, ...
                   'gui_OutputFcn',  @generalset_OutputFcn, ...
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


% --- Executes just before generalset is made visible.
function generalset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generalset (see VARARGIN)

% Choose default command line output for generalset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes generalset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = generalset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% 






% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
global mypath sl cygpath
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')
if ~isfield(general,'rpath')
    general.rpath='';
end

if isfield(general,'clean')==0
    general.clean='-C';
end
if isfield(general,'setenv')==0
    general.setenv=0;
end

if isfield(general,'mercurial')==0
    if ispc
       [~, r]=system([cygpath 'whereis hg']);
        turtle=strfind(r,'TortoiseHg');
        if isempty(turtle)
            general.mercurial='';
        else
            mystarts=strfind(r,'/cygdrive');
            myends=strfind(r,'/hg');
            general.mercurial=r(mystarts(find(mystarts<turtle,1,'last')):myends(find(myends>turtle,1,'first')));
            general.mercurial=['"' strrep(strrep(general.mercurial,'/cygdrive/c','C:'),'/','\') '"'];
        end
    else
        general.mercurial='';
    end
end

% option to save fig files when generated as outputs
set(handles.chk_savefigs,'Value',general.savefigs); % checkbox
set(handles.chk_showfigs,'Value',general.showfigs); % checkbox
set(handles.edit_res,'String',num2str(general.res)); % edit box
set(handles.edit_crop,'String',num2str(general.crop)); % edit box

% choose between clicking output list to open folder or files
set(handles.radio_openfile,'Value',general.outputclick); % radio buttons, 1: open image, 0: open folder
set(handles.radio_openfolder,'Value',abs(general.outputclick-1)); % radio buttons, 1: open image, 0: open folder

% commands used to open things
set(handles.edit_explorer,'String',general.explorer); % edit box
set(handles.edit_picviewer,'String',general.picviewer); % edit box
set(handles.edit_pdfviewer,'String',general.pdfviewer); % edit box
set(handles.edit_textviewer,'String',general.textviewer); % edit box
tmp=strtrim(deblank(general.neuron));
if ~isempty(tmp)
    set(handles.edit_neuron,'String',tmp); % edit box
end
set(handles.edit_python,'String',general.python); % edit box
set(handles.edit_rpath,'String',general.rpath); % edit box
try
    set(handles.txt_cygpath,'String',general.cygpath,'Visible','On'); % edit box
end
set(handles.chk_mpi,'Value',general.mpi);
set(handles.chk_setenv,'Value',general.setenv);


% whether to enter the gsissh passcode at the beginning and use gsissh
set(handles.chk_gsiflag,'Value',general.gsi.flag); % checkbox
set(handles.edit_gsiuser,'String',general.gsi.user); % edit box
set(handles.edit_gsicommand,'String',general.gsi.command); % edit box

% email for supercomputers to send their notifications to
set(handles.edit_email,'String', general.email);
set(handles.chk_roundcoresup,'Value', general.roundcoresup);
try
    set(handles.chk_timelimit,'Value', general.timelimit);
catch
    general.timelimit=1;
end

if isempty(general.clean)
    set(handles.chk_clean,'Value',0)
else
    set(handles.chk_clean,'Value',1)
end

if isempty(general.setenv)
    set(handles.chk_setenv,'Value',0)
else
    set(handles.chk_setenv,'Value',general.setenv)
end



% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)

figure1_CloseRequestFcn(handles.figure1, eventdata, handles);

function savestuff(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

general.neuron=get(handles.edit_neuron,'String');
general.python=get(handles.edit_python,'String');

if ispc
    mystr='.exe';
else
    mystr='';
end
m=findstr(general.neuron,' ');
if ~isempty(m)
    nrnpath=general.neuron(1:m(1)-1);
else
    nrnpath=general.neuron;
end
if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please correct the location','of NEURON''s nrniv executable.'})
    return
end

if ispc && exist([get(handles.txt_cygpath,'String') sl 'bin'],'dir')==0
    msgbox({'Please correct the location','of the Cygwin folder.'})
    return
end


if ispc
    sl='\';
else
    sl='/';
end
load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

% option to save fig files when generated as outputs
general.savefigs=get(handles.chk_savefigs,'Value'); % checkbox
general.showfigs=get(handles.chk_showfigs,'Value'); % checkbox
general.res=str2num(get(handles.edit_res,'String')); % edit box
general.crop=str2num(get(handles.edit_crop,'String')); % edit box

% choose between clicking output list to open folder or files
general.outputclick=get(handles.radio_openfile,'Value'); % radio buttons, 1: open image, 0: open folder

% commands used to open things
general.explorer=get(handles.edit_explorer,'String'); % edit box
general.picviewer=get(handles.edit_picviewer,'String'); % edit box
general.pdfviewer=get(handles.edit_pdfviewer,'String'); % edit box
general.textviewer=get(handles.edit_textviewer,'String'); % edit box
general.neuron=get(handles.edit_neuron,'String');
general.python=get(handles.edit_python,'String');
general.rpath=get(handles.edit_rpath,'String');

general.cygpath=get(handles.txt_cygpath,'String');
general.mpi=get(handles.chk_mpi,'Value');

% whether to enter the gsissh passcode at the beginning and use gsissh
if general.gsi.flag==0 && get(handles.chk_gsiflag,'Value')==1
    launchGSI(handles);
end
general.gsi.flag=get(handles.chk_gsiflag,'Value'); % checkbox
general.gsi.user=get(handles.edit_gsiuser,'String'); % edit box
general.gsi.command=get(handles.edit_gsicommand,'String'); % edit box

% email for supercomputers to send their notifications to
general.email=get(handles.edit_email,'String');
general.roundcoresup=get(handles.chk_roundcoresup,'Value');
general.timelimit=get(handles.chk_timelimit,'Value');
if get(handles.chk_clean,'Value')==1
    general.clean='-C';
else
    general.clean='';
end;
general.setenv=get(handles.chk_setenv,'Value');
if exist([mypath sl 'data'])==0
    mkdir([mypath sl 'data'])
end
if general.setenv==1
    handles.general=general;
    getready2runNRN(handles);
else
    if ispc
        w=strfind(general.neuron,'bin');    
        part2 = ['export N=' strrep(general.neuron(1:w-2),'\','\\') '\nmknrndll'];
        fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
        fprintf(fid,part2);
        fclose(fid);
    end
end

save([mypath sl 'data' sl 'MyOrganizer.mat'],'general','-append')

function launchGSI(handles)
    errorflag=0;
    try
        [status result]=system([get(handles.edit_gsicommand,'String') ' ' get(handles.edit_gsiuser,'String')]);
    catch %#ok<CTCH>
        errorflag=1;
        errorstr='Couldn''t start GSI.';
    end
    if ~isempty(strfind(result,' not recognized'))
        errorflag=1;
        errorstr=result;
    end
    if errorflag==1
        msgbox({errorstr, 'Correct the GSI command and turn it back on.'})
        set(handles.chk_gsiflag,'Value',0)
    end

% --- Executes on button press in chk_savefigs.
function chk_savefigs_Callback(hObject, eventdata, handles)
% hObject    handle to chk_savefigs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_savefigs


% --- Executes on button press in chk_showfigs.
function chk_showfigs_Callback(hObject, eventdata, handles)
% hObject    handle to chk_showfigs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_showfigs



function edit_res_Callback(hObject, eventdata, handles)
% hObject    handle to edit_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_res as text
%        str2double(get(hObject,'String')) returns contents of edit_res as a double


% --- Executes during object creation, after setting all properties.
function edit_res_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radio_openfolder.
function radio_openfolder_Callback(hObject, eventdata, handles)
% hObject    handle to radio_openfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_openfolder

set(handles.radio_openfile,'Value',0)
set(handles.radio_openfolder,'Value',1)

% --- Executes on button press in radio_openfile.
function radio_openfile_Callback(hObject, eventdata, handles)
% hObject    handle to radio_openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_openfile

set(handles.radio_openfile,'Value',1)
set(handles.radio_openfolder,'Value',0)


function edit_explorer_Callback(hObject, eventdata, handles)
% hObject    handle to edit_explorer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_explorer as text
%        str2double(get(hObject,'String')) returns contents of edit_explorer as a double


% --- Executes during object creation, after setting all properties.
function edit_explorer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_explorer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_picviewer_Callback(hObject, eventdata, handles)
% hObject    handle to edit_picviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_picviewer as text
%        str2double(get(hObject,'String')) returns contents of edit_picviewer as a double


% --- Executes during object creation, after setting all properties.
function edit_picviewer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_picviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pdfviewer_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pdfviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pdfviewer as text
%        str2double(get(hObject,'String')) returns contents of edit_pdfviewer as a double


% --- Executes during object creation, after setting all properties.
function edit_pdfviewer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pdfviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_textviewer_Callback(hObject, eventdata, handles)
% hObject    handle to edit_textviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_textviewer as text
%        str2double(get(hObject,'String')) returns contents of edit_textviewer as a double


% --- Executes during object creation, after setting all properties.
function edit_textviewer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_textviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_gsiflag.
function chk_gsiflag_Callback(hObject, eventdata, handles)
% hObject    handle to chk_gsiflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_gsiflag



function edit_gsiuser_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gsiuser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gsiuser as text
%        str2double(get(hObject,'String')) returns contents of edit_gsiuser as a double


% --- Executes during object creation, after setting all properties.
function edit_gsiuser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gsiuser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_gsicommand_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gsicommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gsicommand as text
%        str2double(get(hObject,'String')) returns contents of edit_gsicommand as a double


% --- Executes during object creation, after setting all properties.
function edit_gsicommand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gsicommand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_email_Callback(hObject, eventdata, handles)
% hObject    handle to edit_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_email as text
%        str2double(get(hObject,'String')) returns contents of edit_email as a double


% --- Executes during object creation, after setting all properties.
function edit_email_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_neuron_Callback(hObject, eventdata, handles)
% hObject    handle to edit_neuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_neuron as text
%        str2double(get(hObject,'String')) returns contents of edit_neuron as a double


% --- Executes during object creation, after setting all properties.
function edit_neuron_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_neuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_roundcoresup.
function chk_roundcoresup_Callback(hObject, eventdata, handles)
% hObject    handle to chk_roundcoresup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_roundcoresup


% --- Executes on button press in chk_mpi.
function chk_mpi_Callback(hObject, eventdata, handles)
% hObject    handle to chk_mpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_mpi



function txt_cygpath_Callback(hObject, eventdata, handles)
% hObject    handle to txt_cygpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_cygpath as text
%        str2double(get(hObject,'String')) returns contents of txt_cygpath as a double


% --- Executes during object creation, after setting all properties.
function txt_cygpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_cygpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if ispc==0
    set(hObject,'Visible','Off')
    try
    set(handles.cyglabel,'Visible','Off')
    end
end

% --- Executes on button press in chk_timelimit.
function chk_timelimit_Callback(hObject, eventdata, handles)
% hObject    handle to chk_timelimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_timelimit



function edit_rpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rpath as text
%        str2double(get(hObject,'String')) returns contents of edit_rpath as a double


% --- Executes during object creation, after setting all properties.
function edit_rpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_clean.
function chk_clean_Callback(hObject, eventdata, handles)
% hObject    handle to chk_clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_clean


% --- Executes on button press in chk_setenv.
function chk_setenv_Callback(hObject, eventdata, handles)
% hObject    handle to chk_setenv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_setenv



function edit_crop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_crop as text
%        str2double(get(hObject,'String')) returns contents of edit_crop as a double


% --- Executes during object creation, after setting all properties.
function edit_crop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_python_Callback(hObject, eventdata, handles)
% hObject    handle to edit_python (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_python as text
%        str2double(get(hObject,'String')) returns contents of edit_python as a double


% --- Executes during object creation, after setting all properties.
function edit_python_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_python (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    savestuff(handles.btn_save, [], handles);
    delete(hObject); % calls figure1_DeleteFcn
catch ME
    handleME(ME)
end