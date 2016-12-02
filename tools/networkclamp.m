function varargout = networkclamp(varargin)
% NETWORKCLAMP MATLAB code for networkclamp.fig
%      NETWORKCLAMP, by itself, creates a new NETWORKCLAMP or raises the existing
%      singleton*.
%
%      H = NETWORKCLAMP returns the handle to a new NETWORKCLAMP or the handle to
%      the existing singleton*.
%
%      NETWORKCLAMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NETWORKCLAMP.M with the given input arguments.
%
%      NETWORKCLAMP('Property','Value',...) creates a new NETWORKCLAMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before networkclamp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to networkclamp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help networkclamp

% Last Modified by GUIDE v2.5 25-Feb-2014 12:21:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @networkclamp_OpeningFcn, ...
                   'gui_OutputFcn',  @networkclamp_OutputFcn, ...
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


% Special graph options
%  - Anatomical position of cell in network
% Small multiples for lower-left corner info
% -cross correlograms
% Spikerasters
% List o syns



% --- Executes just before networkclamp is made visible.
function networkclamp_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath RunArray sl
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to networkclamp (see VARARGIN)

% Choose default command line output for networkclamp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

handles.general=general;
clear general

if handles.general.setenv==1
    w=strfind(handles.general.neuron,'bin');

    setenv('PYTHONHOME',handles.general.neuron(1:w-2));
    setenv('PYTHONPATH',[handles.general.neuron(1:w-2) sl 'lib']);
    setenv('N',handles.general.neuron(1:w-2));
    setenv('NEURONHOME',handles.general.neuron(1:w-2));
end

if ispc
    handles.dl = ' & ';
else %if isunix
    handles.dl = ';';
end

% Update handles structure
guidata(hObject, handles);

%idxa=searchRuns('ExecutionDate','',0,'~');
%idxb=searchRuns('PrintVoltage',1,1,'=');
idx=searchRuns('ExecutionDate','',0,'~');%intersect(idxa,idxb);
set(handles.menu_runname,'String',{RunArray(idx(end:-1:1)).RunName},'Value',1)
handles.curses=[];
handles.curses.ind = searchRuns('RunName',RunArray(idx(end)).RunName,0,'=');
guidata(hObject, handles);

%handles.curses=[];
%handles.curses.ind = length(RunArray);
%guidata(handles.btn_generate, handles);
if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end
guidata(handles.btn_generate, handles);

idx=searchRuns('RunName',RunArray(end).RunName,0,'=');

mycells={handles.curses.cells(:).name};
set(handles.menu_celltype,'String',mycells,'Value',1)
cellrez=20;
gids=[handles.curses.cells(get(handles.menu_celltype,'Value')).range_st:max(1,round(handles.curses.cells(get(handles.menu_celltype,'Value')).numcells/cellrez)):handles.curses.cells(get(handles.menu_celltype,'Value')).range_en];

if isempty(gids)
    return
end
gids=sort(gids);
numspikes=0;

for m=1:length(gids)
    numspikes = length(find(handles.curses.spikerast(:,2)==gids(m)));
    mygids{m}=[num2str(gids(m)) ' (' num2str(numspikes) ' spikes)'];
end
set(handles.menu_gid,'String',mygids,'Value',1)
menu_gid_Callback(handles.menu_gid, [], handles,RunArray(end).ConnData)

