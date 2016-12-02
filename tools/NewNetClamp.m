function varargout = NewNetClamp(varargin)
% NEWNETCLAMP MATLAB code for NewNetClamp.fig
%      NEWNETCLAMP, by itself, creates a new NEWNETCLAMP or raises the existing
%      singleton*.
%
%      H = NEWNETCLAMP returns the handle to a new NEWNETCLAMP or the handle to
%      the existing singleton*.
%
%      NEWNETCLAMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWNETCLAMP.M with the given input arguments.
%
%      NEWNETCLAMP('Property','Value',...) creates a new NEWNETCLAMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewNetClamp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewNetClamp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewNetClamp

% Last Modified by GUIDE v2.5 10-Feb-2015 22:41:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewNetClamp_OpeningFcn, ...
                   'gui_OutputFcn',  @NewNetClamp_OutputFcn, ...
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


% --- Executes just before NewNetClamp is made visible.
function NewNetClamp_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath RunArray sl AllResults
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewNetClamp (see VARARGIN)

% Choose default command line output for NewNetClamp
handles.output = hObject;

handles.mydata={};


myrows{1}='*';
myrows{2}='Description';
myrows{3}='Cell';
myrows{4}='Col';
myrows{5}='Line';
    myrows{6}='Spikes';
    myrows{7}='FirRate';
    myrows{8}='th. Hz';
    myrows{9}='th. pow';
    myrows{10}='Spk Norm th. pow';
    myrows{11}='MP Norm th. pow';
    myrows{12}='MP th. Hz';
    myrows{13}='MP th. pow';
    myrows{14}='Phase Pref';
    myrows{15}='Phase Shift';
myrows{16} = 'Input Type';
myrows{17} = 'Input Details';
myrows{18} = '# Conns';
myrows{19} = 'Weights';
myrows{20} = 'Synapses';
myrows{21} = 'Plot h';
handles.myrows = myrows;


load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

handles.general=general;
clear general

% Update handles structure
guidata(hObject, handles);

getready2runNRN(handles)


if ispc
    sl='\';
else
    sl='/';
end


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;

if exist([repospath sl  'networkclamp_results' sl 'AllResults.mat'],'file')
    load([repospath sl  'networkclamp_results' sl 'AllResults.mat'],'AllResults');
else
    AllResults=[];
end

d = dir([repospath sl 'datasets' sl 'phasic*.dat']);
myphasic = {d.name};

set(handles.menu_input_ideal,'String',myphasic,'Value',1);

addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conn_conn')
addcells2menu(myrepos(q).dir,sl,handles,'syndata','syns','conn_syn')

idx=searchRuns('ExecutionDate','',0,'~');%intersect(idxa,idxb);

d=dir([myrepos(q).dir sl 'cells' sl 'class_*hoc']);
for r=1:length(d)
    celltypes{r}=d(r).name(7:end-4);
end
set(handles.menu_cell_type,'String',celltypes)

if exist('RunArray','var') && ~isempty(RunArray) && length(RunArray)>0
    set(handles.menu_input_run,'String',{RunArray(idx(end:-1:1)).RunName},'Value',1)
    guidata(hObject,handles)
    menu_input_run_Callback(handles.menu_input_run, [], handles)
    handles=guidata(hObject);
    set(handles.menu_conn_run,'String',{RunArray(idx(end:-1:1)).RunName},'Value',1)
    menu_conn_run_Callback(handles.menu_conn_run, [], handles)
else
    guidata(hObject,handles)
    %menu_input_run_Callback(handles.menu_input_run, [], handles)
    handles=guidata(hObject);
    %menu_conn_run_Callback(handles.menu_conn_run, [], handles)
