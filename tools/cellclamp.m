function varargout = cellclamp(varargin)
global mypath nmod mydesc

% CELLCLAMP M-file for cellclamp.fig
%       /usr/local/mpich2/bin/
%      CELLCLAMP, by itself, creates a new CELLCLAMP or raises the existing
%      singleton*.
%
%      H = CELLCLAMP returns the handle to a new CELLCLAMP or the handle to
%      the existing singleton*.
%
%      CELLCLAMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLCLAMP.M with the given input arguments.
%
%      CELLCLAMP('Property','Value',...) creates a new CELLCLAMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellclamp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellclamp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to nmodify the response to help cellclamp

% Last nmodified by GUIDE v2.5 08-Feb-2013 10:31:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellclamp_OpeningFcn, ...
                   'gui_OutputFcn',  @cellclamp_OutputFcn, ...
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


% --- Executes just before cellclamp is made visible.
function cellclamp_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath mydesc sl
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellclamp (see VARARGIN)

% Choose default command line output for cellclamp
handles.output = hObject;
set(handles.btn_browse,'Visible','off')

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

handles.general=general;
clear general

    getready2runNRN(handles)

%     if isfield(handles.general,'setenv') && handles.general.setenv==1
%         w=strfind(handles.general.neuron,'bin');
% 
%         if ispc==1
%             setenv('PYTHONHOME',cygwin(handles.general.neuron(1:w-2)));
%             setenv('PYTHONPATH',cygwin([handles.general.neuron(1:w-2) sl 'lib']));
%             setenv('N',cygwin(handles.general.neuron(1:w-2)));
%             setenv('NEURONHOME',cygwin(handles.general.neuron(1:w-2)));
%         else
%             setenv('PYTHONHOME',handles.general.neuron(1:w-2));
%             setenv('PYTHONPATH',[handles.general.neuron(1:w-2) sl 'lib']);
%             setenv('N',handles.general.neuron(1:w-2));
%             setenv('NEURONHOME',handles.general.neuron(1:w-2));
%        end
%     end

if ispc
    handles.dl = ' & ';
else %if isunix
    handles.dl = ';';
end

% Update handles structure
guidata(hObject, handles);
addpath(mypath)

% UIWAIT makes cellclamp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end
handles.directoryname = myrepos(q).dir;


if exist([ handles.directoryname sl 'setupfiles' sl 'clamp' sl 'blanksoma.mat'])
    load([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'blanksoma.mat'])
    handles.somadim = somadim;
    handles.Ra = Ra;
    handles.cm = cm; % 32*10^(-5) ? // for the p-type channel, 32 pF
    handles.Ca = Ca;
    handles.celsius = celsius;
    handles.mydt = mydt;
    if exist('secondorder','var')
        handles.secondorder = secondorder;
    else
        handles.secondorder = 2;
    end
else
    handles.somadim = 16.8;
    handles.Ra = 210;
    handles.cm = 1; % 32*10^(-5) ? // for the p-type channel, 32 pF
    handles.Ca = 5.e-6;
    handles.celsius = 37;
    handles.mydt = 0.1;
    handles.secondorder = 2;
end

handles.excmdstr = handles.general.neuron;
%handles.directoryname = directoryname;
btn_browse_Callback(handles.btn_browse, [], handles,1)

guidata(hObject, handles);
menu_cellnum_Callback(handles.menu_cellnum, eventdata, handles)

function cmdstr=cygwin(cmdstr)

cmdstr=strrep(strrep(cmdstr,'\','/'),'C:','/cygdrive/c');

function btn_browse_CreateFcn(hObject, eventdata, handles)
global mypath sl
set(hObject,'Visible','off')

% --- Outputs from this function are returned to the command line.
function varargout = cellclamp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txt_directory_Callback(hObject, eventdata, handles)
% hObject    handle to txt_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_directory as text
%        str2double(get(hObject,'String')) returns contents of txt_directory as a double


% --- Executes during object creation, after setting all properties.
function txt_directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles,varargin)
global mypath mydesc sl
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open the uigetdirectory



if isempty(varargin)

        handles.directoryname = uigetdir(handles.directoryname, 'Pick a Directory');
    
end
set(handles.txt_directory,'String',handles.directoryname)

%excmdstr = handles.excmdstr;
%directoryname = handles.directoryname;
%save tools/excmdstr.mat excmdstr directoryname

if ispc
    [~, result] = system(['cd ' handles.directoryname handles.dl 'hg parent --template "{rev}: {desc}\n"']);
else
    [~, result] = system(['cd ' handles.directoryname handles.dl 'hg parent --template ''{rev}: {desc}\n''']);
end
set(handles.txt_version,'String',['Version ' result])

%cd(handles.directoryname)
guidata(hObject, handles)
fldrs={'cellclamp_results','figures','setupfiles'};
% if pc
%     sl='\';
% else
%     sl='/';
% end
for r=1:length(fldrs)
    if exist([handles.directoryname sl fldrs{r}],'dir')~=7
        mkdir(handles.directoryname,fldrs{r});
    end
end;

%removethispart
% a = dir([handles.directoryname '/cells/class_*cell.hoc']);
% mycells{1}='All';
% for r=1:length(a)
%     mycells{r+1}=a(r).name(7:end-4);
% end
% mycells{r+2}='ppca3sin';
% mycells{r+3}='ppecsin';
% set(handles.list_cell,'Value',1);
% set(handles.list_cell,'String',mycells);

a = dir([handles.directoryname sl 'ch_*.mod']);

%mynmod{1}='All';
mechdata={};
for r=1:length(a)
    %mynmod{r+1}=a(r).name(4:end-4);
    mechdata{r}=a(r).name(4:end-4);

    fid = fopen([handles.directoryname sl a(r).name]);
    C = textscan(fid, '%s');
    fclose(fid);
    useion=strmatch('USEION',C{:}(:));
    if isempty(useion)
        ion{r}='';
    else
        ion{r}=['e' char(C{:}(useion(1)+1))];
    end
end

%set(handles.list_mech,'Value',1);
%set(handles.list_mech,'String',mynmod);

%mechdata = {'table_ResultCounts';'table_softwareinfo';'table_computerinfo';'table_printinfo'; 'table_siminfo'};
if exist('mechdata','var') && ~isempty(mechdata)
    mechdata = [mechdata'  repmat({''},size(mechdata')) ion' repmat({''},size(mechdata'))];
    set(handles.table_mech,'Data',mechdata);
else
    mechdata={};
    set(handles.table_mech,'Data',mechdata);
end

usenewway=0;
if usenewway
    addcells2menu(myrepos(q).dir,sl,handles,'cellnumbers','cells','numdata')
    addcells2menu(myrepos(q).dir,sl,handles,'conndata','conns','conndata')
    addcells2menu(myrepos(q).dir,sl,handles,'syndata','syns','syndata')
else
    a=dir([handles.directoryname sl 'datasets' sl 'syndata_*.dat']);
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'syndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=a(r).name;
        end
    end
    numvec=numvec(end:-1:1);
    set(handles.menu_kinsyn,'String',numvec)
    set(handles.menu_kinsyn,'Value',1)
    menu_kinsyn_Callback(handles.menu_kinsyn, [], handles)

    a=dir([handles.directoryname sl 'datasets' sl 'conndata_*.dat']);
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'conndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=a(r).name;
        end
    end
    numvec=numvec(end:-1:1);
    set(handles.menu_numcon,'String',numvec)
    set(handles.menu_numcon,'Value',1)
    menu_numcon_Callback(handles.menu_numcon, [], handles)

    a=dir([handles.directoryname '/datasets/cellnumbers_*.dat']);
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'cellnumbers_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=a(r).name;
        end
    end
    numvec=numvec(end:-1:1);
    set(handles.menu_cellnum,'String',numvec)
    set(handles.menu_cellnum,'Value',1)
    menu_cellnum_Callback(handles.menu_cellnum, [], handles)
end

if exist([handles.directoryname '/cellclamp_results/mydesc.mat'])
    load([handles.directoryname '/cellclamp_results/mydesc.mat'])

    mystr={};
    for r=1:length(mydesc)
        mystr{r}=[mydesc(r).name ': ' mydesc(r).desc];
    end
    mystr=mystr(end:-1:1);
    set(handles.menu_results,'String',mystr)

else
    mydesc=[];
end




function txt_command_Callback(hObject, eventdata, handles)
% hObject    handle to txt_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_command as text
%        str2double(get(hObject,'String')) returns contents of txt_command as a double



% --- Executes during object creation, after setting all properties.
function txt_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_examples.
function btn_examples_Callback(hObject, eventdata, handles)
% hObject    handle to btn_examples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open a new gui with copy-able text strings that are examples with mpi,
% without mpi, etc.

% --- Executes on button press in btn_showreport.
function btn_showreport_Callback(hObject, eventdata, handles)
% hObject    handle to btn_showreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open a pdf (or whatever) outside of MATLAB


% --- Executes on button press in btn_showimages.
function btn_showimages_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_showimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open the alphabetically first image outside of MATLAB in a default image
% viewer, which is likely to have forward/back navigation through image
% files

try
    contents=cellstr(get(handles.menu_results,'String'));
	myname=contents{get(handles.menu_results,'Value')};
    f = findstr(':', myname);
    myresultsfolder=myname(1:f-1);
catch
    tmp=inputdlg('Name the results folder to use');
    myresultsfolder=tmp{:};
end
%check here for cd results issues
% if isunix
%     cd([handles.directoryname '/cellclamp_results/' myresultsfolder]);
% elseif ispc
%     cd([handles.directoryname '\cellclamp_results\' myresultsfolder]);
% end
fi=dir([handles.directoryname '/cellclamp_results/' myresultsfolder '/*.jpg']);
if isempty(fi)
    handles=geticlamp(hObject,handles);
    % make the figs
    if get(handles.chk_customcurr,'Value')==1
        plotsinglecustom(handles.iclamp,handles,myresultsfolder) %addhere
    elseif get(handles.chk_cellclamp,'Value')==1
        plotsingleresults(handles.iclamp,handles,myresultsfolder);
    elseif get(handles.chk_cellclampi,'Value')==1
        plotsingleresultsSE(handles.iclamp,handles,myresultsfolder);
    end
    if (get(handles.chk_connpair,'Value')==1 || get(handles.chk_currpair,'Value')==1)
        plotpairresults(handles.iclamp,handles,myresultsfolder);
    end
    fi=dir([handles.directoryname '/cellclamp_results/' myresultsfolder '/*.jpg']);
end

if ~isempty(fi)
    picfile=[handles.directoryname '/cellclamp_results/' myresultsfolder '/' fi(1).name];
    system([handles.general.picviewer ' ' regexprep(picfile, ' ', '\\ ')])
end

% --- Executes on button press in btn_showfigs.
function btn_showfigs_Callback(hObject, eventdata, handles)
global mypath nmod sl
% hObject    handle to btn_showfigs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    contents=cellstr(get(handles.menu_results,'String'));
	myname=contents{get(handles.menu_results,'Value')};
    f = findstr(':', myname);
    myresultsfolder=myname(1:f-1);
catch
    tmp=inputdlg('Name the results folder to use');
    myresultsfolder=tmp{:};
end

% if isunix
%     cd([handles.directoryname '/cellclamp_results/' myresultsfolder]);
% elseif ispc
%     cd([handles.directoryname '\cellclamp_results\' myresultsfolder]);
% end
% fi=dir('*.fig');
fi=dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl '*.fig']);

handles.myresultsfolder = myresultsfolder;
%if isempty(nmod)
if get(handles.chk_mechact,'Value')==1 || get(handles.chk_mechIV,'Value')==1
    ff = fopen([handles.directoryname '/cellclamp_results/' myresultsfolder '/clamp/nmod.txt' ], 'r');
    myevals = textscan(ff,'%s','Delimiter','\n');
    fclose(ff)
    for r=1:length(myevals{1})
        eval(myevals{1}{r})
    end
    
%     nmod.stepto_amplitude1
%     nmod.hold_amplitude2
%     nmod.stepto_duration2
%     nmod.stepto_duration1
%     nmod.stepto_current
%     nmod.iv_current
%end
end
   % just uncommented this part 
%if length(fi)==0
    handles=geticlamp(hObject,handles);
    % make the figs
    if get(handles.chk_mechact,'Value')==1
        plotmechact(handles.iclamp,handles);
    end
    if get(handles.chk_mechIV,'Value')==1
        %plotmechiv(handles.iclamp,handles);
    end
    if get(handles.chk_cellclamp,'Value')==1
        plotsingleresults(handles.iclamp,handles,myresultsfolder);
    elseif get(handles.chk_cellclampi,'Value')==1
        plotsingleresultsSE(handles.iclamp,handles,myresultsfolder);
    elseif get(handles.chk_customcurr,'Value')==1
        plotsinglecustom(handles.iclamp,handles,myresultsfolder) %addhere
    end
    if (get(handles.chk_connpair,'Value')==1 || get(handles.chk_currpair,'Value')==1)
        plotpairresults(handles.iclamp,handles,myresultsfolder);
    end
    fi=dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl '*.fig']);
%end

%for r=1:length(fi)
%    figfile=[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl fi(r).name];
%    openfig(figfile,'reuse','visible');
%end

% --- Executes on button press in btn_showdata.
function btn_showdata_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_showdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    contents=cellstr(get(handles.menu_results,'String'));
	myname=contents{get(handles.menu_results,'Value')};
    f = findstr(':', myname);
    myresultsfolder=myname(1:f-1);
catch
    tmp=inputdlg('Name the results folder to use');
    myresultsfolder=tmp{:};
end

% open the folder with the data files
%if isunix
    system([handles.general.explorer ' ' regexprep([handles.directoryname sl 'cellclamp_results' sl myresultsfolder], ' ', '\\ ')])