a=dir([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_*.dat']);
if ~isempty(a)
    conndatas={};
    for r=1:length(a)
        tk = regexp(a(r).name,'conndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>99
            conndatas{length(conndatas)+1}=tk{1}{:};
        end
    end
    conndatas = fliplr(conndatas);
    myConnData_idx = find(strcmp(conndatas, num2str(RunArray(idx).ConnData))==1);
    set(handles.menu_conndata,'String',conndatas,'Value',myConnData_idx)
end



% UIWAIT makes networkclamp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = networkclamp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in menu_rundesc.
function menu_rundesc_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rundesc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_rundesc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_rundesc


% --- Executes during object creation, after setting all properties.
function menu_rundesc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_rundesc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_execute.
function btn_execute_Callback(hObject, eventdata, handles, varargin) 
global mypath sl RunArray
% hObject    handle to btn_execute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% make files -----------
contents = cellstr(get(handles.menu_runname,'String'));
runname = contents{get(handles.menu_runname,'Value')};
idx=searchRuns('RunName',runname,0,'=');

contents = cellstr(get(handles.menu_celltype,'String'));
celltype = contents{get(handles.menu_celltype,'Value')};

contents = cellstr(get(handles.menu_gid,'String'));
gidstr = contents{get(handles.menu_gid,'Value')};
findspace = findstr(gidstr,' ');
gid = str2num(gidstr(1:findspace-1));

if exist([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl 'mydesc.mat'],'file')
    load([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl 'mydesc.mat'], 'mydesc')
end

% get results folder ---------
if isempty(varargin)
    mycomments=inputdlg(['Give a description to this dataset: ']);
else
    mycomments=varargin{1};
end

if isempty(mycomments)
    return;
end

if iscell(mycomments)
    mycomments = mycomments{:};
end

if isempty(mycomments)
    return
end


if exist('mydesc','var')==0 || isempty(mydesc) || length(mydesc)<1
     resultsfolder='00001';
     g=1;
else
    resultsfolder= sprintf('%05.0f',(str2num(mydesc(end).name)+1));
    g=length(mydesc)+1;
    %g=1;
end


runname = RunArray(idx).RunName;

handles.resultsfolder=resultsfolder;
handles.runname=runname;
if ispc
    system(['mkdir "' RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl resultsfolder '"'])
else
    system(['mkdir ' RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl resultsfolder])
end

mydesc(g).name=resultsfolder;
mydesc(g).desc=mycomments;
mydesc(g).run=runname;

myNumData=RunArray(idx).NumData;
myConnData=RunArray(idx).ConnData;
mySynData=RunArray(idx).SynData;
if ispc
    handles.dl='&';
else
    handles.dl=';';
end
% Update SynData if necessary
%updatecelltemplates(handles,myNumData,mySynData,RunArray(idx).ModelDirectory)

% pull weight either from the table or from the RunArray(idx).ConnData or
% from the desired ConnData
if isempty(varargin) && get(handles.rad_syngen,'Value')==1
    myweights=get(handles.tbl_synapses,'Data');
    for r=1:size(myweights,1)
        weights.(myweights{r,1}) = myweights{r,4};
    end
else
    %myConnData_idx = find(strcmp(conndatas, num2str(RunArray(idx).ConnData))==1);
    if ~isempty(varargin) && length(varargin)>1
        cellindOI = addtype2raster(handles.curses.cells,gid,2,1);

        myConnData = varargin{2};

        destfile=[RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'run.hoc'];
        [SUCCESS,MESSAGE,MESSAGEID] = copyfile([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl RunArray(idx).RunName '_run.hoc'],destfile);

        if SUCCESS==0
            [SUCCESS,MESSAGE,MESSAGEID] = copyfile([RunArray(idx).ModelDirectory sl 'jobscripts' sl RunArray(idx).RunName '_run.hoc'],destfile);
        end

        if SUCCESS==0
            msgbox(['Gonna try to use run ' RunArray(idx).RunName(1:end-3) ' instead.'])
            [SUCCESS,MESSAGE,MESSAGEID] = copyfile([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName(1:end-3) sl RunArray(idx).RunName(1:end-3) '_run.hoc'],destfile);
        end
        if SUCCESS==0
            return
        end
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
            elseif findstr(tline{i},'ConnData')>0
                str = tline{i}; %'{load_file("./ca1.hoc")}';
                expression = 'ConnData=([0-9]+)';
                replace = ['ConnData=' num2str(myConnData)];
                tline{i} = regexprep(str,expression,replace);
            elseif findstr(tline{i},'SynData')>0
                str = tline{i}; %'{load_file("./ca1.hoc")}';
                expression = 'SynData=([0-9]+)';
                replace = ['SynData=' num2str(mySynData)];
                tline{i} = regexprep(str,expression,replace);
            end
        end
        fclose(fid);


        fid = fopen(destfile,'w');
        for t=1:length(tline)-1
            fprintf(fid,'%s\n',tline{t});
        end
        fclose(fid);
        % Write a run receipt

        % call NEURON ---------
        % formulate system call
        if ispc
            handles.dl = '&';
        else
            handles.dl = ';';
        end
        if exist([RunArray(idx).ModelDirectory sl 'newnetclamp.hoc'],'file')==0
            msgbox('Sorry, Network Clamp is not yet compatible with this repository.')
            return;
        end
        cmdstr=['cd ' RunArray(idx).ModelDirectory ' ' handles.dl ' ' handles.general.neuron ' -c gidOI=' num2str(gid)  ' -c cellindOI=' num2str(cellindOI(2)) ' -c "strdef runname" -c runname="\"' runname '\""  -c "strdef origRunName" -c origRunName="\"' runname '\"" -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./networkclamp_results/' runname '/' resultsfolder '/run.hoc -c "quit()"'];
        %cmdstr=[handles.general.neuron ' -c spkflag=' num2str(spkflag) ' -c gidOI=' num2str(gid)  ' -c cellindOI=' num2str(cellindOI(2)) ' -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./setupfiles/clamp/netclamp.hoc'];
        % execute system call and display results
        disp(cmdstr);
        [~, results]=system(cmdstr);
        disp(results);
        
        voltage = importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'mytrace_' num2str(gid) '_soma.dat']);
        lfp = []; %importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl resultsfolder sl 'myvrec_' num2str(gid) '_soma.dat']);
        % read in spike raster for just that gid
        spikerast = importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'spikeraster.dat']);
        spiketrain = spikerast(spikerast(:,2)==gid,1);

        setcell(handles,voltage,lfp,spikerast(spikerast(:,2)==gid,1),mycomments);
        return;
    else
        conndatas = get(handles.menu_conndata,'String');
        myConnData = str2num(conndatas{get(handles.menu_conndata,'Value')});
    end
    
    % scan each line
    % if postcell is right type
    % update weights structure
    fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(myConnData) '.dat'],'r');                
    numlines = fscanf(fid,'%d\n',1) ;
    filedata = textscan(fid,'%s %s %f %f %f\n') ;
    fclose(fid);
    for r=1:length(filedata{1})
        if strcmp(filedata{2}{r},celltype)==1
            weights.(filedata{1}{r}) = filedata{3}(r); % 3: weight, 4: numconns, 5: numsyns per conn
        end
    end
