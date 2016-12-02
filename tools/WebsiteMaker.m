function varargout = WebsiteMaker(varargin)
% WEBSITEMAKER MATLAB code for WebsiteMaker.fig
%      WEBSITEMAKER, by itself, creates a new WEBSITEMAKER or raises the existing
%      singleton*.
%
%      H = WEBSITEMAKER returns the handle to a new WEBSITEMAKER or the handle to
%      the existing singleton*.
%
%      WEBSITEMAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEBSITEMAKER.M with the given input arguments.
%
%      WEBSITEMAKER('Property','Value',...) creates a new WEBSITEMAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WebsiteMaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WebsiteMaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WebsiteMaker

% Last Modified by GUIDE v2.5 12-Oct-2016 10:02:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WebsiteMaker_OpeningFcn, ...
                   'gui_OutputFcn',  @WebsiteMaker_OutputFcn, ...
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


% --- Executes just before WebsiteMaker is made visible.
function WebsiteMaker_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl RunArray
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WebsiteMaker (see VARARGIN)

% Choose default command line output for WebsiteMaker
handles.output = hObject;


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(websitepath,'dir')==0
    mkdir(websitepath)
end

set(handles.txt_path,'String',websitepath,'Style','edit');

set(handles.btn_directory,'Visible','Off')

if ispc
    handles.dl='&';
else
    handles.dl=';';
end

if ~exist([myrepos(q).dir sl 'results' sl 'RunArrayData.mat'],'file')
    return
end

load([myrepos(q).dir sl 'results' sl 'RunArrayData.mat']);

idx=searchRuns('ExecutionDate','',0,'~');

for k=1:length(idx)
    mylist{length(idx)-k+1} = [RunArray(idx(k)).RunName '/' num2str(RunArray(idx(k)).NumData) '/' num2str(RunArray(idx(k)).ConnData) '/' num2str(RunArray(idx(k)).SynData) '/' RunArray(idx(k)).RunComments ];
end

set(handles.list_runs,'String',mylist)
set(handles.menu_baseline,'String',mylist)


if exist([myrepos(q).dir sl 'cellclamp_results' sl 'mydesc.mat'],'file')
load([myrepos(q).dir sl 'cellclamp_results' sl 'mydesc.mat'], 'mydesc')
else
    mydesc=[];
end

mycelllist={};
mysynlist={};
mychlist={};
gidx=1;
ppidx=1;
chidx=1;
for g=1:length(mydesc)
    if exist([myrepos(q).dir sl 'cellclamp_results' sl mydesc(g).name sl 'GUIvalues.mat'],'file')
        load([myrepos(q).dir sl 'cellclamp_results' sl mydesc(g).name sl 'GUIvalues.mat'],'GUIvalues');
        %if (GUIvalues.chk_cellclamp.value==1)
        %    mycelllist{gidx}=[mydesc(g).name ': ' mydesc(g).desc '/' GUIvalues.menu_cellnum(1).value{GUIvalues.menu_cellnum(2).value}(end-6:end-4)];
        %    gidx = gidx + 1;
        %end
        
        if (GUIvalues.chk_connpair.value==1 || GUIvalues.chk_currpair.value==1) % right now not set up to do current clamp, which would be GUIvalues.chk_currpair.value==1 || 
            mysynlist{ppidx}=[mydesc(g).name ': ' mydesc(g).desc '/' GUIvalues.menu_numcon(1).value{GUIvalues.menu_numcon(2).value}(end-6:end-4) '/' GUIvalues.menu_kinsyn(1).value{GUIvalues.menu_kinsyn(2).value}(end-6:end-4)];
            ppidx = ppidx + 1;
        end
        
        if (GUIvalues.chk_mechIV.value==1 || GUIvalues.chk_mechact.value==1)
            mychlist{chidx}=[mydesc(g).name ': ' mydesc(g).desc];
            chidx = chidx + 1;
        end       
    end
end

set(handles.list_esyns,'String',mysynlist(end:-1:1))
set(handles.list_psyns,'String',mysynlist(end:-1:1))
set(handles.list_chans,'String',mychlist(end:-1:1))

if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')
load([mypath sl 'data' sl 'AllCellsData.mat']);
else
    AllCells=[];