end

    if ispc
        handles.dl = ' & '; % System command delimiter for this computer (; for linux, & for pc)
        if isempty(strfind(mypath,'\'))
            mysl='/';
        else
            mysl='\';
        end
        % for PCs, to compile NEURON mod files, must set an environmental
        % variable $N first (to NEURON path)
        handles.compilenrn = ['sh ' deblank(mypath) mysl 'data' mysl 'runme.sh'];
        w=strfind(handles.general.neuron,'bin');    
        part2 = ['rm *.c\nrm *.o\nrm *.dll\nexport PYTHONHOME=' cygwin(handles.general.neuron(1:w-2)) '\nexport PYTHONPATH=' cygwin(handles.general.neuron(1:w-2)) '/lib\nexport N=' cygwin(handles.general.neuron(1:w-2)) '\nexport NEURONHOME=' cygwin(handles.general.neuron(1:w-2)) '\nexport PATH="$PATH:' cygwin(handles.general.neuron(1:w+2)) '"\nmknrndll'];
        fid=fopen([mypath sl 'data' sl 'runme.sh'],'w');
        fprintf(fid,part2);
        fclose(fid);
    else %if isunix
        handles.dl = ';';
        handles.compilenrn = 'nrnivmodl';
    end
guidata(hObject,handles)


% 
% if isfield(handles.general,'setenv') && handles.general.setenv==1
%     w=strfind(handles.general.neuron,'bin');
%     if ispc
%         setenv('PYTHONHOME',cygwin(handles.general.neuron(1:w-2)));
%         setenv('PYTHONPATH',cygwin([handles.general.neuron(1:w-2) sl 'lib']));
%         setenv('N',cygwin(handles.general.neuron(1:w-2)));
%         setenv('NEURONHOME',cygwin(handles.general.neuron(1:w-2)));
%     else
%         setenv('PYTHONHOME',handles.general.neuron(1:w-2));
%         setenv('PYTHONPATH',[handles.general.neuron(1:w-2) sl 'lib']);
%         setenv('N',handles.general.neuron(1:w-2));
%         setenv('NEURONHOME',handles.general.neuron(1:w-2));
%     end
% end


% UIWAIT makes NewNetClamp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewNetClamp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rad_input_run.
function rad_input_run_Callback(hObject, eventdata, handles)
% hObject    handle to rad_input_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_input_run
try
set(handles.rad_input_run,'Value',1)
set(handles.rad_input_file,'Value',0)
set(handles.rad_input_ideal,'Value',0)

set(handles.menu_input_type,'Visible','on')
set(handles.lbl_gid,'Visible','on')
set(handles.txt_input_gid,'Visible','on')
%set(handles.txt_Duration,'Visible','off')


contents = cellstr(get(handles.menu_input_run,'String'));
if isempty(contents)
    return;
end
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');

handles.curses=[];
handles.curses.ind=idx;
guidata(handles.btn_execute,handles);
getcelltypes(handles.btn_execute,guidata(handles.btn_execute))
handles=guidata(handles.btn_execute);

ridx=1;
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname,'ppspont')==0
        mycellranges{ridx} = [handles.curses.cells(r).name ' (' num2str(handles.curses.cells(r).range_st) ' - ' num2str(handles.curses.cells(r).range_en) ')'];
        ridx = ridx + 1;
    end
end

set(handles.menu_input_type,'String', mycellranges)
catch ME
    handleME(ME)
end


% --- Executes on button press in rad_input_file.
function rad_input_file_Callback(hObject, eventdata, handles)
% hObject    handle to rad_input_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_input_file

set(handles.rad_input_run,'Value',0)
set(handles.rad_input_file,'Value',1)
set(handles.rad_input_ideal,'Value',0)

set(handles.menu_input_type,'Visible','on')
set(handles.lbl_gid,'Visible','on')
set(handles.txt_input_gid,'Visible','on')
%set(handles.txt_Duration,'Visible','off')


% --- Executes on button press in rad_input_ideal.
function rad_input_ideal_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to rad_input_ideal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_input_ideal

set(handles.rad_input_run,'Value',0)
set(handles.rad_input_file,'Value',0)
set(handles.rad_input_ideal,'Value',1)

%set(handles.menu_input_type,'Visible','off')
set(handles.lbl_gid,'Visible','off')
set(handles.txt_input_gid,'Visible','off')
%set(handles.txt_Duration,'Visible','on')


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;

d = dir([repospath sl 'datasets' sl 'phasic*.dat']);
myphasic = {d.name};

set(handles.menu_input_ideal,'String',myphasic,'Value',1);

% --- Executes on selection change in menu_input_run.
function menu_input_run_Callback(hObject, eventdata, handles)
global mypath RunArray
% hObject    handle to menu_input_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_input_run contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_input_run

contents = cellstr(get(handles.menu_input_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');

handles.curses=[];
handles.curses.ind=idx;
guidata(handles.btn_execute,handles);
getcelltypes(handles.btn_execute,guidata(handles.btn_execute))
handles=guidata(handles.btn_execute);

ridx=1;
handles.mycellranges=[];
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname,'ppspont')==0
        handles.mycellranges(ridx)=r;
        mycellranges{ridx} = [handles.curses.cells(r).name ' (' num2str(handles.curses.cells(r).range_st) ' - ' num2str(handles.curses.cells(r).range_en) ')'];
        ridx = ridx + 1;
    end
end
guidata(handles.btn_execute,handles);


set(handles.menu_input_type,'String', mycellranges,'Value',1)
% set(handles.txt_input_gid,'String', '0')
menu_input_type_Callback(handles.menu_input_type, [], handles)

runstr = cellstr(get(handles.menu_conn_run,'String'));
midx = strmatch(contents{get(handles.menu_input_run,'Value')},runstr,'exact');
if ~isempty(midx)
    set(handles.menu_conn_run,'Value',midx);
end

menu_conn_run_Callback(handles.menu_conn_run, [], handles)

set(handles.txt_Duration,'String',num2str(RunArray(idx).SimDuration))

% --- Executes during object creation, after setting all properties.
function menu_input_run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_input_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_input_file.
function btn_input_file_Callback(hObject, eventdata, handles)
% hObject    handle to btn_input_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in menu_input_ideal.
function menu_input_ideal_Callback(hObject, eventdata, handles)
% hObject    handle to menu_input_ideal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_input_ideal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_input_ideal

set(handles.rad_input_ideal,'Value',1);
set(handles.rad_input_run,'Value',0);
set(handles.rad_input_file,'Value',0);
%set(handles.txt_Duration,'Visible','on')




% --- Executes during object creation, after setting all properties.
function menu_input_ideal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_input_ideal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rad_conn_conn.
function rad_conn_conn_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to rad_conn_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_conn_conn

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;

set(handles.rad_conn_run,'Value',0)
set(handles.rad_conn_conn,'Value',1)
set(handles.rad_conn_custom,'Value',0)

if get(handles.rad_syn_run,'Value')==0
    set(handles.menu_conn_run,'Visible','off')
end

set(handles.menu_conn_conn,'Visible','on','Enable','on')
addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conn_conn')


% --- Executes on button press in rad_conn_custom.
function rad_conn_custom_Callback(hObject, eventdata, handles)
% hObject    handle to rad_conn_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_conn_custom

set(handles.rad_conn_run,'Value',0)
set(handles.rad_conn_conn,'Value',0)
set(handles.rad_conn_custom,'Value',1)

if get(handles.rad_syn_run,'Value')==0
    set(handles.menu_conn_run,'Visible','off')
end

set(handles.menu_conn_conn,'Visible','off')

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in rad_syn_syn.
function rad_syn_syn_Callback(hObject, eventdata, handles)
% hObject    handle to rad_syn_syn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_syn_syn

set(handles.rad_syn_run,'Value',0)
set(handles.rad_syn_syn,'Value',1)
set(handles.rad_syn_custom,'Value',0)

set(handles.menu_conn_syn,'Visible','on','Enable','on')

if get(handles.rad_conn_run,'Value')==0
    set(handles.menu_conn_run,'Visible','off')
end



% --- Executes on button press in rad_syn_custom.
function rad_syn_custom_Callback(hObject, eventdata, handles)
% hObject    handle to rad_syn_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_syn_custom

set(handles.rad_syn_run,'Value',0)
set(handles.rad_syn_syn,'Value',0)
set(handles.rad_syn_custom,'Value',1)

if get(handles.rad_conn_run,'Value')==0
    set(handles.menu_conn_run,'Visible','off')
end

set(handles.menu_conn_syn,'Visible','off')

% if get(handles.rad_conn_conn,'Value')==0
%     set(handles.menu_conn_conn,'Visible','off')
% end

% --- Executes on button press in rad_conn_run.
function rad_conn_run_Callback(hObject, eventdata, handles)
% hObject    handle to rad_conn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_conn_run

set(handles.rad_conn_run,'Value',1)
set(handles.rad_conn_conn,'Value',0)
set(handles.rad_conn_custom,'Value',0)

set(handles.menu_conn_run,'Visible','on')
menu_conn_run_Callback(handles.menu_conn_run, [], handles)

set(handles.menu_conn_conn,'Visible','on','Enable','off')


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11


% --- Executes on button press in rad_syn_run.
function rad_syn_run_Callback(hObject, eventdata, handles)
% hObject    handle to rad_syn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_syn_run

set(handles.rad_syn_run,'Value',1)
set(handles.rad_syn_syn,'Value',0)
set(handles.rad_syn_custom,'Value',0)


set(handles.menu_conn_run,'Visible','on')
menu_conn_run_Callback(handles.menu_conn_run, [], handles)

set(handles.menu_conn_syn,'Visible','on','Enable','off')


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on selection change in menu_conn_conn.
function menu_conn_conn_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_conn_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conn_conn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conn_conn

contents = cellstr(get(handles.menu_cell_type,'String'));
celltype = contents{get(handles.menu_cell_type,'Value')};

if ispc
    sl='\';
else
    sl='/';
end
load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;

contents = cellstr(get(handles.menu_conn_conn,'String'));
try
constr = contents{get(handles.menu_conn_conn,'Value')};
catch
constr = contents{100};
end

celltype = handles.curses.cells(handles.mycellranges(get(handles.menu_input_type,'Value'))).name;

id = findstr(constr,':');
myConnData=str2num(constr(1:id-1));

fid = fopen([repospath sl 'datasets' sl 'conndata_' num2str(myConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);
clear myconns
for r=1:length(filedata{1})
    if strcmp(filedata{2}{r},celltype)==1        
        myconns.(filedata{1}{r}).weight = filedata{3}(r); % 3: weight, 4: numconns, 5: numsyns per conn
        myconns.(filedata{1}{r}).conns = filedata{4}(r); % 3: weight, 4: numconns, 5: numsyns per conn
        myconns.(filedata{1}{r}).syncon = filedata{5}(r); % 3: weight, 4: numconns, 5: numsyns per conn
    end
end

%  mydata=get(handles.table_conn_custom,'Data');
wfields = fieldnames(myconns);

for r=1:length(wfields)
    mydata{r,1} = wfields{r};
    mydata{r,2} = myconns.(wfields{r}).conns;
    mydata{r,3} = myconns.(wfields{r}).weight;
    mydata{r,4} = myconns.(wfields{r}).syncon;
    mydata{r,5} = NaN;
end    

set(handles.table_conn_custom,'Data',mydata);
    

% --- Executes during object creation, after setting all properties.
function menu_conn_conn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_conn_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function addcells2menu(myrep,sl,handles,filestr,varname,menuname)

mynumdata={};
a=dir([myrep sl 'datasets' sl filestr '_*.dat']);
if isempty(a)
    msgbox(['There are no ' filestr ' datasets in this repository.'])
    return
end
%load ../cellnumbers_gui/cells.mat %% new
cellflag=0;
if exist([myrep sl 'datasets' sl varname '.mat'])
    load([myrep sl 'datasets' sl varname '.mat']) %% new
    eval(['cellidx=length(' varname ')+1;'])
else
    cellflag=1;
    cellidx=1;
end
for r=1:length(a)
    tk = regexp(a(r).name,[filestr '_(\d*).dat'],'tokens');
    numtk = str2double(tk{1}{:});
    if numtk>90
        if cellflag==1 || eval(['isempty(find([' varname '(:).num]==numtk))'])
            eval([varname '(cellidx).num=numtk;'])
            eval([varname '(cellidx).comments='''';'])
            eval(['cellidx=length(' varname ')+1;'])
        end
        eval(['mynumdata{length(mynumdata)+1}=[tk{1}{:} '': '' ' varname '([' varname '(:).num]==numtk).comments];']) %#ok<NODEF,AGROW>
    end
end
if cellflag==1 && exist(varname,'var')
    save([myrep sl 'datasets' sl varname '.mat'],varname,'-v7.3') %% new
else
    save([myrep sl 'datasets' sl varname '.mat'],varname,'-append') %% new
end
if isempty(mynumdata)
    msgbox(['Doesn''t work for menu_' menuname])
else
    set(handles.(['menu_' menuname]),'Style','popupmenu','String',mynumdata,'Visible','on','Value',length(mynumdata))
end





% --- Executes on selection change in menu_conn_syn.
function menu_conn_syn_Callback(hObject, eventdata, handles)
% hObject    handle to menu_conn_syn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conn_syn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conn_syn


% --- Executes during object creation, after setting all properties.
function menu_conn_syn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_conn_syn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_conn_run.
function menu_conn_run_Callback(hObject, eventdata, handles)
global mypath RunArray sl
% hObject    handle to menu_conn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conn_run contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conn_run

contents = cellstr(get(handles.menu_conn_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_conn_run,'Value')},0,'=');
if isempty(idx)
    return
end
contents = cellstr(get(handles.menu_conn_conn,'String'));
mysidx = strmatch([num2str(RunArray(idx).ConnData) ':'],contents);
if ~isempty(mysidx)
set(handles.menu_conn_conn,'Value',mysidx);
else
set(handles.menu_conn_conn,'Value',100);
end
menu_conn_conn_Callback(handles.menu_conn_conn, [], handles)

contents = cellstr(get(handles.menu_conn_syn,'String'));
mysidx = strmatch([num2str(RunArray(idx).SynData) ':'],contents);
set(handles.menu_conn_syn,'Value',mysidx);
menu_conn_syn_Callback(handles.menu_conn_syn, [], handles)

% --- Executes during object creation, after setting all properties.
function menu_conn_run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_conn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_cell_type.
function menu_cell_type_Callback(hObject, eventdata, handles)
% hObject    handle to menu_cell_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_cell_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_cell_type


% --- Executes during object creation, after setting all properties.
function menu_cell_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_cell_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in txt_input_gid.
function txt_input_gid_Callback(hObject, eventdata, handles)
% hObject    handle to txt_input_gid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns txt_input_gid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from txt_input_gid


% --- Executes during object creation, after setting all properties.
function txt_input_gid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_input_gid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_execute.
function btn_execute_Callback(hObject, eventdata, handles)
global mypath RunArray AllResults sl
% hObject    handle to btn_execute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myweights=get(handles.table_conn_custom,'Data');
for r=1:size(myweights,1)
    weights.(myweights{r,1}) = myweights{r,3};
end


celltypeOI=handles.mycellranges(get(handles.menu_input_type,'Value'))-1;
gidOI=str2num(get(handles.txt_input_gid,'String'));
gid=gidOI;


stimflag=get(handles.rad_input_ideal,'Value');

contents = cellstr(get(handles.menu_input_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');
resultsdir=[RunArray(idx).ModelDirectory sl 'networkclamp_results'];
repodir=RunArray(idx).ModelDirectory;
if stimflag==1
    contents = cellstr(get(handles.menu_input_ideal,'String'));
    phasicfile = contents{get(handles.menu_input_ideal,'Value')};
    PhaseDataStr=phasicfile(8:end-4);
    runname = ['phasic' PhaseDataStr];
else
    runname = RunArray(idx).RunName;
end


resultidx=1;
if exist([resultsdir sl runname],'dir')
    d=dir([resultsdir sl runname]);
    for dr=3:length(d)
        if resultidx<=str2num(d(dr).name)
            resultidx = str2num(d(dr).name)+1;
        end
    end
else
    mkdir([resultsdir sl runname])
end
resultsfolder=sprintf('%05.0f',resultidx); %changeresultsfolder

mkdir([resultsdir sl runname sl resultsfolder])

contents = cellstr(get(handles.menu_input_type,'string'));
mytype = contents{get(handles.menu_input_type,'Value')};

myi = findstr(mytype,' ');
mytype = mytype(1:myi-1);

mycomments=get(handles.txt_description,'String');

contents = cellstr(get(handles.menu_cell_type,'String'));
celltype2use = contents{get(handles.menu_cell_type,'Value')};

contents = cellstr(get(handles.menu_conn_run,'String'));
cnidx=searchRuns('RunName',contents{get(handles.menu_conn_run,'Value')},0,'=');
conndata='';

if get(handles.rad_conn_conn,'Value')==1
    contents = cellstr(get(handles.menu_conn_conn,'String'));
    myconn = contents{get(handles.menu_conn_conn,'Value')};
    cidx = strfind(myconn,':');
    conndata=myconn(1:cidx-1);
    copyfile([repodir sl 'datasets' sl 'conndata_' conndata '.dat'],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'conndata.dat'])
elseif get(handles.rad_conn_custom,'Value')==1 % custom
    fid = fopen([repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'conndata.dat'],'w');
    fprintf(fid,'%d\n',size(myweights,1));
    for r=1:size(myweights,1) 
        fprintf(fid,'%s %s %f %f %f\n', myweights{r,1}, mytype, myweights{r,3}, myweights{r,2}, myweights{r,4}); % 3 = length(handles.prop)
    end
    fclose(fid);
else % if get(handles.rad_conn_run,'Value')==1
    if RunArray(cnidx).ConnData==501 && exist([repodir sl 'datasets' sl 'conndata_' num2str(RunArray(cnidx).ConnData)  '.dat'],'file')==0
        copyfile([repodir sl 'datasets' sl 'conndata_430.dat'],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'conndata.dat'])
    else
        copyfile([repodir sl 'datasets' sl 'conndata_' num2str(RunArray(cnidx).ConnData)  '.dat'],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'conndata.dat'])
    end
end

if get(handles.rad_input_ideal,'Value')==1
    contents = cellstr(get(handles.menu_input_ideal,'String'));
    phasicdatafile = contents{get(handles.menu_input_ideal,'Value')};
    copyfile([repodir sl 'datasets' sl phasicdatafile],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'phasicdata.dat'])
end
syndata='';
if get(handles.rad_syn_syn,'Value')==1
    contents = cellstr(get(handles.menu_conn_syn,'String'));
    mysyn = contents{get(handles.menu_conn_syn,'Value')};
    cidx = strfind(mysyn,':');
    syndata=mysyn(1:cidx-1);
    copyfile([repodir sl 'datasets' sl 'syndata_' syndata '.dat'],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'syndata.dat'])
elseif get(handles.rad_syn_custom,'Value')==1 % custom
    msgbox('Not implemented yet')
%     fid = fopen([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'syndata.dat'],'w');
%     fprintf(fid,'%d\n',size(myweights,1));
%     for r=1:size(myweights,1) 
%         fprintf(fid,'%s %s %f %f %f\n', myweights{r,1}, celltype2use, myweights{r,3}, myweights{r,2}, myweights{r,4}); % 3 = length(handles.prop)
%     end
%     fclose(fid);
else % if get(handles.rad_syn_run,'Value')==1
    copyfile([repodir sl 'datasets' sl 'syndata_' num2str(RunArray(cnidx).SynData)  '.dat'],[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'syndata.dat'])
end


destfile=[repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'run.hoc'];
[SUCCESS,MESSAGE,MESSAGEID] = copyfile([repodir sl 'results' sl RunArray(idx).RunName sl RunArray(idx).RunName '_run.hoc'],destfile);

if SUCCESS==0
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile([repodir sl 'jobscripts' sl RunArray(idx).RunName '_run.hoc'],destfile);
end

if SUCCESS==0
    disp(['Gonna try to use run ' RunArray(idx).RunName(1:end-3) ' instead.'])
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile([repodir sl 'results' sl RunArray(idx).RunName sl RunArray(idx).RunName(1:end-3) '_run.hoc'],destfile);
end

if SUCCESS==0
    disp(['Gonna try to use run ' RunArray(idx).RunName(1:end-3) ' in jobscripts instead.'])
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile([repodir sl 'jobscripts' sl RunArray(idx).RunName(1:end-3) '_run.hoc'],destfile);
end

if SUCCESS==0
    disp(['Gonna try to use results folder ' RunArray(idx).RunName(1:end-3) ' instead.'])
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile([repodir sl 'results' sl RunArray(idx).RunName(1:end-3) sl RunArray(idx).RunName(1:end-3) '_run.hoc'],destfile);
end

if SUCCESS==0
    fid = fopen(destfile,'w');
    fprintf(fid,'NumData=104\nScale=1\nSimDuration=%s\nPrintVoltage=1\nPrintTerminal=1\n{load_file("./newnetclamp.hoc")}',get(handles.txt_Duration,'String'));
    fclose(fid);

    % disp('unsuccessful... quitting.')
    % return
else
        fid = fopen(destfile,'r');
        tline{1} = fgetl(fid);
        i=1;
        while ischar(tline{i})
            i=i+1;
            tline{i} = fgetl(fid);
            if findstr(tline{i},'load_file')>0
                str = tline{i}; %'{load_file("./ca1.hoc")}';
                expression = '"./(\w+).hoc"';
                % replace = '"./setupfiles/clamp/netclamp.hoc"';
                replace = '"./newnetclamp.hoc"';
                tline{i} = regexprep(str,expression,replace);
            elseif findstr(tline{i},'special')>0
                str = tline{i}; %'{load_file("./ca1.hoc")}';
                expression = '"special"';
                % replace = '"./setupfiles/clamp/netclamp.hoc"';
                replace = '"nrniv"';
                tline{i} = regexprep(str,expression,replace);
            elseif findstr(tline{i},'SimDuration')>0
                str = tline{i}; %'{load_file("./ca1.hoc")}';
                expression = 'SimDuration=([0-9]+)';
                replace = ['SimDuration=' get(handles.txt_Duration,'String')];
                tline{i} = regexprep(str,expression,replace);                
%             elseif findstr(tline{i},'ConnData')>0
%                 str = tline{i}; %'{load_file("./ca1.hoc")}';
%                 expression = 'ConnData=([0-9]+)';
%                 replace = ['ConnData=' num2str(myConnData)];
%                 tline{i} = regexprep(str,expression,replace);
%             elseif findstr(tline{i},'SynData')>0
%                 str = tline{i}; %'{load_file("./ca1.hoc")}';
%                 expression = 'SynData=([0-9]+)';
%                 replace = ['SynData=' num2str(mySynData)];
%                 tline{i} = regexprep(str,expression,replace);
            end
        end
        fclose(fid);

        fid = fopen(destfile,'w');
        for t=1:length(tline)-1
            fprintf(fid,'%s\n',tline{t});
        end
        fclose(fid);
end

        kidx = length(AllResults)+1;
AllResults(kidx).SimDuration = str2num(get(handles.txt_Duration,'String'));
AllResults(kidx).InputType = get(handles.rad_input_ideal,'Value');
if stimflag==1
    AllResults(kidx).Phasic = str2num(PhaseDataStr);
    AllResults(kidx).RunIdx = [];
else
    AllResults(kidx).Phasic = [];
    AllResults(kidx).RunIdx = idx;
end
AllResults(kidx).ConnDataType = get(handles.rad_conn_run,'Value')*1 + get(handles.rad_conn_conn,'Value')*2 + get(handles.rad_conn_custom,'Value')*3;
AllResults(kidx).ConnData = str2num(conndata);
AllResults(kidx).ConnDataCustom = myweights;
AllResults(kidx).SynDataType = get(handles.rad_syn_run,'Value')*1 + get(handles.rad_syn_syn,'Value')*2 + get(handles.rad_syn_custom,'Value')*3;
AllResults(kidx).SynData = str2num(syndata);
AllResults(kidx).SynDataCustom = [];
AllResults(kidx).ConnRun = RunArray(cnidx).RunName;


if ispc
    mystr='.exe';
else
    mystr='';
end

m=findstr(handles.general.neuron,' ');

if ~isempty(m)
    nrnpath=handles.general.neuron(1:m(1)-1);
else
    nrnpath=handles.general.neuron;
end

if exist([strrep(nrnpath,'.exe','') mystr],'file')==0
    msgbox({'Please update the location of NEURON''s','nrniv executable in the General Settings first.'})
    return
end

if exist([repodir sl 'newnetclamp.hoc'],'file')==0
    msgbox('Sorry, Network Clamp is not yet compatible with this repository.')
    return;
end

if stimflag==1
    cmdstr = ['cd ' repodir ' ' handles.dl ' ' handles.general.neuron ' -c gidOI=' num2str(gidOI) ' -c cellindOI=' num2str(celltypeOI) ' -c stimflag=' num2str(stimflag) ' -c "strdef runname" -c runname="\"' runname '\""  -c "strdef origRunName" -c origRunName="\"' runname '\"" -c PhasicData=' PhaseDataStr '  -c "strdef celltype2use" -c celltype2use="\"' celltype2use '\""     -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./networkclamp_results/' runname '/' resultsfolder '/run.hoc -c "quit()"'];
else
    cmdstr = ['cd ' repodir ' ' handles.dl ' ' handles.general.neuron ' -c gidOI=' num2str(gidOI) ' -c cellindOI=' num2str(celltypeOI) ' -c stimflag=' num2str(stimflag) ' -c "strdef runname" -c runname="\"' runname '\""  -c "strdef origRunName" -c origRunName="\"' runname '\""  -c "strdef celltype2use" -c celltype2use="\"' celltype2use '\""     -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./networkclamp_results/' runname '/' resultsfolder '/run.hoc -c "quit()"'];
end
disp(cmdstr);
[~, results]=system(cmdstr);
disp(results);

voltage = importdata([repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'mytrace_' num2str(gid) '_soma.dat']);
lfp = importdata([repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'lfp.dat']);
% read in spike raster for just that gid
spikerast = importdata([repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'spikeraster.dat']);

if ~isempty(spikerast)
    myspikes = spikerast(spikerast(:,2)==gidOI,1);
else
    myspikes=[];
end

mycells = importdata([repodir sl 'networkclamp_results' sl runname sl resultsfolder sl 'celltype.dat']);

AllResults(kidx).resultsfolder = resultsfolder;
AllResults(kidx).RunName = runname;
AllResults(kidx).Description = mycomments;
AllResults(kidx).DataPath = [repodir sl 'networkclamp_results' sl runname sl resultsfolder sl   'myresultsDetails.mat'];
myresultsDetails.spikerast = spikerast;
setcell(handles,voltage,lfp,spikerast,myspikes,mycells,mycomments,resultsdir,repodir,runname,resultsfolder,kidx);



function setcell(handles,b,lfp,spikerast,myspikes,mycells,mycomments,resultsdir,repodir,runname,resultsfolder,kidx)
global mypath RunArray sl AllResults myresultsDetails


handles.SimDuration=str2num(get(handles.txt_Duration,'String'));
contents = cellstr(get(handles.menu_input_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');

celltypeidx=handles.mycellranges(get(handles.menu_input_type,'Value'));

celltype=handles.curses.cells(celltypeidx).name;

gid=str2num(get(handles.txt_input_gid,'String'));
gidstr={num2str(gid)};

%%%%%%%%%%%%%%
% Get Run Info
% 
% handles.curses=[];
% handles.curses.ind = idx;
% guidata(handles.btn_execute, handles);
% 
% if isfield(handles.curses,'spikerast')==0
%     spikeraster(handles.btn_execute,guidata(handles.btn_execute))
%     handles=guidata(handles.btn_execute);
% end
% if isfield(handles.curses,'cells')==0
%     getcelltypes(handles.btn_execute,guidata(handles.btn_execute))
%     handles=guidata(handles.btn_execute);
% end
% if size(handles.curses.spikerast,2)<3
%     handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
%     guidata(handles.btn_execute, handles)
% end
% if isfield(handles.curses,'position')==0
%     getposition(handles.btn_execute,guidata(handles.btn_execute))
%     handles=guidata(handles.btn_execute);
% end

if exist([resultsdir sl runname sl resultsfolder sl 'connections.dat'],'file')==0
    return;
end
try
[A, B, C]=textread([resultsdir sl runname sl resultsfolder sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
catch
[A, B, C]=textread([resultsdir sl runname sl resultsfolder sl 'connections.dat'],'%d\t%d\t%d','headerlines',1);
end
cell_syns=[A B C];

clear A B C

myresultsDetails.cell_syns = cell_syns;

inputs = cell_syns(cell_syns(:,2)==gid,:);

for r=1:size(mycells.textdata,1)-1
    cells(r).name=mycells.textdata{r+1,1};
    cells(r).techname=mycells.textdata{r+1,2};
    cells(r).ind=mycells.data(r,1);
    cells(r).range_st=mycells.data(r,2);
    cells(r).range_en=mycells.data(r,3);
    cells(r).numcells=cells(r).range_en - cells(r).range_st + 1;
end

myresultsDetails.cells = cells;

if ~isempty(spikerast)
    spiketrain = addtype2raster(cells,spikerast,3);
    spiketrain=spiketrain(ismember(spiketrain(:,2),inputs(:,1)),:);

    spiking_inputs=inputs(ismember(inputs(:,1),spiketrain(:,2)),:);
    avgsyns=size(spiking_inputs,1)/length(unique(spiking_inputs(:,1)));
    myi=size(spiketrain,1);
    myistart=myi;
    spiketrain(:,3)=-1;
    if ~isnan(avgsyns)
        spiketrain(end+1:round(myi*(avgsyns+.5)),:)=-1;
    end

    for r=1:myistart
        id = find(spiking_inputs(:,1)==spiketrain(r,2));
        spiketrain(r,3)=spiking_inputs(id(1),3); % add the synapse id
        for k=2:length(id)
            myi=myi+1;
            spiketrain(myi,:)=[spiketrain(r,1:2) spiking_inputs(id(k),3)]; % add the synapse id
        end    
    end

    if myi<size(spiketrain,1)
        spiketrain=spiketrain(1:myi,:);
    end
else
    spiketrain = [];
end

% handles.inputs = addtype2raster(handles.curses.cells,inputs,4,1);
% guidata(handles.btn_execute, handles);

if isempty(inputs)
    return
end

% if isempty(handles.curses.spikerast)
%     spiketrain=[];
% else
%     spike_idx = ismember(handles.curses.spikerast(:,2),inputs(:,1));
%     spiketrain = handles.curses.spikerast(spike_idx,:);
% end


%%%%%%%%%%%%%%

handles.prop = {'postcell','precell','weight','conns','syns'}; %, 'strength', 'numcons'};
% fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(idx).ConnData) '.dat']);
fid = fopen([resultsdir sl runname sl resultsfolder sl 'conndata.dat']);
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f';
c = textscan(fid,['%s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

numcon = [];
handles.conndata=[];

if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        postcell = c{1,2}{r};
        precell = c{1,1}{r};
        if ~isfield(handles.conndata,postcell)
            handles.conndata.(postcell)=[];
        end
        if ~isfield(handles.conndata.(postcell), precell)
            handles.conndata.(postcell).(precell)=[];
        end
        try
        for z = 3:length(handles.prop)
            handles.conndata.(postcell).(precell).(handles.prop{z}) = c{1,z}(r);
        end
        catch
            z
        end
    end
end

%%%%%%%%%%%%%%

handles.prop = {'precell','syntype','seclist','range_st','range_en','scaling','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'}; %, 'strength', 'numcons'};
mysl=findstr(repodir,'/');
if isempty(mysl)
    mysl='\';
else
    mysl='/';
end

fid = fopen([resultsdir sl runname sl resultsfolder sl 'syndata.dat']);
% fid = fopen([RunArray(idx).ModelDirectory mysl 'datasets' mysl 'syndata_' num2str(RunArray(idx).SynData) '.dat']);
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f %f %f %f %f %f %f';
c = textscan(fid,['%s %s %s %s %s %s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

numcon = [];
handles.data=[];
if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        postcell = c{1,1}{r};
        precell = c{1,2}{r};
        if ~isfield(handles.data,postcell)
            handles.data.(postcell)=[];
        end
        if ~isfield(handles.data.(postcell), precell)
            handles.data.(postcell).(precell)=[];
            handles.data.(postcell).(precell).syns=[];
            n = 1;
        else
            n = length(handles.data.(postcell).(precell).syns)+1;
        end
        try
            for z = 2:length(handles.prop)
                handles.data.(postcell).(precell).syns(n).(handles.prop{z}) = c{1,z+1}(r);
            end
        catch
            z
        end
    end
end

mysyns=[];
allsyns = importdata([resultsdir sl  runname sl resultsfolder sl 'allsyns.dat']);

h1=[];
if ~isempty(allsyns) && isfield(allsyns,'data')
for r=1:length(allsyns.data)
    if ~isfield(mysyns,allsyns.textdata{r,1})
        mysyns.(allsyns.textdata{r,1})=[];
    end
    if ~isfield(mysyns.(allsyns.textdata{r,1}),allsyns.textdata{r,2})
        mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2})=[];
    end
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synstart = allsyns.data(r,1);
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).synend = allsyns.data(r,2);
    mysyns.(allsyns.textdata{r,1}).(allsyns.textdata{r,2}).numsyns = allsyns.data(r,2)-allsyns.data(r,1)+1;
end

exc=[];
inh=[];
post = celltype;
prefields = fieldnames(handles.data.(post));
for r=1:length(prefields)
    pre = prefields{r};
    if isfield(mysyns.(post),pre) && ~isempty(handles.data.(post).(pre).syns(1).e) && ~isnan(handles.data.(post).(pre).syns(1).e)
        if handles.data.(post).(pre).syns(1).e<-40
            inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
        else
            exc = [exc mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
        end
    elseif  isfield(mysyns.(post),pre) % assume GABAergic (a and b)
        inh = [inh mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend];
    end
end

% plot synaptic input histograms
%%%%%%%%%%%%%%

z=handles.panel_syninputhist; %figure('Color','w','Name',[RunArray(idx).RunName ': ' post ' Inputs by Type']);
numpre = length(prefields);
easz = 1/numpre; %.9/numpre;

axcondelay=3;
cutoff=15;

for r=1:numpre
    pre = prefields{r};
    if isfield(mysyns.(post),pre)==0
        grr(r).useme=0;
        continue
    end
    col='c';
    if ~isempty(handles.data.(post).(pre).syns(1).e) && ~isnan(handles.data.(post).(pre).syns(1).e) && handles.data.(post).(pre).syns(1).e>=-40
        col='m';
    end

    h1(r) = subplot('Position',[0.1 .0+easz*(r-1) .9 easz-.0],'Parent',z);
    spike_idx = ismember(spiketrain(:,3),mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend);
    %corr_idx = ismember(corrtrain(:,3),mysyns.(post).(pre).synstart:mysyns.(post).(pre).synend);
    
    N=histc(spiketrain(spike_idx,1)+axcondelay,[0:handles.SimDuration]);
    hbar=bar([0:handles.SimDuration],N);
    set(hbar,'EdgeColor',col)
    set(hbar,'FaceColor',col)

    set(h1(r),'XTickLabel',{})
    set(h1(r),'YTickLabel',{})

    yy=get(gca,'YLim');
    ylabel([pre(1:end-4) ':' num2str(yy(2))],'rot',0,'HorizontalAlignment','right','VerticalAlignment','Baseline')
    xlim([0 handles.SimDuration])
end
end

% populate synapse table

cellmatdata = get(handles.table_conn_custom, 'Data');
for n=1:size(mycells.data,1)
    cellidx = find(inputs(:,1)>=mycells.data(n,2) & inputs(:,1)<=mycells.data(n,3)); % source target synapse

    if isempty(spikerast)
        spkidx=[];
    else
    spkidx = find(spikerast(:,2)>=mycells.data(n,2) & spikerast(:,2)<=mycells.data(n,3)); % source target synapse
    end
    nidx = strmatch(mycells.textdata{n+1,1},cellmatdata(:,1));
    cellmatdata{nidx,5} = length(spkidx);
end
set(handles.table_conn_custom, 'Data', cellmatdata); %, 'ColumnEditable', true([1 length(get(handles.tbl_synapses,'ColumnName'))]), 'ColumnName', {'     Cell Type     ','# syns','# spikes x syns','  Weight (uS)  ','# conns','unique cells','#syns/conn'},'ColumnFormat',{'char','numeric','numeric','short e','numeric','numeric'}); %,'UIContextMenu',mycontextmenuz);

[myh, mycolor, myline]=addline2graph(handles,b);
if ~isempty(h1)
linkaxes([h1 get(myh,'Parent')],'x');
end

add2table(handles,b,lfp,spikerast,myspikes,mycells,mycomments,repodir,runname,resultsfolder,mycolor,myline,myh,idx,celltype,gid,kidx)

function readdline(handles,xidx)
if ispc
    sl='\';
else
    sl='/';
end
b = importdata([handles.mydata{xidx,29} sl 'networkclamp_results' sl handles.mydata{xidx,25} sl handles.mydata{xidx,26} sl 'mytrace_' handles.mydata{xidx,28} '_soma.dat']);
[myh, mycolor, myline]=addline2graph(handles,b);
handles.mydata{xidx,4} = mycolor;
handles.mydata{xidx,5} = myline;
handles.mydata{xidx,23} = myh;
guidata(handles.btn_execute,handles);

if get(handles.rad_view_results,'Value')==1
    idx2show=[1:17];
else % (handles.rad_view_show)
    idx2show=[1:5 18:22];
end

set(handles.table_runs,'Data',handles.mydata(:,idx2show),'ColumnName',handles.myrows(:,idx2show));

function [myh, mycolor, myline]=addline2graph(handles,b)
g=0;
usedstyles={};
for m=1:size(handles.mydata,1)
    if ~isempty(handles.mydata{m,23})
        g = g+1;
        usedstyles{g} = [handles.mydata{m,4} handles.mydata{m,5}];
    end
end

colorvec={'g','b','m','c','r'};
patvec={'-','--',':'};

myflag=0;
m=0;
while myflag==0
    mycol=mod(m,length(colorvec))+1;
    mypat=floor(m/length(colorvec))+1;

    mycolor = colorvec{mycol};
    myline = patvec{mypat};
    teststyle = [mycolor myline];
    myflag=1;
    for z=1:g
        if strcmp(usedstyles{z},teststyle)==1
            myflag=0;
        end
    end
    m = m + 1;
end

mystyle = teststyle;

% add a line to the voltage trace plot and update the legend
z=handles.panel_traces;
if ~isfield(handles,'mytrace') || isempty(handles.mytrace)
    handles.mytrace = subplot('Position',[0.1 0.13 .9 .82],'Parent',z);
end
axes(handles.mytrace)
hold on

myh=plot(b.data(:,1),b.data(:,2),mystyle); %,'LineWidth',2);
% xlim([0 str2num(get(handles.txt_Duration,'String'))])



function removeline2graph(handles,xidx)

% add a line to the voltage trace plot and update the legend
z=handles.panel_traces;
if ~isfield(handles,'mytrace') || isempty(handles.mytrace)
    handles.mytrace = subplot('Position',[0.1 0.13 .9 .82],'Parent',z);
end
axes(handles.mytrace)
if strcmp(get(handles.mydata{xidx,23},'Type'),'line')==1
    delete(handles.mydata{xidx,23})
else
    disp('some sort of problem with this row')
end

handles.mydata{xidx,4} = '';
handles.mydata{xidx,5} = '';
handles.mydata{xidx,23} = '';

guidata(handles.btn_execute, handles)

if get(handles.rad_view_results,'Value')==1
    idx2show=[1:17];
else % (handles.rad_view_show)
    idx2show=[1:5 18:22];
end

set(handles.table_runs,'Data',handles.mydata(:,idx2show),'ColumnName',handles.myrows(:,idx2show));

function cmdstr=cygwin(cmdstr)

cmdstr=strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c');

function add2table(handles,b,lfp,spikerast,myspikes,mycells,mycomments,repodir,runname,resultsfolder,mycolor,myline,myh,idx,celltype,gid,kidx)
global mypath sl RunArray AllResults myresultsDetails
mydata = handles.mydata; % get(handles.table_runs,'Data');
myrows = handles.myrows;

for r=size(mydata,1):-1:1
    mydata(r+1,:)=mydata(r,:);
end

myi=1;
myrows{1}= '*';
mydata{myi,1}= logical(1);

myrows{2} = 'Description';
mydata{myi,2} = mycomments;

myrows{3}='Cell';

contents = cellstr(get(handles.menu_cell_type,'String'));
ephyscell = contents{get(handles.menu_cell_type,'Value')};

stimflag=get(handles.rad_input_ideal,'Value');

contents = cellstr(get(handles.menu_input_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');
if stimflag==1
    contents = cellstr(get(handles.menu_input_ideal,'String'));
    phasicfile = contents{get(handles.menu_input_ideal,'Value')};
    PhaseDataStr=phasicfile(8:end-4);
    runname = ['phasic' PhaseDataStr];
else
    runname = RunArray(idx).RunName;
end

% contents = cellstr(get(handles.menu_input_run,'String'));
% runname = contents{get(handles.menu_input_run,'Value')};

if strcmp(celltype, ephyscell)==0
    exstr = [ephyscell ' as '];
else
    exstr = '';
end

mydata{myi,3}=[runname ' ' resultsfolder ': ' exstr celltype ' (' num2str(gid) ')'];

AllResults(kidx).InputsCellType = celltype;
AllResults(kidx).CellType = ephyscell;
AllResults(kidx).GidOI = gid;

myresultsDetails.Trace = b.data;
myresultsDetails.FilteredTrace = [];
myrows{4}='Col';
myrows{5}='Line';
mydata{myi,4}=mycolor;
mydata{myi,5}=myline;

    %MP FFT stuff
    rez=b.data(2,1)-b.data(1,1); % .1 is simulation resolution

    Fs = 1000/rez; % sampling frequency (per s)

    y=b.data(:,2);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));

    theta_range=find(f(:)>=4 & f(:)<=12);
    [~, peak_idx] = max(fft_results(theta_range));
    rel_range=find(f(:)>2 & f(:)<=100);
    [~, over_idx] = max(fft_results(rel_range));
    gamma_range=find(f(:)>=25 & f(:)<=80);
    [~, gamma_idx] = max(fft_results(gamma_range));

    myresultsDetails.FFTMP.f = f;
    myresultsDetails.FFTMP.power = fft_results;

    AllResults(kidx).FFTMP.Theta.freq = f(theta_range(peak_idx));
    AllResults(kidx).FFTMP.Theta.power = fft_results(theta_range(peak_idx));
    AllResults(kidx).FFTMP.Theta.norm = fft_results(theta_range(peak_idx))/fft_results(rel_range(over_idx));

    rez = b.data(2,1)-b.data(1,1);
    y_trace = b.data(:,2);
    y_trace = y_trace - sum(y_trace)/length(y_trace);

    Fs = 1000/rez; % sampling frequency (per s)
    
    try
        AllResults(kidx).FFTMP.Theta.filtered=mikkofilter([b.data(:,1) y_trace],Fs);
        %AllResults(kidx).FFTMP.Theta.filtered = mikkoscript(y_trace,Fs,[AllResults(kidx).FFTMP.Theta.freq AllResults(kidx).FFTMP.Theta.freq]);
        gidx=find(AllResults(kidx).FFTMP.Theta.filtered(:,1)*1000>=(1000/AllResults(kidx).FFTMP.Theta.freq),1,'first');
        numsamp=floor(length(AllResults(kidx).FFTMP.Theta.filtered(:,1))/gidx);
        grr=reshape(AllResults(kidx).FFTMP.Theta.filtered(gidx+1:numsamp*gidx,2),numsamp-1,gidx);
        [~, pkidx]=max(mean(grr));
        AllResults(kidx).FFTMP.Theta.phase = AllResults(kidx).FFTMP.Theta.filtered(pkidx,1)/AllResults(kidx).FFTMP.Theta.filtered(gidx,1)*360;
    catch me
        AllResults(kidx).FFTMP.Theta.filtered=[];
        gidx=find(b.data(:,1)>=(1000/AllResults(kidx).FFTMP.Theta.freq),1,'first');
        if isempty(gidx)
            [~, pkidx]=max(b.data(:,2));
            AllResults(kidx).FFTMP.Theta.phase = b.data(pkidx,1)/(1000/AllResults(kidx).FFTMP.Theta.freq)*360;
            msgbox('This run is too short to look at theta phase')
        else
            numsamp=floor(length(b.data(:,1))/gidx);
            grr=reshape(b.data(1:numsamp*gidx,2),numsamp,gidx);
            [~, pkidx]=max(mean(grr));
            AllResults(kidx).FFTMP.Theta.phase = b.data(pkidx,1)/b.data(gidx,1)*360;
        end
    end
    %h = plot(hp);
    
    
    AllResults(kidx).FFTMP.Gamma.freq = f(gamma_range(gamma_idx));
    AllResults(kidx).FFTMP.Gamma.power = fft_results(gamma_range(gamma_idx));
    AllResults(kidx).FFTMP.Gamma.norm = fft_results(gamma_range(gamma_idx))/fft_results(rel_range(over_idx));
    
    try
        AllResults(kidx).FFTMP.Gamma.filtered = mikkoscript(y_trace,Fs,[AllResults(kidx).FFTMP.Gamma.freq AllResults(kidx).FFTMP.Gamma.freq]);
        gidx=find(AllResults(kidx).FFTMP.Gamma.filtered(:,1)*1000>=(1000/AllResults(kidx).FFTMP.Gamma.freq),1,'first');
        numsamp=floor(length(AllResults(kidx).FFTMP.Gamma.filtered(:,1))/gidx);
        grr=reshape(AllResults(kidx).FFTMP.Theta.filtered(gidx+1:numsamp*gidx,2),numsamp-1,gidx);
        [~, pkidx]=max(mean(grr));
        AllResults(kidx).FFTMP.Gamma.phase = AllResults(kidx).FFTMP.Gamma.filtered(pkidx,1)/AllResults(kidx).FFTMP.Gamma.filtered(gidx,1)*360;
    catch
        AllResults(kidx).FFTMP.Gamma.filtered=[];
        gidx=find(b.data(:,1)>=(1000/AllResults(kidx).FFTMP.Gamma.freq),1,'first');
        numsamp=floor(length(b.data(:,1))/gidx);
        grr=reshape(b.data(1:numsamp*gidx,2),numsamp,gidx);
        [~, pkidx]=max(mean(grr));
        AllResults(kidx).FFTMP.Gamma.phase = b.data(pkidx,1)/b.data(gidx,1)*360;
    end
    
    myrows{11}='MP Norm th. pow';
    mydata{myi,11} = sprintf('%.2f', fft_results(theta_range(peak_idx))/fft_results(rel_range(over_idx)));


    myrows{12}='MP th. Hz';
    mydata{myi,12} = sprintf('%.2f', f(theta_range(peak_idx)));

    myrows{13}='MP th. pow';
    mydata{myi,13} = sprintf('%.2f', fft_results(theta_range(peak_idx)));


AllResults(kidx).spikes = myspikes;
AllResults(kidx).numspikes = length(myspikes);
AllResults(kidx).FireRate = length(myspikes)/(AllResults(kidx).SimDuration/1000);

if ~isempty(myspikes)
    %Sp. FFT stuff
    rez=1; % .1 is simulation resolution

    Fs = 1000/rez; % sampling frequency (per s)

    bins=[0:rez:AllResults(kidx).SimDuration];
    y=histc(myspikes,bins);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));

    theta_range=find(f(:)>=4 & f(:)<=12);
    [~, peak_idx] = max(fft_results(theta_range));
    rel_range=find(f(:)>2 & f(:)<=100);
    [~, over_idx] = max(fft_results(rel_range));
    gamma_range=find(f(:)>=25 & f(:)<=80);
    [~, gamma_idx] = max(fft_results(gamma_range));


    myrows{6}='Spikes';
    mydata{myi,6} = sprintf('%.2f', length(myspikes)); %f(rel_range(over_idx)));

    myrows{7}='FireRate';
    mydata{myi,7} = sprintf('%.2f', length(myspikes)/(AllResults(kidx).SimDuration/1000)); %fft_results(rel_range(over_idx)));

    myrows{8}='Spk th. Hz';
    mydata{myi,8} = sprintf('%.2f', f(theta_range(peak_idx)));

    myrows{9}='Spk th. pow';
    mydata{myi,9} = sprintf('%.2f', fft_results(theta_range(peak_idx)));

    myrows{10}='Spk Norm th. pow';
    mydata{myi,10} = sprintf('%.2f', fft_results(theta_range(peak_idx))/fft_results(rel_range(over_idx)));

    myresultsDetails.FFTSpike.f = f;
    myresultsDetails.FFTSpike.power = fft_results;
    AllResults(kidx).FFTSpike.Theta.freq = f(theta_range(peak_idx));
    AllResults(kidx).FFTSpike.Theta.power = fft_results(theta_range(peak_idx));
    AllResults(kidx).FFTSpike.Theta.norm = fft_results(theta_range(peak_idx))/fft_results(rel_range(over_idx));
    
    n=length(myspikes);
    modspiketimes = mod(myspikes, 1000/AllResults(kidx).FFTSpike.Theta.freq);

    xbar = 1/n*sum(sin(modspiketimes*pi/(1000/AllResults(kidx).FFTSpike.Theta.freq/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(1000/AllResults(kidx).FFTSpike.Theta.freq/2)));

    magnitude=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude);
    else
        angle = 2*pi - acos(ybar/magnitude);
    end
    
    AllResults(kidx).FFTSpike.Theta.phase = angle*180/pi;    
    
    AllResults(kidx).FFTSpike.Gamma.freq = f(gamma_range(gamma_idx));
    AllResults(kidx).FFTSpike.Gamma.power = fft_results(gamma_range(gamma_idx));
    AllResults(kidx).FFTSpike.Gamma.norm = fft_results(gamma_range(gamma_idx))/fft_results(rel_range(over_idx));
    
    n=length(myspikes);
    modspiketimes = mod(myspikes, 1000/AllResults(kidx).FFTSpike.Gamma.freq);

    xbar = 1/n*sum(sin(modspiketimes*pi/(1000/AllResults(kidx).FFTSpike.Gamma.freq/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(1000/AllResults(kidx).FFTSpike.Gamma.freq/2)));

    magnitude=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude);
    else
        angle = 2*pi - acos(ybar/magnitude);
    end
    
    AllResults(kidx).FFTSpike.Gamma.phase = angle*180/pi;    
    
    phase_pref = AllResults(kidx).FFTSpike.Theta.phase;
    if size(mydata,1)>1 % x>1
        phase_diff = phase_pref - str2num(mydata{size(mydata,1),14});
    else
        phase_diff = 0;
    end
    %%%%%%%%%%%%%%


    myrows{14}='Spk Phase Pref';
    mydata{myi,14} = sprintf('%.0f', phase_pref);

    myrows{15}='Spk Phase Shift';
    mydata{myi,15} = sprintf('%+.0f', phase_diff);
else
    myrows{6}='FFT Hz';
    myrows{7}='FFT pow';
    myrows{8}='th. Hz';
    myrows{9}='th. pow';
    myrows{10}='Spk Norm th. pow';
    myrows{11}='MP Norm th. pow';
    myrows{12}='MP th. Hz';
    myrows{13}='MP th. pow';
    myrows{14}='Spk Phase Pref';
    myrows{15}='Spk Phase Shift';

    mydata{myi,6} = '';
    mydata{myi,7} = '';
    mydata{myi,8} = '';
    mydata{myi,9} = '';
%     mydata{myi,10} = '';
%     mydata{myi,11} = '';
%     mydata{myi,12} = '';
%     mydata{myi,13} = '';
    mydata{myi,14} = '';
    mydata{myi,15} = '';
end
    save(AllResults(kidx).DataPath,'myresultsDetails','-v7.3');
    tmpidx=AllResults(kidx).RunIdx;
    if isempty(tmpidx)
        tmpidx=length(RunArray);
    end
    save([RunArray(tmpidx).ModelDirectory sl 'networkclamp_results' sl 'AllResults.mat'],'AllResults','-v7.3');

myrows{16} = 'MP Phase';
myrows{17} = 'MP Phase shift';
% g = gausswin(5000);
% g = g/sum(g);
% y3=conv(b.data(:,2),g,'same');
% [t yidx]=findpeaks(y3);
% pks=b.data(yidx,1);
% MP_per = 1000/str2num(mydata{myi,12});
% mp_rdir=mean(mod(pks,MP_per))/MP_per*2*pi;
% 
% pyrangle_shift=0;
% mp_rdir = mp_rdir-pyrangle_shift;
mp_phase_pref = AllResults(kidx).FFTMP.Theta.phase;
if size(mydata,1)>1 % x>1
    mp_phase_diff = mp_phase_pref - str2num(mydata{size(mydata,1),16});
else
    mp_phase_diff = 0;
end
    
mydata{myi,16} = sprintf('%.0f', mp_phase_pref);
mydata{myi,17} = sprintf('%+.0f', mp_phase_diff);


myrows{18} = 'Input Type';
myrows{19} = 'Input Details';
myrows{20} = '# Conns';
myrows{21} = 'Weights';
myrows{22} = 'Synapses';
myrows{23} = 'Plot h';

mydata{myi,18} = '';
mydata{myi,19} = '';
mydata{myi,20} = '';
mydata{myi,21} = '';
mydata{myi,22} = '';
mydata{myi,23} = myh;

mydata{myi,24} = ephyscell;
mydata{myi,25} = runname;
mydata{myi,26} = resultsfolder;
mydata{myi,27} = celltype;
mydata{myi,28} = num2str(gid);
mydata{myi,29} = repodir;

handles.mydata = mydata; % get(handles.table_runs,'Data');
handles.myrows = myrows;

guidata(handles.table_runs,handles);

if get(handles.rad_view_results,'Value')==1
    idx2show=[1:17];
else % (handles.rad_view_show)
    idx2show=[1:5 18:22];
end

set(handles.table_runs,'Data',mydata(:,idx2show),'ColumnName',myrows(:,idx2show));


        
function txt_description_Callback(hObject, eventdata, handles)
% hObject    handle to txt_description (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_description as text
%        str2double(get(hObject,'String')) returns contents of txt_description as a double


% --- Executes during object creation, after setting all properties.
function txt_description_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_description (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rad_view_setup.
function rad_view_setup_Callback(hObject, eventdata, handles)
% hObject    handle to rad_view_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_view_setup

set(handles.rad_view_setup,'Value',1)
set(handles.rad_view_results,'Value',0)

idx2show=[1:5 16:20];

if ~isempty(handles.mydata) && ~isempty(handles.myrows)
    set(handles.table_runs,'Data',handles.mydata(:,idx2show),'ColumnName',handles.myrows(:,idx2show));
elseif ~isempty(handles.myrows)
    set(handles.table_runs,'ColumnName',handles.myrows(:,idx2show));
end

% --- Executes on button press in rad_view_results.
function rad_view_results_Callback(hObject, eventdata, handles)
% hObject    handle to rad_view_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_view_results

set(handles.rad_view_setup,'Value',0)
set(handles.rad_view_results,'Value',1)

idx2show=[1:15];

if ~isempty(handles.mydata) && ~isempty(handles.myrows)
    set(handles.table_runs,'Data',handles.mydata(:,idx2show),'ColumnName',handles.myrows(:,idx2show));
elseif ~isempty(handles.myrows)
    set(handles.table_runs,'ColumnName',handles.myrows(:,idx2show));
end


% --- Executes on selection change in menu_input_type.
function menu_input_type_Callback(hObject, eventdata, handles)
% hObject    handle to menu_input_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_input_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_input_type
contents = cellstr(get(handles.menu_input_run,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_input_run,'Value')},0,'=');

handles.curses=[];
handles.curses.ind=idx;
guidata(handles.btn_execute,handles);
getcelltypes(handles.btn_execute,guidata(handles.btn_execute))
handles=guidata(handles.btn_execute);


ridx=1;
handles.mycellranges=[];
for r=1:length(handles.curses.cells)
    if strcmp(handles.curses.cells(r).techname,'ppspont')==0
        handles.mycellranges(ridx)=r;
        % mycellranges{ridx} = [handles.curses.cells(r).name ' (' num2str(handles.curses.cells(r).range_st) ' - ' num2str(handles.curses.cells(r).range_en) ')'];
        ridx = ridx + 1;
    end
end
guidata(handles.btn_execute,handles);

%menu_input_run_Callback(handles.menu_input_run, [], handles)
% 
% ridx=1;
% for r=1:length(handles.curses.cells)
%     if strcmp(handles.curses.cells(r).techname,'ppspont')==0
%         mycellranges{ridx} = [handles.curses.cells(r).name ' (' num2str(handles.curses.cells(r).range_st) ' - ' num2str(handles.curses.cells(r).range_en) ')'];
%         ridx = ridx + 1;
%     end
% end

mycellranges=cellstr(get(handles.menu_input_type,'String'));
mycellstr = mycellranges{get(handles.menu_input_type,'Value')};
stidx=strfind(mycellstr,'(');
mycellstr = mycellstr(stidx+1:end);
stidx=strfind(mycellstr,' ');
mycellstr = mycellstr(1:stidx-1);
set(handles.txt_input_gid,'String',mycellstr)

techstr = handles.curses.cells(handles.mycellranges(get(handles.menu_input_type,'Value'))).techname;
midx = strmatch(techstr,cellstr(get(handles.menu_cell_type,'String')));
set(handles.menu_cell_type,'Value',midx)
menu_conn_conn_Callback(handles.menu_conn_conn, [], handles)

% --- Executes during object creation, after setting all properties.
function menu_input_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_input_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in table_runs.
function table_runs_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table_runs (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

for g=1:size(eventdata.Indices,1)
    if eventdata.Indices(g,2)==1 && eventdata.PreviousData(g)==0 && eventdata.NewData(g)==1
        handles.mydata{eventdata.Indices(g,1),1}=logical(1);
        guidata(hObject,handles);
        readdline(handles,eventdata.Indices(g,1))
    elseif eventdata.Indices(g,2)==1 && eventdata.PreviousData(g)==1 && eventdata.NewData(g)==0
        handles.mydata{eventdata.Indices(g,1),1}=logical(0);
        guidata(hObject,handles);
        removeline2graph(handles,eventdata.Indices(g,1))
    end
end



function txt_Duration_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Duration as text
%        str2double(get(hObject,'String')) returns contents of txt_Duration as a double


% --- Executes during object creation, after setting all properties.
function txt_Duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ShowRast()
celltypeNice={'Pyramidal','PV+ Basket','CCK+ Basket','S.C.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform'};
handles.formatP.textwidth=15;
handles.formatP.plottextwidth=.1;
handles.formatP.marg=.03/2;
handles.formatP.st=2;
handles.formatP.left = .065;
handles.formatP.bottom=.065;
handles.formatP.hmar=-.03;
handles.formatP.colorvec={'m','k','b','r','g','y','c'};
handles.formatP.sizevec={5,5,5,5,5,5,5,5,5,5,5,5,5};
handles.formatP.figs=[];

handles.curses=[];
handles.curses.ind=[];

filename = ['C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\CutMor_032_Long\00035\celltype.dat'];
tmpdata = importdata(filename);

for r=1:size(tmpdata.textdata,1)-1
    handles.curses.cells(r).name=tmpdata.textdata{r+1,1};
    handles.curses.cells(r).techname=tmpdata.textdata{r+1,2};
    handles.curses.cells(r).ind=tmpdata.data(r,1);
    handles.curses.cells(r).range_st=tmpdata.data(r,2);
    handles.curses.cells(r).range_en=tmpdata.data(r,3);
    handles.curses.cells(r).numcells=handles.curses.cells(r).range_en - handles.curses.cells(r).range_st + 1;
end

filename = ['C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\CutMor_032_Long\00035\spikeraster.dat'];
readsegsize=10000;

handles.curses.spikerast=[];

fid=fopen(filename);
i=0;

while ~feof(fid) % & i<1000
    [mymat valcount] = fscanf(fid, '%f\t%g\n',[readsegsize, 2]);
    if valcount==readsegsize*2
        try
            handles.curses.spikerast(1+i*readsegsize:(i+1)*readsegsize,1:2) = reshape(mymat,2,[])';
        catch ME         
            disp(['could not fill spikes ' num2str(1+i*readsegsize) ':' num2str((i+1)*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    else
        try
            handles.curses.spikerast(1+i*readsegsize:valcount/2+i*readsegsize,1:2) = reshape(mymat(1:valcount),2,[])';
            handles.curses.spikerast(valcount/2+i*readsegsize+1:end,:) = [];
        catch ME
            disp(['could not fill last spikes ' num2str(1+i*readsegsize) ':' num2str(valcount/2+i*readsegsize)])
            disp(['specific error: ' ME.message]);
            disp(['in ' ME.stack.file ' line ' ME.stack.line]);
            return
        end
    end
    i=i+1;
end
fclose(fid);
clear mymat fid filename valcount i ME
handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);

handles.optarg='pyremph'; % pyremph
htmp=figure('Visible','on','Color','w','PaperUnits','inches','PaperSize',[11 7],'PaperPosition',[1 1 10 6]);
pos=get(gcf,'Units');
set(gcf,'Units','normalized','Position',[0.1 0.1 .9 .9]);
set(gcf,'Units',pos);
figure(htmp);
htmp=plot_raster(handles,gca);

ch=get(gcf,'Children');
for c=1:length(ch)
    yr=get(get(ch(c),'Children'),'YData');
    [~, ~, ranking] = unique(yr);
    set(get(ch(c),'Children'),'YData',ranking);
    set(ch(c),'YLim',[min(ranking) max(ranking)]);%,'XLim',[0 1000]);
end
linkaxes(ch,'x');


handles.optarg='histemph'; % pyremph
htmp(2)=figure('Visible','on','Color','w','PaperUnits','inches','PaperSize',[11 7],'PaperPosition',[1 1 10 6]);
pos=get(gcf,'Units');
set(gcf,'Units','normalized','Position',[0.1 0.1 .9 .9]);
set(gcf,'Units',pos);
figure(htmp(2));
htmp=plot_raster(handles,gca);
ch=get(gcf,'Children');
linkaxes(ch,'x');

function PlotTrace()
% baseresults=importdata('C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\BasicRun_02\00059\mytrace_21310_soma.dat');
% pvresults=importdata('C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\BasicRun_02\00060\mytrace_21310_soma.dat');
baseresultsSpike=importdata('C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\CutMor_032_Long\00026\mytrace_21310_soma.dat');
baseresults=importdata('C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\CutMor_032_Long\00032\mytrace_21310_soma.dat');
pvresults=importdata('C:\Users\maria_000\Documents\repos\ca1\networkclamp_results\CutMor_032_Long\00031\mytrace_21310_soma.dat');

figure('Color','w')
plot(baseresultsSpike.data(:,1),baseresultsSpike.data(:,2),'k')



figure('Color','w')
plot(baseresults.data(:,1),baseresults.data(:,2),'k','LineWidth',2)
hold on
plot(pvresults.data(:,1),pvresults.data(:,2),'Color',[.5 .5 .5],'LineWidth',2)
xlim([1000 1500])

legend({'base','0% PV inhibition'})
set(gco,'EdgeColor','w')
axis off