end

cellindOI = addtype2raster(handles.curses.cells,gid,2,1);
mydesc(g).cellOI = cellindOI;
mydesc(g).gidOI = gid;

save([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl 'mydesc.mat'], 'mydesc','-v7.3')

if ~isempty(varargin)
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl '00001' sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];
elseif exist([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'], 'file')
    %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/cell_syns.dat']);
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];
else
    %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/connections.dat']);
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];
end
clear A B C
%cell_syns=cell_syns.data;

% handles.inputs = precell postcell synid precelltype;
celltypemapping={handles.curses.cells(:).name};
gidmapping = unique(handles.inputs(:,1));

fid0=fopen([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'gids2make.dat'],'w');
fprintf(fid0,'%d\n',sum(gidmapping~=gid));
mytype = addtype2raster(handles.curses.cells,gidmapping,2,1);
for g=1:length(gidmapping)
    if gidmapping(g)~=gid
        fprintf(fid0,'%d\t%d\n',mytype(g,1), mytype(g,2));
    end
end
fclose(fid0);

fid = fopen([RunArray(idx).ModelDirectory sl 'results' sl runname sl 'allsyns.dat'],'r'); %gohere
allsyns = textscan(fid,['%s %s %d %d\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

delay=3;
% make a list of the connections to make
fid1=fopen([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'conns2make.dat'],'w');
fprintf(fid1,'%d\n',size(handles.inputs,1));
for s=1:size(handles.inputs,1)           
    newgid=find(gidmapping==handles.inputs(s,1));
    precelltype = handles.inputs(s,4);

    pre_idx=strcmp(celltypemapping{precelltype+1},allsyns{2});
    post_idx=strcmp(celltypemapping{cellindOI(2)+1},allsyns{1});
    syn_idx=find(pre_idx==1 & post_idx==1);
    baselinesyn=double(allsyns{3}(syn_idx));
    synid = handles.inputs(s,3)-baselinesyn;
    weight = weights.(celltypemapping{precelltype+1});

    fprintf(fid1,'%d\t%d\t%d\t%d\t%f\t%d\n', handles.inputs(s,1), gid, precelltype, synid, weight, delay);
    %fprintf(fid1,'%d\t%d\t%d\t%f\t%d\n', newgid, precelltype, synid, weight, delay);
end
fclose(fid1);

if get(handles.rad_spktimegen,'Value')==0
    spkflag=1;
    % make spike time vectors
    fid2=fopen([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'spiketimes2use.dat'],'w');
    numspk = sum(ismember(handles.curses.spikerast(:,2),gidmapping(gidmapping~=gid)));
    fprintf(fid2,'%d\n',numspk);
    fullvec=[];
    for g=1:length(gidmapping) % as opposed to 1:length(gidmapping), gidmapping(g) g
        if gidmapping(g)~=gid
            spikevec = handles.curses.spikerast(handles.curses.spikerast(:,2)==gidmapping(g),1);
            fullvec = [fullvec; [spikevec gidmapping(g)*ones(size(spikevec))]];
        end
    end
    fullvec=sortrows(fullvec);
    for t=1:length(fullvec)
        fprintf(fid2,'%d\t%f\n', fullvec(t,2), fullvec(t,1));
    end
    fclose(fid2);
else
    spkflag=0;
    % write out parameters of artificial spike times
end

destfile=[RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'run.hoc'];
[SUCCESS,MESSAGE,MESSAGEID] = copyfile([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl RunArray(idx).RunName '_run.hoc'],destfile);

if SUCCESS==0
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName(1:end-3) sl RunArray(idx).RunName(1:end-3) '_run.hoc'],destfile);
end

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
    elseif findstr(tline{i},'ConnData')>0
        str = tline{i}; %'{load_file("./ca1.hoc")}';
        expression = 'ConnData=([0-9]+)';
        replace = ['ConnData=' num2str(myConnData)];
        tline{i} = regexprep(str,expression,replace);
    elseif findstr(tline{i},'SynData')>0
        str = tline{i}; %'{load_file("./ca1.hoc")}';
        expression = 'SynData=([0-9]+)';
        replace = ['SynData=' num2str(mySynData)];
        tline{i} = regexprep(str,expression,replace);
    end