end
cidx=1;
for c=1:length(AllCells)
    if strcmp(AllCells(c).Experimenter,'Model')==1
        if isempty(AllCells(c).Notes)
            mycelllist{cidx} = AllCells(c).CellName;
        else
            mycelllist{cidx} = [AllCells(c).CellName ': ' AllCells(c).Notes];
        end
        cidx = cidx + 1;
    end
end


set(handles.list_cells,'String',mycelllist(end:-1:1))

if exist([myrepos(q).dir sl 'results' sl 'repotype.mat'])
    load([myrepos(q).dir sl 'results' sl 'repotype.mat'],'repotype')
    set(handles.edit_publication,'String',repotype.publication);
    set(handles.edit_url,'String',repotype.publink);
    set(handles.edit_funding,'String',repotype.funding);
    set(handles.edit_author,'String',repotype.author);
    set(handles.edit_authorlink,'String',repotype.authorlink);
    set(handles.edit_lab,'String',repotype.lab);
    set(handles.edit_lablink,'String',repotype.lablink);
else
    switch myrepos(q).name
        case 'ca1'
        set(handles.edit_publication,'String','Bezaire MJ, Soltesz I. 2013. Quantitative Assessment of CA1 Local Circuits: Knowledge Base for Interneuron-Pyramidal Cell Connectivity. Hippocampus: 23(9), 751-785');
        set(handles.edit_url,'String','http://onlinelibrary.wiley.com/doi/10.1002/hipo.22141/full');
        case 'entocort'
        set(handles.edit_publication,'String','Bezaire.... Hasselmo, In Preparation');
        set(handles.edit_url,'String','http://www.cell.com/neuron/abstract/S0896-6273%2814%2900336-5');
        otherwise
    % else
    %     repotype.publication = 'Lee S, Marchionni I, Bezaire MJ, Varga C, Danielson N, Lovett-Barron M, Losonczy A, Soltesz I. GABAergic Basket Cells Differentiate Among Hippocampal Pyramidal Cells. Neuron: Volume 82, Issue 5, 1129-1144, 2014';
    %     repotype.publink = 'http://www.cell.com/neuron/abstract/S0896-6273%2814%2900336-5';
    end
end


% Update handles structure
guidata(hObject, handles);
ensureGUIfits(hObject)

% UIWAIT makes WebsiteMaker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WebsiteMaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txt_path_Callback(hObject, eventdata, handles)
% hObject    handle to txt_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_path as text
%        str2double(get(hObject,'String')) returns contents of txt_path as a double


% --- Executes during object creation, after setting all properties.
function txt_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_directory.
function btn_directory_Callback(hObject, eventdata, handles)
% hObject    handle to btn_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in chk_sims.
function chk_sims_Callback(hObject, eventdata, handles)
% hObject    handle to chk_sims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_sims


% --- Executes on button press in chk_cells.
function chk_cells_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cells


% --- Executes on button press in chk_psyns.
function chk_psyns_Callback(hObject, eventdata, handles)
% hObject    handle to chk_psyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_psyns


% --- Executes on button press in chk_chans.
function chk_chans_Callback(hObject, eventdata, handles)
% hObject    handle to chk_chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_chans


% --- Executes on button press in btn_generate.
function btn_generate_Callback(hObject, eventdata, handles)
global mypath RunArray sl websitepath

% hObject    handle to btn_generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

websitepath=get(handles.txt_path,'String');
try
[r, details]=system(['cd ' websitepath ' ' handles.dl ' hg init']);
if r==0
    pullINrepo=['cd ' websitepath ' ' handles.dl  ' hg pull https://bitbucket.org/mbezaire/modelgraphic ' handles.dl 'hg update tip'];
    [r, s]=system(pullINrepo);
else
    myf=websave([websitepath sl 'tip.gz'],'http://bitbucket.org/mbezaire/modelgraphic/get/tip.gz');
    [r, s]=system(['cd ' websitepath ' ' handles.dl ' tar -xzf ' myf ' ' handles.dl ' rsync -a mbezaire-modelgraphic-*/* ./ ' handles.dl ' rm -r mbezaire-modelgraphic-*/ ' handles.dl ' rm tip.gz']);
end
catch
    msgbox('no internet?')
end

