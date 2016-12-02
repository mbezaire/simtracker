function varargout = MRF_gui(varargin)
% MRF_GUI MATLAB code for MRF_gui.fig
%      MRF_GUI, by itself, creates a new MRF_GUI or raises the existing
%      singleton*.
%
%      H = MRF_GUI returns the handle to a new MRF_GUI or the handle to
%      the existing singleton*.
%
%      MRF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MRF_GUI.M with the given input arguments.
%
%      MRF_GUI('Property','Value',...) creates a new MRF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MRF_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MRF_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MRF_gui

% Last Modified by GUIDE v2.5 27-May-2016 04:52:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MRF_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @MRF_gui_OutputFcn, ...
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


% --- Executes just before MRF_gui is made visible.
function MRF_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MRF_gui (see VARARGIN)
global mypath AllCells sl

% Choose default command line output for MRF_gui
handles.output = hObject;

% populate the biological and model cell menus (others populated upon
% selection)

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

if exist([mypath sl  'data' sl 'AllCellsData.mat'],'file')
    load([mypath sl  'data' sl 'AllCellsData.mat'],'AllCells');
    set(handles.popmenu_biologicalcell,'String',{AllCells(:).CellName},'Value',1)
    load([mypath sl  'DetailedData' sl AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData])
    eval(['DetailedData=' AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData ';'])

    ivec=DetailedData.AxoClampData.Currents;%AllCells(get(handles.popmenu_biologicalcell,'Value')).CurrentRange;
    mystr={};
    for r=1:length(ivec)
        mystr{r}=[num2str(ivec(r)) ' ' DetailedData.AxoClampData.CurrentUnits];
    end
    set(handles.popmenu_current,'String',mystr,'Value',1)

    d=dir([myrepos(q).dir sl 'cells' sl 'class_*cell.hoc']);
    set(handles.popmenu_modelcell,'String',{d(:).name},'Value',1)
else
    msgbox('No experimental data loaded')
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MRF_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MRF_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popmenu_biologicalcell.
function popmenu_biologicalcell_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_biologicalcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmenu_biologicalcell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_biologicalcell
global mypath AllCells sl

    load([mypath sl 'data' sl 'DetailedData' sl AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData])
    eval(['DetailedData=' AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData ';'])

    ivec=DetailedData.AxoClampData.Currents;%AllCells(get(handles.popmenu_biologicalcell,'Value')).CurrentRange;
    mystr={};
    for r=1:length(ivec)
        mystr{r}=[num2str(ivec(r)) ' ' DetailedData.AxoClampData.CurrentUnits];
    end
    set(handles.popmenu_current,'String',mystr,'Value',1)

% --- Executes during object creation, after setting all properties.
function popmenu_biologicalcell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_biologicalcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popmenu_current.
function popmenu_current_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmenu_current contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_current


% --- Executes during object creation, after setting all properties.
function popmenu_current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popmenu_modelcell.
function popmenu_modelcell_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu_modelcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmenu_modelcell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu_modelcell


% --- Executes during object creation, after setting all properties.
function popmenu_modelcell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu_modelcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_parameters.
function list_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to list_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_parameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_parameters


% --- Executes during object creation, after setting all properties.
function list_parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath AllCells sl myhandles

q=getcurrepos(handles);
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')


% Make the biological data file
currents = cellstr(get(handles.popmenu_current,'String'));
biocells = cellstr(get(handles.popmenu_biologicalcell,'String'));
modelcells = cellstr(get(handles.popmenu_modelcell,'String'));
load([mypath sl 'data' sl 'DetailedData' sl AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData])
eval(['DetailedData=' AllCells(get(handles.popmenu_biologicalcell,'Value')).DetailedData])
numlines = length(DetailedData.AxoClampData.Time.Data);

if exist([myrepos(q).dir sl 'cellclamp_results' sl 'MRF'],'dir')==0
    mkdir([myrepos(q).dir sl 'cellclamp_results' sl 'MRF'])