end
fclose(fid);


fid = fopen(destfile,'w');
for t=1:length(tline)-1
    fprintf(fid,'%s\n',tline{t});
end
fclose(fid);
% Write a run receipt

% call NEURON ---------
% formulate system call
if ispc
    handles.dl = '&';
else
    handles.dl = ';';
end
cmdstr=['cd ' RunArray(idx).ModelDirectory ' ' handles.dl ' ' handles.general.neuron ' -c spkflag=' num2str(spkflag) ' -c gidOI=' num2str(gid)  ' -c cellindOI=' num2str(cellindOI(2)) ' -c "strdef runname" -c runname="\"' runname '\""  -c "strdef origRunName" -c origRunName="\"' runname '\"" -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./networkclamp_results/' runname '/' resultsfolder '/run.hoc -c "quit()"'];
%cmdstr=[handles.general.neuron ' -c spkflag=' num2str(spkflag) ' -c gidOI=' num2str(gid)  ' -c cellindOI=' num2str(cellindOI(2)) ' -c "strdef resultsfolder" -c resultsfolder="\"' resultsfolder '\"" ./setupfiles/clamp/netclamp.hoc'];
% execute system call and display results
disp(cmdstr);
[~, results]=system(cmdstr);
disp(results);

% read in results ----------------
% read in new voltage trace
voltage = importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'mytrace_' num2str(gid) '_soma.dat']);
lfp = []; %importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl resultsfolder sl 'myvrec_' num2str(gid) '_soma.dat']);
% read in spike raster for just that gid
spikerast = importdata([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl runname sl resultsfolder sl 'spikeraster.dat']);
spiketrain = spikerast(spikerast(:,2)==gid,1);

% plot results ----------------
% add a column to the results table
% mynewnames=get(handles.tbl_netclampstats,'ColumnName');
% mynewdata=get(handles.tbl_netclampstats,'Data');
% set(handles.tbl_netclampstats,'Data',mynewdata,'ColumnName',mynewnames)


% Add a column to the table
%     b =  b.data(:,1),b.data(:,2)
%     
%     networkclamp_results/%s/spikeraster.dat
%     myspikes =  %1: time, 2: gid, 3: type

setcell(handles,voltage,lfp,spikerast(spikerast(:,2)==gid,1),mycomments);


% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in menu_runname.
function menu_runname_Callback(hObject, eventdata, handles)
global mypath RunArray sl
% hObject    handle to menu_runname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_runname contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_runname

contents = cellstr(get(handles.menu_runname,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_runname,'Value')},0,'=');
handles.curses=[];
handles.curses.ind = idx;
guidata(handles.btn_generate, handles);
if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end
guidata(handles.btn_generate, handles);

conndatas = get(handles.menu_conndata,'String');
myConnData_idx = find(strcmp(conndatas, num2str(RunArray(idx).ConnData))==1);
set(handles.menu_conndata,'String',conndatas,'Value',myConnData_idx)

mycells={handles.curses.cells(:).name};
set(handles.menu_celltype,'String',mycells,'Value',1)
cellrez=20;
gids=[handles.curses.cells(get(handles.menu_celltype,'Value')).range_st:max(1,round(handles.curses.cells(get(handles.menu_celltype,'Value')).numcells/cellrez)):handles.curses.cells(get(handles.menu_celltype,'Value')).range_en];

gids=sort(gids);
numspikes=0;
if isempty(gids)
    return
end

for g=1:length(gids);
    numspikes = length(find(handles.curses.spikerast(:,2)==gids(g)));
    mygids{g}=[num2str(gids(g)) ' (' num2str(numspikes) ' spikes)'];
end
set(handles.menu_gid,'String',mygids,'Value',1)
menu_gid_Callback(handles.menu_gid, [], handles, RunArray(idx).ConnData)