% if get(handles.chk_esyns_only,'Value')==1
if get(handles.chk_esyns,'Value')==1
    contents = cellstr(get(handles.list_esyns,'String'));
    myesyns = contents(get(handles.list_esyns,'Value'));
    for m=1:length(myesyns)
        tidx=strfind( myesyns{m},':')-1;
        myesyns{m} = myesyns{m}(1:tidx(1));
    end
else
    myesyns={};
end

% if get(handles.chk_psyns_only,'Value')==1
if get(handles.chk_psyns,'Value')==1
    contents = cellstr(get(handles.list_psyns,'String'));
    mypsyns = contents(get(handles.list_psyns,'Value'));
    for m=1:length(mypsyns)
        tidx=strfind( mypsyns{m},':')-1;
        mypsyns{m} = mypsyns{m}(1:tidx(1));
    end
else
    mypsyns={};
end

% if get(handles.chk_chans_only,'Value')==1
if get(handles.chk_chans,'Value')==1
    contents = cellstr(get(handles.list_chans,'String'));
    mychans = contents(get(handles.list_chans,'Value'));
    for m=1:length(mychans)
        tidx=strfind( mychans{m},':')-1;
        mychans{m} = mychans{m}(1:tidx(1));
    end
else
    mychans={};
end

websitepath = get(handles.txt_path,'String');

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;
repo = myrepos(q).name;


contents = cellstr(get(handles.menu_baseline,'String'));
myruns = contents(get(handles.menu_baseline,'Value'));
myrunidx=[];
for m=1:length(myruns)
    bsl=regexp(myruns{m},'/','split');
    baserun = searchRuns('RunName',bsl{1},0);
end
if isempty(baserun)
    msgbox('Check which repository SimTracker is in right now.')
    return
end