end
fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'biodata_' biocells{get(handles.popmenu_biologicalcell,'Value')} '_' currents{get(handles.popmenu_current,'Value')} '.dat'],'w');
fprintf(fid,'label:%s_%s_v\n%g\n', strrep(biocells{get(handles.popmenu_biologicalcell,'Value')},' ','_'), currents{get(handles.popmenu_current,'Value')}, numlines);
TimeScale=1;
if strcmp(DetailedData.AxoClampData.Time.Units,'s')
    TimeScale=1000;
end

for r=1:numlines
    fprintf(fid,'%f\t%f\n',DetailedData.AxoClampData.Time.Data(r)*TimeScale,DetailedData.AxoClampData.Data(get(handles.popmenu_current,'Value')).RecordedVoltage(r)-AllCells(get(handles.popmenu_biologicalcell,'Value')).JunctionPotential);
end
fclose(fid);

% Make the model cell definition file
if 1==1
system(['cp ' myrepos(q).dir sl 'cells' sl modelcells{get(handles.popmenu_modelcell,'Value')} ' ' myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'modelcell.hoc']);
homedir=[myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'modelcell.hoc'];
if ispc
    handles.dl='&';
else
    handles.dl=';';
end
removethese={'begintemplate','public','external','synapses($3)'};
for r=1:length(removethese)
    system(['cat ' homedir ' | sed -e ''/' removethese{r} '/d'' > x ' handles.dl ' mv x ' homedir])
end

system(['cat ' homedir ' | sed -e ''s/proc init()^ *[^ ]*/proc myinit() /'' > x ' handles.dl ' mv x ' homedir])
system(['cat ' homedir ' | sed -e ''s/^endtemplate/myinit(0,0,0) \/\/ /'' > x ' handles.dl ' mv x ' homedir])

end



% MRF session addl files
fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'myMRFsession.ses.fd1'],'w');
%numlines = length(AllCells(get(handles.popmenu_biologicalcell,'Value')).structured.TimeVec);

fprintf(fid,'RegionFitness xdat ydat boundary weight (lines=%d) 1\n', numlines*2+10);
fprintf(fid, '|%s_%s_v|\n', strrep(biocells{get(handles.popmenu_biologicalcell,'Value')},' ','_'), strrep(currents{get(handles.popmenu_current,'Value')},' ','_'));
fprintf(fid, '%d\n', numlines);
for r=1:numlines
    fprintf(fid,'%f\n',DetailedData.AxoClampData.Time.Data(r)*TimeScale);
end
fprintf(fid, '\n');
for r=1:numlines
    fprintf(fid,'%f\n',DetailedData.AxoClampData.Data(get(handles.popmenu_current,'Value')).RecordedVoltage(r)-AllCells(get(handles.popmenu_biologicalcell,'Value')).JunctionPotential);
end
fprintf(fid, '\n');
fprintf(fid, '3\n0\n475.45\n574.25\n\n0\n1\n1\n\n1\n');
fclose(fid);


fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'modelcell.hoc'],'r');

tline = fgetl(fid);
allines={};
a=1;
st=0;
en=0;
while ischar(tline)
    disp(tline)
    if st
        if ~isempty(strfind(tline,'}'))
            st=0;
        else
            allines{a}=strtrim(strrep(tline,' ',''));
            a=a+1;
        end
    end
    if ~isempty(strfind(strrep(tline,' ',''),'procmechinit()'))
        st=1;
    end
    tline = fgetl(fid);
end

fclose(fid);

myp={};
myv={};
pv=1;
for a=length(allines):-1:1
    if ~isempty(strfind(allines{a},'//'))
        allines{a}=allines{a}(1:(strfind(allines{a},'//')-1));
    end
    if isempty(allines{a})
        allines(a)=[];
        continue;
    end
    qq=strfind(allines{a},'=');
    myp{pv}=strtrim(allines{a}(1:qq-1));
    myv{pv}=strtrim(allines{a}(qq+1:end));
    pv=pv+1;
end