% --- Executes during object creation, after setting all properties.
function menu_runname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_runname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in menu_celltype.
function menu_celltype_Callback(hObject, eventdata, handles)
global mypath RunArray sl
% hObject    handle to menu_celltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_celltype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_celltype


contents = cellstr(get(handles.menu_runname,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_runname,'Value')},0,'=');

%mycells={handles.curses.cells(:).name};
%set(handles.menu_celltype,'String',mycells,'Value',1)
cellrez=20;
gids=[handles.curses.cells(get(handles.menu_celltype,'Value')).range_st:max(1,round(handles.curses.cells(get(handles.menu_celltype,'Value')).numcells/cellrez)):handles.curses.cells(get(handles.menu_celltype,'Value')).range_en];

gids=sort(gids);
numspikes=0;

if isempty(gids)
    return
end

for g=1:length(gids);
    numspikes = length(find(handles.curses.spikerast(:,2)==gids(g)));
    mygids{g}=[num2str(gids(g)) ' (' num2str(numspikes) ' spikes)'];
end
set(handles.menu_gid,'String',mygids,'Value',1)
menu_gid_Callback(handles.menu_gid, [], handles,RunArray(idx).ConnData)


% --- Executes during object creation, after setting all properties.
function menu_celltype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_celltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_gid.
function menu_gid_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to menu_gid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_gid contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_gid

set(handles.tbl_netclampstats,'Data',{});
set(handles.tbl_netclampstats,'ColumnName',{'Default'});

if isempty(varargin)
    btn_execute_Callback(handles.btn_execute, [], handles, '00001')
else
    btn_execute_Callback(handles.btn_execute, [], handles, '00001',varargin{1})
end

%setcell(handles);

% --- Executes during object creation, after setting all properties.
function menu_gid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_gid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setcell(handles,varargin)
global mypath RunArray sl

contents = cellstr(get(handles.menu_runname,'String'));
idx=searchRuns('RunName',contents{get(handles.menu_runname,'Value')},0,'=');

contents = cellstr(get(handles.menu_celltype,'String'));
celltype=contents{get(handles.menu_celltype,'Value')};

contents = cellstr(get(handles.menu_gid,'String'));
gidstr=contents{get(handles.menu_gid,'Value')};
findspace=findstr(gidstr,' ');
gid=str2num(gidstr(1:findspace-1));
gidstr={num2str(gid)};

%%%%%%%%%%%%%%
% Get Run Info

handles.curses=[];
handles.curses.ind = idx;
guidata(handles.btn_generate, handles);