% if get(handles.chk_cells_only,'Value')==1
if get(handles.chk_cells,'Value')==1 && exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')

    load([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells');

    contents = get(handles.list_cells,'String');
    mycells = contents(get(handles.list_cells,'Value'));

    for m=1:length(mycells)
        tmp=strfind(mycells{m},':');
        if ~isempty(tmp)
            tmpcellstr=mycells{m}(1:tmp-1);
        else
            tmpcellstr=mycells{m};
        end
        handles.indices(m)=strmatch(tmpcellstr,{AllCells.CellName});
    end

    handles.cellproperties = {'Sweep','Firing Rate','Input Resistance','AmplitudeFatigue','Adaptation','Voltage Offset','Membrane Tau','Threshold','RMP','Sag Amplitude','Sag Tau','Peak Amplitude','Peak Decay Tau','Steady State','Max Hyperpolarization','Max Depolarization','ISI','AHP','ADP','1st Spike HalfWidth','HalfWidths','1st Spike Amp','Spike Amps','Voltage Circle'};

    makecellsite(AllCells,handles,websitepath)
end

% figure format settings
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
handles.optarg='';
guidata(handles.btn_generate, handles);

myind=[];

if exist([websitepath sl 'channels'],'dir')==0
    mkdir([websitepath sl 'channels'])
end

if exist([websitepath sl 'cells'],'dir')==0
    mkdir([websitepath sl 'cells'])
end


fid = fopen([repospath sl 'datasets' sl 'cellnumbers_' num2str(RunArray(baserun).NumData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);
for mtc=1:length(filedata{1})
    if ~exist([websitepath sl 'cells' sl filedata{1}{mtc}],'dir')
        mkdir([websitepath sl 'cells' sl filedata{1}{mtc}])
    end
end
chtc=dir([repospath sl 'ch_*.mod']);
for mtc=1:length(chtc)
    if ~exist([websitepath sl 'channels' sl chtc(mtc).name(4:end-4)],'dir')
        mkdir([websitepath sl 'channels' sl chtc(mtc).name(4:end-4)])
    end
end

if get(handles.chk_sims,'Value')==1
    if get(handles.chk_runs_only,'Value')==1
        system(['rm -r ' websitepath sl 'results'])
        system(['mkdir ' websitepath sl 'results'])
        fidrunsum=fopen([websitepath sl 'results' sl 'allruns.txt'],'w');
        fclose(fidrunsum);
    end
    
    contents = cellstr(get(handles.list_runs,'String'));
    myruns = contents(get(handles.list_runs,'Value'));
    myrunidx=[];
    for m=1:length(myruns)
        bsl=regexp(myruns{m},'/','split');
        handles.curses=[];
        handles.curses.ind = searchRuns('RunName',bsl{1},0);
        myrunidx(m) = handles.curses.ind;
        if get(handles.chk_sims,'Value')==1 && exist([websitepath sl 'results' sl bsl{1}],'dir')==0 || length(dir([websitepath sl 'results' sl bsl{1} '\']))<4
            guidata(handles.btn_generate, handles);
            h = plot_websitemore(handles,[websitepath sl 'results' sl]);
            close(h);
        end
    end
    varsby={'ConnData','DegreeStim','SimDuration','SynData'};
    var1=[RunArray(myrunidx).(varsby{1})];
    var2=[RunArray(myrunidx).(varsby{2})];
    var3=[RunArray(myrunidx).(varsby{3})];
    var4=[RunArray(myrunidx).(varsby{4})];
    uniq1=unique(var1); % [322 325 324 323 ]; %
    uniq2=unique(var2);
    uniq3=unique(var3);
    uniq4=unique(var4);
    
    [~, myi1]=ismember(var1,uniq1);
    [~, myi2]=ismember(var2,uniq2);
    [~, myi3]=ismember(var3,uniq3);
    [~, myi4]=ismember(var4,uniq4);
    
    for u=1:length(uniq1)
        for q=1:length(uniq2)
            for z=1:length(uniq3)
                for w=1:length(uniq4)
                    myrows(u).mycols(q).mydepth(z).myother(w).name='';
                end
            end
        end
    end
    try
    for i1=1:length(myi1)
        myrows(myi1(i1)).mycols(myi2(i1)).mydepth(myi3(i1)).myother(myi4(i1)).name=RunArray(myrunidx(i1)).RunName;
    end
    catch
        i1
    end
    
    if exist([myrepos(q).dir sl 'datasets' sl 'conns.mat'],'file')
    load([myrepos(q).dir sl 'datasets' sl 'conns.mat'])
    
    fidruntbl=fopen([websitepath sl 'results' sl 'spiketable.txt'],'w');
    fprintf(fidruntbl,'%s/<br/>%s,',varsby{1},varsby{2});
    dispvec=[1:length(uniq2)]; %[4 5 7 8 9 10 11 12];
    allothers=dispvec(1:end-1);
    lastone=dispvec(end); % length(uniq2)
    for q=allothers %length(uniq2)-1
        fprintf(fidruntbl,'%f,',uniq2(q));
    end
    fprintf(fidruntbl,'%f\n',uniq2(lastone));
    
    for w=1:length(uniq4)
        for z=1:length(uniq3)
            for u=1:length(uniq1)
                ib=find([conns(:).num]==uniq1(u));
                mystr = conns(ib).comments;
                mystr(strfind(mystr,','))=[];
                fprintf(fidruntbl,'"%d:%s",',uniq1(u),mystr);
                for q=allothers %1:length(uniq2)-1
                    if isfield(myrows(u).mycols(q).mydepth(z).myother(w),'name') && ~isempty(myrows(u).mycols(q).mydepth(z).myother(w).name)
                        fprintf(fidruntbl,'%s,',myrows(u).mycols(q).mydepth(z).myother(w).name);
                    else
                        fprintf(fidruntbl,',');
                    end
                end
                if isfield(myrows(u).mycols(lastone).mydepth(z).myother(w),'name') && ~isempty(myrows(u).mycols(lastone).mydepth(z).myother(w).name)
                    fprintf(fidruntbl,'%s\n',myrows(u).mycols(lastone).mydepth(z).myother(w).name);
                else
                    fprintf(fidruntbl,'\n');
                end
            end
        end
    end
    fclose(fidruntbl);
    end
end

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

handles.general=general;
clear general

contents = get(handles.menu_baseline,'String');
myrun = contents{get(handles.menu_baseline,'Value')};

bsl=regexp(myrun,'/','split');

myind = searchRuns('RunName',bsl{1},0);

repotype.RunName = RunArray(myind).RunName;
repotype.NumData = RunArray(myind).NumData;
repotype.ConnData = RunArray(myind).ConnData;
repotype.SynData = RunArray(myind).SynData;



repotype.repospath = repospath;
repotype.repo = repo;


repotype.publication = get(handles.edit_publication,'String');
repotype.publink = get(handles.edit_url,'String');
repotype.funding = get(handles.edit_funding,'String');
repotype.author = get(handles.edit_author,'String');
repotype.authorlink = get(handles.edit_authorlink,'String');
repotype.lab = get(handles.edit_lab,'String');
repotype.lablink = get(handles.edit_lablink,'String');


getwebsitedata(websitepath,repotype,mychans,mypsyns,myesyns) % channel % phys syns % exp syns

%save([repospath sl 'results' sl 'repotype.mat'],'repotype','-v7.3')

if get(handles.chk_morph,'Value')==1    
    system(['cd ' repospath ' ' handles.dl ' ' handles.general.neuron ' -c "NumData=' num2str(repotype.NumData) '" -c "ConnData=' num2str(repotype.ConnData) '" -c "SynData=' num2str(repotype.SynData) '" -c "strdef reposdir" -c "reposdir = \"' strrep(strrep(websitepath,'\','/'),'C:','/cygdrive/c')  '\""' ' ./setupfiles/clamp/print_morph_website.hoc -c "quit()"']);
    changePS2PDF([websitepath sl 'cells']);
end

msgbox({'The website has been created in:',websitepath})

% close(handles.output);

% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close(handles.output);

% --- Executes on selection change in list_runs.
function list_runs_Callback(hObject, eventdata, handles)
% hObject    handle to list_runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_runs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_runs


% --- Executes during object creation, after setting all properties.
function list_runs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_cells.
function list_cells_Callback(hObject, eventdata, handles)
% hObject    handle to list_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_cells contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_cells


% --- Executes during object creation, after setting all properties.
function list_cells_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_psyns.
function list_psyns_Callback(hObject, eventdata, handles)
% hObject    handle to list_psyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_psyns contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_psyns


% --- Executes during object creation, after setting all properties.
function list_psyns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_psyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_chans.
function list_chans_Callback(hObject, eventdata, handles)
% hObject    handle to list_chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_chans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_chans


% --- Executes during object creation, after setting all properties.
function list_chans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_esyns.
function chk_esyns_Callback(hObject, eventdata, handles)
% hObject    handle to chk_esyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_esyns


% --- Executes on selection change in list_esyns.
function list_esyns_Callback(hObject, eventdata, handles)
% hObject    handle to list_esyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_esyns contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_esyns


% --- Executes during object creation, after setting all properties.
function list_esyns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_esyns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_runs_only.
function chk_runs_only_Callback(hObject, eventdata, handles)
% hObject    handle to chk_runs_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_runs_only


% --- Executes on button press in chk_chans_only.
function chk_chans_only_Callback(hObject, eventdata, handles)
% hObject    handle to chk_chans_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_chans_only


% --- Executes on button press in chk_esyns_only.
function chk_esyns_only_Callback(hObject, eventdata, handles)
% hObject    handle to chk_esyns_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_esyns_only


% --- Executes on button press in chk_cells_only.
function chk_cells_only_Callback(hObject, eventdata, handles)
% hObject    handle to chk_cells_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_cells_only


% --- Executes on button press in chk_psyns_only.
function chk_psyns_only_Callback(hObject, eventdata, handles)
% hObject    handle to chk_psyns_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_psyns_only


% --- Executes on button press in chk_morph.
function chk_morph_Callback(hObject, eventdata, handles)
% hObject    handle to chk_morph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_morph


% --- Executes on selection change in menu_baseline.
function menu_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to menu_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_baseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_baseline


% --- Executes during object creation, after setting all properties.
function menu_baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_publication_Callback(hObject, eventdata, handles)
% hObject    handle to edit_publication (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_publication as text
%        str2double(get(hObject,'String')) returns contents of edit_publication as a double


% --- Executes during object creation, after setting all properties.
function edit_publication_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_publication (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_url_Callback(hObject, eventdata, handles)
% hObject    handle to edit_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_url as text
%        str2double(get(hObject,'String')) returns contents of edit_url as a double


% --- Executes during object creation, after setting all properties.
function edit_url_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_url (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_funding_Callback(hObject, eventdata, handles)
% hObject    handle to edit_funding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_funding as text
%        str2double(get(hObject,'String')) returns contents of edit_funding as a double


% --- Executes during object creation, after setting all properties.
function edit_funding_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_funding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lab_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lab as text
%        str2double(get(hObject,'String')) returns contents of edit_lab as a double


% --- Executes during object creation, after setting all properties.
function edit_lab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lablink_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lablink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lablink as text
%        str2double(get(hObject,'String')) returns contents of edit_lablink as a double


% --- Executes during object creation, after setting all properties.
function edit_lablink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lablink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_author_Callback(hObject, eventdata, handles)
% hObject    handle to edit_author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_author as text
%        str2double(get(hObject,'String')) returns contents of edit_author as a double


% --- Executes during object creation, after setting all properties.
function edit_author_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_authorlink_Callback(hObject, eventdata, handles)
% hObject    handle to edit_authorlink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_authorlink as text
%        str2double(get(hObject,'String')) returns contents of edit_authorlink as a double


% --- Executes during object creation, after setting all properties.
function edit_authorlink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_authorlink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_pdf.
function btn_pdf_Callback(hObject, eventdata, handles)
global mypath pdfpath sl RunArray
% hObject    handle to btn_pdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pdfpath=get(handles.txt_path,'String');
mkdir(pdfpath)

% if get(handles.chk_esyns_only,'Value')==1
if get(handles.chk_esyns,'Value')==1
    contents = cellstr(get(handles.list_esyns,'String'));
    myesyns = contents(get(handles.list_esyns,'Value'));
    for m=1:length(myesyns)
        tidx=strfind( myesyns{m},':')-1;
        myesyns{m} = myesyns{m}(1:tidx(1));
    end
else
    myesyns={};
end

% if get(handles.chk_psyns_only,'Value')==1
if get(handles.chk_psyns,'Value')==1
    contents = cellstr(get(handles.list_psyns,'String'));
    mypsyns = contents(get(handles.list_psyns,'Value'));
    for m=1:length(mypsyns)
        tidx=strfind( mypsyns{m},':')-1;
        mypsyns{m} = mypsyns{m}(1:tidx(1));
    end
else
    mypsyns={};
end

% if get(handles.chk_chans_only,'Value')==1
if get(handles.chk_chans,'Value')==1
    contents = cellstr(get(handles.list_chans,'String'));
    mychans = contents(get(handles.list_chans,'Value'));
    for m=1:length(mychans)
        tidx=strfind( mychans{m},':')-1;
        mychans{m} = mychans{m}(1:tidx(1));
    end
else
    mychans={};
end


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

repospath = myrepos(q).dir;
repo = myrepos(q).name;

contents = cellstr(get(handles.menu_baseline,'String'));
myruns = contents(get(handles.menu_baseline,'Value'));
myrunidx=[];
for m=1:length(myruns)
    bsl=regexp(myruns{m},'/','split');
    baserun = searchRuns('RunName',bsl{1},0);
end
if isempty(baserun)
    msgbox('Check which repository SimTracker is in right now.')
    return
end


filename = [RunArray(baserun).ModelDirectory sl 'results' sl RunArray(baserun).RunName sl 'celltype.dat'];
tmpdata = importdata(filename);

for r=1:size(tmpdata.textdata,1)-1
    basecells(r).name=tmpdata.textdata{r+1,1};
    basecells(r).numcells=tmpdata.data(r,3) - tmpdata.data(r,2) + 1;
end

Props2Plot={'Sweep'};%,'Firing Rate'};%,'MaxHyperpolarization'};
Props2List={'RMP', 'Input Resistance #1', 'Sag Amplitude','Sag Tau', 'Membrane Tau', 'Rheobase', 'ISI', 'Threshold', 'Spike Amplitude', 'Slow AHP Amplitude'};

% if get(handles.chk_cells_only,'Value')==1
if get(handles.chk_cells,'Value')==1 && exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')

    load([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells');

    contents = get(handles.list_cells,'String');
    mycells = contents(get(handles.list_cells,'Value'));

    for m=1:length(mycells)
        tmp=strfind(mycells{m},':');
        if ~isempty(tmp)
            tmpcellstr=mycells{m}(1:tmp-1);
        else
            tmpcellstr=mycells{m};
        end
        handles.indices(m)=strmatch(tmpcellstr,{AllCells.CellName});
    end

    handles.cellproperties = {'Sweep','Firing Rate','Input Resistance','AmplitudeFatigue','Adaptation','Voltage Offset','Membrane Tau','Threshold','RMP','Sag Amplitude','Sag Tau','Peak Amplitude','Peak Decay Tau','Steady State','Max Hyperpolarization','Max Depolarization','ISI','AHP','ADP','1st Spike HalfWidth','HalfWidths','1st Spike Amp','Spike Amps','Voltage Circle'};

    makecellpdf(AllCells,handles,pdfpath,Props2Plot,Props2List,basecells)
end

% figure format settings
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
handles.optarg='';
guidata(handles.btn_generate, handles);

myind=[];

if exist([pdfpath sl 'channels'],'dir')==0
    mkdir([pdfpath sl 'channels'])
end

if exist([pdfpath sl 'cells'],'dir')==0
    mkdir([pdfpath sl 'cells'])
end

contents = cellstr(get(handles.menu_baseline,'String'));
myruns = contents(get(handles.menu_baseline,'Value'));
myrunidx=[];
for m=1:length(myruns)
    bsl=regexp(myruns{m},'/','split');
    baserun = searchRuns('RunName',bsl{1},0);
end
if isempty(baserun)
    msgbox('Check which repository SimTracker is in right now.')
    return
end

fid = fopen([repospath sl 'datasets' sl 'cellnumbers_' num2str(RunArray(baserun).NumData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ; %#ok<NASGU>
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);
for mtc=1:length(filedata{1})
    if ~exist([pdfpath sl 'cells' sl filedata{1}{mtc}],'dir')
        mkdir([pdfpath sl 'cells' sl filedata{1}{mtc}])
    end
end
chtc=dir([repospath sl 'ch_*.mod']);
for mtc=1:length(chtc)
    if ~exist([pdfpath sl 'channels' sl chtc(mtc).name(4:end-4)],'dir')
        mkdir([pdfpath sl 'channels' sl chtc(mtc).name(4:end-4)])
    end
end

if get(handles.chk_sims,'Value')==1
    if get(handles.chk_runs_only,'Value')==1
        system(['rm -r ' pdfpath sl 'results'])
        system(['mkdir ' pdfpath sl 'results'])
        fidrunsum=fopen([pdfpath sl 'results' sl 'allruns.txt'],'w');
        fclose(fidrunsum);
    end
    
    contents = cellstr(get(handles.list_runs,'String'));
    myruns = contents(get(handles.list_runs,'Value'));
    myrunidx=[];
    for m=1:length(myruns)
        bsl=regexp(myruns{m},'/','split');
        handles.curses=[];
        handles.curses.ind = searchRuns('RunName',bsl{1},0);
        myrunidx(m) = handles.curses.ind;
        if get(handles.chk_sims,'Value')==1 && exist([pdfpath sl 'results' sl bsl{1}],'dir')==0 || length(dir([pdfpath sl 'results' sl bsl{1} '\']))<4
%             guidata(handles.btn_generate, handles);
%             h = plot_pdfmore(handles,[pdfpath sl 'results' sl]);
%             close(h);
        end
    end
    varsby={'ConnData','DegreeStim','SimDuration','SynData'};
    var1=[RunArray(myrunidx).(varsby{1})];
    var2=[RunArray(myrunidx).(varsby{2})];
    var3=[RunArray(myrunidx).(varsby{3})];
    var4=[RunArray(myrunidx).(varsby{4})];
    uniq1=unique(var1); % [322 325 324 323 ]; %
    uniq2=unique(var2);
    uniq3=unique(var3);
    uniq4=unique(var4);
    
    [~, myi1]=ismember(var1,uniq1);
    [~, myi2]=ismember(var2,uniq2);
    [~, myi3]=ismember(var3,uniq3);
    [~, myi4]=ismember(var4,uniq4);
    
    for u=1:length(uniq1)
        for q=1:length(uniq2)
            for z=1:length(uniq3)
                for w=1:length(uniq4)
                    myrows(u).mycols(q).mydepth(z).myother(w).name='';
                end
            end
        end
    end
    try
    for i1=1:length(myi1)
        myrows(myi1(i1)).mycols(myi2(i1)).mydepth(myi3(i1)).myother(myi4(i1)).name=RunArray(myrunidx(i1)).RunName;
    end
    catch
        i1
    end
    
    if exist([myrepos(q).dir sl 'datasets' sl 'conns.mat'],'file')
    load([myrepos(q).dir sl 'datasets' sl 'conns.mat'])
    
    fidruntbl=fopen([pdfpath sl 'results' sl 'spiketable.txt'],'w');
    fprintf(fidruntbl,'%s/<br/>%s,',varsby{1},varsby{2});
    dispvec=[1:length(uniq2)]; %[4 5 7 8 9 10 11 12];
    allothers=dispvec(1:end-1);
    lastone=dispvec(end); % length(uniq2)
    for q=allothers %length(uniq2)-1
        fprintf(fidruntbl,'%f,',uniq2(q));
    end
    fprintf(fidruntbl,'%f\n',uniq2(lastone));
    
    for w=1:length(uniq4)
        for z=1:length(uniq3)
            for u=1:length(uniq1)
                ib=find([conns(:).num]==uniq1(u));
                mystr = conns(ib).comments;
                mystr(strfind(mystr,','))=[];
                fprintf(fidruntbl,'"%d:%s",',uniq1(u),mystr);
                for q=allothers %1:length(uniq2)-1
                    if isfield(myrows(u).mycols(q).mydepth(z).myother(w),'name') && ~isempty(myrows(u).mycols(q).mydepth(z).myother(w).name)
                        fprintf(fidruntbl,'%s,',myrows(u).mycols(q).mydepth(z).myother(w).name);
                    else
                        fprintf(fidruntbl,',');
                    end
                end
                if isfield(myrows(u).mycols(lastone).mydepth(z).myother(w),'name') && ~isempty(myrows(u).mycols(lastone).mydepth(z).myother(w).name)
                    fprintf(fidruntbl,'%s\n',myrows(u).mycols(lastone).mydepth(z).myother(w).name);
                else
                    fprintf(fidruntbl,'\n');
                end
            end
        end
    end
    fclose(fidruntbl);
    end
end

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')

handles.general=general;
clear general

contents = get(handles.menu_baseline,'String');
myrun = contents{get(handles.menu_baseline,'Value')};

bsl=regexp(myrun,'/','split');

myind = searchRuns('RunName',bsl{1},0);

repotype.RunName = RunArray(myind).RunName;
repotype.NumData = RunArray(myind).NumData;
repotype.ConnData = RunArray(myind).ConnData;
repotype.SynData = RunArray(myind).SynData;



repotype.repospath = repospath;
repotype.repo = repo;


repotype.publication = get(handles.edit_publication,'String');
repotype.publink = get(handles.edit_url,'String');
repotype.funding = get(handles.edit_funding,'String');
repotype.author = get(handles.edit_author,'String');
repotype.authorlink = get(handles.edit_authorlink,'String');
repotype.lab = get(handles.edit_lab,'String');
repotype.lablink = get(handles.edit_lablink,'String');

    % makecellpdf makecellsite
    % plot_pdfmore plot_websitemore
    % getpdfdata getwebsitedata

getpdfdata(handles,pdfpath,repotype,mychans,mypsyns,myesyns) % channel % phys syns % exp syns

%save([repospath sl 'results' sl 'repotype.mat'],'repotype','-v7.3')

if get(handles.chk_morph,'Value')==1    
    system(['cd ' repospath ' ' handles.dl ' ' handles.general.neuron ' -c "NumData=' num2str(repotype.NumData) '" -c "ConnData=' num2str(repotype.ConnData) '" -c "SynData=' num2str(repotype.SynData) '" -c "strdef reposdir" -c "reposdir = \"' strrep(strrep(websitepath,'\','/'),'C:','/cygdrive/c')  '\""' ' ./setupfiles/clamp/print_morph_website.hoc -c "quit()"']);
    %changePS2PDF([pdfpath sl 'cells']);
end

msgbox({'The latex code for a PDF has been created in:',pdfpath})