% if ispc
%     [~, firstline]=system('C:\cygwin\bin\gawk.exe ''/proc[[:space:]]mechinit()/ {print FNR}'' modelcell.hoc');
%     [~, lastline]=system(['C:\cygwin\bin\gawk.exe ''' deblank(firstline) '<=NR && /}/ {print NR;exit}'' modelcell.hoc']);
%     [~, params]=system(['C:\cygwin\bin\gawk.exe ''NR==' num2str(str2num(firstline)+1) ',NR==' num2str(str2num(lastline)-1) ''' modelcell.hoc']);
% else
%     [~, firstline]=system('awk ''/proc[[:space:]]mechinit()/ {print FNR}'' modelcell.hoc');
%     [~, lastline]=system(['awk ''' deblank(firstline) '<=NR && /}/ {print NR;exit}'' modelcell.hoc']);
%     [~, params]=system(['awk ''NR==' num2str(str2num(firstline)+1) ',NR==' num2str(str2num(lastline)-1) ''' modelcell.hoc']);
% end
 
 
 
fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'myMRFsession.ses.ft1'],'w');
fprintf(fid, 'ParmFitness: Unnamed multiple run protocol\n');
fprintf(fid, '\tFitnessGenerator: iclamp\n');
fprintf(fid, '\t\tRegionFitness:	soma[0].v( 0.5 )\n\n');
fprintf(fid, '\tParameters:\n');
for pv=1:length(myp)
    if strcmp(myp{pv}(1),'e')
        fprintf(fid, '\t\t"%s",%s, -110, 110, 1, 0\n',myp{pv},myv{pv});
    else
        fprintf(fid, '\t\t"%s",%s, 1e-9, 1e2, 1, 1\n',myp{pv},myv{pv});
    end
end
fprintf(fid, 'End ParmFitness\n');
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%


% Make the model condition/initiation file
currentinj=AllCells(get(handles.popmenu_biologicalcell,'Value')).CurrentRange(get(handles.popmenu_current,'Value')); 
if isempty(DetailedData.AxoClampData.BaselineCurrent)
    currentbase=0;
else
    currentbase=DetailedData.AxoClampData.BaselineCurrent;
end
%currentbase=str2num(get(handles.edit_base,'String')); % until we can get this somewhere else ... extract from esther's current traces, prompt for sanghun's?
if strcmp(DetailedData.AxoClampData.CurrentUnits,'pA')
    currentinj=currentinj/1000; %nA (Convert from pA), else assume nA
    currentbase=currentbase/1000; %nA (Convert from pA), else assume nA
end
baselinetime=DetailedData.AxoClampData.Time.Data(DetailedData.AxoClampData.Injection.OnIdx); %ms
stepduration=DetailedData.AxoClampData.Time.Data(DetailedData.AxoClampData.Injection.OffIdx-DetailedData.AxoClampData.Injection.OnIdx);
totalduration=DetailedData.AxoClampData.Time.Data(end);
rez=DetailedData.AxoClampData.Time.Data(2)-DetailedData.AxoClampData.Time.Data(1);
if strcmp(DetailedData.AxoClampData.Time.Units,'s')
    baselinetime=baselinetime*1000; %ms (convert from s)
    stepduration=stepduration*1000; %ms
    totalduration=totalduration*1000; %ms
    rez=rez*1000;
end
connectto='soma'; % where to put the clamp... 

fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'MRFinit.hoc'],'w');
fprintf(fid,'steps_per_ms = %d\ndt = %f\nsecondorder = %d\nv_init = Vrest\n\n', round(1/myhandles.mydt), myhandles.mydt, myhandles.secondorder);
fprintf(fid,'BASELINEDUR=%f\n',baselinetime);
fprintf(fid,'STEPDUR = %f\n',stepduration);
fprintf(fid,'TOTALDUR=%f\n',totalduration);
fprintf(fid,'ibase =  %f\n',currentbase);
fprintf(fid,'istep = %f\n\n',currentinj);

fprintf(fid,'proc init() {\n');
fprintf(fid,'	insert_mechs()\n');
%fprintf(fid,'	set_biophys()\n');
fprintf(fid,'	finitialize(v_init)\n');
fprintf(fid,'	if (cvode.active()) {\n');
fprintf(fid,'		cvode.re_init()\n');
fprintf(fid,'	} else {\n');
fprintf(fid,'		fcurrent()\n');
fprintf(fid,'	}\n');
fprintf(fid,'	frecord_init()\n');
fprintf(fid,'}\n\n');

fprintf(fid,'objref tvec,ivec\n');
fprintf(fid,'tvec = new Vector(6)\n');
fprintf(fid,'ivec = new Vector(6)\n');
fprintf(fid,'tvec.x[0] = 0\n');
fprintf(fid,'ivec.x[0] = ibase\n');
fprintf(fid,'tvec.x[1] = BASELINEDUR\n');
fprintf(fid,'ivec.x[1] = ibase\n');
fprintf(fid,'tvec.x[2] = BASELINEDUR + %f\n', rez);
fprintf(fid,'ivec.x[2] = istep\n');
fprintf(fid,'tvec.x[3] = BASELINEDUR + STEPDUR\n');
fprintf(fid,'ivec.x[3] = istep\n');
fprintf(fid,'tvec.x[4] = BASELINEDUR + STEPDUR + %f\n', rez);
fprintf(fid,'ivec.x[4] = ibase\n');
fprintf(fid,'tvec.x[5] = TOTALDUR\n');
fprintf(fid,'ivec.x[5] = ibase\n\n');

fprintf(fid,'objref stimobj\n');
fprintf(fid,'%s stimobj = new IClamp(0.5)\n',connectto);
fprintf(fid,'stimobj.del=0\n');
fprintf(fid,'stimobj.dur=1e9\n');
fprintf(fid,'ivec.play(&stimobj.amp, tvec)\n');
fprintf(fid,'\nobjref cellType[1]\n');

fclose(fid);

system(['cp ' myrepos(q).dir sl 'setupfiles' sl 'clamp' sl    'myMRFsession.ses  ' myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'myMRFsession.ses'])

fid=fopen([myrepos(q).dir sl 'cellclamp_results' sl 'MRF' sl 'MRF_instructions.txt'],'w');
fprintf(fid,'1. At the command line, enter: cd %s %s nrniv cellclamp_results/MRF/myMRFsession.ses\n',cygwin(myrepos(q).dir), handles.dl);
fprintf(fid,'OR:\n');
fprintf(fid,'1a. Open NEURON (nrngui)\n');
fprintf(fid,'1b. From the file menu in NEURON, choose "Working Dir" and set it to: %s\n',cygwin(myrepos(q).dir));
fprintf(fid,'1c. From the file menu in NEURON, choose "Load session" and open cellclamp_results/MRF/myMRFsession.ses\n');
fprintf(fid,'THEN:\n');
fprintf(fid,'2. Ensure everything looks ok, then click "Optimize" in the Praxis Panel to begin.\n');
fprintf(fid,'3. For more info, see NEURON''s MRF tutorial starting at: http://www.neuron.yale.edu/neuron/static/docs/optimiz/model/set_up_runfitness.html\n');
%fprintf(fid,'6. When you get to the section for loading exerimental data (http://www.neuron.yale.edu/neuron/static/docs/optimiz/model/loaddata.html)\n');
%fprintf(fid,'   instead of loading "iclamp.dat", load cellclamp_results/MRF/%s \n', ['biodata_' biocells{get(handles.popmenu_biologicalcell,'Value')} '_' currents{get(handles.popmenu_current,'Value')} '.dat']);
fclose(fid);


if exist([mypath sl 'data' sl 'MyOrganizer.mat'],'file')==2
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'general');
end



% Make a little instruction manual or a ses file?

system([general.explorer ' ' myrepos(q).dir sl 'cellclamp_results' sl 'MRF'])
msgbox('It is ready!')

system('nrniv cellclamp_results/MRF/myMRFsession.ses &')

function edit_base_Callback(hObject, eventdata, handles)
% hObject    handle to edit_base (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_base as text
%        str2double(get(hObject,'String')) returns contents of edit_base as a double


% --- Executes during object creation, after setting all properties.
function edit_base_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_base (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cmdstr=cygwin(cmdstr)

cmdstr=strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c');
% if ispc
%     system(strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c'));
% else
%     system(cmdstr);
% end