if isfield(handles.curses,'spikerast')==0
    spikeraster(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if size(handles.curses.spikerast,2)<3
    handles.curses.spikerast = addtype2raster(handles.curses.cells,handles.curses.spikerast,3);
    guidata(handles.btn_generate, handles)
end
if isfield(handles.curses,'position')==0
    getposition(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end


mydata = get(handles.tbl_netclampstats,'Data');
mycols = get(handles.tbl_netclampstats,'ColumnName');

x = size(mydata,2)+1;
if x==1
    mycols={'Default'};
else
    if x==2 && ischar(mycols)
        mycols={'Default'}
    end
    mycols{length(mycols)+1} = ['#' num2str(x-1)];
end

if x==1
    %%%%%%%%%%%%%%
    % Get conn and spike info for connections onto cell
%     if exist([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'], 'file')
%         %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/cell_syns.dat']);
%         [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'cell_syns.dat'],'%d\t%d\t%d\n','headerlines',1);
%         cell_syns=[A B C];
%     else
%         %cell_syns = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/connections.dat']);
%         [A B C]=textread([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
%         cell_syns=[A B C];
%     end

    if exist([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl '00001' sl 'connections.dat'],'file')==0
        return;
    end
    [A B C]=textread([RunArray(idx).ModelDirectory sl 'networkclamp_results' sl RunArray(idx).RunName sl '00001' sl 'connections.dat'],'%d\t%d\t%d\n','headerlines',1);
    cell_syns=[A B C];

    clear A B C
    %cell_syns=cell_syns.data;

    inputs = cell_syns(cell_syns(:,2)==gid,:);
    handles.inputs = addtype2raster(handles.curses.cells,inputs,4,1);
    guidata(handles.btn_generate, handles);

    if isempty(inputs)
        return
    end
    %inputs = unique(inputs, 'rows');

    if isempty(handles.curses.spikerast)
        spiketrain=[];
    else
        spike_idx = ismember(handles.curses.spikerast(:,2),inputs(:,1));
        spiketrain = handles.curses.spikerast(spike_idx,:);
    end

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

    %%%%%%%%%%%%%%

    handles.prop = {'postcell','precell','weight','conns','syns'}; %, 'strength', 'numcons'};
    fid = fopen([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(idx).ConnData) '.dat']);
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

    handles.prop = {'precell','seclist','range_st','range_en','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'}; %, 'strength', 'numcons'};
    mysl=findstr(RunArray(idx).ModelDirectory,'/');
    if isempty(mysl)
        mysl='\';
    else
        mysl='/';
    end

    fid = fopen([RunArray(idx).ModelDirectory mysl 'datasets' mysl 'syndata_' num2str(RunArray(idx).SynData) '.dat']);
    numlines = textscan(fid,'%d\n',1);
    propstr=' %f %f %f %f %f %f %f %f %f';
    c = textscan(fid,['%s %s %s %s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
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
    %allsyns = importdata([RunArray(idx).ModelDirectory sl 'cells' sl 'allsyns.dat']);
    allsyns = importdata([RunArray(idx).ModelDirectory sl 'results' sl  RunArray(idx).RunName sl 'allsyns.dat']);

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
    %corrdeadline=20000;
    %corrtrain = spiketrain(spiketrain(:,1)<corrdeadline,:);
    %postcellspks = handles.curses.spikerast(handles.curses.spikerast(handles.curses.spikerast(:,1)<corrdeadline,2)==gid,1);

    %if length(postcellspks)>1
    %    postcellspks = [postcellspks(1); postcellspks((postcellspks(2:end)-postcellspks(1:end-1))>5.5)]; % only take the first PVBC spike in each burst
    %end

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
        N=histc(spiketrain(spike_idx,1)+axcondelay,[0:RunArray(idx).SimDuration]);
        hbar=bar([0:RunArray(idx).SimDuration],N);
        set(hbar,'EdgeColor',col)
        set(hbar,'FaceColor',col)
        %if r==1
        %    xlabel('Time (ms)')
        %else
            set(h1(r),'XTickLabel',{})
            set(h1(r),'YTickLabel',{})
        %end
        yy=get(gca,'YLim');
        ylabel([pre(1:end-4) ':' num2str(yy(2))],'rot',0,'HorizontalAlignment','right','VerticalAlignment','Baseline')
        xlim([0 RunArray(idx).SimDuration])

        %h2(r) = axes('Position',get(h1(r),'Position'),'YAxisLocation','right','Color','none','YTickLabel',{},'XTickLabel',{});
        %hl1 = line(b.data(:,1),b.data(:,2),'Color','k','Parent',h2(r));

        %spkpre = corrtrain(corr_idx,1)+3;

    end

    % plot voltage trace
    z=handles.panel_traces; %figure('Color','w','Name',[RunArray(idx).RunName ': ' post ' Inputs by Type']);
    handles.mytrace = subplot('Position',[0.1 0.13 .9 .82],'Parent',z);
    hold off
    b=importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'trace_' celltype gidstr{:} '.dat']);
    plot(b.data(:,1),b.data(:,2),'Color','k');
    axes(handles.mytrace);
    [LEGH,OBJH,OUTH,OUTM] = legend('Default','Location',[0 0 .03 1]);
    handles.LEGH = LEGH;
    handles.OBJH = OBJH;
    handles.OUTH = OUTH;
    handles.OUTM = OUTM;
    guidata(handles.btn_generate, handles);
        %handles = guidata(handles.btn_execute);

    % populate synapse table

    mycells = importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'celltype.dat']);

    for n=1:size(mycells.data,1)
        cellidx = find(inputs(:,1)>=mycells.data(n,2) & inputs(:,1)<=mycells.data(n,3)); % source target synapse
        %cellidx = find(spiking_inputs(:,1)>=mycells.data(n,2) & spiking_inputs(:,1)<=mycells.data(n,3)); % source target synapse
        spkidx = find(spiketrain(:,2)>=mycells.data(n,2) & spiketrain(:,2)<=mycells.data(n,3)); % source target synapse
        precell = mycells.textdata{1+n, 1};
        cellmat{n,1} = precell; % # precells of this type
        cellmat{n,2} = length(cellidx); % # precells of this type
        cellmat{n,3} = length(spkidx);
        if isfield(handles.conndata, post) && isfield(handles.conndata.(post), precell)
        cellmat{n,4} = handles.conndata.(post).(precell).weight;
        cellmat{n,5} = length(inputs(cellidx,1))/handles.conndata.(post).(precell).syns;
        cellmat{n,6} = length(unique(inputs(cellidx,1)));
        %cellmat{n,5} = length(unique(spiking_inputs(cellidx,1)));
        cellmat{n,7} = handles.conndata.(post).(precell).syns;
        else
            for g=4:7
                cellmat{n,g} = 0;
            end
        end
        %cellmat{n,4} = length(cellidx)*?; % # presyns of this type
        %cellmat{n,5} = mysyns.(celltype).(mycells.textdata{1+n, 1}).synstart;
        %cellmat{n,6} = mysyns.(celltype).(mycells.textdata{1+n, 1}).synend;
        if n==1
            %back when there was only one pp synapsing onto a given cell, this
            %made sense to display:
            %disp([mycells.textdata{1+n, 1} ' gid: ' num2str(inputs(cellidx,1))])
        end
    end
    set(handles.tbl_synapses, 'Data', cellmat, 'ColumnEditable', true([1 length(get(handles.tbl_synapses,'ColumnName'))]), 'ColumnName', {'     Cell Type     ','# syns','# spikes x syns','  Weight (uS)  ','# conns','unique cells','#syns/conn'},'ColumnFormat',{'char','numeric','numeric','short e','numeric','numeric'}); %,'UIContextMenu',mycontextmenuz);