%else
%    winopen([handles.directoryname '\cellclamp_results\' myresultsfolder])
%end

function handles=getcusticlamp(hObject,handles)
global mypath sl

if 1==0
    testy=eval(clipboard('paste'));
    handles.iclamp.current=[testy(:,1)*1000 testy(:,2)]; %[time current];
    handles.iclamp.c_dur = testy(end,1)*1000;
else
    handles.iclamp.c_dur = 20*1000; % twenty seconds ... ramp up to 20 Hz
    time=0:.001:handles.iclamp.c_dur/1000;wh=-.040*chirp(time,0,20,20,'linear',-90);
    handles.iclamp.current=[time(:)*1000 wh(:)]; %[time current];
end
handles.iclamp.c_start=0; % (ms)
handles.iclamp.c_after=0; % (ms)
guidata(hObject, handles);

handles.iclamp.tstop=handles.iclamp.c_dur;

handles.iclamp.paircurrent=str2num(get(handles.txt_pre,'String')); % (current)
handles.iclamp.holding=str2num(get(handles.txt_post,'String')); % (holding pot.)
handles.iclamp.pairstart=str2num(get(handles.txt_pairstart,'String')); % (ms)
handles.iclamp.pairend=str2num(get(handles.txt_pairend,'String')); % (ms)
handles.iclamp.revpot=str2num(get(handles.txt_rev,'String')); % (reversal pot.)
handles.iclamp.revflag=get(handles.radio_set,'Value'); % set reversal potential (or leave per original definition)

guidata(hObject, handles);

function handles=geticlamp(hObject,handles)
global mypath sl
handles.iclamp.current=eval(get(handles.txt_current,'String'));
handles.iclamp.c_start=str2num(get(handles.txt_start,'String')); % (ms)
handles.iclamp.c_dur=str2num(get(handles.txt_dur,'String')); % (ms)
handles.iclamp.c_after=str2num(get(handles.txt_after,'String')); % (ms)
guidata(hObject, handles);
handles.iclamp.tstop=handles.iclamp.c_after+handles.iclamp.c_start+handles.iclamp.c_dur;

handles.iclamp.paircurrent=str2num(get(handles.txt_pre,'String')); % (current)
handles.iclamp.holding=str2num(get(handles.txt_post,'String')); % (holding pot.)
handles.iclamp.pairstart=str2num(get(handles.txt_pairstart,'String')); % (ms)
handles.iclamp.pairend=str2num(get(handles.txt_pairend,'String')); % (ms)
handles.iclamp.revpot=str2num(get(handles.txt_rev,'String')); % (reversal pot.)
handles.iclamp.revflag=get(handles.radio_set,'Value'); % set reversal potential (or leave per original definition)

guidata(hObject, handles);


% --- Executes on button press in btn_run.
function myresultsfolder = btn_run_Callback(hObject, eventdata, handles,varargin)
global mypath nmod mydesc sl logloc
% hObject    handle to btn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
if isempty(findstr(handles.directoryname,'/'))
    mysl='\';
else
    mysl='/';
end

if isempty(varargin)
    mycomments = inputdlg(['Give a description to this dataset: ']);
else
    mycomments = varargin(1);
end

if isempty(mycomments) || isempty(mycomments{:})
    return
end

% d=dir([handles.directoryname sl 'cellclamp_results']);
% idx=[d.isdir];
% d=d(idx);
% if length(d)==2
%     myresultsfolder='001';
% else
%     myresultsfolder=sprintf('%03.0f', str2num(d(end).name)+1);
% end

if isempty(mydesc) || length(mydesc)<1
     myresultsfolder='001';
else
    myresultsfolder= sprintf('%03.0f',(str2num(mydesc(end).name)+1));
end

handles.myresultsfolder=myresultsfolder;
if ispc
    system(['mkdir "' handles.directoryname sl 'cellclamp_results' sl myresultsfolder '"'])
else
    system(['mkdir ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder])
end
if get(handles.chk_mechact,'Value')==1 || get(handles.chk_mechIV,'Value')==1
if ispc
    system(['mkdir "' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp"'])
else
    system(['mkdir ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp'])
end
end
system([handles.general.explorer ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl])
disp(['Results are in folder: ' myresultsfolder ])
getGUIvalues(handles,myresultsfolder)
% RUNHERE

g=length(mydesc)+1;
mydesc(g).name=myresultsfolder;
mydesc(g).desc=mycomments{:};
save([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc','-v7.3')

mystr={};
for r=1:length(mydesc)
    mystr{r}=[mydesc(r).name ': ' mydesc(r).desc];
end
mystr=mystr(end:-1:1);
set(handles.menu_results,'String',mystr)

% Write files documenting any version diffs
[~, statresult]=system(['cd ' handles.directoryname sl  handles.dl ' hg status']);
if ~isempty(statresult)
    % print file to save stats results
    fid = fopen([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'versionstatus.dat'], 'w');
    fprintf(fid, '%s', statresult) 
    fclose(fid)
    [~, diffresult]=system(['cd ' handles.directoryname sl  handles.dl ' hg diff']);
    % print file to save diff results
    fid = fopen([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'versiondifference.dat'], 'w');
    fprintf(fid, '%s', diffresult)
    fclose(fid)
end

if get(handles.chk_customcurr,'Value')==1
    handles=getcusticlamp(hObject,handles);
else
    handles=geticlamp(hObject,handles);
end
% Write a run receipt

fid = fopen([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'runreceipt.dat'], 'w');
if ispc
    [~, versionresult]=system(['cd ' handles.directoryname sl  handles.dl ' hg parent --template "{rev}: {desc}"']);
else
    [~, versionresult]=system(['cd ' handles.directoryname sl  handles.dl ' hg parent --template ''{rev}: {desc}''']);
end
fprintf(fid, 'run=''%s''\nversion=''%s''\n', myresultsfolder, versionresult);
fprintf(fid, 'somadim=%g\nRa=%g\ncm=%g\nCa=%g\ncelsius=%g\nmydt=%g\n', handles.somadim, handles.Ra, handles.cm, handles.Ca, handles.celsius, handles.mydt);

numtmp=get(handles.menu_cellnum,'String');
try
tk = regexp(numtmp{get(handles.menu_cellnum,'Value')},'cellnumbers_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl numtmp{get(handles.menu_cellnum,'Value')} ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
catch
tk = regexp(numtmp,'cellnumbers_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl numtmp ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
end
numstr = str2double(tk{1}{:});

conntmp=get(handles.menu_numcon,'String');
try
tk = regexp(conntmp{get(handles.menu_numcon,'Value')},'conndata_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl conntmp{get(handles.menu_numcon,'Value')} ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
catch
tk = regexp(conntmp,'conndata_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl conntmp ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
end
connstr = str2double(tk{1}{:});

syntmp=get(handles.menu_kinsyn,'String');
try
tk = regexp(syntmp{get(handles.menu_kinsyn,'Value')},'syndata_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl syntmp{get(handles.menu_kinsyn,'Value')} ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
catch
tk = regexp(syntmp,'syndata_(\d*).dat','tokens');
system(['cp ' handles.directoryname sl 'datasets' sl syntmp ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl ])
end
synstr = str2double(tk{1}{:});

NumData = numstr; 
ConnData =connstr;
SynData = synstr;

fprintf(fid, 'NumData=%g\nConnData=%g\nSynData=%g\n', NumData, ConnData, SynData);


% if ion channel graphs produced, write out table and voltage settings
if get(handles.chk_mechact,'Value')==1 || get(handles.chk_mechIV,'Value')==1
    fprintf(fid, 'ionchannels=1\n');    
%     fprintf(fid, 'stepto_current=%g\niv_current=%g\nstepto_stepsize=%g\n', eval(get(handles.txt_actcurr,'String')), eval(get(handles.txt_IVcurr,'String')), nmod.stepto_current(2)-nmod.stepto_current(1));
%     fprintf(fid, 'run_current=%g\n', min(nmod.stepto_current(1),nmod.iv_current(1)):nmod.stepto_stepsize:max(nmod.stepto_current(end),nmod.iv_current(end)));
%     fprintf(fid, 'stepto_numsteps=%g\n', length(nmod.run_current));
%  	fprintf(fid, 'stepto_amplitude=%g\n', str2num(get(handles.txt_actstartcurr,'String')));
%  	fprintf(fid, 'stepto_amplitude2=%g\n', nmod.run_current(1));
%  	fprintf(fid, 'stepto_duration=%g\n', str2num(get(handles.txt_actstart,'String')));
%  	fprintf(fid, 'stepto_duration2=%g\n', str2num(get(handles.txt_actdur,'String')));
%     fprintf(fid, 'hold_current=%g\n', eval(get(handles.txt_incurr,'String')));  
%     fprintf(fid, 'hold_numsteps=%g\n', length(nmod.hold_current));
%  	fprintf(fid, 'hold_amplitude1=%g\n', nmod.hold_current(1));
%  	fprintf(fid, 'hold_amplitude2=%g\n', str2num(get(handles.txt_inaftercurr,'String')));
%  	fprintf(fid, 'hold_stepsize=%g\n', nmod.hold_current(2)-nmod.hold_current(1));
%  	fprintf(fid, 'hold_duration1=%g\n', str2num(get(handles.txt_indur,'String')));
%  	fprintf(fid, 'hold_duration2=%g\n', str2num(get(handles.txt_inafter,'String'))); 

    % write the number of currents
    mechdata = get(handles.table_mech,'Data');

    for r=1:size(mechdata,1)
        if ~isempty(mechdata{r,2})
            if isempty(mechdata{r,3})
                mechdata{r,3}=['e_ch_' mechdata{r,1}];
            end
            fprintf(fid, '%s\t%s\t%s\t%s\n', mechdata{r,1}, num2str(mechdata{r,2}), mechdata{r,3}, num2str(mechdata{r,4}));
            %system(['cd /home/casem/matlab/work/cellclamp/clamp/;mkdir ' mechdata{r,1}]);
            system(['cd ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl handles.dl 'mkdir ' mechdata{r,1}]);
        end
    end
else
    fprintf(fid, 'ionchannels=0\n');    
end

% if single cell produced, write out voltage settings
if get(handles.chk_cellclamp,'Value')==1
    fprintf(fid, 'cellclamp=1\n');    
    fprintf(fid, 'numcurrents=%g\ncurrents=[', length(handles.iclamp.current));
    % write each current on its own line
    fprintf(fid, '%g\t', handles.iclamp.current);
    fprintf(fid, ']\n');
    % close the file

elseif get(handles.chk_cellclampi,'Value')==1
    fprintf(fid, 'cellclamp=1\n');    
    fprintf(fid, 'numcurrents=%g\ncurrents=[', length(handles.iclamp.current));
    % write each current on its own line
    fprintf(fid, '%g\t', handles.iclamp.current);
    fprintf(fid, ']\n');
    % close the file
elseif get(handles.chk_customcurr,'Value')==1
    fprintf(fid, 'cellclamp=1\n');    
    fprintf(fid, 'numcurrents=%g\ncurrents=[', length(handles.iclamp.current));
    % write each current on its own line
    fprintf(fid, '%g\t', handles.iclamp.current);
    fprintf(fid, ']\n');
    % close the file
else
    fprintf(fid, 'cellclamp=0\n');    
end

% if pairs produced, write out NumData, ConnData, SynData, current/voltage
% produced and reversal potential

if (get(handles.chk_connpair,'Value')==1 || get(handles.chk_currpair,'Value')==1)
    fprintf(fid, 'pairs=1\n');    
    fprintf(fid, 'paircurrent=%g\nholding=%g\npairstart=%g\npairend=%g\nrevpot=%g\nrevflag=%g\n', handles.iclamp.paircurrent, handles.iclamp.holding, handles.iclamp.pairstart, handles.iclamp.pairend, handles.iclamp.revpot, handles.iclamp.revflag);
else
    fprintf(fid, 'pairs=0\n');    
end

fclose(fid);


if get(handles.chk_mechact,'Value')==1
    % mechs we want
    % open a celltype file and list all the ones we want the data for
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'imodset.dat'], 'w');
    
%     % mechs we want
%     cs = get(handles.list_mech, 'String');
%     cv = get(handles.list_mech, 'Value');
%     mynmod = cs(cv);
%     
%     if (length(cv)==1 && strcmp('All',cs{cv}))==1
%         mynmod=cs(2:end);
%     end
  
    fprintf(fid, '%f\n', handles.somadim);
    
    fprintf(fid, '%f\n', handles.Ra);
    
    fprintf(fid, '%f\n', handles.cm);
    
    fprintf(fid, '%f\n', handles.Ca);
    
    fprintf(fid, '%f\n', handles.celsius);    
    
    fprintf(fid, '%f\n', handles.mydt);    
    
    mydata=get(handles.table_mech,'Data');
    for r=1:size(mydata,1)
        if ~isempty(mydata{r,2})
            % write each current
            fprintf(fid, 'ch_%s\ngmax\n', mydata{r,1});
            fprintf(fid, '%s\n%f\n%f', mydata{r,3}, mydata{r,2}, mydata{r,4}); % reversal_str, density, reversal_val);            
        end
    end

    % fprintf(fid, '%g\n', length(mynmod)); % write out the number of
    % channels to test - this is commented out for now while I only run one
    % at a time
    
    % close the file
    fclose(fid);
end


% get the custom run command from step 2


nhost = feature('numCores');
excmdstr = handles.excmdstr;
%excmdstr = get(handles.txt_command,'String');
insertstring = [' -c mytstop=' num2str(handles.iclamp.tstop)]; %num2str(handles.iclamp.tstop)];
insertstring = [insertstring ' -c duration=' num2str(handles.iclamp.c_dur)];
insertstring = [insertstring ' -c starttime=' num2str(handles.iclamp.c_start)];


fid = fopen([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'mechclamp.dat'], 'w');
%fprintf(fid, '%g\t%g\t%g\t%g\t%g\t%g\n', get(handles.chk_mechact,'Value'), get(handles.chk_mechIV,'Value'), handles.somadim, handles.Ra, handles.cm, handles.celsius);
fprintf(fid, '%g\t%g\t%g\t%g\t%g\t%g\n', handles.somadim, handles.Ra, handles.cm, handles.Ca, handles.celsius, handles.mydt);

if get(handles.chk_mechact,'Value')==1 || get(handles.chk_mechIV,'Value')==1
    insertstring=[insertstring ' -c mech=1'];
    % open the pairclamp.dat file
    
    nmod.stepto_current = eval(get(handles.txt_actcurr,'String'));

    nmod.iv_current = eval(get(handles.txt_IVcurr,'String'));
    
 	nmod.stepto_stepsize = nmod.stepto_current(2)-nmod.stepto_current(1);
    fprintf(fid, '%f\n', nmod.stepto_stepsize);  

    nmod.run_current = min(nmod.stepto_current(1),nmod.iv_current(1)):nmod.stepto_stepsize:max(nmod.stepto_current(end),nmod.iv_current(end));

    nmod.stepto_numsteps = length(nmod.run_current);
    fprintf(fid, '%f\n', nmod.stepto_numsteps);

 	nmod.stepto_amplitude1 = str2num(get(handles.txt_actstartcurr,'String'));
    fprintf(fid, '%f\n', nmod.stepto_amplitude1);
    
 	nmod.stepto_amplitude2 = nmod.run_current(1);
    fprintf(fid, '%f\n', nmod.stepto_amplitude2);
    
 	nmod.stepto_duration1 = str2num(get(handles.txt_actstart,'String'));
    fprintf(fid, '%f\n', nmod.stepto_duration1);
    
 	nmod.stepto_duration2 = str2num(get(handles.txt_actdur,'String'));
    fprintf(fid, '%f\n', nmod.stepto_duration2);

    nmod.hold_current = eval(get(handles.txt_incurr,'String'));  
    
    nmod.hold_numsteps = length(nmod.hold_current);
    fprintf(fid, '%f\n', nmod.hold_numsteps);
    
 	nmod.hold_amplitude1 = nmod.hold_current(1);
    fprintf(fid, '%f\n', nmod.hold_amplitude1);
    
 	nmod.hold_amplitude2 = str2num(get(handles.txt_inaftercurr,'String'));
    fprintf(fid, '%f\n', nmod.hold_amplitude2);
    
 	nmod.hold_stepsize = nmod.hold_current(2)-nmod.hold_current(1);
    fprintf(fid, '%f\n', nmod.hold_stepsize);
    
 	nmod.hold_duration1 = str2num(get(handles.txt_indur,'String'));
    fprintf(fid, '%f\n', nmod.hold_duration1);
    
 	nmod.hold_duration2 = str2num(get(handles.txt_inafter,'String')); 
    fprintf(fid, '%f\n', nmod.hold_duration2);        
%   stepto_numsteps = 14
% 	stepto_amplitude1 = -110
% 	stepto_amplitude2 = -60
% 	stepto_stepsize = 10
% 	stepto_duration1 = 200
% 	stepto_duration2 = 500
% 
% 	hold_numsteps = 16
% 	hold_amplitude1 = -120
% 	hold_amplitude2 = 20
% 	hold_stepsize = 10
% 	hold_duration1 = 500
% 	hold_duration2 = 500 
    
    % write the number of currents
    mechdata = get(handles.table_mech,'Data');
    %system(['cd /home/casem/matlab/work/cellclamp/clamp/;rm -r ./*'])

    for r=1:size(mechdata,1)
        if ~isempty(mechdata{r,2})
            if isempty(mechdata{r,3})
                mechdata{r,3}=['e_ch_' mechdata{r,1}];
            end
            fprintf(fid, '%s\t%s\t%s\t%s\n', mechdata{r,1}, num2str(mechdata{r,2}), mechdata{r,3}, num2str(mechdata{r,4}));
            system(['cd ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl handles.dl 'mkdir ' mechdata{r,1}]);
            ff = fopen([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl mechdata{r,1} sl 'chdata.txt' ], 'w');
            fprintf(ff, '%s\t%s\t%s\t%s\n', mechdata{r,1}, num2str(mechdata{r,2}), mechdata{r,3}, num2str(mechdata{r,4}));
            fclose(ff);
        end
    end
    % close the file
    
    ff = fopen([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl 'nmod.txt' ], 'w');
    fprintf(ff, 'nmod.stepto_amplitude1=%g;\n', nmod.stepto_amplitude1)
    fprintf(ff, 'nmod.hold_amplitude2=%g;\n', nmod.hold_amplitude2)
    fprintf(ff, 'nmod.hold_duration1=%g;\n', nmod.hold_duration1)
    fprintf(ff, 'nmod.hold_duration2=%g;\n', nmod.hold_duration2)
    fprintf(ff, 'nmod.stepto_duration2=%g;\n', nmod.stepto_duration2)
    fprintf(ff, 'nmod.stepto_duration1=%g;\n', nmod.stepto_duration1)
    fprintf(ff, 'nmod.stepto_current=[%s];\n',num2str(nmod.stepto_current))
    fprintf(ff, 'nmod.iv_current=[%s];\n',num2str(nmod.iv_current))
    fclose(ff);
    %fprintf(ff, 'nmod.stepto_current=%g;\n', nmod.stepto_current)
    %fprintf(ff, 'nmod.iv_current=%g;\n', nmod.iv_current)
end
fclose(fid);

    
% cells we want
singleflags=(get(handles.chk_cellmech,'Value') + get(handles.chk_cellclamp,'Value') + get(handles.chk_cellclampi,'Value') + get(handles.chk_cellmorph,'Value') + get(handles.chk_customcurr,'Value'));
pairflags=get(handles.chk_currpair,'Value') + get(handles.chk_connpair,'Value');
if singleflags>0 || pairflags>0
    cs = get(handles.list_cell, 'String');
    cv = get(handles.list_cell, 'Value');
    mycells = cs(cv);

    if (length(cv)==1 && strcmp('All',cs{cv}))==1
        mycells=cs(2:end);
    end
    
    if  get(handles.chk_currpair,'Value')==1 || get(handles.chk_connpair,'Value')==1
        cs = get(handles.list_conn, 'String');
        cv = get(handles.list_conn, 'Value');
        mycellsyn = cs(cv);

        if (length(cv)==1 && strcmp('All',cs{cv}))==1
            mycellsyn=cs(2:end);
        end
        for mcs=1:length(mycellsyn)
            tmp=regexp(mycellsyn{mcs},'[a-zA-Z]+->([a-zA-Z]+)','tokens');
            if ~isempty(tmp) && iscell(tmp{1})
                mycellsyn(mcs)=tmp{1};
            end
        end
    end
    

    if singleflags==0 && pairflags>0
        mycellsall=unique(mycellsyn);
    elseif singleflags>0 && pairflags==0
        mycellsall=mycells;
    else
        mycellsall=unique([mycells; mycellsyn]);
    end

    % open a celltype file and list all the ones we want the data for
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'icell.dat'], 'w');

    % write the number of cells
    fprintf(fid, '%g\n', length(mycellsall));
    % write each cell on its own line
    fprintf(fid, '%s\n', mycellsall{:});
    % close the file
    fclose(fid);
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'icellbase.dat'], 'w');
    for zbase=1:length(mycellsall)
        switch mycellsall{zbase}
            case 'supercell'
                fprintf(fid, '0\n');
                %fprintf(fid, '-0.0610\n');
            case 'deepcell'
                fprintf(fid, '0\n');
                %fprintf(fid, '0.0185\n');
            otherwise
                fprintf(fid, '0\n');
        end
    end
    fclose(fid);
end

%a = dir([handles.directoryname '/cells/class_pp*.hoc']);
%for r=1:length(a)
%    mycellsall{length(mycellsall)+1}=a(r).name(7:end-4);
%    mycellsall{length(mycellsall)+1}='ppecsin';
%    mycellsall{length(mycellsall)+1}='ppca3sin';
%end


if get(handles.chk_cellmech,'Value')==1
   insertstring=[insertstring ' -c cellmechs=1'];
end

if get(handles.chk_cellclamp,'Value')==1
    insertstring=[insertstring ' -c onecell=1'];
    % open the iclamp.dat file
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'iclamp.dat'], 'w');
    % write the number of currents
    fprintf(fid, '%g\n', length(handles.iclamp.current));
    % write each current on its own line
    fprintf(fid, '%g\n', handles.iclamp.current);
    % close the file
    fclose(fid);
elseif get(handles.chk_cellclampi,'Value')==1
    insertstring=[insertstring ' -c onecell=2'];
    % open the iclamp.dat file
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'iclamp.dat'], 'w');
    % write the number of currents
    fprintf(fid, '%g\n', length(handles.iclamp.current));
    % write each current on its own line
    fprintf(fid, '%g\n', handles.iclamp.current);
    % close the file
    fclose(fid);
elseif get(handles.chk_customcurr,'Value')==1
    insertstring=[insertstring ' -c onecell=1 -c onecellsweep=0'];
    % open the iclamp.dat file
    fid = fopen([handles.directoryname sl 'setupfiles' sl 'iclamp.dat'], 'w');
    % write the custom current
    fprintf(fid, '%g 0\n', length(handles.iclamp.current(:,1)));
    fclose(fid);
    % write each current point on its own line
    dlmwrite([handles.directoryname sl 'setupfiles' sl 'iclamp.dat'],handles.iclamp.current, '-append','delimiter',' ') 
    %fprintf(fid, '%g %g\n', handles.iclamp.current);
    % close the file
end

if get(handles.chk_cellmorph,'Value')==1
%    insertstring=[insertstring ' -c cellmorph=1'];
end

if get(handles.chk_cellmorph,'Value')==1
    contents = cellstr(get(handles.menu_cellnum,'String'));
    cellnum = contents{get(handles.menu_cellnum,'Value')};

%fid = fopen([handles.repos '/datasets/cellnumbers_' num2str() '.dat'],'r');                
fid = fopen([handles.directoryname mysl 'datasets' mysl cellnum],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);


for v=1:length(filedata{1}) %RunArray(ind).NumCellTypes % rows
    numcon{v,1} = filedata{1}{v};
    numcon{v,2} = filedata{2}{v};
    numcon{v,3} = filedata{3}(v);
    numcon{v,4} = filedata{4}(v);
    %numcon{v,5} = filedata{5}(v);
end    
 
    
    fid = fopen([handles.directoryname  mysl 'cellclamp_results' mysl myresultsfolder mysl 'morphtable.txt'], 'w');
    fprintf(fid,'Morphology Data for #%s\n\n', myresultsfolder);
    fprintf(fid,'Cell Type\tSection Type\tArea (um2)\tLength (um)\tAverage Diameter (um)\t# Sections in NEURON\n');
    for c=1:length(mycells)
        celltype = mycells{c};
        try
            typemtch=strmatch(celltype,numcon{:,1});
            if ~isempty(typemtch)
                celltype=numcon{typemtch,2};
            end
        catch
            typemtch=strmatch(celltype,numcon(:,1));
            if ~isempty(typemtch)
                celltype=numcon{typemtch,2};
            end
        end
        set(handles.txt_status,'String','Status: Running...');
        %cmdstr = ['cd ' handles.directoryname handles.dl ' ' handles.general.neuron ' -c "strdef celltype" -c "celltype = \"' celltype '\"" ' handles.directoryname mysl 'setupfiles' mysl 'clamp' sl 'makeshape.hoc'];
        cmdstr = ['cd ' handles.directoryname handles.dl ' ' handles.general.neuron ' -c "strdef myresultsfolder" -c "myresultsfolder=\"' myresultsfolder '\"" -c "strdef repodir" -c "repodir = \"' strrep(strrep(handles.directoryname,'\','/'),'C:','/cygdrive/c')  '\"" -c "strdef studycell" -c "studycell = \"' celltype '\"" ./setupfiles/clamp/printareasCELL.hoc -c "quit()"'];
        [~, result]=system(cmdstr);
        disp(result)
        run([handles.directoryname  mysl 'cellclamp_results' mysl myresultsfolder mysl 'getcelldata.m']);% 'morphdata_' celltype '.m'])
        for r=1:length(morphdata)
            fprintf(fid,'%s\t%s\t%.2f\t%.2f\t%.2f\t%d\n', celltype, morphdata(r).name, morphdata(r).area, morphdata(r).length, morphdata(r).diam, morphdata(r).totalsections)
        end
    end
    fclose(fid);
    pathstr = [handles.directoryname  mysl 'cellclamp_results' mysl myresultsfolder mysl];
    b=dir([pathstr mysl '*.ps']);

    for r=1:length(b)
        [~,fname,ext] = fileparts(b(r).name);
        disp(fname)
        ps2pdf('psfile',[pathstr mysl fname ext],'pdffile',[pathstr mysl fname '.png'])
    end
    system([' ' handles.directoryname  mysl 'cellclamp_results' mysl myresultsfolder mysl 'morphtable.txt']);
end

if (get(handles.chk_connpair,'Value')==1 || get(handles.chk_currpair,'Value')==1) 
    % open the pairclamp.dat file
    fid = fopen([handles.directoryname mysl 'setupfiles' mysl 'clamp' mysl 'pairclamp.dat'], 'w');
    % write the number of currents
    fprintf(fid, '%g\n%g\n%g\n%g\n%g\n%g\n', handles.iclamp.paircurrent, handles.iclamp.holding, handles.iclamp.pairstart, handles.iclamp.pairend, handles.iclamp.revpot, handles.iclamp.revflag);
    % close the file
    fclose(fid);
    
    % cells we want
    cs = get(handles.list_cell, 'String');
    cv = get(handles.list_cell, 'Value');

    % cells we want
    csd = get(handles.list_conn, 'String');
    cvd = get(handles.list_conn, 'Value');
    
    %if (length(cvd)==1 && strcmp('All',csd{cvd}))==1
        mycells=cs(2:end);
    %end
    
    cs = get(handles.list_conn, 'String');
    cv = get(handles.list_conn, 'Value');
    myconns = cs(cv);
    
    handles.iclamp.currpair = get(handles.chk_currpair,'Value');
    handles.iclamp.voltpair = get(handles.chk_connpair,'Value');

    contents = cellstr(get(handles.menu_kinsyn,'String'));
    syn = contents{get(handles.menu_kinsyn,'Value')};

    contents = cellstr(get(handles.menu_numcon,'String'));
    conn = contents{get(handles.menu_numcon,'Value')};

    contents = cellstr(get(handles.menu_cellnum,'String'));
    cellnum = contents{get(handles.menu_cellnum,'Value')};

    insertstring=[insertstring ' -c numeapair=10 -c conn=' conn(10:end-4) ' -c mysyn=' syn(9:end-4) ' -c cellnum=' cellnum(13:end-4)];
    
    if length(myconns)==1 && strcmp(myconns{1},'All')==1
        insertstring=[insertstring ' -c pair=' num2str(1+get(handles.chk_currpair,'Value')*2)];
        fid = fopen([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'pairtypes.txt'], 'w');
        fprintf(fid, '0\n');
        fclose(fid);
    else
        fid = fopen([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'pairtypes.txt'], 'w');
        insertstring=[insertstring ' -c pair=' num2str(2+get(handles.chk_currpair,'Value')*2)];
        fprintf(fid, '%g\n', length(myconns));
        for r=1:length(myconns)
            d=strfind(myconns{r},'-');
            %if strcmp(myconns{r}(d+2:end), 'pyramidalcell')==1
            %    fprintf(fid, '%s %s\n', myconns{r}(1:d-1), 'sprustoncell');
            %else
                fprintf(fid, '%s %s\n', myconns{r}(1:d-1), myconns{r}(d+2:end));
            %end
        end
        % close the file
        fclose(fid);
    end
end

%if isfield(handles, 'resultspath') && ~isempty(handles.resultspath)
%    insertstring=[insertstring ' -c "strdef resultspath" -c resultspath="\"' handles.resultspath '\""'];
%end
if ~isempty(myresultsfolder)
    if ispc
        insertstring=[insertstring ' -c "strdef resultspath" -c resultspath="\"' 'cellclamp_results' strrep(strrep([sl myresultsfolder],'\','/'),'C:','/cygdrive/c') '\""'];
    else
        insertstring=[insertstring ' -c "strdef resultspath" -c resultspath="\"' 'cellclamp_results' sl myresultsfolder '\""'];
    end
end

iclamp=handles.iclamp;
save([ handles.directoryname mysl 'cellclamp_results' mysl myresultsfolder mysl 'rundata.mat'],'iclamp','-v7.3') % iclamp

insertstring=[insertstring ' -c NumData=' num2str(numstr) ' -c ConnData=' num2str(connstr) ' -c SynData=' num2str(synstr) ' '];
if ispc
insertstring=[insertstring ' -c "strdef toolpath" -c toolpath="\"' strrep(strrep([mypath sl],'\','/'),'C:','/cygdrive/c') 'tools\""'];
else
insertstring=[insertstring ' -c "strdef toolpath" -c toolpath="\"' mypath sl 'tools\""'];
end
if ispc
    insertstring=[insertstring ' -c "strdef relpath" -c relpath="\"' strrep(strrep(handles.directoryname,'\','/'),'C:','/cygdrive/c') '\"" -c "strdef sl" -c sl="\"' strrep(strrep(mysl,'\','/'),'C:','/cygdrive/c') ' \"" '];
else
    insertstring=[insertstring ' -c "strdef relpath" -c relpath="\"' handles.directoryname '\"" -c "strdef sl" -c sl="\"/ \"" '];
end
% depending on what data is needed, set the flags (-c "x=3")
set(handles.txt_status,'String','Status: Running...');
%updatecelltemplates(handles,NumData,SynData,handles.directoryname)
if handles.general.mpi==1
    numc=1;%feature('numCores');
    cmdstr=['cd ' handles.directoryname handles.dl ' C:\nrn73\bin\mpiexec -n ' num2str(numc) ' ' excmdstr insertstring ' -mpi '  ' .' sl 'setupfiles' sl 'clamp' sl 'electrophys.hoc -c "quit()"' ];
else
    cmdstr=['cd ' handles.directoryname handles.dl ' ' excmdstr insertstring  ' .' sl 'setupfiles' sl 'clamp' sl 'electrophys.hoc -c "quit()"' ];
end
% if strfind(cmdstr,'mpi')>0
%     system('sh C:\Users\M\Desktop\repos\superdeep\setupfiles\clamp\runmpd.sh') % first make a .mpd.conf file in the user's home directory, with special permissions...
%     pause(3)
% end
disp(cmdstr)

% compilestr=['cd ' handles.directoryname handles.dl ' ' handles.compilenrn];
% [~, myname]=system('hostname'); % Warning: need to change this section so that user can easily add in a script how to run model on their compy
% if ~strcmp('Kelly-PC', deblank(myname))
%     system(compilestr);
% end
  
% 
[~, result]=system(cmdstr);
if ~isdeployed
    disp(result)
else
    fidlog=fopen([logloc 'SimTrackerOutput.log'],'a');
    fprintf(fidlog,'\nCELLCLAMP TOOL RUN RESULTS:\n%s\n',result)
    fclose(fidlog)
end

%if strfind(cmdstr,'mpi')>0
%    system('mpdallexit')
%end
if get(handles.chk_mechact,'Value')==1
    plotmechact(handles.iclamp,handles);
end
if get(handles.chk_mechIV,'Value')==1
    %plotmechiv(handles.iclamp,handles);
end
if get(handles.chk_cellclamp,'Value')==1
    if ~isfield(handles, 'resultspath') || (isfield(handles, 'resultspath') && isempty(handles.resultspath))
        plotsingleresults(handles.iclamp,handles,myresultsfolder);
    end
elseif get(handles.chk_cellclampi,'Value')==1
    if ~isfield(handles, 'resultspath') || (isfield(handles, 'resultspath') && isempty(handles.resultspath))
        plotsingleresultsSE(handles.iclamp,handles,myresultsfolder);
    end
elseif get(handles.chk_customcurr,'Value')==1
    if ~isfield(handles, 'resultspath') || (isfield(handles, 'resultspath') && isempty(handles.resultspath))
        plotsinglecustom(handles.iclamp,handles,myresultsfolder) %addhere
    end
end
if (get(handles.chk_connpair,'Value')==1 || get(handles.chk_currpair,'Value')==1)
    numc=1;
    parcmd=''; % ' C:\nrn73\bin\mpiexec -n ' num2str(numc)
    parcmd2=''; % '-mpi'
    cmdstr=['cd ' handles.directoryname handles.dl parcmd ' ' excmdstr ' -c NumData=' num2str(numstr) ' -c ConnData=' num2str(connstr) ' -c SynData=' num2str(synstr) ' ' parcmd2 ' '  ' .' sl 'setupfiles' sl 'clamp' sl 'printsynapseranges.hoc -c "quit()"' ];
    [~, result]=system(cmdstr);
    %btn_viewer_Callback(hObject, eventdata, handles) % don't show results right away b/c so many of them
    plotpairresults(handles.iclamp,handles,myresultsfolder,mycomments);    
end
if get(handles.chk_cellmech,'Value')==1
    plotmechdist(handles,myresultsfolder)
end
set(handles.txt_status,'String','Status: Ready')
msgbox(['The results are in folder ' myresultsfolder])
catch ME
    if isdeployed
        docerr(ME)
    else
        for r=1:length(ME.stack)
            disp(ME.stack(r).file);disp(ME.stack(r).name);disp(num2str(ME.stack(r).line))
        end
        throw(ME)
    end
end
%update available buttons for step 6 (also do this after picking nmodel
%directory)

function compexp(handles,expsyns)


n=1;

precells = fieldnames(expsyns);
resvec={};
pairexist=[0 0];
for p=1:length(precells)
    postcells = fieldnames(expsyns(n).(precells{p}));
    for r=1:length(postcells)
        if strcmp(expsyns(n).(precells{p}).(postcells{r}).Clamp,'Voltage')
            %continue;
            % set the connection type   
            nm = [precells{p} '->' postcells{r}];
            cs = get(handles.list_conn, 'String');
            set(handles.list_conn, 'Value', strmatch(nm,cs));
                        
            % set the clamp type
            set(handles.chk_connpair,'Value',1);
            set(handles.chk_currpair,'Value',0);
            
            % set the start time and duration
            set(handles.txt_pairstart,'String',num2str(15));
            set(handles.txt_pairend,'String',num2str(100));
            
            % set the holding potential
            set(handles.txt_post,'String',num2str(expsyns(n).(precells{p}).(postcells{r}).Holding));
            
            % set the reversal potential (and not auto)
            set(handles.radio_set,'Value',1);
            set(handles.txt_rev,'String',num2str(expsyns(n).(precells{p}).(postcells{r}).Reversal));
           
            % add a comment
            cm = [precells{p}(1:3) '->' postcells{r}(1:3) ' (VC): ' expsyns(n).(precells{p}).(postcells{r}).ref];
            
            if ~isempty(strmatch(nm,cs))
                pairexist(1)=pairexist(1)+1;
            else
                pairexist(2)=pairexist(2)+1;
                disp(['Cell Types not found for: ' cm]);
                continue
            end
            % run the code
            resvec{length(resvec)+1} = btn_run_Callback(handles.btn_run, [], handles,cm);
            
        else % Current
            % set the connection type   
            nm = [precells{p} '->' postcells{r}];
            cs = get(handles.list_conn, 'String');
            set(handles.list_conn, 'Value', strmatch(nm,cs));
                        
            % set the clamp type
            set(handles.chk_connpair,'Value',0);
            set(handles.chk_currpair,'Value',1);
            
            % set the start time and duration
            set(handles.txt_pairstart,'String',num2str(115));
            set(handles.txt_pairend,'String',num2str(200));
            
            % set the holding potential
            try
            set(handles.txt_pre,'String',num2str(expsyns(n).(precells{p}).(postcells{r}).ModelCur));
            catch
                p
            end
            
            % set the reversal potential (and not auto)
            set(handles.radio_set,'Value',1);
            set(handles.txt_rev,'String',num2str(expsyns(n).(precells{p}).(postcells{r}).Reversal));
           
            % add a comment
            cm = [precells{p}(1:3) '->' postcells{r}(1:3) ' (CC to ' num2str(expsyns(n).(precells{p}).(postcells{r}).Holding) '): ' expsyns(n).(precells{p}).(postcells{r}).ref];
            
            if ~isempty(strmatch(nm,cs))
                pairexist(1)=pairexist(1)+1;
            else
                pairexist(2)=pairexist(2)+1;
                disp(['Cell Types not found for: ' cm]);
                continue
            end
            
            % run the code
            resvec{length(resvec)+1} = btn_run_Callback(handles.btn_run, [], handles,cm);
            
        end
    end
end

if ~isempty(resvec)
disp(['results folders ' num2str(resvec{1}) ' through ' num2str(resvec{end})])
end
%getwebsitedata({},{},[num2str(resvec{1}) ':' num2str(resvec{end})])


% --- Executes on button press in btn_help1.
function btn_help1_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpimage=fillmein;
disphelp(helpimage,handles);


% --- Executes on button press in btn_help2.
function btn_help2_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpimage=fillmein;
disphelp(helpimage,handles);


% --- Executes on button press in btn_help3.
function btn_help3_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpimage=fillmein;
disphelp(helpimage,handles);


% --- Executes on button press in btn_help4.
function btn_help4_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpimage=fillmein;
disphelp(helpimage,handles);


% --- Executes on button press in btn_help5.
function btn_help5_Callback(hObject, eventdata, handles)
% hObject    handle to btn_help5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpimage=fillmein;
disphelp(helpimage,handles);

% --- Executes on selection change in list_mech.
function list_mech_Callback(hObject, eventdata, handles)
% hObject    handle to list_mech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_mech contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_mech


% --- Executes during object creation, after setting all properties.
function list_mech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_mech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_cell.
function list_cell_Callback(hObject, eventdata, handles)
% hObject    handle to list_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_cell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_cell


% --- Executes during object creation, after setting all properties.
function list_cell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_conn.
function list_conn_Callback(hObject, eventdata, handles)
% hObject    handle to list_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_conn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_conn


% --- Executes during object creation, after setting all properties.
function list_conn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_cellclamp.
function chk_cellclamp_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cellclamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cellclamp


% --- Executes on button press in chk_cellmorph.
function chk_cellmorph_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cellmorph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cellmorph


% --- Executes on button press in chk_connpair.
function chk_connpair_Callback(hObject, eventdata, handles)
% hObject    handle to chk_connpair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_connpair

%set(handles.chk_connpair,'Value',1)
%set(handles.chk_currpair,'Value',0)


% --- Executes on button press in chk_mechIV.
function chk_mechIV_Callback(hObject, eventdata, handles)
% hObject    handle to chk_mechIV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_mechIV


% --- Executes on button press in chk_mechact.
function chk_mechact_Callback(hObject, eventdata, handles)
% hObject    handle to chk_mechact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_mechact


% --- Executes on button press in chk_report.
function chk_report_Callback(hObject, eventdata, handles)
% hObject    handle to chk_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_report


% --- Executes on button press in chk_images.
function chk_images_Callback(hObject, eventdata, handles)
% hObject    handle to chk_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_images


% --- Executes on button press in chk_figs.
function chk_figs_Callback(hObject, eventdata, handles)
% hObject    handle to chk_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_figs


% --- Executes on button press in chk_data.
function chk_data_Callback(hObject, eventdata, handles)
% hObject    handle to chk_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_data




function disphelp(helpimage,handles)
% make a new figure that displays the appropriate helpimage




function plotmechact(iclamp,handles)
global mypath nmod mydesc sl
myresultsfolder=handles.myresultsfolder;
chanlist = dir([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl]);
chanlist(1:2)=[];
for r=length(chanlist):-1:1
    if chanlist(r).isdir==0
        chanlist(r)=[];
    end
end
id = 500/.01 + 2;
minhold=0;
maxhold=0;
minstep=0;
maxstep=0;
fari=0;

mechdata = get(handles.table_mech,'Data');

gflag=get(handles.radio_cond,'Value');
if gflag==1 % if conductance of interest
    di=3;
else % if current of interest
    di=2;
end

for j=1:length(chanlist)
    chan = chanlist(j).name;
    
    revpot=[];
    
    for r=1:length(mechdata)
        if strcmp(chan,mechdata{r,1})
            revpot = str2num(mechdata{r,4});
            gmax = str2num(mechdata{r,2});
            mystr={['gmax = ' num2str(gmax) ' S/cm^2'], [mechdata{r,3} ' = ' num2str(revpot) ' mV']};
            break
        end
    end
    
    fitwindow=25; %ms
    poi=30; % mV
    risetau(handles,myresultsfolder,chan,handles.directoryname,gflag,gmax,fitwindow,poi)
    
    poi=-60; % mV
    decaytau(handles,myresultsfolder,chan,handles.directoryname,gflag,gmax,fitwindow,poi)

    minhold=0;
    maxhold=0;
    minstep=0;
    maxstep=0;
    fari=0;

    d_hold=dir([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan sl 'hold_*.dat']);
    d_step=dir([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan  sl 'stepto_*.dat']);
    [R G B]=meshgrid([.1:.4:1],[.1:.4:1],[.1:.4:1]);
    colorvec = [R(:) G(:) B(:)];
    colorvec = colorvec([3:2:end 2:2:end],1:3);
  
    % get the unique cell names
    for i=1:length(d_hold)
        d_hold(i).v = str2num(d_hold(i).name(6:end-4));
    end
    
    for i=1:length(d_step)
        d_step(i).v = str2num(d_step(i).name(8:end-4));
    end
    [~, I]=sort([d_hold.v]);
    d_hold=d_hold(I);
    
    [~, I]=sort([d_step.v]);
    d_step=d_step(I);
    
    ha(1)=figure('Color','w','Name',[myresultsfolder ': ' chan],'units','normalized','outerposition',[0 0 1 1]);
    %pos = get(ha(1),'Position');
    %set(ha(1),'Position',[pos(1) pos(2) pos(3)*3 pos(4)*2]);
    
    % data=importdata(['/home/casem/matlab/work/cellclamp/clamp/' chan '/chdata.txt']);
    % h = ['Channel: ' data.textdata{1} '    gmax: ' data.textdata{2} '    ' data.textdata{3} ': ' num2str(data.data)];
    % text(0.5, 0.95, h)
    
    
    % nmod.stepto_current = eval(get(handles.txt_actcurr,'String'));
    % nmod.iv_current = eval(get(handles.txt_IVcurr,'String'));
    
    for i=length(d_step):-1:1
        data=importdata([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan sl 'stepto_' num2str(d_step(i).v) '.dat']);
        d_step(i).data=data.data;
        if ismember(d_step(i).v,nmod.stepto_current)
            d_step(i).stepflag = 1;
        else
            d_step(i).stepflag = 0;
        end
        if ismember(d_step(i).v,nmod.iv_current)
            d_step(i).ivflag = 1;
        else
            d_step(i).ivflag = 0;
        end
    end
    
    subplot(2,3,1)
    t=ismember([d_step.v],[nmod.stepto_current]);
    legendstr={};
    for i=length(d_step):-1:1
        if d_step(i).stepflag == 1;
            plot(d_step(i).data(:,1),d_step(i).data(:,di),'Color', [colorvec(sum(t(1:i)),1:3)])
            legendstr{length(legendstr)+1} = num2str(d_step(i).v);
        end
        
        hold on
        firstdur=nmod.stepto_duration1; %200;

        idx=firstdur/handles.mydt+2;
        if gflag==0
            [infl, plotidx]=getinfl(d_step(i),idx,di,minstep,maxstep,fari,revpot);
            d_step(i).inflection=infl;
            if ~isempty(plotidx)
                plot(d_step(i).data(plotidx,1),d_step(i).data(plotidx,di),'Marker','.','Color',[colorvec(sum(t(1:i)),1:3)],'MarkerSize',10,'HandleVisibility','off')
            end
        else
            d_step(i).inflection=max(d_step(i).data(idx-2:end,di));
            try
            %d_step(i).inflection=d_step(i).data(idx-2,di);
            if d_step(i).stepflag == 1;
                plot(d_step(i).data(idx-2,1),d_step(i).data(idx-2,di),'Marker','.','Color',[colorvec(sum(t(1:i)),1:3)],'MarkerSize',10,'HandleVisibility','off')
            end
            catch
                 'l'
            end
        end
    end
    
    if sum([d_step(:).inflection])==0
        for i=length(d_step):-1:1
            if d_step(i).stepflag == 1;
                d_step(i).inflection = d_step(i).data(end,di);
            end
        end
    end
    
    legend(legendstr,'Location','West','FontSize',8,'Interpreter','none')
    legendstr={};
    title({[myresultsfolder ': ' chan ' Activation'],['from ' num2str(nmod.stepto_amplitude1) ' (mV steps)']})
    marg = min(d_step(i).data(idx+2+fari-1,1)-nmod.stepto_duration1,min(nmod.stepto_duration1,nmod.stepto_duration2));
    try
        xlim([nmod.stepto_duration1-marg*2 nmod.stepto_duration1+marg*2])
    catch
        disp([chan ': no idea what is going on here...'])
    end
    xlabel('Time (ms)')
    
    if gflag==0
        ylabel('Current (nA)')
    else
        ylabel('Conductance (S/cm^2)')
    end

    subplot(2,3,3)
    for i=length(d_step):-1:1
        if d_step(i).stepflag == 1;
            plot(d_step(i).data(:,1),d_step(i).data(:,di),'Color', [colorvec(sum(t(1:i)),1:3)]) %[colorvec(i,1:3)])
            hold on
        end
    end
    tstr=['Run #' myresultsfolder];
    title([tstr mystr])
    xlabel('Time (ms)')
    ylabel('Conductance (S/cm^2)')

    subplot(2,3,2)
    infl = [d_step(t).inflection];
    volt = [d_step(t).v];
    [maxval maxind]=max(abs(infl));
    maxval=maxval*(maxval/infl(maxind));
    plot(volt,infl/maxval,'k')
    results.act.x=volt;
    results.act.y=infl/maxval;
    results.act.xlabel='Voltage (mV)';
    results.act.ylabel='Normalized Conductance (g/g_{max})';
    hold on
    for i=1:length(infl)
        plot(volt(i),infl(i)/maxval,'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',20)    
    end
    title([myresultsfolder ': ' chan ' Activation Curve'])
    ylim([0 1])
    xlabel('Voltage (mV)')
    if gflag==0
        ylabel('Normalized Current (I/I_{max})')
    else
        ylabel('Normalized Conductance (g/g_{max})')
    end

    try
    xlim([min([d_step(t).v]) volt(maxind)])
    end
    
    %ha(2)=figure('Color','w');
    %pos = get(ha(2),'Position');
    %set(ha(2),'Position',[pos(1) pos(2) pos(3)*2 pos(4)]);
    fari=0;
    subplot(2,3,4) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%  IN-ACTIVATION %%%%%%%%%%%
    mydur=nmod.hold_duration1; %500;

    idx2=mydur/handles.mydt+2;
    for i=length(d_hold):-1:1
        data=importdata([ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan sl 'hold_' num2str(d_hold(i).v) '.dat']);
        plot(data.data(:,1),data.data(:,di),'Color', [colorvec(i,1:3)])
        legendstr{length(legendstr)+1} = num2str(d_hold(i).v);
        hold on
        [thismin mini] = min(data.data(idx2+2:end,di));
        [thismax maxi] = max(data.data(idx2+2:end,di));
        minhold = min(minhold,thismin);
        maxhold = max(maxhold,thismax);
        fari=max(fari,max(mini,maxi));

        %if (~isempty(revpot) && revpot<nmod.hold_amplitude2) || (isempty(revpot) &&  thismin >= min(data.data(end,2),data.data(idx2,2)))
        %if gflag==0
            oldway=1;
            if oldway==1
                d_hold(i).inflection=[];
                if (thismin >= min(data.data(end,di),data.data(idx2,di)))
                    thismin = [];
                    plot(data.data(idx2+1+maxi,1),data.data(idx2+1+maxi,di),'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',10,'HandleVisibility','off')
                    d_hold(i).inflection = thismax;
                end
                %if (~isempty(revpot) && revpot>=nmod.hold_amplitude2) || (isempty(revpot) && thismax <= max(data.data(end,2),data.data(idx2,2)))
                if (thismax <= max(data.data(end,di),data.data(idx2,di)))
                    thismax = [];
                    plot(data.data(idx2+1+mini,1),data.data(idx2+1+mini,di),'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',10,'HandleVisibility','off')
                    d_hold(i).inflection = thismin;
                end
                if isempty(d_hold(i).inflection)
                    d_hold(i).inflection = data.data(idx2+2,di);
                end
            else
                d_hold(i).inflection = data.data(idx2-1,di);
                plot(data.data(idx2-1,1),data.data(idx2-1,di),'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',10,'HandleVisibility','off')
            end
        %else
        %    d_hold(i).inflection = data.data(idx2-2,di);
        %    plot(data.data(idx2-2,1),data.data(idx2-2,di),'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',10,'HandleVisibility','off')
        %end
    end
    
    legend(legendstr,'Location','West','FontSize',8,'Interpreter','none')
    clear legendstr
    title({[ myresultsfolder ': ' chan ' Inactivation'],['at ' num2str(nmod.hold_amplitude2) ' (mV steps)']})
    %xlim([495 505])
    %ylim([minhold maxhold])
    marg = min(data.data(idx2+2+fari-1,1)-nmod.hold_duration1,min(nmod.hold_duration1,nmod.hold_duration2));
    xlim([nmod.hold_duration1-marg*2 nmod.hold_duration1+marg*2])
    xlabel('Time (ms)')
    if gflag==0
        ylabel('Current (nA)')
    else
        ylabel('Conductance (S/cm^2)')
    end

    subplot(2,3,5)
    [maxval maxind]=max(abs([d_hold.inflection]));
    maxval=maxval*(abs(d_hold(maxind).inflection)/d_hold(maxind).inflection);
    plot([d_hold.v],[d_hold.inflection]/maxval,'k')
    hold on
    for i=1:length(d_hold)
    	plot(d_hold(i).v,d_hold(i).inflection/maxval,'Marker','.','Color',[colorvec(i,1:3)],'MarkerSize',20)        
    end
    results.inact.x=[d_hold.v];
    results.inact.y=[d_hold.inflection]/maxval;
    results.inact.xlabel='Voltage (mV)';
    results.inact.ylabel='Normalized Conductance (g/g_{max})';
    title([myresultsfolder ': ' chan ' Inactivation Curve'])
    ylim([0 1])
    xlabel('Voltage (mV)')
    if gflag==0
        ylabel('Normalized Current (I/I_{max})')
    else
        ylabel('Normalized Conductance (g/g_{max})')
    end
    
    subplot(2,3,6)
    
    if gflag==1
        for i=length(d_step):-1:1
            [infl, plotidx]=getinfl(d_step(i),idx,2,minstep,maxstep,fari,revpot);
            d_step(i).inflection=infl;
        end
    end

    steadyidx = (nmod.stepto_duration1 + nmod.stepto_duration2)/handles.mydt;

    for i=length(d_step):-1:1
        if d_step(i).ivflag == 1;
            d_step(i).steady = d_step(i).data((steadyidx-2),2); % d_step(i).data((idx + idx2-2),2);
        end
    end        
    
%     if abs(sum([d_step.steady]))<abs(sum([d_step.inflection])*.5)
%         toplot=[d_step.inflection];
%         mytitle=[myresultsfolder ': ' chan ' IV Curve (peak transient)'];
%     else
%         toplot=[d_step.steady];
%         mytitle=[myresultsfolder ': ' chan ' IV Curve (steady state)'];
%     end
%     if max(abs(toplot))<0.01
%         toplot=toplot*1000;
%         yl='Current (pA)'; % ylabel(yl)
%     else
%         yl='Current (nA)'; % ylabel(yl)
%     end

    results.gmax = gmax;
    results.erev = revpot;
    results.dim = handles.somadim;
    results.temp = handles.celsius;
    results.ra = handles.Ra;
    results.cm = handles.cm;
    results.Ca = handles.Ca;
    results.ivpeak.x=[d_step.v];
    results.ivpeak.y=[d_step.inflection];
    results.ivpeak.xlabel='Voltage (mV)';
    results.ivpeak.ylabel='Current (nA)';

    results.ivsteady.x=[d_step.v];
    results.ivsteady.y=[d_step.steady];
    results.ivsteady.xlabel='Voltage (mV)';
    results.ivsteady.ylabel='Current (nA)';
    
    save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan sl 'results.mat'],'results','-v7.3');

    plot([d_step.v],[d_step.inflection],'k')    
    hold on
    plot([d_step.v],[d_step.steady],'g--')    
    legend({'Peak transient','Steady state'})    

    title([myresultsfolder ': ' chan ' IV Curve'])
    xlabel('Voltage (mV)')
    ylabel('Current (nA)')
    if ispc
        [~, mystr] = system('hg parent --template "{rev}:{desc}"');
    else
        [~, mystr] = system('hg parent --template ''{rev}:{desc}''');
    end
    
    g=find(strcmp({mydesc(:).name},myresultsfolder)==1);
    puthere='match not found';
    if ~isempty(g)
    puthere = mydesc(g).desc;
    end
    
    mystr = ['Channel: ' chan ', description: ', puthere , '   Code version: ' mystr ',   figure generated on ' date];
    ha = axes('Position',[0 0 1 .01],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(.5, 1,mystr,'HorizontalAlignment' ,'center','VerticalAlignment', 'bottom','FontSize',8);


   % pp=get(gcf,'PaperPosition');
   % set(gcf,'PaperPosition',[pp(1) pp(2) pp(4) pp(4)])
    set(get(ha(1),'Parent'),'PaperType','usletter','PaperOrientation','landscape','PaperPositionmode','auto')
    print(get(ha(1),'Parent'), '-djpeg', [ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'clamp' sl chan '_mechs.jpg'])
end

%%%%%%%
function [infl, plotidx]=getinfl(dstp,idx,di,minstep,maxstep,fari,revpot)
global mypath sl
[thismin mini] = min(dstp.data(idx+2:end,di));
[thismax maxi] = max(dstp.data(idx+2:end,di));
minstep = min(minstep,thismin);
maxstep = max(maxstep,thismax);
fari=max(fari,max(mini,maxi));
infl=[];
plotidx=[];
if (~isempty(revpot) && revpot>=dstp.v) || (isempty(revpot) && thismax <= max(dstp.data(end,di),dstp.data(idx,di)))  % <=
    thismax = [];
    if dstp.stepflag == 1;
        plotidx=idx+1+mini;
    end
    infl = thismin;
elseif (~isempty(revpot) && revpot<dstp.v) || (isempty(revpot) &&  thismin >= min(dstp.data(end,di),dstp.data(idx,di))) % >=
    thismin = [];
    if dstp.stepflag == 1;
        plotidx=idx+1+maxi;
    end
    infl = thismax;

elseif isempty(infl)
    infl = dstp.data(idx+2,di);
end

%%%%%%%

function tmp=plotifcurve(iclamp,handles,myresultsfolder,uniqcellsec,currents)
global mypath sl

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')
g = find(strcmp(myresultsfolder,{mydesc(:).name})==1);
if ~isempty(g)
    mydeschere = mydesc(g).desc;
else
    mydeschere='';
end


hhypname=['Hyperpolarized Properties (' myresultsfolder ')'];
hhyp=figure('Color','w','Name',hhypname);
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Minimum potential (mV)')
title(['Results #' myresultsfolder ': ']) % superdeep
subplot(1,2,2)
hold on
xlabel('Current (pA)')
ylabel('Steady state potential (mV)')

hhcnname = ['Sag Properties (' myresultsfolder ')'];
hhcn=figure('Color','w','Name',hhcnname);
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Sag amplitude (mV)')
subplot(1,2,2)
hold on
xlabel('Current (pA)')
ylabel('Sag Timing (s)')

hifname = ['IF Curve and Max Depolarization (' myresultsfolder ')'];
hif=figure('Color','w','Name',hifname);
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Max potential (mV)')
subplot(1,2,2)
title(['IF Curve for Results #' myresultsfolder ': ' mydeschere]) % superdeep
hold on
xlabel('Current (pA)')
ylabel('Firing frequency (Hz)')

legstr={};
colorvec={'b','g','m','k','r','c','b','g','m','k','r','c','b','g','m','k','r','c'};

% stimdur=;         %id(1,2);
% predur= ;                        %id(1,3);
% tstop = ;
tmp.stimdur = iclamp.c_dur;
tmp.predur = iclamp.c_start;
tmp.tstop = iclamp.tstop;

for k=1:length(uniqcellsec)
    threshold = -20;
    tmp.cell(k).idxes = [];
    tmp.cell(k).negidx=[];
    tmp.cell(k).posidx=[];
    tmp.cell(k).name=uniqcellsec{k};
    for r=1:length(currents)
        tmp.cell(k).ivec(r)=currents(r)*1000; % convert to pA
        %gohere ... reimporting the data!! arg
        try
            tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
        catch
            tmp.cell(k).fvec(r) = 0;
            continue;
        end
        %if k==1 && r==1
        if  r==1
            tmp.cell(k).TimeVec=tr.data(:,1);
            tmp.mini = find(tmp.cell(k).TimeVec>=tmp.predur,1,'first');
            tmp.maxi = find(tmp.cell(k).TimeVec<=(tmp.predur+tmp.stimdur),1,'last');
        end
        tmp.cell(k).betterdata(r).ResultData=tr.data(:,2);
        spkidx = find(tmp.cell(k).betterdata(r).ResultData(tmp.mini:tmp.maxi-1)<=threshold & tmp.cell(k).betterdata(r).ResultData(tmp.mini+1:tmp.maxi)>=threshold);
        testdur=tmp.stimdur/1000; % convert to seconds
        tmp.cell(k).fvec(r) = length(spkidx)/testdur;
        tmp.cell(k).spikes(r).isi=diff(tmp.cell(k).TimeVec(spkidx));
        if ~isempty(spkidx)
            tmp.cell(k).spikes(r).delay = tmp.cell(k).TimeVec(spkidx(1)+tmp.mini) - tmp.cell(k).TimeVec(tmp.mini); % = tmp.cell(k).TimeVec(spkidx(1))?
        else
            tmp.cell(k).spikes(r).delay = NaN;
        end
        for spk=1:length(spkidx)
            spkstartidx = spkidx(spk)+tmp.mini+0;
            tmp.cell(k).spikes(r).threshold(spk) = tmp.cell(k).betterdata(r).ResultData(spkstartidx); % this one needs better way, dv/dt 3 or something
            spkendidx=find(tmp.cell(k).betterdata(r).ResultData(spkstartidx+1:end)<=threshold,1,'first')+spkstartidx;
            if ~isempty(spkendidx)
                tmp.cell(k).spikes(r).ampl(spk) = max([tmp.cell(k).betterdata(r).ResultData(spkstartidx:spkendidx)]);
                if spk<length(spkidx) && spkendidx<spkidx(spk+1)
                    try
                    tmp.cell(k).spikes(r).ahp(spk) = tmp.cell(k).spikes(r).threshold(spk) - min(tmp.cell(k).betterdata(r).ResultData(spkendidx:spkidx(spk+1)+tmp.mini));
                    catch ME
                        'd'
                    end
                end
                halfamp=mean([tmp.cell(k).spikes(r).ampl(spk) tmp.cell(k).spikes(r).threshold(spk)]);
                half1idx=find(tmp.cell(k).betterdata(r).ResultData(spkstartidx:spkendidx)>=halfamp,1,'first');
                half2idx=find(tmp.cell(k).betterdata(r).ResultData(spkstartidx:spkendidx)>=halfamp,1,'last');
                tmp.cell(k).spikes(r).halfwidth(spk) = tmp.cell(k).TimeVec(half2idx) - tmp.cell(k).TimeVec(half1idx);
            else
                tmp.cell(k).spikes(r).ampl(spk) = NaN;
                tmp.cell(k).spikes(r).ahp(spk) = NaN;
                tmp.cell(k).spikes(r).halfwidth(spk) = NaN;
            end
        end
        
        %same as experimental part, here
        if tmp.cell(k).fvec(r)==0
            tmp.cell(k).ss(r)=tmp.cell(k).betterdata(r).ResultData(tmp.maxi);
            if tmp.cell(k).ivec(r)<0
                [tmp.cell(k).min(r) tmp.cell(k).mintime(r)]=min(tmp.cell(k).betterdata(r).ResultData(tmp.mini:tmp.maxi));
                tmp.cell(k).diffmin(r)=tmp.cell(k).min(r)-tmp.cell(k).ss(r); % sag
                tmp.cell(k).negidx=[tmp.cell(k).negidx r];
            else
                tmp.cell(k).min(r)=NaN;
                tmp.cell(k).diffmin(r)=NaN; % sag
                tmp.cell(k).mintime(r)=NaN;
            end
            if tmp.cell(k).ivec(r)>0
                tmp.cell(k).max(r)=max(tmp.cell(k).betterdata(r).ResultData(tmp.mini:tmp.maxi));
                tmp.cell(k).diffmax(r)=tmp.cell(k).max(r)-tmp.cell(k).ss(r);
                tmp.cell(k).posidx=[tmp.cell(k).posidx r];
            else
                tmp.cell(k).max(r)=NaN;
                tmp.cell(k).diffmax(r)=NaN;
            end
            tmp.cell(k).idxes=[tmp.cell(k).idxes r];
        else
            tmp.cell(k).min(r)=NaN;
            tmp.cell(k).max(r)=NaN;
            tmp.cell(k).ss(r)=NaN;
            tmp.cell(k).diffmin(r)=NaN; % sag
            tmp.cell(k).diffmax(r)=NaN;
            tmp.cell(k).mintime(r)=NaN;
        end
        
        
        
    end
    %tmp.cell(k).currents = currents;
    %tmp.cell(k).numspikes = tmp.cell(k).fvec;
    %tmp.cell(k).hyper = hyper;
%     assignin('base','currents',currents);
%     assignin('base','numspikes',numspikes);
%     assignin('base','hyper',hyper);


    figure(hhyp)
    subplot(1,2,1)
    hold on
    try
    plot(tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).min(tmp.cell(k).negidx),'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).min(tmp.cell(k).negidx),tmp.cell(k).name,'Minimum Potential','Current (pA)','Minimum potential (mV)',hhypname)
    catch
        'd'
    end
    subplot(1,2,2)
    hold on
    plot(tmp.cell(k).ivec(tmp.cell(k).idxes),tmp.cell(k).ss(tmp.cell(k).idxes),'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec(tmp.cell(k).idxes),tmp.cell(k).ss(tmp.cell(k).idxes),tmp.cell(k).name,'Steady State','Current (pA)','Steady state potential (mV)',hhypname)

    figure(hhcn)
    subplot(1,2,1)
    hold on
    plot(tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).diffmin(tmp.cell(k).negidx),'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).diffmin(tmp.cell(k).negidx),tmp.cell(k).name,'Sag Peak Amplitude','Current (pA)','Sag amplitude (mV)',hhcnname)

    subplot(1,2,2)
    hold on
    plot(tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).TimeVec(tmp.cell(k).mintime(tmp.cell(k).negidx))/1000,'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec(tmp.cell(k).negidx),tmp.cell(k).TimeVec(tmp.cell(k).mintime(tmp.cell(k).negidx))/1000,tmp.cell(k).name,'Sag Peak Time','Current (pA)','Sag Timing (s)',hhcnname)


    figure(hif)
    subplot(1,2,1)
    hold on
    plot(tmp.cell(k).ivec(tmp.cell(k).posidx),tmp.cell(k).max(tmp.cell(k).posidx),'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec(tmp.cell(k).posidx),tmp.cell(k).max(tmp.cell(k).posidx),tmp.cell(k).name,'Max Depolarization','Current (pA)','Max potential (mV)',hifname)

    subplot(1,2,2)
    hold on
    plot(tmp.cell(k).ivec,tmp.cell(k).fvec,'Color',colorvec{k},'Marker','.','LineWidth',2)
    logplot(handles.directoryname,myresultsfolder,tmp.cell(k).ivec,tmp.cell(k).fvec,tmp.cell(k).name,'IF Curve','Current (pA)','Firing frequency (Hz)',hifname)
    
    tp=regexp(uniqcellsec{k},'cell.','split');
    legstr{length(legstr)+1}=[upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end)];
    %title(['IF curve for ' upper(tp{2}(1)) tp{2}(2:end)]) % repos


end

if isempty(findstr(handles.directoryname,'/'))
    mysl='\';
else
    mysl='/';
end

if exist([handles.directoryname mysl 'cellclamp_results' mysl 'experimental' mysl 'expcells.mat'])
    myflg=1;
    load([handles.directoryname mysl 'cellclamp_results' mysl 'experimental' mysl 'expcells.mat'],'expcells');

    for r=1:length(expcells)
        mycelltypes{r}=expcells(r).name;
    end
    celltypes=unique(mycelltypes);
        
    for r=1:length(expcells)
        ci=length(uniqcellsec)+r;
        li=find(strcmp(expcells(r).name,celltypes)==1);
        plotsinglecell(expcells(r).structured,ci,li,hif,hhyp,hhcn,expcells(r).name,myresultsfolder,handles.directoryname)
        legstr{length(legstr)+1}= expcells(r).name;
    end
end

figure(hif)
%pp=get(hif,'PaperPosition');
%set(hif,'PaperPosition',[pp(1) pp(2) pp(4)*1.5 pp(4)])
set(hif,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode','auto')
legend(legstr,'Interpreter','none','Location','NorthWest')

figure(hhyp)
%pp=get(hhyp,'PaperPosition');
%set(hhyp,'PaperPosition',[pp(1) pp(2) pp(4)*1.3 pp(4)])
set(hhyp,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode','auto')
legend(legstr,'Interpreter','none','Location','NorthWest')

figure(hhcn)
%pp=get(hhyp,'PaperPosition');
%set(hhyp,'PaperPosition',[pp(1) pp(2) pp(4)*1.3 pp(4)])
set(hhcn,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode','auto')
legend(legstr,'Interpreter','none','Location','NorthWest')

% graph options - graph all, negative, positive, pick own. all black or
% diff colors (color-coded i and v)
print(hif, '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_if.jpg'])
saveas(hif,[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_if.fig'],'fig') 
set(hif,'Visible','on')
%close(gcf)

%pp=get(hhyp,'PaperPosition');
%set(hhyp,'PaperPosition',[pp(1) pp(2) pp(4)/2 pp(4)])
print(hhyp, '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_min.jpg'])
saveas(hhyp,[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_min.fig'],'fig') 
set(hhyp,'Visible','on')
  
%pp=get(hhyp,'PaperPosition');
%set(hhyp,'PaperPosition',[pp(1) pp(2) pp(4)/2 pp(4)])
print(hhcn, '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_min.jpg'])
saveas(hhcn,[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_min.fig'],'fig') 
set(hhcn,'Visible','on')  
    
    
    
function getGUIvalues(handles,myresultsfolder)
global mypath sl
GUIvalues.table_mech.type='Data';
GUIvalues.table_mech.value=get(handles.table_mech,GUIvalues.table_mech.type);

stringcontrols={'txt_version','menu_cellnum','menu_numcon','menu_kinsyn','list_cell','list_conn' ...
                'txt_actstart','txt_actdur','txt_IVcurr','txt_actstartcurr','txt_actcurr','txt_indur', ...
                'txt_inafter','txt_incurr','txt_inaftercurr', ...
                'txt_start','txt_dur','txt_after','txt_current', ...
                'txt_pairstart','txt_pairend','txt_pre','txt_post','txt_rev' };
for r=1:length(stringcontrols)
    GUIvalues.(stringcontrols{r})(1).type='String';
    GUIvalues.(stringcontrols{r})(1).value=get(handles.(stringcontrols{r}),GUIvalues.(stringcontrols{r})(1).type);
end

valuecontrols={'menu_cellnum','menu_numcon','menu_kinsyn','list_cell','list_conn' ...
                'chk_cellclamp','chk_cellmorph','chk_cellmech', ...
                'chk_currpair','chk_connpair','radio_auto','radio_set', ...
                'chk_mechIV','chk_mechact','radio_cond','radio_curr'};
for r=1:length(valuecontrols)
    z=1;
    if isfield(GUIvalues,valuecontrols{r})
        z=length(GUIvalues.(valuecontrols{r}))+1;
    end
    GUIvalues.(valuecontrols{r})(z).type='Value';
    try
    GUIvalues.(valuecontrols{r})(z).value=get(handles.(valuecontrols{r}),GUIvalues.(valuecontrols{r})(z).type);
    catch
        'm'
    end
end



save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'GUIvalues.mat'],'GUIvalues','-v7.3');


function loadGUIvalues(handles,myresultsfolder)
global mypath sl
if exist([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'GUIvalues.mat'],'file')
    load([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'GUIvalues.mat'],'GUIvalues');

    GUIfields = fieldnames(GUIvalues);

    for r=1:length(GUIfields)
        for z=1:length(GUIvalues.(GUIfields{r}))
            set(handles.(GUIfields{r}),GUIvalues.(GUIfields{r})(z).type,GUIvalues.(GUIfields{r})(z).value)
            if z==2
                eval([GUIfields{r} '_Callback(handles.' GUIfields{r} ',[],handles)'])
            end
        end
    end
end


function plotsingleresultsSE(iclamp,handles,myresultsfolder)
global mypath sl cellfigdata

cellfigdata=[];
contents = cellstr(get(handles.list_cell,'String'));
cellOI = contents(get(handles.list_cell,'Value'));

restr=myresultsfolder;

if exist([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat'])
    load([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat']) % iclamp
else
    msgbox('No matfile saved; using current settings in cellclamp tool.')
end
% get all trace names
d=[];
for r=1:length(cellOI)
%     if strcmp(cellOI{r},'sprustoncell')==1
%         cellOI{r}='pyramidalcell';
%     end
%     if strcmp(cellOI{r},'poolosyncell')==1
%         cellOI{r}='pyramidalcell';
%     end
%     if strcmp(cellOI{r},'ppca3sin')==1
%         cellOI{r}='ca3cell';
%     end
%     if strcmp(cellOI{r},'ppecsin')==1
%         cellOI{r}='eccell';
%     end
    d=[d; dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' cellOI{r} '*.dat'])];
end

% tstop=100; %placeholder
 
% get the unique cell names
names={d(:).name}';

cellname=cell(length(names),1);
cellsec=cell(length(names),1);
secname=cell(length(names),1);
secpos=cell(length(names),1);
clampnum=cell(length(names),1);

for i=1:length(names) %length(d)
    parts = regexp(names{i},'[_()]','split'); % 1: trace  2: cell name.section 3: section position 4: clamp number.dat
    parts2=regexp(parts{2},'\.','split');

    cellsec{i}=parts{2};
    cellname{i} = parts2{1};
    secname{i} = parts2{2};
    secpos{i} = parts{3};

    parts3=regexp(parts{4},'\.','split');
    clampnum{i} = parts3{2};
end

% get the unique section names for each cell
uniqcellsec=unique(cellsec);

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')
g = find(strcmp(myresultsfolder,{mydesc(:).name})==1);
if ~isempty(g)
    mydeschere = mydesc(g).desc;
else
    mydeschere='';
end

currents=iclamp.current;

for k=1:length(uniqcellsec)
    figure('Visible','on','Color','w');

    ylabel('Voltage (mV)')
    xlabel('time (ms)')
    title(['Voltage Clamp'])

    for r=1:length(currents)
        try
            tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
        catch
            disp('Didn''t get the results trace for the cell')
            continue;
        end
        plot(tr.data(:,1),tr.data(:,2),'-')
        hold on
    end
end


function plotsinglecustom(iclamp,handles,myresultsfolder)
global mypath sl cellfigdata

cellfigdata=[];
contents = cellstr(get(handles.list_cell,'String'));
cellOI = contents(get(handles.list_cell,'Value'));

restr=myresultsfolder;

if exist([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat'])
    load([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat']) % iclamp
else
    msgbox('No matfile saved; using current settings in cellclamp tool.')
end
% get all trace names
d=[];
for r=1:length(cellOI)
    d=[d; dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' cellOI{r} '*.dat'])];
end

% tstop=100; %placeholder
 
% get the unique cell names
names={d(:).name}';

cellname=cell(length(names),1);
cellsec=cell(length(names),1);
secname=cell(length(names),1);
secpos=cell(length(names),1);
clampnum=cell(length(names),1);

for i=1:length(names) %length(d)
    parts = regexp(names{i},'[_()]','split'); % 1: trace  2: cell name.section 3: section position 4: clamp number.dat
    parts2=regexp(parts{2},'\.','split');

    cellsec{i}=parts{2};
    cellname{i} = parts2{1};
    secname{i} = parts2{2};
    secpos{i} = parts{3};

    parts3=regexp(parts{4},'\.','split');
    clampnum{i} = parts3{2};
end

% get the unique section names for each cell
uniqcellsec=unique(cellsec);

% get the stimulation protocol
%id=importdata('../setupfiles/iclamp.dat');
%numstims=length(iclamp.current);   %id(1,1);
stimdur=iclamp.c_dur;         %id(1,2);
predur= iclamp.c_start;                        %id(1,3);
tstop = iclamp.tstop;

%currents=iclamp.current;
precurr=0;
postcurr=0;

custtime=iclamp.current(:,1);
custcurr=iclamp.current(:,2);

%cd([handles.directoryname '/' handles.resultspath])

for k=1:length(uniqcellsec)
    tp=regexp(uniqcellsec{k},'cell.','split');
    figname=[uniqcellsec{k} ': Channel Currents (' myresultsfolder ')'];
    newfig(1)=figure('Visible','off','Color','w','Name',figname);
    pos=get(newfig(1),'Position');
    set(newfig(1),'Position',[pos(1) pos(2) pos(3)*1.8 pos(4)*2]);
    
    for hh=1
        if hh==1
            crt = 1;
        else
            crt = length(1);
        end
        subplot(2,1,2)
        colorvec2=[ 
                    1 .8 0; ...
                    1 0 1; ...
                    0 1 1; ...
                    .4 .4 .4; ...
                    1 0 0; ...
                    0 1 0; ...
                    0 0 1; ...
                    0 0 0; ...
                    1 .5 .5; ...
                    .5 0 1; ...
                     .9 .4 .1; ...
                   .8 .8 .8; ...
            ];
        colorvec={'k','m','g','y','c','r','b'};

        for r=crt:crt  % which current
            try
                grr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat'],'\t',1);
                mz=length(grr.textdata);
                headerstring='%s';
                datastring='%f';
                for mk=2:mz
                    headerstring=[headerstring '\t%s'];
                    datastring=[datastring '\t%f'];
                end
                headerstring=[headerstring '\n'];
                datastring=[datastring '\n'];
                fid = fopen([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
                % headers = textscan(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',1) ;
                headers = textscan(fid,headerstring,1) ;
                % data = fscanf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n');
                data = fscanf(fid,datastring);
                fclose(fid);
                tr.data=reshape(data,mz,length(data)/mz)'; clear data grr;
                %tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
                for t = 1:length(headers)
                    tr(1).colheaders{t}=headers{t}{1};
                    if t>2
                    tr(1).colheaders{t}(1:4)=[];
                    end
                end
            catch ME
                ME
                continue;
            end
            %plot(tr.data(:,1),tr.data(:,2),'-')

            for jk = 3:size(tr.data,2)
                plot(tr.data(:,1), tr.data(:,jk)*10^6,'Color', colorvec2(jk-2,:))
                logplot(handles.directoryname,myresultsfolder,tr.data(:,1),tr.data(:,jk)*10^6,[tr.colheaders{jk} ' #' num2str(r)],[upper(tp{1}(1)) tp{1}(2:end) ' Cell Channel Currents'],'Time (ms)','Current (nA)',figname)
                hold on
            end
        end
        tstop=round(max(tr.data(:,1)));
        postdur=tstop-stimdur-predur;
        xlim([0 tstop])
        %axis off
        ylabel('currents (nA)')
        xlabel('time (ms)')

        title([upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end)  ' (' restr ')'])
        if hh==1
            legend([tr.colheaders(3:end)'],'Location','Best','Interpreter','none')
        else
            legend([tr.colheaders(3:end)'],'Location','Best','Interpreter','none')
        end
        
        subplot(2,1,1)
        plot(custtime,custcurr)
            %logploty = [zeros(1,switchup_idx) ones(1,middle_range)*currents(r)  zeros(1,length(tr.data(:,1))-switchdown_idx-1)  ];
            %logplot(handles.directoryname,myresultsfolder,tr.data(:,1),logploty,[num2str(currents(r)) ' nA'],[upper(tp{1}(1)) tp{1}(2:end) ' Cell Current Injection'],'Time (ms)','Current (nA)',figname)
        %ylim([-1 1])
        hold on
        xlim([0 tstop])
        y=get(gca,'ylim');
        currange=y(2)-y(1);
        plot([tstop*.8 tstop*.9],[y(1)+currange/20 y(1)+currange/20],'Color','k')
        text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
        plot([tstop*.8 tstop*.8],[y(1)+currange/20 y(1)+currange/20+currange/10],'Color','k')
        text(tstop*.82,y(1)+currange/10,[num2str(currange/10) ' nA'])
        text((predur+stimdur)*1.05,.75,[num2str(.75) ' nA'])
        text((predur+stimdur)*1.05,.25,[num2str(.25) ' nA'])

        axis off
        ylabel('current (nA)')
        xlabel('time (ms)')
        title(['Current Injection on a '  upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end)  ' (' restr ')'])

        %pp=get(gcf,'PaperPosition');
        %set(gcf,'PaperPosition',[pp(1) pp(2) pp(4) pp(4)])
        set(newfig(1),'units','normalized','outerposition',[0 0 1 1])
        print(newfig(1), '-djpeg', [ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_mechs.jpg'])
        saveas(newfig(1),[ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_mechs.fig'],'fig') 
        %saveas(gcf,[uniqcellsec{k} '_mechs.fig'],'fig') 
        set(newfig(1),'Visible','on')
        %close(gcf)
    end
end

load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')
g = find(strcmp(myresultsfolder,{mydesc(:).name})==1);
if ~isempty(g)
    mydeschere = mydesc(g).desc;
else
    mydeschere='';
end

for k=1:length(uniqcellsec)
    gstruct(k).num=myresultsfolder;
    gstruct(k).desc=mydeschere; %aqua
    gstruct(k).name=uniqcellsec{k};
    tp=regexp(gstruct(k).name,'cell.','split');
    figname=['Voltage Traces for ' gstruct(k).name ' (' myresultsfolder ')'];
    newfig(2)=figure('Visible','on','Color','w','Name',figname);
    pos=get(newfig(2),'Position');
    set(newfig(2),'Position',[pos(1) pos(2) pos(3)*.8 pos(4)*2]);
    subplot(2,1,2)
    spikes = 0;
    timing = 0;
    firerate = 0;
    threshold = -10;
    idx = [];
    gstruct(k).results=[];%results.cell(k);

    for r=1
        try
            tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' gstruct(k).name '(0.5).' num2str(r-1) '.dat']);
        catch
            disp(['Didn''t get the results trace for the cell: ' gstruct(k).name ', current: ' num2str(currents(r)) ' (file: ' num2str(r-1) ')'])
            continue;
        end
        gstruct(k).cell(r).current=r;
        gstruct(k).cell(r).tr = tr;
        idx = find(tr.data(1:end-1,2)<=threshold & tr.data(2:end,2)>=threshold);
        if length(idx)>1
            gstruct(k).cell(r).ISI_1=(tr.data(idx(2),1)-tr.data(idx(1),1));
            gstruct(k).cell(r).ISI_last=(tr.data(idx(end),1)-tr.data(idx(end-1),1));
        else
            gstruct(k).cell(r).ISI_1=[];
        end
        if length(idx)>3
            gstruct(k).cell(r).ISI_3=(tr.data(idx(4),1)-tr.data(idx(3),1));
        else
            gstruct(k).cell(r).ISI_3=[];
        end
        gstruct(k).cell(r).spk_idx=idx;
        spikes = max(spikes,length(idx));
        if length(idx)>0, timing = max(tr.data(idx(end),1) - tr.data(idx(1),1)); end
%         if currents(r)>0 && currents(r)~=max(currents)
%             continue
%         end
        %logplot(handles.directoryname,myresultsfolder,x,y,legendentry,axistitle,xlabel,ylabel,figname)
        plot(tr.data(:,1),tr.data(:,2),'-')
        logplot(handles.directoryname,myresultsfolder,tr.data(:,1),tr.data(:,2),['#' num2str(r)],[tp{1} ' MP Trace Bottom'],'Time (ms)','Potential (mV)',figname)
        hold on
    end
    tstop=round(max(tr.data(:,1)));
    postdur=tstop-stimdur-predur;
    xlim([0 tstop])

    y=get(gca,'ylim');
    potrange=y(2)-y(1);
    % Scale
    plot([tstop*.8 tstop*.9],[y(1)+potrange/20 y(1)+potrange/20],'Color','k')
    text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
    plot([tstop*.8 tstop*.8],[y(1)+potrange/20 y(1)+potrange/10+potrange/20],'Color','k')
    text(tstop*.82,y(1)+potrange/10,[num2str(potrange/10) ' mV'])

    %ylim([-100 20])

    axis off
    %sub
    xlabel('time (ms)')
    
    % resample because the current injection is not updated every dt time
    % step
    longct=repmat(custcurr(:),1,round(length(tr.data(:,1))/length(custcurr)))';
    longct=longct(1:length(tr.data(:,1)));
    entry = AnalyzeChirpMJB(tr.data(:,1)/1000,longct',tr.data(:,2));   
    title({['Potential at the '  upper(tp{2}(1)) tp{2}(2:end) '.']; ['RMP: ' sprintf('%.1f',entry.results.holdingVoltage) ' mV    Res. Freq: ' sprintf('%.2f',entry.results.resFreq) ' Hz (Q=' num2str(entry.results.Q) ', Z=' num2str(entry.results.peakZ) ')']})
    
    
    
    subplot(2,1,1)
     plot(custtime,custcurr)
%         logploty = [zeros(1,switchup_idx) ones(1,middle_range)*currents(r)  zeros(1,length(tr.data(:,1))-switchdown_idx-1)  ];
%         logplot(handles.directoryname,myresultsfolder,tr.data(:,1),logploty,[num2str(currents(r)) ' nA'],[tp{1} ' MP Trace Top'],'Time (ms)','Current (nA)',figname)
    hold on
    xlim([0 tstop])
%     y=get(gca,'ylim');
%     currange=y(2)-y(1);
%     plot([tstop*.8 tstop*.9],[y(1)+currange/20 y(1)+currange/20])
%     text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
%     plot([tstop*.8 tstop*.8],[y(1)+currange/20 y(1)+currange/20+currange/10])
%     text(tstop*.82,y(1)+currange/10,[num2str(currange/10) ' nA'])
%     text((predur+stimdur)*1.02,.75,[num2str(.75) ' nA'])
%     text((predur+stimdur)*1.02,.25,[num2str(.25) ' nA'])
    
    axis off
    ylabel('current (nA)')
    xlabel('time (ms)')
    title(['Current Clamp on a ' upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end) ' (' restr ')'])
    % graph options - graph all, negative, positive, pick own. all black or
    % diff colors (color-coded i and v)
    pp=get(newfig(2),'PaperPosition');
    %set(gcf,'units','normalized','outerposition',[0 0 1 1])
    set(newfig(2),'PaperPositionMode','auto')
    %set(gcf,'PaperPosition',[pp(1) pp(2) pp(4)/1.3 pp(4)])
    print(newfig(2), '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '.jpg'])
    saveas(newfig(2),[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '.fig'],'fig') 
    set(newfig(2),'Visible','on')
    %close(gcf)
end

assignin('base',['gstruct_' myresultsfolder],gstruct)
save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'cellfigdata.mat'],'cellfigdata','-v7.3')
save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'gstruct.mat'],'gstruct','-v7.3')
assignin('base',['cellfigdata_' myresultsfolder],cellfigdata)



function plotsingleresults(iclamp,handles,myresultsfolder)
global mypath sl cellfigdata

cellfigdata=[];
contents = cellstr(get(handles.list_cell,'String'));
cellOI = contents(get(handles.list_cell,'Value'));

% restr='';
% if isfield(handles, 'resultspath') && ~isempty(handles.resultspath)
%     cd([handles.directoryname '/' handles.resultspath])
%     restr = [ ' ' handles.resultspath];
% else
%     cd([handles.directoryname '/cellclamp_results/' myresultsfolder])
%     handles.resultspath = ['cellclamp_results/' myresultsfolder];
% end
restr=myresultsfolder;

if exist([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat'])
    load([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'rundata.mat']) % iclamp
else
    msgbox('No matfile saved; using current settings in cellclamp tool.')
end
% get all trace names
d=[];
for r=1:length(cellOI)
%     if strcmp(cellOI{r},'sprustoncell')==1
%         cellOI{r}='pyramidalcell';
%     end
%     if strcmp(cellOI{r},'poolosyncell')==1
%         cellOI{r}='pyramidalcell';
%     end
%     if strcmp(cellOI{r},'ppca3sin')==1
%         cellOI{r}='ca3cell';
%     end
%     if strcmp(cellOI{r},'ppecsin')==1
%         cellOI{r}='eccell';
%     end
    d=[d; dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' cellOI{r} '*.dat'])];
end

% tstop=100; %placeholder
 
% get the unique cell names
names={d(:).name}';

cellname=cell(length(names),1);
cellsec=cell(length(names),1);
secname=cell(length(names),1);
secpos=cell(length(names),1);
clampnum=cell(length(names),1);

for i=1:length(names) %length(d)
    parts = regexp(names{i},'[_()]','split'); % 1: trace  2: cell name.section 3: section position 4: clamp number.dat
    parts2=regexp(parts{2},'\.','split');

    cellsec{i}=parts{2};
    cellname{i} = parts2{1};
    secname{i} = parts2{2};
    secpos{i} = parts{3};

    parts3=regexp(parts{4},'\.','split');
    clampnum{i} = parts3{2};
end

% get the unique section names for each cell
uniqcellsec=unique(cellsec);

% get the stimulation protocol
%id=importdata('../setupfiles/iclamp.dat');
numstims=length(iclamp.current);   %id(1,1);
stimdur=iclamp.c_dur;         %id(1,2);
predur= iclamp.c_start;                        %id(1,3);
tstop = iclamp.tstop;

currents=iclamp.current;
precurr=0;
postcurr=0;


%cd([handles.directoryname '/' handles.resultspath])

for k=1:length(uniqcellsec)
    tp=regexp(uniqcellsec{k},'cell.','split');
    figname=[uniqcellsec{k} ': Channel Currents (' myresultsfolder ')'];
    newfig(1)=figure('Visible','off','Color','w','Name',figname);
    pos=get(newfig(1),'Position');
    set(newfig(1),'Position',[pos(1) pos(2) pos(3)*1.8 pos(4)*2]);
    
    for hh=1:2
        if hh==1
            crt = 1;
        else
            crt = length(currents);
        end
        subplot(2,2,hh+2)
        colorvec2=[ 
                    1 .8 0; ...
                    1 0 1; ...
                    0 1 1; ...
                    .4 .4 .4; ...
                    1 0 0; ...
                    0 1 0; ...
                    0 0 1; ...
                    0 0 0; ...
                    1 .5 .5; ...
                    .5 0 1; ...
                     .9 .4 .1; ...
                   .8 .8 .8; ...
            ];
        colorvec={'k','m','g','y','c','r','b'};

        for r=crt:crt  % which current
            try
                grr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat'],'\t',1);
                mz=length(grr.textdata);
                headerstring='%s';
                datastring='%f';
                for mk=2:mz
                    headerstring=[headerstring '\t%s'];
                    datastring=[datastring '\t%f'];
                end
                headerstring=[headerstring '\n'];
                datastring=[datastring '\n'];
                fid = fopen([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
                % headers = textscan(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',1) ;
                headers = textscan(fid,headerstring,1) ;
                % data = fscanf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n');
                data = fscanf(fid,datastring);
                fclose(fid);
                tr.data=reshape(data,mz,length(data)/mz)'; clear data grr;
                %tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' uniqcellsec{k} '(0.5).' num2str(r-1) '.dat']);
                for t = 1:length(headers)
                    tr(1).colheaders{t}=headers{t}{1};
                    if t>2
                    tr(1).colheaders{t}(1:4)=[];
                    end
                end
            catch ME
                ME
                continue;
            end
            %plot(tr.data(:,1),tr.data(:,2),'-')

            for jk = 3:size(tr.data,2)
                plot(tr.data(:,1), tr.data(:,jk)*10^6,'Color', colorvec2(jk-2,:))
                logplot(handles.directoryname,myresultsfolder,tr.data(:,1),tr.data(:,jk)*10^6,[tr.colheaders{jk} ' ' num2str(currents(r)) ' nA'],[upper(tp{1}(1)) tp{1}(2:end) ' Cell Channel Currents'],'Time (ms)','Current (nA)',figname)
                hold on
            end
        end
        tstop=round(max(tr.data(:,1)));
        postdur=tstop-stimdur-predur;
         xlim([0 tstop])
        %axis off
        ylabel('currents (nA)')
        xlabel('time (ms)')

        title(['Currents for the '  upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end)  ' (' restr ')'])
        if hh==1
            legend([tr.colheaders(3:end)'],'Location','Best','Interpreter','none')
        else
            legend([tr.colheaders(3:end)'],'Location','Best','Interpreter','none')
        end
        
        subplot(2,2,hh)

        for r=crt:crt % which current
            x=[0 predur predur predur+stimdur predur+stimdur predur+stimdur+postdur];
            y=[0 0 currents(r) currents(r) 0 0];
            plot(x,y,'-')
            hold on
            switchup_idx = find(tr.data(:,1)>=predur,1,'first');
            switchdown_idx =find(tr.data(:,1)>=(predur+stimdur),1,'first');
            middle_range = switchdown_idx-switchup_idx;
            logploty = [zeros(1,switchup_idx) ones(1,middle_range)*currents(r)  zeros(1,length(tr.data(:,1))-switchdown_idx-1)  ];
            logplot(handles.directoryname,myresultsfolder,tr.data(:,1),logploty,[num2str(currents(r)) ' nA'],[upper(tp{1}(1)) tp{1}(2:end) ' Cell Current Injection'],'Time (ms)','Current (nA)',figname)
        end
        ylim([-1 1])
        xlim([0 tstop])
        y=get(gca,'ylim');
        currange=y(2)-y(1);
        plot([tstop*.8 tstop*.9],[y(1)+currange/20 y(1)+currange/20])
        text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
        plot([tstop*.8 tstop*.8],[y(1)+currange/20 y(1)+currange/20+currange/10])
        text(tstop*.82,y(1)+currange/10,[num2str(currange/10) ' nA'])
        text((predur+stimdur)*1.05,max(currents),[num2str(max(currents)) ' nA'])
        text((predur+stimdur)*1.05,min(currents),[num2str(min(currents)) ' nA'])

        axis off
        ylabel('current (nA)')
        xlabel('time (ms)')
        title(['Current Clamp on a '  upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end)  ' (' restr ')'])

        %pp=get(gcf,'PaperPosition');
        %set(gcf,'PaperPosition',[pp(1) pp(2) pp(4) pp(4)])
        set(newfig(1),'units','normalized','outerposition',[0 0 1 1])
        print(newfig(1), '-djpeg', [ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_mechs.jpg'])
        saveas(newfig(1),[ handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '_mechs.fig'],'fig') 
        %saveas(gcf,[uniqcellsec{k} '_mechs.fig'],'fig') 
        set(newfig(1),'Visible','on')
        %close(gcf)
    end
end
     
results=plotifcurve(iclamp,handles,myresultsfolder,uniqcellsec,currents); 


load([handles.directoryname sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')
g = find(strcmp(myresultsfolder,{mydesc(:).name})==1);
if ~isempty(g)
    mydeschere = mydesc(g).desc;
else
    mydeschere='';
end

for k=1:length(uniqcellsec)
    gstruct(k).num=myresultsfolder;
    gstruct(k).desc=mydeschere; %aqua
    gstruct(k).name=uniqcellsec{k};
    tp=regexp(gstruct(k).name,'cell.','split');
    figname=['Voltage Traces for ' gstruct(k).name ' (' myresultsfolder ')'];
    newfig(2)=figure('Visible','on','Color','w','Name',figname);
    pos=get(newfig(2),'Position');
    set(newfig(2),'Position',[pos(1) pos(2) pos(3)*.8 pos(4)*2]);
    subplot(2,1,2)
    spikes = 0;
    timing = 0;
    firerate = 0;
    threshold = -10;
    idx = [];
    gstruct(k).results=results.cell(k);

    for r=1:length(currents)
        try
            tr=importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'trace_' gstruct(k).name '(0.5).' num2str(r-1) '.dat']);
        catch
            disp(['Didn''t get the results trace for the cell: ' gstruct(k).name ', current: ' num2str(currents(r)) ' (file: ' num2str(r-1) ')'])
            continue;
        end
        gstruct(k).cell(r).current=currents(r);
        gstruct(k).cell(r).tr = tr;
        idx = find(tr.data(1:end-1,2)<=threshold & tr.data(2:end,2)>=threshold);
        if length(idx)>1
            gstruct(k).cell(r).ISI_1=(tr.data(idx(2),1)-tr.data(idx(1),1));
            gstruct(k).cell(r).ISI_last=(tr.data(idx(end),1)-tr.data(idx(end-1),1));
        else
            gstruct(k).cell(r).ISI_1=[];
        end
        if length(idx)>3
            gstruct(k).cell(r).ISI_3=(tr.data(idx(4),1)-tr.data(idx(3),1));
        else
            gstruct(k).cell(r).ISI_3=[];
        end
        gstruct(k).cell(r).spk_idx=idx;
        spikes = max(spikes,length(idx));
        if length(idx)>0, timing = max(tr.data(idx(end),1) - tr.data(idx(1),1)); end
        if currents(r)>0 && currents(r)~=max(currents)
            continue
        end
        %logplot(handles.directoryname,myresultsfolder,x,y,legendentry,axistitle,xlabel,ylabel,figname)
        plot(tr.data(:,1),tr.data(:,2),'-')
        logplot(handles.directoryname,myresultsfolder,tr.data(:,1),tr.data(:,2),[num2str(currents(r)) ' nA'],[tp{1} ' MP Trace Bottom'],'Time (ms)','Potential (mV)',figname)
        hold on
    end
    tstop=round(max(tr.data(:,1)));
    postdur=tstop-stimdur-predur;
    xlim([0 tstop])

    y=get(gca,'ylim');
    potrange=y(2)-y(1);
    % Scale
    plot([tstop*.8 tstop*.9],[y(1)+potrange/20 y(1)+potrange/20])
    text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
    plot([tstop*.8 tstop*.8],[y(1)+potrange/20 y(1)+potrange/10+potrange/20])
    text(tstop*.82,y(1)+potrange/10,[num2str(potrange/10) ' mV'])

    %ylim([-100 20])

    axis off
    %sub
    xlabel('time (ms)')
    if timing>0, firerate = spikes/timing*1000; end
    
    ridx = find(tr.data(:,1)<predur/2,1,'last');
    rmp = tr.data(ridx,2);
    title({['Membrane Potential at the '  upper(tp{2}(1)) tp{2}(2:end) '.']; ['RMP: ' sprintf('%.1f',rmp) 'mV    Max rate: ' sprintf('%.2f',firerate) ' Hz (' num2str(spikes) ' spikes)']})

    subplot(2,1,1)
    for r=1:length(currents)
        if currents(r)>0 && currents(r)~=max(currents)
            continue
        end
        x=[0 predur predur predur+stimdur predur+stimdur predur+stimdur+postdur];
        y=[0 0 currents(r) currents(r) 0 0];
        plot(x,y,'-')
        switchup_idx = find(tr.data(:,1)>=predur,1,'first');
        switchdown_idx =find(tr.data(:,1)>=(predur+stimdur),1,'first');
        middle_range = switchdown_idx-switchup_idx;
        logploty = [zeros(1,switchup_idx) ones(1,middle_range)*currents(r)  zeros(1,length(tr.data(:,1))-switchdown_idx-1)  ];
        logplot(handles.directoryname,myresultsfolder,tr.data(:,1),logploty,[num2str(currents(r)) ' nA'],[tp{1} ' MP Trace Top'],'Time (ms)','Current (nA)',figname)
        hold on
    end
    ylim([-1 1])
    xlim([0 tstop])
    y=get(gca,'ylim');
    currange=y(2)-y(1);
    plot([tstop*.8 tstop*.9],[y(1)+currange/20 y(1)+currange/20])
    text(tstop*.8,y(1),[num2str(tstop/10) ' ms'])
    plot([tstop*.8 tstop*.8],[y(1)+currange/20 y(1)+currange/20+currange/10])
    text(tstop*.82,y(1)+currange/10,[num2str(currange/10) ' nA'])
    text((predur+stimdur)*1.02,max(currents),[num2str(max(currents)) ' nA'])
    text((predur+stimdur)*1.02,min(currents),[num2str(min(currents)) ' nA'])
    
    axis off
    ylabel('current (nA)')
    xlabel('time (ms)')
    title(['Current Clamp on a ' upper(tp{1}(1)) tp{1}(2:end) ' Cell ' upper(tp{2}(1)) tp{2}(2:end) ' (' restr ')'])
    % graph options - graph all, negative, positive, pick own. all black or
    % diff colors (color-coded i and v)
    pp=get(newfig(2),'PaperPosition');
    %set(gcf,'units','normalized','outerposition',[0 0 1 1])
    set(newfig(2),'PaperPositionMode','auto')
    %set(gcf,'PaperPosition',[pp(1) pp(2) pp(4)/1.3 pp(4)])
    print(newfig(2), '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '.jpg'])
    saveas(newfig(2),[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl uniqcellsec{k} '.fig'],'fig') 
    set(newfig(2),'Visible','on')
    %close(gcf)
end

assignin('base',['gstruct_' myresultsfolder],gstruct)
save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'cellfigdata.mat'],'cellfigdata','-v7.3')
save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'gstruct.mat'],'gstruct','-v7.3')
assignin('base',['cellfigdata_' myresultsfolder],cellfigdata)

if 1==0
    warning off MATLAB:xlswrite:AddSheet

    %cellfigdata.fig.axis.data
    worksheet=[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl  'cellfigdata.xls'];
    for z=1:length(cellfigdata.fig)
        for b=1:length(cellfigdata.fig(z).axis)
            sheetname=strrep(strrep([cellfigdata.fig(z).axis(b).name],':',' '),'.',' ');
            xlswrite(worksheet, {['Y-axis: ' cellfigdata.fig(z).axis(b).ylabel]}, sheetname, 'A1');

            m=1;
            if size(cellfigdata.fig(z).axis(b).data(m).x,2)>1
                cellfigdata.fig(z).axis(b).data(m).x=cellfigdata.fig(z).axis(b).data(m).x';
            end

            xlswrite(worksheet, {cellfigdata.fig(z).axis(b).xlabel}, sheetname, 'A3');
            xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(1).x), sheetname, 'A4');

            addme=0;
            for m=1:length(cellfigdata.fig(z).axis(b).data)
                if size(cellfigdata.fig(z).axis(b).data(m).x,2)>1
                    cellfigdata.fig(z).axis(b).data(m).x=cellfigdata.fig(z).axis(b).data(m).x';
                end
                if size(cellfigdata.fig(z).axis(b).data(m).y,2)>1
                    cellfigdata.fig(z).axis(b).data(m).y=cellfigdata.fig(z).axis(b).data(m).y';
                end
                if m>1 && (length(cellfigdata.fig(z).axis(b).data(m-1).x)~=length(cellfigdata.fig(z).axis(b).data(m).x) || sum(abs(cellfigdata.fig(z).axis(b).data(m).x-cellfigdata.fig(z).axis(b).data(m-1).x))>abs(.001*cellfigdata.fig(z).axis(b).data(1).x(1)))
                    addme = addme + 1;
                    Letter = char(m +'A'+addme);
                    xlswrite(worksheet, {cellfigdata.fig(z).axis(b).xlabel}, sheetname, [Letter '3']);
                    xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(m).x), sheetname, [Letter '4']);
                    addme = addme + 1;
                end
                Letter = char(m +'A'+addme);
                xlswrite(worksheet, {cellfigdata.fig(z).axis(b).data(m).name}, sheetname, [Letter '3']);
                xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(m).y), sheetname, [Letter '4']);
            end
        end
    end
end

function plotpairresults(iclamp,handles,myresultsfolder,varargin)
global mypath sl cellfigdata

try
    cellfigdata=[];
st = round(iclamp.c_start/2);

mycomments = '';
if ~isempty(varargin)
    mycomments = varargin{1};
end

%cd([handles.directoryname '/cellclamp_results/' myresultsfolder])
% get all trace names
d=dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl '*.*.*.trace.dat']);

for i=1:length(d)
    h=regexp(d(i).name,'\.','split');
    d(i).precell = h{1};
    d(i).postcell = h{2};
    d(i).synapse = h{3};
    d(i).prebypost = [h{1} h{2}];
end

try
    prebypost = unique({d(:).prebypost});
catch
    msgbox('There was an error running the code. Check the MATLAB command line.')
    return
end

fid=fopen([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'runreceipt.dat'],'r');
mm=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
for z=9:11
    eval([mm{1}{z} ';'])
end
%updatecelltemplates(handles,NumData,SynData,handles.directoryname)

%prebypost={'pyramidalcellpyramidalcell'};
for i=1:length(prebypost)
    [numsyns idx]= searchfield(d,'prebypost',prebypost{i});        

    % get the actual synapses used and write them out, update the sids.dat
    % file
    fid = fopen([handles.directoryname sl 'cells' sl 'synlist.dat'],'r');   
    if ~isempty(fid)
        syndata = textscan(fid,'%s %s %f %s\n') ;
        fclose(fid);
    else
        msgbox('Could not open the synlist.dat file in cells folder.')
        return
    end

    mydend={};
    fid = fopen([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(1)).precell '.' d(idx(1)).postcell '.sids.dat'],'r');                
    numlines = fscanf(fid,'%d\n',1) ;
    numcols = fscanf(fid,'%d\n',1) ;
    filedata = textscan(fid,'%f %f\n') ;
    fclose(fid);
    if numcols == 2
%if length(filedata{1})==numlines % then already did this
        idx1=strmatch(d(idx(1)).precell,syndata{2});
        idx2=strmatch(d(idx(1)).postcell,syndata{1});
        subidx = intersect(idx1,idx2);
        for r=1:length(filedata{1})
            syn = filedata{2}(r);
            myidx = find(syndata{3}(subidx)==syn);
            try
            mydend{r} = syndata{4}{subidx(myidx)};
            catch
                r
            end
           
                
            ib = strfind(mydend{r},'.');
            mydend{r}=mydend{r}(ib+1:end);
        end

        fid = fopen([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(1)).precell '.' d(idx(1)).postcell '.sids.dat'],'w');

        % write
        fprintf(fid, '%g\n3\n', numlines);
        for r=1:length(filedata{1})
            fprintf(fid, '%g %g %s\n', filedata{1}(r), filedata{2}(r), mydend{r});
        end
        fclose(fid);

    
        it=strmatch(d(idx(1)).postcell,handles.celltype);
        techtype = handles.techtype{it};
        % then, have NEURON make a picture of the cell with the used synapses
        if isempty(dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(1)).precell '.' d(idx(1)).postcell '*.eps']))
            if ispc
                %system(['cd ' handles.directoryname handles.dl ' ' handles.general.neuron ' -c "strdef postcell" -c postcell="\"' d(idx(1)).postcell '\"" -c "strdef precell" -c precell="\"' d(idx(1)).precell '\"" -c "strdef studycell" -c studycell="\"' techtype '\"" -c "strdef RunName"  -c RunName="\"' myresultsfolder '\"" -c "strdef repodir"  -c repodir="\"' strrep(strrep(handles.directoryname,'\','/'),'C:','/cygdrive/c') '\"" ' handles.directoryname sl 'setupfiles' sl 'clamp' sl 'colorsynapses.hoc -c "quit()"'])
            else
                %system(['cd ' handles.directoryname handles.dl ' ' handles.general.neuron ' -c "strdef postcell" -c postcell="\"' d(idx(1)).postcell '\"" -c "strdef precell" -c precell="\"' d(idx(1)).precell '\"" -c "strdef studycell" -c studycell="\"' techtype '\"" -c "strdef RunName"  -c RunName="\"' myresultsfolder '\"" -c "strdef repodir"  -c repodir="\"' handles.directoryname '\"" ' handles.directoryname sl 'setupfiles' sl 'clamp' sl 'colorsynapses.hoc -c "quit()"'])
            end
        end
    end
    z=3;  
    p=1;
    %while numsyns>=1+(p-1)*z
        h2(p) = figure('Color','w','Name', [d(idx(1)).precell ' -> ' d(idx(1)).postcell]);

        for n=1:numsyns
            tr(n) = importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(n)).name]);
            tr(1).data(:,2+n) = tr(n).data(:,3);
        end
        tr(2:end)=[];
        
            figure(h2(p))
            subplot(2,1,1)
            %subplot(2,min(numsyns,z),nmod(n+min(numsyns,z)-1,min(numsyns,z))+1)
            %plot(tr.data(st:end,1),tr.data(st:end,2))
            %ylabel('voltage (mV)')
            avgkinetics=[];
            allkinetics=[];
            meankinetics=[];
            
            m = size(tr(1).data,2);
            if m<4
                avgdata = tr(1).data(:,3:m);
            else
                avgdata = mean(tr(1).data(:,3:m)')';
            end
            
            mystruct(i).name = prebypost{i};
            mystruct(i).time = tr(1).data(:,1);
            mystruct(i).meantrance = avgdata;
 
            avgkinetics = getkinetics(tr.data(:,1),avgdata,iclamp.pairstart-5); %addhere

            ag=1;
            for g=3:m
                %if std(tr(1).data(100:end,g))>0.001
                    if ag==1
                        allkinetics = getkinetics(tr.data(:,1),tr(1).data(:,g),iclamp.pairstart-5);
                    else
                        allkinetics(ag) = getkinetics(tr.data(:,1),tr(1).data(:,g),iclamp.pairstart-5);
                    end
                    ag=ag+1;
                %else
                %    msgbox({['Trace ' d(idx(g-2)).name ' was skipped'], 'because it had almost no postsynaptic response.'})
                %end
            end
            myf = fieldnames(allkinetics);
            
            for g=1:length(myf)
            meankinetics.(myf{g}) = mean([allkinetics(:).(myf{g})]);
            end
            kinetics=meankinetics;
            kinetics.change_idx=round(meankinetics.change_idx);
            kinetics.peak_idx=round(meankinetics.peak_idx);

%             before_idx = find(tr.data(:,1)>10,1,'first');
%             after_idx = length(tr.data);
% 
%             [~, peak_idx] = max(abs(avgdata(before_idx:after_idx)-avgdata(before_idx)));
%             peak_idx = peak_idx + before_idx - 1;
% 
%             change_idx = find(abs(diff(avgdata(before_idx:end)))>.05*max(abs(diff(avgdata(before_idx:end)))),1,'first') + before_idx-1;
% 
%             idxes = [change_idx peak_idx after_idx];
% 
%             %figure;
%             % plot(tr.data(2:end,1),tr.data(2:end,3),'b')
%             % hold on
%             % 
%             % xl = get(gca,'xlim');
%             % yl = get(gca,'ylim');
%             % 
%             % stx = (xl(2)-xl(1))*.1+xl(1);
%             % sty = (yl(2)-yl(1))*.1+yl(1);
%             % 
%             % plot([stx stx+10],[sty sty],'k')
%             % plot([stx stx],[sty sty+.02],'k')
% 
% 
%             %plot(tr.data(idxes,1),tr.data(idxes,3),'r','LineStyle','none','Marker','.')
% 
%             % 10 - 90 rise time
%             compdata = avgdata - avgdata(change_idx);
%             per10_val = .1*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
%             per10_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per10_val),1,'first')+change_idx-1;
%             %plot(tr.data(per10_idx,1),tr.data(per10_idx,3),'g','LineStyle','none','Marker','.')
% 
%             per90_val = .9*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
%             per90_idx = find(abs(compdata(change_idx:peak_idx))>=abs(per90_val),1,'first')+change_idx-1;
%             %plot(tr.data(per90_idx,1),tr.data(per90_idx,3),'g','LineStyle','none','Marker','.')
%             rt_10_90 = tr.data(per90_idx,1) - tr.data(per10_idx,1);
% 
%             % width at half amplitude
%             per50_val = .5*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
%             halfup_idx = find(abs(compdata(before_idx:after_idx))>=abs(per50_val),1,'first')+before_idx-1;
%             halfdown_idx = find(abs(compdata(before_idx:after_idx))>=abs(per50_val),1,'last')+before_idx-1;
% 
%             %plot(tr.data(halfup_idx,1),tr.data(halfup_idx,3),'c','LineStyle','none','Marker','.')
%             %plot(tr.data(halfdown_idx,1),tr.data(halfdown_idx,3),'c','LineStyle','none','Marker','.')
%             halfwidth = tr.data(halfdown_idx,1) - tr.data(halfup_idx,1);
% 
%             % rise time constant
%             erise_val = (1-1/exp(1))*(compdata(peak_idx) - compdata(change_idx))+compdata(change_idx);
%             taurise_idx = find(abs(compdata(before_idx:after_idx))>=abs(erise_val),1,'first')+before_idx-1;
%             %plot(tr.data(taurise_idx,1),tr.data(taurise_idx,3),'y','LineStyle','none','Marker','.')
%             taurise = tr.data(taurise_idx,1) - tr.data(change_idx,1);
% 
%             % decay time constant
%             edecay_val = (1/exp(1))*(compdata(peak_idx) - compdata(after_idx))+compdata(after_idx);
%             taudecay_idx = find(abs(compdata(before_idx:after_idx))>=abs(edecay_val),1,'last')+before_idx-1;
%             %plot(tr.data(taudecay_idx,1),tr.data(taudecay_idx,3),'y','LineStyle','none','Marker','.')
%             taudecay = tr.data(taudecay_idx,1) - tr.data(peak_idx,1);


            % display results

            % voltage clamp
            titlestr{1}=[d(idx(1)).precell ' -> ' d(idx(1)).postcell];
            try
            titlestr{2}= mycomments{:};
            catch
            titlestr{2}= mycomments;
            end
            titlestr{3}=['10 - 90% rise time: ' sprintf('%.2f',kinetics.rt_10_90) ' ms, time to peak: ' sprintf('%.2f', tr.data(kinetics.peak_idx,1) - tr.data(kinetics.change_idx,1)) ' ms'];
            if get(handles.chk_connpair,'Value')==1
                titlestr{4}=['Amplitude: ' sprintf('%.2f',kinetics.amplitude*10^3) ' pA'];
                titlestr{5}=['Decay tau: ' sprintf('%.2f',kinetics.taudecay) ' ms'];
            else
                titlestr{4}=['Amplitude: ' sprintf('%.2f',kinetics.amplitude) ' mV'];
                titlestr{5}=['Half Width: ' sprintf('%.2f',kinetics.halfwidth) ' ms'];
            end

            handles=geticlamp(handles.menu_kinsyn,handles);
            
            if handles.iclamp.revflag==1
                mystr = [num2str(handles.iclamp.revpot)  ' mV'];
            else
                mystr='auto';
            end
            
            if get(handles.chk_connpair,'Value')==1
                titlestr{6}=['Hold: ' num2str(handles.iclamp.holding) ' mV, reversal pot: ' mystr];
            else
                titlestr{6}=['Current: ' num2str(handles.iclamp.paircurrent) ' nA, reversal pot: ' mystr];
            end

            contents = cellstr(get(handles.menu_kinsyn,'String'));
            syn = contents{get(handles.menu_kinsyn,'Value')};

            contents = cellstr(get(handles.menu_numcon,'String'));
            con = contents{get(handles.menu_numcon,'Value')};

            contents = cellstr(get(handles.menu_cellnum,'String'));
            cellnum = contents{get(handles.menu_cellnum,'Value')};

            titlestr{7}=['cellnum: ' cellnum ' conmat: ' con ' synset: ' syn ' # ' num2str(m-2)];
            figure(h2(p))
            cla
            text(.5,.5,titlestr,'HorizontalAlignment','center','VerticalAlignment','middle','Interpreter','none')
            axis off
            
            %title(['pair: ' num2str(d(idx(n)).synapse)])
            %subplot(2,min(numsyns,z),nmod(n+min(numsyns,z)-1,min(numsyns,z))+min(numsyns,z)+1)
            newfig(3)=figure(h2(p));
            subplot(2,1,2)
            colorvec={'r','m','y','g','c','k','r','g','b','k'};
            stylevec={'-','-','-','-','-','-',':',':',':',':'};
            
            if get(handles.chk_connpair,'Value')==1
                ylabelstr = 'current (nA)';
            else
                ylabelstr = 'potential (mV)';
            end
            %if (m>3)
                for g=3:m
                    plot(tr.data(st:end,1),tr.data(st:end,g),'Color','c'); %colorvec{g-2},'LineStyle',stylevec{g-2}); %'c')
                    logplot(handles.directoryname,myresultsfolder,tr.data(st:end,1),tr.data(st:end,g)-tr.data(100,g),['Connection #' num2str(g-2)],titlestr{1},'Time (ms)',ylabelstr,'Pairs')
                    hold on
                end
            %end
            plot(tr.data(st:end,1),avgdata(st:end),'b','LineWidth',2)
            logplot(handles.directoryname,myresultsfolder,tr.data(st:end,1),avgdata(st:end)-avgdata(100),['Mean Trace'],titlestr{1},'Time (ms)',ylabelstr,'Pairs')
            %legend({'0','1','2','3','4','5','6','7','8','9','mean'})
            if get(handles.chk_connpair,'Value')==1
                ylabel('current (nA)')
            else
                ylabel('potential (mV)')

                yr = get(gca,'ylim');
                xr = get(gca,'xlim');
                hold on
                xhold = .9*(xr(2)-xr(1))+xr(1);
                yhold = .9*(yr(2)-yr(1))+yr(1);
                if abs(avgdata(kinetics.peak_idx)-avgdata(kinetics.change_idx))<=.25
                    plot([xhold xhold], [yhold yhold-.25],'k')
                elseif abs(avgdata(kinetics.peak_idx)-avgdata(kinetics.change_idx))<=.5
                    plot([xhold xhold], [yhold yhold-.5],'k')
                else
                    plot([xhold xhold], [yhold yhold-1],'k')
                end
                plot([xhold xhold-10], [yhold yhold],'k')

            end
            xlabel('time (ms)')
        %end

        pp=get(newfig(3),'PaperPosition');
        set(newfig(3),'PaperPosition',[pp(1) pp(2) pp(4)/2 pp(4)])
        print(newfig(3), '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(1)).precell '_' d(idx(1)).postcell '_' num2str(p) '.jpg'])
        saveas(newfig(3),[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl d(idx(1)).precell '_' d(idx(1)).postcell '_' num2str(p) '.fig'],'fig')
        p=p+1; 
    %end
end
assignin('base',['mystruct_' myresultsfolder],mystruct);
save('mysynresults.mat','mystruct','-v7.3')


save([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'synfigdata.mat'],'cellfigdata','-v7.3')
assignin('base',['synfigdata_' myresultsfolder],cellfigdata)

if 1==0
warning off MATLAB:xlswrite:AddSheet

%cellfigdata.fig.axis.data
worksheet=[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl  'synfigdata.xls'];
for z=1:length(cellfigdata.fig)
    for b=1:length(cellfigdata.fig(z).axis)
        sheetname=strrep(strrep([cellfigdata.fig(z).axis(b).name],':',' '),'.',' ');
        xlswrite(worksheet, {['Y-axis- ' cellfigdata.fig(z).axis(b).ylabel]}, sheetname, 'A1');

        m=1;
        if size(cellfigdata.fig(z).axis(b).data(m).x,2)>1
            cellfigdata.fig(z).axis(b).data(m).x=cellfigdata.fig(z).axis(b).data(m).x';
        end

        xlswrite(worksheet, {cellfigdata.fig(z).axis(b).xlabel}, sheetname, 'A3');
        xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(1).x), sheetname, 'A4');

        addme=0;
        for m=1:length(cellfigdata.fig(z).axis(b).data)
            if size(cellfigdata.fig(z).axis(b).data(m).x,2)>1
                cellfigdata.fig(z).axis(b).data(m).x=cellfigdata.fig(z).axis(b).data(m).x';
            end
            if size(cellfigdata.fig(z).axis(b).data(m).y,2)>1
                cellfigdata.fig(z).axis(b).data(m).y=cellfigdata.fig(z).axis(b).data(m).y';
            end
            if m>1 && (length(cellfigdata.fig(z).axis(b).data(m-1).x)~=length(cellfigdata.fig(z).axis(b).data(m).x) || sum(abs(cellfigdata.fig(z).axis(b).data(m).x-cellfigdata.fig(z).axis(b).data(m-1).x))>abs(.001*cellfigdata.fig(z).axis(b).data(1).x(1)))
                addme = addme + 1;
                Letter = char(m +'A'+addme);
                xlswrite(worksheet, {cellfigdata.fig(z).axis(b).xlabel}, sheetname, [Letter '3']);
                xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(m).x), sheetname, [Letter '4']);
                addme = addme + 1;
            end
            Letter = char(m +'A'+addme);
            xlswrite(worksheet, {cellfigdata.fig(z).axis(b).data(m).name}, sheetname, [Letter '3']);
            xlswrite(worksheet, num2cell(cellfigdata.fig(z).axis(b).data(m).y), sheetname, [Letter '4']);
        end
    end
end
system([handles.general.explorer ' ' handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl])
end

catch ME
    if isdeployed
        docerr(ME)
    else
        for r=1:length(ME.stack)
            disp(ME.stack(r).file);disp(ME.stack(r).name);disp(num2str(ME.stack(r).line))
        end
        throw(ME)
    end
end

function [y idx]=searchfield(d,field,val)

idx=[];

for r=1:length(d)
    if strcmp(d(r).(field),val)==1
        idx(length(idx)+1)=r;
    end
end
y=length(idx);

function txt_start_Callback(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_start as text
%        str2double(get(hObject,'String')) returns contents of txt_start as a double


% --- Executes during object creation, after setting all properties.
function txt_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_dur_Callback(hObject, eventdata, handles)
% hObject    handle to txt_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_dur as text
%        str2double(get(hObject,'String')) returns contents of txt_dur as a double


% --- Executes during object creation, after setting all properties.
function txt_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_after_Callback(hObject, eventdata, handles)
% hObject    handle to txt_after (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_after as text
%        str2double(get(hObject,'String')) returns contents of txt_after as a double


% --- Executes during object creation, after setting all properties.
function txt_after_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_after (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_current_Callback(hObject, eventdata, handles)
% hObject    handle to txt_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_current as text
%        str2double(get(hObject,'String')) returns contents of txt_current as a double


% --- Executes during object creation, after setting all properties.
function txt_current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_pre_Callback(hObject, eventdata, handles)
% hObject    handle to txt_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_pre as text
%        str2double(get(hObject,'String')) returns contents of txt_pre as a double


% --- Executes during object creation, after setting all properties.
function txt_pre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_post_Callback(hObject, eventdata, handles)
% hObject    handle to txt_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_post as text
%        str2double(get(hObject,'String')) returns contents of txt_post as a double


% --- Executes during object creation, after setting all properties.
function txt_post_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_actstart_Callback(hObject, eventdata, handles)
% hObject    handle to txt_actstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_actstart as text
%        str2double(get(hObject,'String')) returns contents of txt_actstart as a double


% --- Executes during object creation, after setting all properties.
function txt_actstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_actstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_actdur_Callback(hObject, eventdata, handles)
% hObject    handle to txt_actdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_actdur as text
%        str2double(get(hObject,'String')) returns contents of txt_actdur as a double


% --- Executes during object creation, after setting all properties.
function txt_actdur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_actdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_actafter_Callback(hObject, eventdata, handles)
% hObject    handle to txt_actafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_actafter as text
%        str2double(get(hObject,'String')) returns contents of txt_actafter as a double


% --- Executes during object creation, after setting all properties.
function txt_actafter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_actafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_actcurr_Callback(hObject, eventdata, handles)
% hObject    handle to txt_actcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_actcurr as text
%        str2double(get(hObject,'String')) returns contents of txt_actcurr as a double


% --- Executes during object creation, after setting all properties.
function txt_actcurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_actcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_instart_Callback(hObject, eventdata, handles)
% hObject    handle to txt_instart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_instart as text
%        str2double(get(hObject,'String')) returns contents of txt_instart as a double


% --- Executes during object creation, after setting all properties.
function txt_instart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_instart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_indur_Callback(hObject, eventdata, handles)
% hObject    handle to txt_indur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_indur as text
%        str2double(get(hObject,'String')) returns contents of txt_indur as a double


% --- Executes during object creation, after setting all properties.
function txt_indur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_indur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_inafter_Callback(hObject, eventdata, handles)
% hObject    handle to txt_inafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_inafter as text
%        str2double(get(hObject,'String')) returns contents of txt_inafter as a double


% --- Executes during object creation, after setting all properties.
function txt_inafter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_inafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_incurr_Callback(hObject, eventdata, handles)
% hObject    handle to txt_incurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_incurr as text
%        str2double(get(hObject,'String')) returns contents of txt_incurr as a double


% --- Executes during object creation, after setting all properties.
function txt_incurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_incurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_actstartcurr_Callback(hObject, eventdata, handles)
% hObject    handle to txt_actstartcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_actstartcurr as text
%        str2double(get(hObject,'String')) returns contents of txt_actstartcurr as a double


% --- Executes during object creation, after setting all properties.
function txt_actstartcurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_actstartcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_inaftercurr_Callback(hObject, eventdata, handles)
% hObject    handle to txt_inaftercurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_inaftercurr as text
%        str2double(get(hObject,'String')) returns contents of txt_inaftercurr as a double


% --- Executes during object creation, after setting all properties.
function txt_inaftercurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_inaftercurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rad_separate.
function rad_separate_Callback(hObject, eventdata, handles)
% hObject    handle to rad_separate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_separate


% --- Executes on button press in rad_combined.
function rad_combined_Callback(hObject, eventdata, handles)
% hObject    handle to rad_combined (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_combined



function txt_IVcurr_Callback(hObject, eventdata, handles)
% hObject    handle to txt_IVcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_IVcurr as text
%        str2double(get(hObject,'String')) returns contents of txt_IVcurr as a double


% --- Executes during object creation, after setting all properties.
function txt_IVcurr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_IVcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_pairstart_Callback(hObject, eventdata, handles)
% hObject    handle to txt_pairstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_pairstart as text
%        str2double(get(hObject,'String')) returns contents of txt_pairstart as a double


% --- Executes during object creation, after setting all properties.
function txt_pairstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_pairstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_pairend_Callback(hObject, eventdata, handles)
% hObject    handle to txt_pairend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_pairend as text
%        str2double(get(hObject,'String')) returns contents of txt_pairend as a double


% --- Executes during object creation, after setting all properties.
function txt_pairend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_pairend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in menu_kinsyn.
function menu_kinsyn_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_kinsyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_kinsyn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_kinsyn

contents = cellstr(get(hObject,'String'));
syn = contents{get(hObject,'Value')};

fid = fopen([handles.directoryname sl 'datasets' sl syn]);
numlines = textscan(fid,'%d\n',1);
c = textscan(fid,['%s %s %s %s %s %s %s %f %f %f %f %f %f %f %f %f\n']);
fclose(fid);

synstr{1}='All';
for r=1:length(c{1})
    synstr{r+1}=[c{2}{r} '->' c{1}{r}];
end

synstr = sort(unique(synstr));

set(handles.list_conn,'String',synstr);

% --- Executes during object creation, after setting all properties.
function menu_kinsyn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_kinsyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_numcon.
function menu_numcon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_numcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_numcon contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_numcon


% --- Executes during object creation, after setting all properties.
function menu_numcon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_numcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function plotmechdist(handles,myresultsfolder)
global mypath sl
mechstruct=[];
mydir = dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'celldata_*.dat']);
myEdir = dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl 'cellEdata_*.dat']);

load('myrepos.mat','myrepos')
q=getcurrepos;

celltypearray={};
chanarray={};
gmaxarray=[];
revarray=[];
locarray={};
descarray={};

for r=1:length(mydir)
    d = importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl mydir(r).name]);
    de = importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl myEdir(r).name]);
    celltype = mydir(r).name(10:end-4);
    
    header = d.textdata(1,2:end);
    cellsecname = d.textdata(2:end,1);
    
    for k=1:length(cellsecname)
        id = findstr(cellsecname{k},'.');
        secname{k} = cellsecname{k}(id+1:end);
        id = findstr(secname{k},'[');
        if ~isempty(id)
            basename{k} = secname{k}(1:id-1);
        else
            if strcmp(secname{k}(1:3),'ori')==1
                basename{k} = 'basal';
            elseif (strcmp(secname{k},'soma')==1 || strcmp(secname{k},'axon')==1)
                basename{k} = secname{k};
            else
                basename{k} = 'apical';
            end
        end
        
        secdata(k).secname = secname{k};
        secdata(k).basename = basename{k};

        for g = 1:length(header)
            secdata(k).(header{g}) = d.data(k,g);
        end
    end
    
    bases = unique({secdata(:).basename});
    
    for b=1:length(bases)
        id = strcmp(bases{b},{secdata(:).basename});
        
        minime = secdata(id);
        
        h = figure('Color','w','Name',[celltype ': ' bases{b}]);
        u = get(h,'Units');
        set(h,'Units','inches');
        pos = get(h,'Position');
        set(h,'Position',[pos(1) pos(2) 11 8.5])
        set(h,'Units',u);
        
        distvec = [minime.dist];       
        
        numplots=0;
        for x=4:length(header)
            yvec = [minime.(header{x})];
            zid=find(yvec~=0);
            yvec=yvec(zid);
            if ~isempty(yvec)
                numplots = numplots + 1;
            end
        end
            
        rows = 3;
        cols = ceil(numplots/rows);
        
        numplots = 0;
        for x=4:length(header)
            yvec = [minime.(header{x})];
            zid=find(yvec~=0);
            yvec=yvec(zid);
            xvec = distvec(zid);
            
            m = length(mechstruct)+1;
            mechstruct(m).xvec = xvec;
            mechstruct(m).yvec = yvec;
            mechstruct(m).type = header{x};
            mechstruct(m).sections = bases{b};
            
            if isempty(yvec)
                continue
            end
            numplots = numplots+1;
            
            try
            subplot(rows,cols,numplots)
            catch ME
                'test'
            end
            plot(xvec,yvec,'LineStyle','none','Marker','.','MarkerSize',10)
            xlabel('Dist from soma(0) (um)')
            ylabel(header{x},'Interpreter','none')
            yrange = get(gca,'ylim');
            yrange(1) = 0;
            set(gca,'ylim',yrange)
            while yrange(2)/max(yvec)>10
                set(gca,'ylim',yrange/10)
                yrange = get(gca,'ylim');
            end
            
            basestr=sprintf('%s,',bases{:});
            basestr=basestr(1:end-1);
            [r,desctmp]=system(['grep TITLE ' myrepos(q).dir sl header{x}(6:end) '.mod']);
            if r==0
                desc=strtrim(strrep(desctmp,'TITLE',''));
            else
                desc='no description';
            end

            if length(header{x})>8 && strcmp(header{x}(1:8),'gmax_ch_') && sum(yvec)>0
                deidx=strmatch(header{x}(6:end),de.textdata(1,2:end),'exact');
                n=length(gmaxarray)+1;
                celltypearray{n}=celltype;
                chanarray{n}=header{x}(9:end);
                gmaxarray(n)=max(yvec);
                revarray(n)=mean(de.data(:,deidx));
                locarray{n}=basestr;
                descarray{n}=desc;
            end
        end
        set(h,'PaperUnits','normalized','PaperPosition',[0 0 1 1], 'PaperOrientation','landscape')
        print(h,'-djpeg','-r300',[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl celltype '_' bases{b} '_mechs'])
    end
end
assignin('base','mechstruct',mechstruct);
fid = fopen([myrepos(q).dir sl 'cellclamp_results' sl 'website' sl 'channels.dat'],'w');
fprintf(fid,'%d\n',length(gmaxarray));
for n=1:length(gmaxarray)
    fprintf(fid,'%s\t%s\t%f\t%f\t%s\t"%s"\n',celltypearray{n}, chanarray{n}, gmaxarray(n), revarray(n), locarray{n}, strtrim(descarray{n}));
end
fclose(fid);

% --- Executes on button press in chk_cellmech.
function chk_cellmech_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cellmech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cellmech

function viewresults(iclamp,handles)
global mypath sl
handles.h = figure('Units','normalized');
ha=axes;

handles.st = max(round(iclamp.pairstart/2),1);

% get all trace names
handles.d=dir([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl '*.*.trace.dat']);

for k=1:length(handles.d)
    b=regexp(handles.d(k).name,'\.','split');
    handles.d(k).precell = b{1};
    handles.d(k).postcell = b{2};
    handles.d(k).synapse = b{3};
    handles.d(k).prebypost = [b{1} b{2}];
end

handles.prebypost = unique({handles.d(:).prebypost});

handles.i=1;
handles.hi = uicontrol('Parent',handles.h,'Style','edit','String',num2str(handles.i),'Units','normalized','Position',[0 .95 .05 .05]);
showfig(handles)
btnR = uicontrol('Parent',handles.h,'Style','pushbutton','String','>','Units','normalized','Position',[.5 .95 .05 .05],'Callback',{@btnR_Callback,handles});
btnL = uicontrol('Parent',handles.h,'Style','pushbutton','String','<','Units','normalized','Position',[.45 .95 .05 .05],'Callback',{@btnL_Callback,handles});

function btnR_Callback(src,eventdata,handles)
handles.i=str2num(get(handles.hi,'String'));
handles.i=min(handles.i+1,length(handles.prebypost));
set(handles.hi,'String',num2str(handles.i))

showfig(handles)

function btnL_Callback(src,eventdata,handles)
handles.i=str2num(get(handles.hi,'String'));
handles.i=max(handles.i-1,1);
set(handles.hi,'String',num2str(handles.i))
showfig(handles)

function showfig(handles)
global mypath sl
[numsyns idx]= searchfield(handles.d,'prebypost',handles.prebypost{handles.i});
set(handles.h,'Color','w','Name', [handles.d(idx(1)).precell ' -> ' handles.d(idx(1)).postcell]);

z=min(3,numsyns);  
p=1;

while numsyns>=1+(p-1)*z
    if p>1
        h2(p) = figure('Color','w','Name', [handles.d(idx(1)).precell ' -> ' handles.d(idx(1)).postcell]);
    end
    
    for n=1+(p-1)*z:min(numsyns,p*z)
        tr = importdata([handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl handles.d(idx(n)).name]);
        q=nmod(n,z);
        if q==0
            q=z;
        end
        subplot(2,z,q)
        %plot(tr.data(handles.st:end,1),tr.data(handles.st:end,2))
        %ylabel('voltage (mV)')
        %title(['sid: ' num2str(handles.d(idx(n)).synapse)])
        
        
        
before_idx = find(tr.data(:,1)>15,1,'first');
after_idx = length(tr.data);

[~, peak_idx] = max(abs(tr.data(before_idx:after_idx,3)));
peak_idx = peak_idx + before_idx - 1;

change_idx = find(abs(diff(tr.data(before_idx:end,3)))>.05*max(abs(diff(tr.data(before_idx:end,3)))),1,'first') + before_idx-1;

idxes = [change_idx peak_idx after_idx];

%figure;
% plot(tr.data(2:end,1),tr.data(2:end,3),'b')
% hold on
% 
% xl = get(gca,'xlim');
% yl = get(gca,'ylim');
% 
% stx = (xl(2)-xl(1))*.1+xl(1);
% sty = (yl(2)-yl(1))*.1+yl(1);
% 
% plot([stx stx+10],[sty sty],'k')
% plot([stx stx],[sty sty+.02],'k')


%plot(tr.data(idxes,1),tr.data(idxes,3),'r','LineStyle','none','Marker','.')

% 10 - 90 rise time
per10_val = .1*(tr.data(peak_idx,3) - tr.data(change_idx,3))+tr.data(change_idx,3);
per10_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(per10_val),1,'first')+before_idx-1;
%plot(tr.data(per10_idx,1),tr.data(per10_idx,3),'g','LineStyle','none','Marker','.')

per90_val = .9*(tr.data(peak_idx,3) - tr.data(change_idx,3))+tr.data(change_idx,3);
per90_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(per90_val),1,'first')+before_idx-1;
%plot(tr.data(per90_idx,1),tr.data(per90_idx,3),'g','LineStyle','none','Marker','.')
rt_10_90 = tr.data(per90_idx,1) - tr.data(per10_idx,1);

% width at half amplitude
per50_val = .5*(tr.data(peak_idx,3) - tr.data(change_idx,3))+tr.data(change_idx,3);
halfup_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(per50_val),1,'first')+before_idx-1;
halfdown_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(per50_val),1,'last')+before_idx-1;

%plot(tr.data(halfup_idx,1),tr.data(halfup_idx,3),'c','LineStyle','none','Marker','.')
%plot(tr.data(halfdown_idx,1),tr.data(halfdown_idx,3),'c','LineStyle','none','Marker','.')
halfwidth = tr.data(halfdown_idx,1) - tr.data(halfup_idx,1);

% rise time constant
erise_val = (1-1/exp(1))*(tr.data(peak_idx,3) - tr.data(change_idx,3))+tr.data(change_idx,3);
taurise_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(erise_val),1,'first')+before_idx-1;
%plot(tr.data(taurise_idx,1),tr.data(taurise_idx,3),'y','LineStyle','none','Marker','.')
taurise = tr.data(taurise_idx,1) - tr.data(change_idx,1);

% decay time constant
edecay_val = (1/exp(1))*(tr.data(peak_idx,3) - tr.data(after_idx,3))+tr.data(after_idx,3);
taudecay_idx = find(abs(tr.data(before_idx:after_idx,3))>=abs(edecay_val),1,'last')+before_idx-1;
%plot(tr.data(taudecay_idx,1),tr.data(taudecay_idx,3),'y','LineStyle','none','Marker','.')
taudecay = tr.data(taudecay_idx,1) - tr.data(peak_idx,1);


% display results

% voltage clamp
titlestr{1}=['10 - 90% rise time: ' sprintf('%.2f',rt_10_90) ' ms'];
titlestr{2}=['Amplitude: ' sprintf('%.2f',abs(tr.data(peak_idx,3)-tr.data(change_idx,3))*10^3) ' pA'];
titlestr{3}=['Decay tau: ' sprintf('%.2f',taudecay) ' ms'];

handles=geticlamp(handles.menu_kinsyn,handles);

if handles.iclamp.revflag==1
    mystr='used';
else
    mystr='didn''t use';
end

titlestr{4}=['Hold: ' num2str(handles.iclamp.holding) ' mV, reversal pot: ' num2str(handles.iclamp.revpot) ' mV (' mystr ')'];

contents = cellstr(get(handles.menu_kinsyn,'String'));
syn = contents{get(handles.menu_kinsyn,'Value')};

contents = cellstr(get(handles.menu_numcon,'String'));
con = contents{get(handles.menu_numcon,'Value')};


    contents = cellstr(get(handles.menu_cellnum,'String'));
    cellnum = contents{get(handles.menu_cellnum,'Value')};


titlestr{5}=['numcell: ' cellnum ' conmat: ' con ' synset: ' syn];
cla
text(.5,.5,titlestr,'HorizontalAlignment','center','VerticalAlignment','middle','Interpreter','none')
        
        
        
        
        
        subplot(2,z,q+z)
        plot(tr.data(handles.st:end,1),tr.data(handles.st:end,3))
        ylabel('current (nA)')
        xlabel('time (ms)')
    end

    pp=get(h2(p),'PaperPosition');
    set(h2(p),'PaperPosition',[pp(1) pp(2) pp(4)/2 pp(4)])
    print(h2(p), '-djpeg', [handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl handles.prebypost{handles.i} '.jpg'])
    saveas(h2(p),[handles.directoryname sl 'cellclamp_results' sl myresultsfolder sl handles.prebypost{handles.i} '.fig'],'fig') 
    p=p+1; 
end




function txt_rev_Callback(hObject, eventdata, handles)
% hObject    handle to txt_rev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_rev as text
%        str2double(get(hObject,'String')) returns contents of txt_rev as a double


% --- Executes during object creation, after setting all properties.
function txt_rev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_rev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_currpair.
function chk_currpair_Callback(hObject, eventdata, handles)
% hObject    handle to chk_currpair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_currpair
%set(handles.chk_connpair,'Value',0)
%set(handles.chk_currpair,'Value',1)


% --- Executes on selection change in menu_results.
function menu_results_Callback(hObject, eventdata, handles)
% hObject    handle to menu_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_results contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_results

contents=cellstr(get(handles.menu_results,'String'));
myname=contents{get(handles.menu_results,'Value')};
f = findstr(':', myname);
myresultsfolder=myname(1:f-1);

loadGUIvalues(handles,myresultsfolder)

% --- Executes during object creation, after setting all properties.
function menu_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_settings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_icsettings_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menuitem_icsettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'secondorder')
    handles.secondorder=2;
end
myvals=inputdlg({'Diameter (\mu m)','Ra (ohm*cm)','cm (uF/cm^2)','[Ca2+]_i (mM)','Celsius (^o)','Dt (ms)','secondorder (0,1,2)'},'Parameters for cell to insert channel in:',1,{num2str(handles.somadim),num2str(handles.Ra),num2str(handles.cm),num2str(handles.Ca),num2str(handles.celsius),num2str(handles.mydt),num2str(handles.secondorder)});

if ~isempty(myvals)
    handles.somadim = str2num(myvals{1});
    handles.Ra = str2num(myvals{2});
    handles.cm = str2num(myvals{3});
    handles.Ca = str2num(myvals{4});
    handles.celsius = str2num(myvals{5});
    handles.mydt = str2num(myvals{6});
    handles.secondorder = str2num(myvals{7});
    guidata(hObject, handles);

    somadim = handles.somadim;
    Ra = handles.Ra;
    cm = handles.cm;
    Ca = handles.Ca;
    celsius = handles.celsius;
    mydt = handles.mydt;
    secondorder = handles.secondorder;
    save([handles.directoryname sl 'setupfiles' sl 'clamp' sl 'blanksoma.mat'],'somadim', 'Ra', 'cm', 'Ca', 'celsius', 'mydt','secondorder','-v7.3')
end


% --- Executes on selection change in menu_cellnum.
function menu_cellnum_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_cellnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_cellnum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_cellnum


contents = cellstr(get(handles.menu_cellnum,'String'));
myfile = contents{get(handles.menu_cellnum,'Value')};

fid = fopen([handles.directoryname sl 'datasets' sl myfile],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

mycells = [{'All'}; filedata{1}];
handles.celltype = filedata{1};
handles.techtype = filedata{2};
guidata(hObject, handles);

set(handles.list_cell,'String',mycells);
set(handles.list_cell,'Value',1);



% --- Executes during object creation, after setting all properties.
function menu_cellnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_cellnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radio_auto.
function radio_auto_Callback(hObject, eventdata, handles)
% hObject    handle to radio_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_auto
set(handles.radio_auto,'Value',1)
set(handles.radio_set,'Value',0)


% --- Executes on button press in radio_set.
function radio_set_Callback(hObject, eventdata, handles)
% hObject    handle to radio_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_set
set(handles.radio_set,'Value',1)
set(handles.radio_auto,'Value',0)


% --------------------------------------------------------------------
function menuitem_exec_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_exec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% myvals=inputdlg({'Execution command'},'Execution Command:',1,{handles.excmdstr});
% 
% if ~isempty(myvals)
%     handles.excmdstr = myvals{1};
%     guidata(hObject, handles);
% 
%     excmdstr = handles.excmdstr;
%     directoryname = handles.directoryname;
%     save tools/excmdstr.mat excmdstr directoryname
% end


% --- Executes on button press in radio_cond.
function radio_cond_Callback(hObject, eventdata, handles)
% hObject    handle to radio_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_cond
set(handles.radio_cond,'Value',1)
set(handles.radio_curr,'Value',0)

% --- Executes on button press in radio_curr.
function radio_curr_Callback(hObject, eventdata, handles)
% hObject    handle to radio_curr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_curr
set(handles.radio_cond,'Value',0)
set(handles.radio_curr,'Value',1)


% --------------------------------------------------------------------
function menu_exp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_singlecell_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menuitem_singlecell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')==0
    msgbox('No single cell experimental data yet')
    return;
end


uiwait(evalin('base', 'PickExpSingleCells'))


if exist([mypath sl 'data' sl 'CompExpCells.mat'],'file')==0
    return;
end

load([mypath sl 'data' sl 'CompExpCells.mat'],'mytabledata')

contents = get(handles.list_cell,'String');

set(handles.chk_cellclamp,'Value',1);

resvec={};
nocompfl=0;
for nidx=1:size(mytabledata,1)
    if mytabledata{nidx,1}
        val = strmatch(mytabledata{nidx,2},contents);
        if isempty(val)
            nocompfl=nidx;
            continue
        end
        nocompfl=0;
        set(handles.list_cell,'Value', val)
        set(handles.txt_current,'String', ['[' mytabledata{nidx,4} ']./1000'])   
        cm = [mytabledata{nidx,2} ' compare ' mytabledata{nidx,3}];
        resvec{length(resvec)+1} = btn_run_Callback(handles.btn_run, [], handles,cm);
    end
end

if nocompfl
    set(handles.list_cell,'Value', val)
    set(handles.txt_current,'String', ['[' mytabledata{nidx,4} ']./1000'])   
    msgbox({['1+ types not found, including ''' mytabledata{nocompfl,2} '''.' ],'Setting single cell clamp parameters to ' mytabledata{nocompfl,2} ',','but you must select model cell and click Run button.'})
end


function old_expdata_singlecell()
[files, PATHNAME] = uigetfile({'*.atf;*.ATF','All Axo-Clamp Files: *.atf';'*','All Files'}, 'Select the Axo-Clamp data file(s)', myrepos(q).dir,'MultiSelect', 'on');

if length(files)==1 sum(files)==0
    return
end
hif=figure('Color','w');
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Max potential (mV)')
subplot(1,2,2)
hold on
xlabel('Current (pA)')
ylabel('Firing frequency (Hz)')

hhyp=figure('Color','w');
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Minimum potential (mV)')
subplot(1,2,2)
hold on
xlabel('Current (pA)')
ylabel('Steady state potential (mV)')

hhcn=figure('Color','w');
subplot(1,2,1)
hold on
xlabel('Current (pA)')
ylabel('Sag amplitude (mV)')
subplot(1,2,2)
hold on
xlabel('Current (pA)')
ylabel('Sag Timing (s)')

if iscell(files)
    getinput={'','',''};
    for r=1:length(files)
        filestr=files{r};
        mycelltypes(r)=inputdlg(['Celltype for file ' filestr]);
    end
    celltypes=unique(mycelltypes);
    for r=1:length(files)
        filestr=files{r};
        celltype=find(strcmp(mycelltypes{r},celltypes)==1);
        [tmpdata hif hhyp getinput]=readsinglecell([PATHNAME filestr],filestr,getinput,hif,hhyp,hhcn,r,celltype); % hif, hhyp, ci, li
        if isempty(tmpdata)
            close(hif)
            close(hhyp)
            close(hhcn)
            return
        end
        legstr{r}=filestr(1:end-3);
        expcells(r).name=filestr;
        expcells(r).celltype=celltypes{celltype};
        expcells(r).colheaders=tmpdata.colheaders;
        expcells(r).data=tmpdata.data;
        expcells(r).structured=tmpdata;
        expcells(r).textdata=tmpdata.textdata;
    end
else
    r=1;
    getinput={'','',''};
    [tmpdata hif hhyp getinput]=readsinglecell([PATHNAME files],files,getinput,hif,hhyp,hhcn,r,1); % hif, hhyp, ci, li
    legstr{r}=files(1:end-3);
    expcells(r).name=files;
    expcells(r).colheaders=tmpdata.colheaders;
    expcells(r).data=tmpdata.data;
    expcells(r).structured=tmpdata;
    expcells(r).textdata=tmpdata.textdata;
end

figure(hif)
legend(legstr,'Interpreter','none')


figure(hhyp)
legend(legstr,'Interpreter','none')

if isdeployed==0
    assignin('base','expcells',expcells)
end

if isempty(findstr(handles.directoryname,'/'))
    mysl='\';
else
    mysl='/';
end
if ~exist([handles.directoryname mysl 'cellclamp_results' mysl 'experimental'],'dir')
    system(['mkdir ' handles.directoryname mysl 'cellclamp_results' mysl 'experimental']);
end
save([handles.directoryname mysl 'cellclamp_results' mysl 'experimental' mysl 'expcells.mat'],'expcells','-v7.3'); % ,'-v7.3'
%save([PATHNAME 'expcells.mat'],'expcells'); % ,'-v7.3'

% msgbox : what was baseline current holding? Perhaps plot current
% differences. And what was RMP in cells with the baseline holding?

% --------------------------------------------------------------------
function menuitem_pair_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menuitem_pair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')==0
    msgbox('No paired recording experimental data yet')
    return;
end
uiwait(evalin('base', 'PairPicker'))


if exist([mypath sl 'data' sl 'CompPairs.mat'],'file')==0
    return;
end
load([mypath sl 'data' sl 'CompPairs.mat'],'mytabledata')

expsyns = expsyndata();

for n=1:size(mytabledata,1)
    if mytabledata{n,1}
        pr = mytabledata{n,2};
        po = mytabledata{n,3};
        t = mytabledata{n,6};
        newexpsyns.(pr).(po) = expsyns(t).(pr).(po);
    end
end

compexp(handles,newexpsyns)

% --------------------------------------------------------------------
function menuitem_mrf_Callback(hObject, eventdata, handles)
global mypath myhandles sl
% hObject    handle to menuitem_mrf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myhandles = handles;

if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')==0
    msgbox('No experimental data available to use in MRF.')
    return
end

evalin('base', 'MRF_gui')


% --------------------------------------------------------------------
function menuitem_morph_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_morph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% q=find([myrepos(:).current]==1);
% 
% [files, PATHNAME] = uigetfile({'*.asc;*.ASC','All Axo-Clamp Files: *.asc';'*','All Files'}, 'Select the morphology data file(s)', myrepos(q).dir,'MultiSelect', 'on');
% 
% if length(files)==1 sum(files)==0
%     return
% end

% instructions
% 1. Obtain a hierchical .asc format file from Neurolucida.
% 2. In NEURON, go to tools > Miscellaneous > Import 3D
% 3. Click the import button, choose the .asc file
% 4. Verifying that the cell looks correct, attend to any terminal messages
% that pop up
% 5. Click the Export button, choose CellBuilder
% 6. In the cell builder, click "continuous create"
% 7. In the cell builder, click the management tab, click .... 
% 8. Close NEURON
% 9. Restart NEURON, load the newly created hoc file
% 10. Run printnewcell3d.hoc   %print3dsynapses
% 11. Replace the existing position info in the new hoc file with the text output from printnewcell3d.hoc (in superdeep/transformationalmaterials)
% 12. Close NEURON
% 13. Restart NEURON, load in newly edited hoc file
% 15. Run printareas:  C:\Users\M\SkyDrive\Documents\Modeling\Csaba Project\printareas.hoc
% 16. Run: output from printareas
morphdata(1).name='somatic';morphdata(1).area=883.52;morphdata(1).length=16.77;morphdata(1).diam=16.77;morphdata(1).totalsections=1;
morphdata(2).name='dendritic';morphdata(2).area=10255.3;morphdata(2).length=4024.21;morphdata(2).diam=0.924337;morphdata(2).totalsections=42;
morphdata(3).name='axonic';morphdata(3).area=157.08;morphdata(3).length=100;morphdata(3).diam=0.5;morphdata(3).totalsections=1;
morphdata(4).name='total';morphdata(4).area=11295.9;morphdata(4).length=4140.98;morphdata(4).diam=1.27482;morphdata(4).totalsections=44;
for r=1:4
fprintf('%s\t%f\t%f\t%f\t%d\n', morphdata(r).name, morphdata(r).area, morphdata(r).length, morphdata(r).diam, morphdata(r).totalsections)
end
% 17. Run: ps2pdf('psfile','C:\Users\M\SkyDrive\Documents\Modeling\Csaba Project\mycellview.ps','pdffile','C:\Users\M\SkyDrive\Documents\Modeling\Csaba Project\mycellview.pdf')
% 18. MATLAB should somehow incorporate the image and table data into a
% report, perhaps a latex document or something?


% --- Executes on button press in chk_cellclampi.
function chk_cellclampi_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cellclampi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cellclampi


% --- Executes on button press in chk_customcurr.
function chk_customcurr_Callback(hObject, eventdata, handles)
% hObject    handle to chk_customcurr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_customcurr