end
handles.OUTM=1;

g=length(handles.OUTM)-1;
colorvec={'g','b','m','c','r'};
patvec={'-','--',':'};

mycol=mod(g,length(colorvec))+1;
mypat=floor(g/length(colorvec))+1;

mystyle = [colorvec{mycol} patvec{mypat}];

% set cell characteristics
if isempty(varargin)
    myspikes=handles.curses.spikerast(handles.curses.spikerast(:,2)==gid,1);
    lfp=[];
else
    b = varargin{1}; % b.data(:,1),b.data(:,2)
    lfp = varargin{2};
    myspikes=varargin{3}; %1: time, 2: gid, 3: type
    
    % add a line to the voltage trace plot and update the legend
    axes(handles.mytrace)
    hold on

    %hdbl=plotyy(b.data(:,1),b.data(:,2),lfp.data(:,1),lfp.data(:,2));
    hdbl=plot(b.data(:,1),b.data(:,2),mystyle); %,'LineWidth',2);
    %hdbl=plot(b.data(:,1),b.data(:,2),'g'); %,'LineWidth',2);

    htmp = get(hdbl(1),'Children');
%     lfplines = get(hdbl(2),'Children');
%     if length(lfplines)>1
%         try
%         delete(lfplines(2:end))
%         end
%         lfplines = lfplines(1);
%     end
    hnew = hdbl; %htmp(1);

%     try
%     set(hnew,'Color',varargin{4});
%     catch
%     set(hnew,'Color','g');
%     end
%     
%     set(get(hdbl(2),'Children'),'Color',[.5 .5 .5],'LineWidth',2);
    handles.OUTH = [handles.OUTH hnew];
    if length(varargin)>3
        handles.OUTM = [handles.OUTM ['#' num2str(x-1) ': ' varargin{4}]];
    else
        handles.OUTM = [handles.OUTM ['#' num2str(x-1)]];
    end
    guidata(handles.btn_execute, handles)
    % Add object with new handle and new legend string to legend
    legend(handles.OUTH,handles.OUTM,'Location','NorthWest') %[0 0 .03 1])
    
end

myi=1;

myrows{myi}='Spikes';
mydata{myi,x} = length(myspikes);
myi=myi+1;

myrows{myi}='Hz';
mydata{myi,x} = sprintf('%.2f', length(myspikes)/RunArray(idx).SimDuration*1000);
myi=myi+1;

myrows{myi}='ISI mean';
mydata{myi,x} = sprintf('%.2f', mean(diff(myspikes)));
myi=myi+1;

myrows{myi}='ISI std';
mydata{myi,x} = sprintf('%.2f', std(diff(myspikes)));
myi=myi+1;


%Sp. FFT stuff
rez=1; % .1 is simulation resolution

Fs = 1000/rez; % sampling frequency (per s)

bins=[0:rez:RunArray(idx).SimDuration];
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


myrows{myi}='FFT Hz';
mydata{myi,x} = sprintf('%.2f', f(rel_range(over_idx)));
myi=myi+1;

myrows{myi}='FFT pow';
mydata{myi,x} = sprintf('%.2f', fft_results(rel_range(over_idx)));
myi=myi+1;

myrows{myi}='th. Hz';
mydata{myi,x} = sprintf('%.2f', f(theta_range(peak_idx)));
myi=myi+1;

myrows{myi}='th. pow';
mydata{myi,x} = sprintf('%.2f', fft_results(theta_range(peak_idx)));
myi=myi+1;

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

myrows{myi}='MP FFT Hz';
mydata{myi,x} = sprintf('%.2f', f(rel_range(over_idx)));
myi=myi+1;

myrows{myi}='MP FFT pow';
mydata{myi,x} = sprintf('%.2f', fft_results(rel_range(over_idx)));
myi=myi+1;

myrows{myi}='MP th. Hz';
mydata{myi,x} = sprintf('%.2f', f(theta_range(peak_idx)));
myi=myi+1;

myrows{myi}='MP th. pow';
mydata{myi,x} = sprintf('%.2f', fft_results(theta_range(peak_idx)));
myi=myi+1;

%%%%%%%%%%%%%%
% get pyramidal angle
pyrangle = 20/180*pi; % will eventually want to read this in
thetaper = 1000/7.3; % will eventually want to read this in
spiketimes = myspikes;
%%%%%%%%%%%%%%
    n=length(spiketimes);
    modspiketimes = mod(spiketimes, thetaper);

    xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

    magnitude=sqrt(xbar^2+ybar^2);
    if xbar>0
        angle = acos(ybar/magnitude);
    else
        angle = 2*pi - acos(ybar/magnitude);
    end

    rdir = angle; % * pi/180;

if isdeployed
    usepyrspikes=0;
else
    myvers=ver;
    g=strcmp({myvers(:).Name},'Signal Processing Toolbox');
    if sum(g)>0
        usepyrspikes=0;
    else
        usepyrspikes=1;
    end
end
%usepyrspikes=1;
if usepyrspikes
    refangle=20/180*pi;
    pyrangle_shift=pyrangle-refangle;
    disp('Set the pyramidal cell angle to the reference angle of 20^o')
else % use pyramidal intracellular peaks
    refangle=0;
    %pyrangle=getpyramidalphase(handles,[myHz myHz],0);
    try
    pyrangle=getpyramidalphase(handles,[4 12],0);
    catch
        pyrangle=0;
    end
    pyrangle_shift=pyrangle-refangle;
end

rdir = rdir-pyrangle_shift;
phase_pref = rdir*180/pi;
if x>1
    phase_diff = phase_pref - str2num(mydata{myi,1});
else
    phase_diff = 0;
end
%%%%%%%%%%%%%%


myrows{myi}='Phase Pref';
mydata{myi,x} = sprintf('%.0f', phase_pref);
myi=myi+1;

myrows{myi}='Phase Shift';
mydata{myi,x} = sprintf('%+.0f', phase_diff);
myi=myi+1;

set(handles.tbl_netclampstats,'Data',mydata,'ColumnName',mycols,'RowName',myrows,'ColumnWidth',{40},'ColumnFormat',{'numeric'});


% --- Executes on button press in rad_syndefault.
function rad_syndefault_Callback(hObject, eventdata, handles)
global mypath RunArray sl
% hObject    handle to rad_syndefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_syndefault
set(handles.rad_syndefault,'Value',1);
set(handles.rad_syngen,'Value',0);


contents = get(handles.menu_runname,'String');
RunName = contents{get(handles.menu_runname,'Value')};
idx=searchRuns('RunName',RunArray(end).RunName,0,'=');

a=dir([RunArray(idx).ModelDirectory sl 'datasets' sl 'conndata_*.dat']);
if ~isempty(a)
    conndatas={};
    for r=1:length(a)
        tk = regexp(a(r).name,'conndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>99
            conndatas{length(conndatas)+1}=tk{1}{:};
        end
    end
    conndatas = fliplr(conndatas);
    myConnData_idx = find(strcmp(conndatas, num2str(RunArray(idx).ConnData))==1);
    set(handles.menu_conndata,'String',conndatas,'Value',myConnData_idx)
end

% --- Executes on button press in rad_syngen.
function rad_syngen_Callback(hObject, eventdata, handles)
% hObject    handle to rad_syngen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_syngen
set(handles.rad_syngen,'Value',1);
set(handles.rad_syndefault,'Value',0);


% --- Executes on button press in rad_spktimedefault.
function rad_spktimedefault_Callback(hObject, eventdata, handles)
% hObject    handle to rad_spktimedefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_spktimedefault


% --- Executes on button press in rad_spktimegen.
function rad_spktimegen_Callback(hObject, eventdata, handles)
% hObject    handle to rad_spktimegen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad_spktimegen


% --- Executes on selection change in menu_spktime.
function menu_spktime_Callback(hObject, eventdata, handles)
% hObject    handle to menu_spktime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_spktime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_spktime


% --- Executes during object creation, after setting all properties.
function menu_spktime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_spktime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in menu_conndata.
function menu_conndata_Callback(hObject, eventdata, handles)
% hObject    handle to menu_conndata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conndata contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conndata


% --- Executes during object creation, after setting all properties.
function menu_conndata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_conndata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
