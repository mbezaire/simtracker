function varargout = CellData(varargin)
% CELLDATA MATLAB code for CellData.fig
%      CELLDATA, by itself, creates a new CELLDATA or raises the existing
%      singleton*.
%
%      H = CELLDATA returns the handle to a new CELLDATA or the handle to
%      the existing singleton*.
%
%      CELLDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLDATA.M with the given input arguments.
%
%      CELLDATA('Property','Value',...) creates a new CELLDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CellData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CellData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CellData

% Last Modified by GUIDE v2.5 11-Jun-2016 18:41:26
try
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CellData_OpeningFcn, ...
                   'gui_OutputFcn',  @CellData_OutputFcn, ...
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
catch ME
    handleME(ME)
end

% --- Executes just before CellData is made visible.
function CellData_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl AllCells mymode wbflg
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CellData (see VARARGIN)

% Choose default command line output for CellData
handles.output = hObject;

wbflg=1;

set(handles.tbl_properties,'Units','normalized')
startpos=get(handles.tbl_properties,'Position');
set(handles.tbl_properties,'Units','inches')
tgroup = uitabgroup('Parent', hObject,'Units','normalized','Position',[startpos(1)-.005 startpos(2)-.02 startpos(3) startpos(4)+.06]);

panel_intrinsicprops = uitab('Parent', tgroup, 'Title', 'Basic Intrinsic');
% panel_ressag = uitab('Parent', tgroup, 'Title', 'Resonance and Sag');
panel_custom = uitab('Parent', tgroup, 'Title', 'Custom');

startpos=get(handles.tbl_properties,'Position');
set(handles.tbl_properties,'Parent',panel_intrinsicprops,'Position',[.05 .05 startpos(3)-.3 startpos(4)-.15])
% set(handles.tbl_ressag,'Parent',panel_ressag,'Units','inches','Position',[.05 .05 startpos(3)-.3 startpos(4)-.15])

try
set(handles.menu_filter,'String',{'All','Data Loaded','Sweep Verified','Thresholds Reviewed','Analyzed','Date Range','Cell Type','Cell Name','Search Notes','With Notes','Custom Filter'});
mymode = 0;
if exist([mypath sl 'data'],'dir')==0
    mkdir([mypath sl 'data'])
end

if isempty(sl)
    if ispc
        sl='\';
    else
        sl='/';
    end
end
if isempty(mypath)
    mypath=GetSimStorageFolder();%GetExecutableFolder();
end
if exist([mypath sl 'data' sl 'DetailedData'],'dir')==0
    mkdir([mypath sl 'data' sl 'DetailedData'])
end

if exist([mypath sl 'data' sl 'DetailedData.mat'],'file')
    alldats=load([mypath sl 'data' sl 'DetailedData.mat']);
    af=fieldnames(alldats);
    for a=1:length(af)
        eval([af{a} ' = alldats.' af{a} ';']) 
        save([mypath sl 'data' sl 'DetailedData' sl af{a} '.mat'],af{a},'-v7.3')
    end
    %delete('data/DetailedData.mat');
end

if exist('cellfiles','dir')==0
    mkdir('cellfiles')
end

if wbflg==0
    set(handles.btn_website,'Visible','Off')
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
mystr=GetSimStorageFolder();%GetExecutableFolder();
if isempty(findstr(lower(mystr),'simtracker')) && isempty(dir([myrepos(q).dir sl 'cellclamp_results']))
    set(handles.btn_import,'Visible','Off')
    set(handles.text5,'Visible','Off')
    set(handles.btn_load,'Position',get(handles.btn_import,'Position'))
end
    
if ismac
     handles.general.pdfviewer= 'open';
elseif isunix
    handles.general.pdfviewer= 'xdg-open';
else
    handles.general.pdfviewer = ' ';
end
handles.viewother='';
guidata(hObject, handles);

if exist([mypath sl 'data' sl 'Analysis.mat'],'file')
    load([mypath sl 'data' sl 'Analysis.mat']); %,'Analysis','Defaults')
    handles.Analysis = Analysis;
    if ~isfield(handles.Analysis,'Thresh_1_param') || ~isfield(handles.Analysis,'Thresh_2_param')
        handles.Analysis.Thresh_1_param = 2;
        handles.Analysis.Thresh_2_param = 28;
    end
    if ~isfield(handles.Analysis,'ThreshCheck')
        handles.Analysis.ThreshCheck = -20;
    end
    if ~isfield(handles.Analysis,'Window')
        handles.Analysis.Window = 50;
    end
else
    handles.Analysis.Window = 50;
    handles.Analysis.ThreshCheck = -20;
    handles.Analysis.ThresholdCalc = 1;
    handles.Analysis.Thresh_1_param = 2;
    handles.Analysis.Thresh_2_param = 28;
    handles.Analysis.SagTauEq = 'A*(1-exp(-t./tau)).^4';
    handles.Analysis.PeakTauEq = 'A*(exp(-t./tau))';
    handles.Analysis.HyperTauEq = 'A*(exp(-t./tau))';
    handles.Analysis.DepolTauEq = 'A*(1-exp(-t./tau))';
    %handles.Analysis.RInRange = [-200 0];
    Analysis = handles.Analysis;
    save([mypath sl 'data' sl 'Analysis.mat'],'Analysis','-v7.3')
end

if exist('Defaults','var')
    handles.Defaults = Defaults;
else
    handles.Defaults.Experimenter = 'Caren';
    handles.Defaults.Region = 'ECII';
    handles.Defaults.CellType = '?';
    Defaults = handles.Defaults;
    save([mypath sl 'data' sl 'Analysis.mat'],'Defaults','-append')
end

handles.axes.AX = handles.ax_display;

myfunc=@context_copytable_Callback;
myopenfunc=@context_open_Callback;
mydeletefunc=@context_delete_Callback;
mycontextmenuh=uicontextmenu('Tag','menu_copyh');
uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
uimenu(mycontextmenuh,'Label','Open AxoClamp File','Tag','context_copytableh1','Callback',myopenfunc);
uimenu(mycontextmenuh,'Label','Delete Cell','Tag','context_copytableh2','Callback',mydeletefunc);
set(handles.tbl_cells,'UIContextMenu',mycontextmenuh);
handles.cellproperties = {'Sweep','Firing Rate','Input Resistance','AmplitudeFatigue','Adaptation','Voltage Offset','Membrane Tau','Threshold','RMP','Sag Amplitude','Sag Tau','Peak Amplitude','Peak Decay Tau','Steady State','Max Hyperpolarization','Max Depolarization','ISI','AHP','ADP','1st Spike HalfWidth','HalfWidths','1st Spike Amp','Spike Amps','Voltage Circle','FFT'};
set(handles.menu_figure,'String',[{''} handles.cellproperties]);

mycontextmenuM=uicontextmenu('Tag','menu_copyz');
uimenu(mycontextmenuM,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
set(handles.tbl_properties,'UIContextMenu',mycontextmenuM);
set(handles.menuitem_trainwhistle,'Checked','on')
load('train','Fs','y');
handles.y = y;
handles.Fs = Fs;
handles.ind=1;
% Update handles structure
guidata(hObject, handles);

if ispc
    sl='\';
else
    sl='/';
end


if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')
    tic
    load([mypath sl 'data' sl 'AllCellsData.mat']);
    toc

    if ~isa(AllCells,'ExpCell')
        msgbox({'THE FILE WAS NOT SAVED PROPERLY',' ','    AllCellsData.mat',})
    end
else
    AllCells=[];
end

save([mypath sl 'data' sl 'AllCellsDataBackup.mat'],'AllCells','-v7.3')

for r=1:length(AllCells)
    if ~isempty(AllCells(r).AxoClampData) || ~isempty(AllCells(r).SpikeData) || ~isempty(AllCells(r).OtherData) || ~isempty(AllCells(r).TableData)
        reorgCellData(r);
    end
end

save([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells','-v7.3')

updateTable(handles)
catch ME
    handleME(ME)
end


function ShowWaitBar(handles)
try
set(handles.txt_wait,'Visible','On')
set(handles.ax_waitbar,'Visible','On')
UpdateWaitBar(handles,0)
catch ME
    handleME(ME)
end


function UpdateWaitBar(handles,value)
try
    axes(handles.ax_waitbar);
cla;
handles.hwait = patch([0,value,value,0],[0,0,1,1],'b');
axis([0,1,0,1]);
axis off;
drawnow;
set(handles.txt_wait,'String',['Calculating: ' num2str(round(value*100)) '%']);
guidata(handles.ax_waitbar, handles);
catch ME
    handleME(ME)
end

function HideWaitBar(handles)
try
handles = guidata(handles.ax_waitbar);
if isfield(handles,'hwait') %&& ~isempty(handles.hwait)
    try
        delete(handles.hwait);
        handles.hwait = [];
    catch
        axes(handles.ax_waitbar);
        cla;
        handles.hwait = [];
    end
else
    axes(handles.ax_waitbar);
    cla;
    handles.hwait = [];
end
set(handles.ax_waitbar,'Visible','Off')
set(handles.txt_wait,'Visible','Off')
if strcmp(get(handles.menuitem_trainwhistle,'Checked'),'on')
    try
    sound(handles.y,handles.Fs)
    end
end
catch ME
    handleME(ME)
end




function context_open_Callback(hObject, ~)
% hObject    handle to context_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath AllCells
try
handles = guidata(hObject);
ind=handles.ind;

system([' ' AllCells(ind).PathToFile ' &'])
catch ME
    handleME(ME)
end


function context_delete_Callback(hObject, ~)
% hObject    handle to context_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath AllCells
try
handles = guidata(hObject);
if ~isfield(handles,'indices')
    return
end
indices=handles.indices;

ListOCells=sprintf('%s, ', AllCells(indices).FileName);
myans=questdlg(['Are you sure you want to delete cells: ' ListOCells(1:end-2) '?'],'Check First','Yes','No','No');
if strcmp(myans,'Yes')==1
    AllCells(indices)=[];
    saveCells(handles);
    menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
end
% UIWAIT makes CellData wait for user response (see UIRESUME)
% uiwait(handles.figure1);
catch ME
    handleME(ME)
end

function context_copytable_Callback(hObject, ~)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
handles = guidata(hObject); 
if strcmp(get(get(hObject,'Parent'),'Tag'),'menu_copyh') %hObject==handles.tbl_cells
    mydata=get(handles.tbl_cells,'Data');
    mycol=get(handles.tbl_cells,'ColumnName');
else
    mydata=get(handles.tbl_properties,'Data');
    mycol=get(handles.tbl_properties,'ColumnName');
end

%load parameters
% create a header
% copy each row
str = sprintf ('\t');
for j=1:size(mydata,2)
    str = sprintf ( '%s%s\t', str, mycol{j} );
end
str = sprintf ( '%s\n', str(1:end-1));
for i=1:size(mydata,1)
    str = sprintf ( '%s%d\t', str, i );
    for j=1:size(mydata,2)
        if isstr(mydata{i,j})
            str = sprintf ( '%s%s\t', str, mydata{i,j} );
        elseif isinteger(mydata{i,j})
            str = sprintf ( '%s%d\t', str, mydata{i,j} );
        else
            str = sprintf ( '%s%f\t', str, mydata{i,j} );
        end
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);
catch ME
    handleME(ME)
end

% --- Outputs from this function are returned to the command line.
function varargout = CellData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles,varargin)
global mypath AllCells
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
if isempty(varargin)
    [files, PATHNAME] = uigetfile({'*.atf;*.ATF;*.abf;*.ABF','All Axo-Clamp Files: *.atf,*.abf';'*.mat;*.MAT','MATLAB data files';'*','All Files'}, 'Select the Axo-Clamp data file(s)', './cellfiles/','MultiSelect', 'on');
else
    files=varargin{1};
    PATHNAME=varargin{2};
end
if (length(files)==1 && iscell(files)==0) || (iscell(files)==0 && sum(files)==0)
    return
end
myi=1;
if ~isempty(AllCells)
    myi=length(AllCells)+1;
end
getinput={'','',''};

CellType = '';
Region = '';
Experimenter = '';

if iscell(files)
    for r=1:length(files)
        filestr=files{r};
        if ~isempty(searchRuns('FileName',filestr,0,'=='))
            msgbox(['File ' filestr ' was already uploaded. Skipping...'])
            continue;
        end
        if strcmp(CellType,'') || strcmp(Region,'') || strcmp(Experimenter,'')
            mycelltype=inputdlg({['Celltype for file ' filestr],'Region of brain','Experimenter'},'Get File metadata',1,{handles.Defaults.CellType,handles.Defaults.Region,handles.Defaults.Experimenter});
%             for n=1:length(removeflag)
%                 if mycelltype{n}(end)=='*'
%                     eval([removeflag(n).field '=''' mycelltype{n}(1:end-1) ''';']);
%                     if isempty(removeflag(n).a), removeflag(n).a=0; end
%                 else
%                     eval([removeflag(n).field '=''' mycelltype{n} ''';']);
%                     if isempty(removeflag(n).a), removeflag(n).a=1; end
%                 end
%             end
            if isempty(mycelltype)
                continue;
            end
        end
        
        AllCells(myi)=importcell([PATHNAME filestr],filestr,mycelltype{1},handles); % hif, hhyp, ci, li
        AllCells(myi).Region = mycelltype{2};
        AllCells(myi).Experimenter = mycelltype{3};
        
        handles.Defaults.Experimenter = AllCells(myi).Experimenter;
        handles.Defaults.Region = AllCells(myi).Region;
        handles.Defaults.CellType = AllCells(myi).CellType;
        myi = myi + 1;
    end
else
    filestr=files;
    if ~isempty(searchRuns('FileName',filestr,0,'=='))
        msgbox(['File ' filestr ' was already uploaded. Skipping...'])
        return;
    end
    mycelltype=inputdlg({['Celltype for file ' filestr],'Region of brain','Experimenter'},'Get File metadata',1,{handles.Defaults.CellType,handles.Defaults.Region,handles.Defaults.Experimenter});
    if isempty(mycelltype)
        return
    end
    AllCells(myi)=importcell([PATHNAME filestr],filestr,mycelltype{1},handles); % hif, hhyp, ci, li
    AllCells(myi).Region = mycelltype{2};
    AllCells(myi).Experimenter = mycelltype{3};
    handles.Defaults.Experimenter = AllCells(myi).Experimenter;
    handles.Defaults.Region = AllCells(myi).Region;
    handles.Defaults.CellType = AllCells(myi).CellType;
    guidata(hObject, handles);
end

    saveCells(handles)
    menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);

    mydata=get(handles.tbl_cells,'Data');
    jUIScrollPane = findjobj(handles.tbl_cells);
    jUITable = jUIScrollPane.getViewport.getView;
    jUITable.setRowSelectionAllowed(0);
    jUITable.setColumnSelectionAllowed(0);
    jUITable.changeSelection(max(size(mydata,1),1)-1,0, false, false);    

catch ME
    handleME(ME)
end

% --- Executes on button press in btn_load.
function btn_loadfolder_Callback(hObject, eventdata, handles,varargin)
global mypath AllCells
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
if isempty(varargin)
    DIRECTORYNAME = uigetdir('./cellfiles/', 'Select the folder containing the data file(s) or its parent folder'); % ,'MultiSelect', 'on'
else
    DIRECTORYNAME=varargin{1};
end
if (length(DIRECTORYNAME)==1 && iscell(DIRECTORYNAME)==0) || (iscell(DIRECTORYNAME)==0 && sum(DIRECTORYNAME)==0)
    return
end
myi=1;
if ~isempty(AllCells)
    myi=length(AllCells)+1;
end
getinput={'','',''};

CellType = '';
Region = '';
Experimenter = '';
filestr='';
if iscell(DIRECTORYNAME)
    for r=1:length(DIRECTORYNAME)
        PathToFile=DIRECTORYNAME{r}; % 'cellfiles/ShayData/'; % 
        if strcmp(CellType,'') || strcmp(Region,'') || strcmp(Experimenter,'')
            celldefaults=inputdlg({['Defaults to use for file ' filestr ' (if not specified). Cell Type'],'Region of brain','Experimenter'},'Get File metadata',1,{handles.Defaults.CellType,handles.Defaults.Region,handles.Defaults.Experimenter});
        end
        
        mycell = readinWChapCells(PathToFile,handles,celldefaults{1},celldefaults{2});
        AllCells(myi:myi+length(mycell)-1) = mycell;
        myi = myi + length(mycell);
    end
else
    PathToFile=DIRECTORYNAME;
    if strcmp(CellType,'') || strcmp(Region,'') || strcmp(Experimenter,'')
        celldefaults=inputdlg({['Defaults to use for file ' filestr ' (if not specified). Cell Type'],'Region of brain','Experimenter'},'Get File metadata',1,{handles.Defaults.CellType,handles.Defaults.Region,handles.Defaults.Experimenter});
    end

    mycell = readinWChapCells(PathToFile,handles,celldefaults{1},celldefaults{2});
    AllCells(myi:myi+length(mycell)-1) = mycell;
    myi = myi + length(mycell);
end

    saveCells(handles)
    menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);

    mydata=get(handles.tbl_cells,'Data');
    jUIScrollPane = findjobj(handles.tbl_cells);
    jUITable = jUIScrollPane.getViewport.getView;
    jUITable.setRowSelectionAllowed(0);
    jUITable.setColumnSelectionAllowed(0);
    jUITable.changeSelection(max(size(mydata,1),1)-1,0, false, false);    

catch ME
    handleME(ME)
end

function updateTable(handles,varargin)
global mypath sl AllCells DetailedData
try
myans={'No','Yes'};
NextSteps={'2. Verify currents','3. Choose Thresholds','4. Analyze cell','All done!'};
changeCellFlag=0;
if ~isempty(varargin)
    allidx = varargin{1};
else
    allidx = 1:length(AllCells);
end

if isempty(allidx)
    changeCellFlag=1;
    tbldata = {};
end

for d=1:length(allidx)
    c = allidx(d);
    tbldata{d,1} = AllCells(c).CellType;
    tbldata{d,2} = AllCells(c).FileName;
    tbldata{d,3} = AllCells(c).CellName;
    if isempty(AllCells(c).Date)
        tbldata{d,4} = '';
    else
        tbldata{d,4} = datestr(AllCells(c).Date,'dd-mmm-yy');
    end
    ToDo=1;
    
    if AllCells(c).DataVerified==1
        ToDo=2;
        if AllCells(c).ThresholdsVerified==1
            ToDo=3;
            if AllCells(c).Analyzed==1
                ToDo=4;
            end
        end
    end
    
    tbldata{d,5} = NextSteps{ToDo};
    tbldata{d,6} = AllCells(c).Region;
    tbldata{d,7} = AllCells(c).Experimenter;
    tbldata{d,8} = num2str(AllCells(c).ThresholdType);
    tbldata{d,9} = num2str(AllCells(c).MethodSet);  
    tbldata{d,10} = AllCells(c).CurrentRange;
    tbldata{d,11} = AllCells(c).Notes;
end
if isempty(handles.viewother)
    save([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells','-v7.3')
else
save(handles.viewother,'AllCells','-v7.3')
end
if isfield(handles,'ind') && ~ isempty(handles.ind) && (handles.ind>size(tbldata,1) || handles.ind>length(AllCells))
    changeCellFlag=1;
    handles.ind=[]; %size(tbldata,1);
    DetailedData=[];
end
if isfield(handles,'indices') && ~ isempty(handles.indices)
    changeCellFlag=1;
    bidx = find( handles.indices(:,1)>size(tbldata,1));
    handles.indices(bidx,:)=[];
    bidx = find( handles.indices(:,1)>length(AllCells));
    handles.indices(bidx,:)=[];
    if isempty(handles.indices)
        handles.ind=[];
    else
        handles.ind=handles.indices(1);
    end
end

guidata(handles.ax_display, handles);
set(handles.tbl_cells,'Data',tbldata)
if isfield(handles,'indices') && ~isempty(handles.indices)
    for r=1:length(handles.indices)
        tmp = strmatch(AllCells(handles.indices(r)).FileName,tbldata(:,2),'exact');
        if ~isempty(tmp)
            row(r)=tmp(1);
        else
            changeCellFlag=1;
            row(r)=1;
        end
    end
    if changeCellFlag==1 && length(handles.indices)==1
        jUIScrollPane = findjobj(handles.tbl_cells);
        jUITable = jUIScrollPane.getViewport.getView;
%         btest=jUITable.getSelectedRows();
%         jUITable.setRowSelectionAllowed(0);
%         jUITable.setColumnSelectionAllowed(0);
%         jUITable.setCellSelectionEnabled(true);
        try
%             jUITable.clearSelection();
%             resultmat=getrowmat(row);
%             jUITable.changeSelection(resultmat(1,1)-1,resultmat(1,1)-1, false, false);
%             jUITable.addColumnSelectionInterval(0, 0)
%             for cc=1:size(resultmat,1)
%                 jUITable.addRowSelectionInterval(resultmat(cc,1)-1,resultmat(cc,2)-1) % Adds the rows from index0 to index1, inclusive, to the current selection.
%             end
% OR
            jUITable.changeSelection(max(row(end),1)-1,0, false, false);
        catch ME
            disp('Updating Table')
            ME
        end
    end
end

set(handles.txt_filterresults,'String',[num2str(length(allidx)) ' of ' num2str(length(AllCells)) ' files showing'])
catch ME
    handleME(ME)
end

function resultmat=getrowmat(row)
myidx=1;

rowstart=row(myidx);
rowprev=row(myidx);

resultmat=[];
mylen=size(resultmat,1)+1;
resultmat(mylen,1)=rowstart;
if length(row)==1
    resultmat(mylen,2)=rowstart;
else
    for r=2:length(row)
        if r==length(row)
            if row(r)==rowprev+1
                rowprev=row(r);
                resultmat(mylen,2)=rowprev;
            else
                resultmat(mylen,2)=rowprev;
                mylen=size(resultmat,1)+1;
                resultmat(mylen,1)=row(r);
                resultmat(mylen,2)=row(r);
            end
        elseif row(r)==rowprev+1
            rowprev=row(r);
        else
            resultmat(mylen,2)=rowprev;

            rowstart=row(r);
            rowprev=row(r);

            mylen=size(resultmat,1)+1;
            resultmat(mylen,1)=rowstart;
        end
    end
end


function mycell=importcell(PathToFile,FileName,CellType,handles)
global mypath sl
try
    
    switch FileName(end-2:end)
        case 'atf'
            [filecontents, tmp, analtype, checkmestart] = readATF(PathToFile,FileName,CellType);
        case 'abf'
            [filecontents, d, analtype, checkmestart] = readABF(PathToFile,FileName,CellType);
    end
    
    
switch analtype
    case 'standard'
        switch FileName(end-2:end)
            case 'atf'
                AxoClampData = standardAnalAxoClATF(filecontents,tmp);
            case 'abf'
                AxoClampData = standardAnalAxoClABF(filecontents,d);
        end

        % check current sweep
        % check on and off sweep times
        % check if baseline condition
        % if current given, get idealized current sweep
        % if current not given, compute current traces
        % either way, get confirmation from user of what current was

        % AxoClampData = readWCmat(PathToFile,FileName,CellType);


        MethodSet = 0; %0: unspecified methods.  Later, change this to: getMethods(PaperRef);
        % check if JP
        % check methods

        mycell = ExpCell([],MethodSet,PathToFile,FileName,CellType);
        eval([mycell.DetailedData '.AxoClampData=AxoClampData;'])
        mycell.CurrentRange = [num2str(AxoClampData.Currents(1)) ':' num2str(AxoClampData.CurrentStepSize) ':' num2str(AxoClampData.Currents(end))];
        mycell.ThresholdType = handles.Analysis.ThresholdCalc;
        mycell.ThreshCheck = handles.Analysis.ThreshCheck;
        save([mypath sl 'data' sl 'DetailedData' sl mycell.DetailedData '.mat'],mycell.DetailedData,'-v7.3')
    case 'nonstandard'
        MethodSet = 0; %0: unspecified methods.  Later, change this to: getMethods(PaperRef);
        mycell = ExpCell([],MethodSet,PathToFile,FileName,CellType);
        mycell.Notes='Non standard current injection';
        switch FileName(end-2:end)
            case 'atf'
                mycell.NSACData = tmp;
            case 'abf'
                mycell.NSACData = d;
        end
end
catch ME
    handleME(ME)
end


function MethodSet = getMethods(PaperRef)

% prompt for paper

% if new paper, does it have same methods as a previous one?

% if yes, add paper to previous method set, return that method set and
% method specifier (multiple methods exist in one paper, usually for
% different cell types)

% if no, add new method set with paper, return that method set and
% method specifier (multiple methods exist in one paper, usually for
% different cell types)

% whenever a method set is created ... define all method specifiers, 
% load in external and internal solution components, blockers, etc
% calculate all reversal potentials
% calculate a junction potential
% prompt to add measured or corrected junction potential values
% flag for junction-potential-corrected measurements

function tbl_cells_CellSelectionCallback(hObject, eventdata, handles)
global mypath sl AllCells DetailedData mymode logloc wbflg
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

if mymode==1
    return
end
mymode=1;
%set(handles.tbl_cells,'enable','off')
try
fields=fieldnames(handles.axes);
for f=1:length(fields)
    if strcmp(fields{f},'AX')==1
        cla(handles.axes.(fields{f}))
        cla(handles.axes.(fields{f}),'reset')
    else
        try
            delete(handles.axes.(fields{f})(2));
        catch ME
            ME
        end
        handles.axes=rmfield(handles.axes,fields{f});
    end
end
guidata(handles.ax_display, handles);

mydata = get(handles.tbl_cells,'Data');
curadded=0;
if (isfield(eventdata,'Indices') ||  isprop(eventdata,'Indices')) && numel(eventdata.Indices)>0  && length(eventdata.Indices)>0 && eventdata.Indices(1,1)<=size(mydata,1)
    handles.ind = [];
    DetailedData=[];
    handles.indices = [];
    try
        handles.ind = searchRuns('FileName',mydata{eventdata.Indices(1,1),2},0,'==');
        handles.ind = handles.ind(1);
        if isempty(AllCells(handles.ind).DetailedData)
            if ~isempty(AllCells(handles.ind).AxoClampData)
                reorgCellData([handles.ind])
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Attempting to reorgCellData due to unnamed DetailedData and existence AxoClampData in original cell (673)\n');
                fclose(fid);
            else
                tmpFile=AllCells(handles.ind).FileName;
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Going to ask user to reload cell due to unnamed DetailedData and no AxoClampData in original cell (678)\n');
                fclose(fid);
                myans=questdlg(['Would you like to delete or reload errant file ' tmpFile '?'],'Delete file','Delete','Reload','Delete');
                switch myans
                    case 'Delete'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                    case 'Reload'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        uiwait(msgbox(['File ' tmpFile ' needs to be reloaded. Please select the file location next.']));
                        btn_load_Callback(handles.btn_load, [], handles)
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                end
            end
        end
        try
            load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.ind).DetailedData '.mat'],AllCells(handles.ind).DetailedData)
        catch
            msgbox('something went wrong')
            mymode=0;
            myindices = unique(eventdata.Indices(:,1));
            xidx=1;
            for x=1:length(myindices)
                tmp = searchRuns('FileName',mydata{myindices(x),2},0,'==');
                if ~isempty(tmp)
                    handles.indices(xidx) = tmp(1);
                    xidx=xidx+1;
                end
            end
            guidata(handles.ax_display, handles);
            handles.ind = searchRuns('FileName',mydata{eventdata.Indices(1,1),2},0,'==');
            handles.ind = handles.ind(1);
            return
        end
        try
            eval(['DetailedData = ' AllCells(handles.ind).DetailedData ';']);
        catch
            reorgCellData([handles.ind])
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Just reran reorgCellData (705)');
                fclose(fid);
            load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.ind).DetailedData '.mat'],AllCells(handles.ind).DetailedData)
            try
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Now attempting to set DetailedData to the one for this cell (710)');
                fclose(fid);
                eval(['DetailedData = ' AllCells(handles.ind).DetailedData ';']);
                save([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells','-v7.3')
            catch
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Couldnt set DetailedData so gonna ask user to reload cell (716)');
                fclose(fid);
                tmpFile=AllCells(handles.ind).FileName;
                myans=questdlg(['Would you like to delete or reload errant file ' tmpFile '?'],'Delete file','Delete','Reload','Delete');
                switch myans
                    case 'Delete'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                    case 'Reload'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        uiwait(msgbox(['File ' tmpFile ' needs to be reloaded. Please select the file location next.']));
                        btn_load_Callback(handles.btn_load, [], handles)
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                end
            end
        end
        eval(['clear ' AllCells(handles.ind).DetailedData])
        if isfield(AllCells(handles.ind),'CurrentRange')==0 || isempty(AllCells(handles.ind).CurrentRange)
            if isfield(DetailedData,'AxoClampData') && isfield(DetailedData.AxoClampData,'Currents')
                curadded=1;
                AllCells(handles.ind).CurrentRange = [num2str(DetailedData.AxoClampData.Currents(1)) ':' num2str(DetailedData.AxoClampData.CurrentStepSize) ':' num2str(DetailedData.AxoClampData.Currents(end))];
            elseif isfield(AllCells(handles.ind),'AxoClampData') && ~isempty(AllCells(handles.ind).AxoClampData)
                reorgCellData([handles.ind])
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.ind).DetailedData '.mat'],AllCells(handles.ind).DetailedData)
                eval(['DetailedData = ' AllCells(handles.ind).DetailedData ';']);
                AllCells(handles.ind).CurrentRange = [num2str(DetailedData.AxoClampData.Currents(1)) ':' num2str(DetailedData.AxoClampData.CurrentStepSize) ':' num2str(DetailedData.AxoClampData.Currents(end))];
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'Had to reorg cell because it had AxoClampData. did not have currentrange (749)');
                fclose(fid);
            else
                fid = fopen([logloc 'SimTrackerOutput.log'],'a');
                fprintf(fid,'CurrentRange field doesnt exist or is empty but DetailedData doesnt have it either (752)');
                fclose(fid);
                tmpFile=AllCells(handles.ind).FileName;
                myans=questdlg(['Would you like to delete or reload errant file ' tmpFile '?'],'Delete file','Delete','Reload','Delete');
                switch myans
                    case 'Delete'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                    case 'Reload'
                        AllCells(handles.ind)=[];
                        saveCells(handles);
                        menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                        uiwait(msgbox(['File ' tmpFile ' needs to be reloaded. Please select the file location next.']));
                        btn_load_Callback(handles.btn_load, [], handles)
                        mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                        return
                end
            end
        end
        myindices = unique(eventdata.Indices(:,1));
        xidx=1;
        for x=1:length(myindices)
            tmp = searchRuns('FileName',mydata{myindices(x),2},0,'==');
            if ~isempty(tmp)
                handles.indices(xidx) = tmp(1);
                xidx=xidx+1;
            end
        end
        guidata(handles.ax_display, handles);
        %tbldata = get(handles.tbl_cells,'Data');
        set(handles.tbl_properties,'Data',{});
        if AllCells(handles.ind).DataVerified==0
            plotQuickCurrent(handles.ind,handles,handles.ax_display);
            set(handles.btn_review,'Visible','Off');
            set(handles.btn_analyze,'Visible','Off');
        elseif AllCells(handles.ind).ThresholdsVerified==0
            set(handles.btn_review,'Visible','On');
            set(handles.btn_analyze,'Visible','Off');
        elseif AllCells(handles.ind).Analyzed==0
            explot_Sweep(handles.ind,handles.ax_display);
            title('Analyze cell (Step #4) to see other plot types')
            set(handles.btn_review,'Visible','On');
            set(handles.btn_analyze,'Visible','On');
        else
            contents = get(handles.menu_figure,'String');
            plotType = contents{get(handles.menu_figure,'Value')};
            if ~isempty(plotType)
                eval(['explot_' plotType(isspace(plotType)==0) '(handles.ind,handles.ax_display);']);
            end
            if isfield(DetailedData,'TableData')
                updateTblProps(handles)
            else
                set(handles.tbl_properties,'Data',{});
            end
%             if isfield(DetailedData,'ResSagTableData')
%                 updateTblResSag(handles)
%             else
%                 set(handles.tbl_ressag,'Data',{});
%             end  
            set(handles.btn_review,'Visible','On');
            set(handles.btn_analyze,'Visible','On');
        end
    catch ME
        handleME(ME)
        handles.ind = searchRuns('FileName',mydata{eventdata.Indices(1,1),2},0,'==');
        handles.ind = handles.ind(1);
        tmpFile=AllCells(handles.ind).FileName;
        myans=questdlg(['Would you like to delete file ' tmpFile '?'],'Delete file','Yes','No','Yes');
        switch myans
            case 'Yes'
                AllCells(handles.ind)=[];
                saveCells(handles);
                menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
                mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                return
            case 'No'
                mymode=0;
                        %set(handles.tbl_cells,'enable','on')
                return
        end
        %msgbox(['eventdata.Indices(1)=' num2str(eventdata.Indices(1)) ' but mydata length = ' num2str(size(mydata,1))])
    end
%else
    %msgbox('No row selection info available in eventdata (indices).')
end

viewflag=1;
if isfield(handles,'indices')
    for i=1:length(handles.indices)
        if length(AllCells)>=handles.indices(i)
        if AllCells(handles.indices(i)).Analyzed==0
            viewflag=0;
        end
        end
    end
else
    viewflag=0;
end

if viewflag==1
    set(handles.btn_view,'Visible','On');
    set(handles.btn_export,'Visible','On');
    if wbflg==1
    set(handles.btn_website,'Visible','On');
    end
else
    set(handles.btn_view,'Visible','Off');
    set(handles.btn_export,'Visible','Off');
    set(handles.btn_website,'Visible','Off');
end

if curadded
    saveCells(handles)
    updateTable(handles)
end

if size(eventdata.Indices,1)==1 && eventdata.Indices(1,2)==4 % Date field
    mydate = inputdlg('Enter the date of recording','Date Cell Recorded',1,{datestr(now,'dd-mmm-yy')});
    if isempty(mydate)
                mymode=0;
                        %set(handles.tbl_cells,'enable','on')
        return
    end
    if isempty(mydate{:})
        AllCells(handles.ind).Date = [];
    else
        AllCells(handles.ind).Date = datenum(mydate{:},'dd-mmm-yy');
    end
    saveCells(handles)
    updateTable(handles)
end
catch ME
    handleME(ME)
end
mymode=0;
%set(handles.tbl_cells,'enable','on')

function plotQuickCurrent(ind,handles,varargin)
global mypath AllCells DetailedData
try
if isempty(varargin)
    h=figure('Color','w','Name','Current Sweep Key Points');
    axes;
    handles.axes.AX=gca; %handles.ax_display; %axes(h);
else
    handles.axes.AX=varargin{1};
end
fields=fieldnames(handles.axes);
for f=1:length(fields)
    for g=1:length(handles.axes.(fields{f}))
        cla(handles.axes.(fields{f})(g))
        cla(handles.axes.(fields{f})(g),'reset')
    end
end

idx = 1;
[handles.axes.AX1,H1,H2] = plotyy(handles.axes.AX,DetailedData.AxoClampData.Time(idx).Data,DetailedData.AxoClampData.Data(idx).RecordedVoltage,DetailedData.AxoClampData.Time(idx).Data,DetailedData.AxoClampData.Data(idx).CurrentInjection);
set(handles.axes.AX1(2),'YLimMode','auto','YTick',[])
tmp = get(handles.axes.AX1(2),'ylim');
y2low(1)=tmp(1);
y2high(1)=tmp(2);
set(handles.axes.AX1(1),'YLimMode','auto','YTick',[])
tmp = get(handles.axes.AX1(1),'ylim');
y1low(1)=tmp(1);
y1high(1)=tmp(2);

hold on
idx = length(DetailedData.AxoClampData.Data);
[handles.axes.AX2,H1,H2] = plotyy(handles.axes.AX1,DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(idx).RecordedVoltage,DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(idx).CurrentInjection);
set(handles.axes.AX2(2),'YLimMode','auto','YTick',[])
tmp = get(handles.axes.AX2(2),'ylim');
y2low(2)=tmp(1);
y2high(2)=tmp(2);
set(handles.axes.AX2(1),'YLimMode','auto','YTick',[])
tmp = get(handles.axes.AX2(1),'ylim');
y1low(2)=tmp(1);
y1high(2)=tmp(2);
idx = find(DetailedData.AxoClampData.Currents==0);
if ~isempty(idx)
    idx = idx(1);
    [handles.axes.AX3,H1,H2] = plotyy(handles.axes.AX1,DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(idx).RecordedVoltage,DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(idx).CurrentInjection);
    set(handles.axes.AX3(2),'YLimMode','auto','YTick',[])
    tmp = get(handles.axes.AX3(2),'ylim');
    y2low(3)=tmp(1);
    y2high(3)=tmp(2);
    set(handles.axes.AX3(1),'YLimMode','auto','YTick',[])
    tmp = get(handles.axes.AX3(1),'ylim');
    y1low(3)=tmp(1);
    y1high(3)=tmp(2);
    set(handles.axes.AX3(1),'ylim',[min(y1low) max(y1high)],'box','off')
    set(handles.axes.AX3(2),'ylim',[min(y2low) max(y2high)],'box','off')
end
set(handles.axes.AX1(2),'ylim',[min(y2low) max(y2high)],'box','off','YTickMode','auto','YTickLabelMode','auto')
set(handles.axes.AX2(2),'ylim',[min(y2low) max(y2high)],'box','off')

set(handles.axes.AX1(1),'ylim',[min(y1low) max(y1high)],'box','off','YTickMode','auto','YTickLabelMode','auto')
set(handles.axes.AX2(1),'ylim',[min(y1low) max(y1high)],'box','off')

if ~isempty(idx)
    try
        plot([DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OnIdx) DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OnIdx)],[min(y1low) max(y1high)],'r:')
        plot([DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OffIdx) DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OffIdx)],[min(y1low) max(y1high)],'r:')

        xlabel(handles.axes.AX1(1),['Time (' DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Units ')'])
        ylabel(handles.axes.AX1(1),['Recorded Potential (' DetailedData.AxoClampData.VoltageUnits ')'])
        ylabel(handles.axes.AX1(2),['Current Injection (' DetailedData.AxoClampData.CurrentUnits ')'])
        title(handles.axes.AX1(1),{'Verify current sweep (Step #2)','to see desired figure'})
    catch ME
        ME
        uiwait(msgbox(['OnIdx length=' num2str(length(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OnIdx)) ' OffIdx length=' num2str(length(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OffIdx)) ' other lengths=' num2str(length(min(y1low))) ' and ' num2str(length(max(y1high)))]))
    end
else
    for cc=1:length(DetailedData.AxoClampData.Time)
        plot(DetailedData.AxoClampData.Time(cc).Data,DetailedData.AxoClampData.Data(cc).CurrentInjection)
    end
    xlabel(handles.axes.AX1(1),['Time (' DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Units ')'])
    ylabel(handles.axes.AX1(1),['Current Injection (' DetailedData.AxoClampData.CurrentUnits ')'])
    title(handles.axes.AX1(1),'Non-standard Current Injection')
end
guidata(handles.axes.AX, handles);
catch ME
    handleME(ME)
end

function [filecontents, d, analtype, checkmestart] = readABF(filestr,FileName,CellType)
% written by marianne.bezaire@gmail.com  2015
try
        [d,si,h]=abfload(filestr);

        filecontents.Time.Units = 's';
        filecontents.Time.Res = h.si*1e-6;
        filecontents.Time.Data = (0:(size(d,1)-1))*filecontents.Time.Res;
        
        filecontents.VoltageUnits = '';
        filecontents.CurrentUnits = '';
        filecontents.ColumnsPerSweep = size(d,2);

ResultUnits=h.recChUnits;
uniqueUnits = unique(ResultUnits);
g=strfind(uniqueUnits,'A');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.CurrentUnits = uniqueUnits{1};
        else
            filecontents.CurrentUnits = uniqueUnits{r};
        end
    end
end
g=strfind(uniqueUnits,'V');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.VoltageUnits = uniqueUnits{1};
        else
            filecontents.VoltageUnits = uniqueUnits{r};
        end
    end
end
   
switch filecontents.ColumnsPerSweep
    case 1
        filecontents.Style='VoltageOnly'; %|'VoltageAndCurrent'|'ExtraChannels';
        filecontents.CurrentColumn=0;
        filecontents.VoltageColumn=1;
        filecontents.CurrentUnits = 'pA';
    case 2
        filecontents.Style='VoltageAndCurrent'; %|'ExtraChannels';
        filecontents.CurrentColumn=find(strcmp(filecontents.CurrentUnits,ResultUnits)==1);
        filecontents.VoltageColumn=find(strcmp(filecontents.VoltageUnits,ResultUnits)==1);
    otherwise
        filecontents.Style='ExtraChannels';
        getinput=inputdlg({['The order of ' FileName ' (' CellType ') data for each current injection is: ' sprintf('%s ',ResultUnits{:}) '. The current injection column is:'],'The recorded membrane potential column is:'});
        filecontents.CurrentColumn=str2num(getinput{1});
        filecontents.VoltageColumn=str2num(getinput{2});
        if isempty(strfind(ResultUnits{filecontents.CurrentColumn},'A')) || isempty(strfind(ResultUnits{filecontents.VoltageColumn},'V'))
            msgbox('Something is not right about your selection')
        end
end

filecontents.Sweeps=cellstr([repmat('# ',size(d,3),1) num2str([1:size(d,3)]')]);
filecontents.NumberSweeps=size(d,3);

chkflg=1;

checkmestart=1;

for n=1:filecontents.NumberSweeps
    checkme=d(checkmestart:end,2,n);
    mystdvals(n) = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
end

for n=1:filecontents.NumberSweeps
    zerocase=0;
    sqwv=0;
    checkme=d(checkmestart:end,2,n);
    tmpstd = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
    if tmpstd==min(mystdvals) && mystdvals(n)<(mean(mystdvals)-std(mystdvals))
        zerocase=1;
    end
    
    minme=min(checkme);
    maxme=max(checkme);
    if mean(mystdvals)>1 % pA instead of nA
        testidx=find(checkme>(minme+5) & checkme<(maxme-5));
    else
        testidx=find(checkme>(minme+.005) & checkme<(maxme-.005));
    end
    if length(testidx)/length(checkme)<.3
        %checkme = (checkme - minme)/(maxme - minme);
        sqwv=1;
    end
    
    if sum([sqwv zerocase])==0
        chkflg=0;
        break;
    end
end

chkflgrerun=0;
if chkflg==0
    tmpf=inputdlg('It was not immediately obvious where the current step starts. Please give a baseline time to start checking:','0.5');
    chkflgrerun=1;
end

if chkflgrerun
    checkmestart=find(filecontents.Time.Data>0.5,1,'first');
    chkflg=1;

    for n=1:filecontents.NumberSweeps
        checkme=d(checkmestart:end,2,n);
        mystdvals(n) = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
    end

    for n=1:filecontents.NumberSweeps
        zerocase=0;
        sqwv=0;
        checkme=d(checkmestart:end,2,n);
        tmpstd = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        if tmpstd==min(mystdvals) && mystdvals(n)<(mean(mystdvals)-std(mystdvals))
            zerocase=1;
        end

        minme=min(checkme);
        maxme=max(checkme);
        if mean(mystdvals)>1 % pA instead of nA
            testidx=find(checkme>(minme+5) & checkme<(maxme-5));
        else
            testidx=find(checkme>(minme+.005) & checkme<(maxme-.005));
        end
        if length(testidx)/length(checkme)<.3
            %checkme = (checkme - minme)/(maxme - minme);
            sqwv=1;
        end

        if sum([sqwv zerocase])==0
            chkflg=0;
            break;
        end
    end
end

if chkflg==1
    analtype='standard';
else
    analtype='nonstandard';
end

catch ME
    ME
end

function filecontents = standardAnalAxoClABF(filecontents,d)
try
lookIdx = find(filecontents.Time.Data>.02,1,'first'); % assume the current injection never starts more than .02 s into the trace
nn=1;
nno=1;
for n=1:filecontents.NumberSweeps
    ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.VoltageColumn;
    filecontents.Data(n).RecordedVoltage = d(:,1,n);% tmp.data(:,ResultIdx);
    filecontents.Data(n).Sweep = filecontents.Sweeps(n);

    mydiff=diff(filecontents.Data(n).RecordedVoltage);
    otherdiff = diff(d(:,2,n));
    register=.75;
    tmpnn = find(abs(mydiff(lookIdx:end))>register*max(abs(mydiff(lookIdx:end))),1,'first')-1+lookIdx;
    tmpnno = find(abs(otherdiff(lookIdx:end))>register*max(abs(otherdiff(lookIdx:end))),1,'first')-1+lookIdx;
    if ~isempty(tmpnn)
        estimatedOnIdx(nn) = tmpnn;
        nn=nn+1;
    end
    if ~isempty(tmpnno)
        estimatedOnIdxO(nno) = tmpnno;
        nno=nno+1;
    end
end

if mode(estimatedOnIdx) > (mean(estimatedOnIdx) + mystd(estimatedOnIdx)) || mode(estimatedOnIdx) < (mean(estimatedOnIdx) - mystd(estimatedOnIdx)) || (std(estimatedOnIdx) - mystd(estimatedOnIdxO)) > 10000
    [filecontents.Injection.OnIdx, numtimes] = mode(estimatedOnIdxO);
else
    [filecontents.Injection.OnIdx, numtimes] = mode(estimatedOnIdx);
end
if numtimes==1
    grr=sort(estimatedOnIdx);
    [~, bidx] = min(diff(grr));
    filecontents.Injection.OnIdx = grr(bidx+1);
end
if (filecontents.Injection.OnIdx*filecontents.Time.Res<0.05) %.1)
    htm=figure('Color','w');
    plot(filecontents.Time.Data,filecontents.Data(1).RecordedVoltage)
    hold on
    plot(filecontents.Time.Data,filecontents.Data(end).RecordedVoltage)
    title('Please click where the current injection starts:');
    [x,y]=ginput(1);
    close(htm);
    filecontents.Injection.OnIdx = find(filecontents.Time.Data>=x,1,'first');
end
try
filecontents.Injection.OffIdx = round(filecontents.Injection.OnIdx+1/filecontents.Time.Res); % mode([filecontents.Data(:).EstimatedOffIdx]);
filecontents.Injection.Duration = filecontents.Time.Data(filecontents.Injection.OffIdx) - filecontents.Time.Data(filecontents.Injection.OnIdx);
catch
    myle=inputdlg({'How long did the current injection last, in seconds?'},'Confirm injection time',1,{'0.5'});
    filecontents.Injection.OffIdx = round(filecontents.Injection.OnIdx+str2num(myle{:})/filecontents.Time.Res); % mode([filecontents.Data(:).EstimatedOffIdx]);
filecontents.Injection.Duration = filecontents.Time.Data(filecontents.Injection.OffIdx) - filecontents.Time.Data(filecontents.Injection.OnIdx);
end

filecontents.HoldingVoltage = [];
filecontents.BaselineCurrent = [];

switch filecontents.Style
    case 'VoltageOnly'
        % find the zero current injection
        for n=1:filecontents.NumberSweeps
            mystdval(n) = mystd(filecontents.Data(n).RecordedVoltage); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        end
        [~, n] = min(mystdval);
        if mystdval(n)>=(mean(mystdval)-std(mystdval))
            getinput=inputdlg({['Give the current sweep step size and either the most hyperpolarized or most depolarized current injection used during the sweep. Current sweep step size in ' filecontents.CurrentUnits ':'],['Most hyperpolarized injection in ' filecontents.CurrentUnits ':'],['Most depolarized injection in ' filecontents.CurrentUnits ':']});
            if isempty(getinput)
                return
            end
        else
            getinput=inputdlg(['Give the current sweep step size in ' filecontents.CurrentUnits ':']);
            if isempty(getinput)
                return
            end
        end
        
        if ~isempty(getinput{1})
            filecontents.CurrentStepSize = str2num(getinput{1});
        else
            msgbox('Current step size is required.')
            return;
        end
        if length(getinput)>1 && ~isempty(getinput{2})
            filecontents.Currents = [str2num(getinput{2}):filecontents.CurrentStepSize:(filecontents.NumberSweeps-1)*filecontents.CurrentStepSize+str2num(getinput{2})];
            if ~isempty(getinput{3})
                if filecontents.Currents(end)~=str2num(getinput{3})
                    msgbox('The three numbers you entered are incompatible.')
                    return
                end
            end
        elseif length(getinput)>1 && ~isempty(getinput{3})
            filecontents.Currents = [(str2num(getinput{3}) - (filecontents.NumberSweeps-1)*filecontents.CurrentStepSize):filecontents.CurrentStepSize:str2num(getinput{3})];
        elseif length(getinput)>1
            msgbox('You needed to enter either the max hyper or depol step')
            return;
        else
            filecontents.Currents = [-filecontents.CurrentStepSize*(n-1):filecontents.CurrentStepSize:filecontents.CurrentStepSize*(filecontents.NumberSweeps-n)];
        end
        
        for n=1:filecontents.NumberSweeps
            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
            else
                filecontents.Data(n).BaselineCurrent = 0;
            end

            filecontents.Data(n).CurrentInjection = [zeros(filecontents.Injection.OnIdx-1,1); repmat(filecontents.Currents(n),filecontents.Injection.OffIdx-filecontents.Injection.OnIdx+1,1); zeros(length(filecontents.Time.Data)-filecontents.Injection.OffIdx,1)];
        end
    otherwise % 'ExtraChannels' || 'VoltageAndCurrent'
        for n=1:filecontents.NumberSweeps
            ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn;
            
            filecontents.Injection(n) = filecontents.Injection(1);
            otherdiff = diff(d(:,2,n)); % (filecontents.Data(n).CurrentInjection);
            register=.75;
            tmpnno = find(abs(otherdiff(filecontents.Injection(n).OnIdx+.001/filecontents.Time.Res:end))>register*max(abs(otherdiff(filecontents.Injection(n).OnIdx+.001/filecontents.Time.Res:end))),1,'first')-1+filecontents.Injection(n).OnIdx+.001/filecontents.Time.Res;
                        
            filecontents.Injection(n).OffIdx = tmpnno;
            filecontents.Injection(n).Duration = filecontents.Time.Data(filecontents.Injection(n).OffIdx) - filecontents.Time.Data(filecontents.Injection(n).OnIdx);

            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
                filecontents.Data(n).CurrentInjection = d(:,2,n)-filecontents.Data(n).BaselineCurrent; % relative to baseline
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection(n).OnIdx:filecontents.Injection(n).OffIdx-1,ResultIdx))/10)*10;
            else
                filecontents.Data(n).BaselineCurrent = mymean(d((lookIdx+1):(filecontents.Injection(n).OnIdx-1),2,n));
                filecontents.Data(n).CurrentInjection = d(:,2,n)-filecontents.Data(n).BaselineCurrent; % relative to baseline
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection(n).OnIdx:filecontents.Injection(n).OffIdx-1))/10)*10;
            end
        end
        if length(filecontents.Currents)>1
            filecontents.CurrentStepSize = filecontents.Currents(2) - filecontents.Currents(1);
        else
            filecontents.CurrentStepSize = NaN;
        end
        
        chkflg=1;
        for n=2:filecontents.NumberSweeps
            if isequal(filecontents.Injection(1),filecontents.Injection(n))==0
                chkflg=0;
                break;
            end
        end
        if 1==chkflg % is only 1 injection
            filecontents.Injection = filecontents.Injection(1);
        end
        
        if isempty(filecontents.BaselineCurrent)
            filecontents.BaselineCurrent=mymean([filecontents.Data(:).BaselineCurrent]);
        end
end

allcurrents = sprintf('%d, ',filecontents.Currents);
catch ME
    handleME(ME)
end

function [filecontents, tmp, analtype, checkmestart] = readATF(filestr,FileName,CellType)
checkmestart=1;
try
tmp=importdata(filestr, '\t', 11); % 
if isempty(cell2mat(strfind(tmp.textdata(:,1),'Sync')))
    msgbox('assuming this is an old format atf file with only 10 header lines')
    tmp=importdata(filestr, '\t', 10); %
end
for z=1:length(tmp.colheaders)
    myt=regexp(tmp.colheaders{z},'"([a-zA-Z]+)\s*#?([0-9]+)?\s*\(([a-zA-Z]+)\)"','tokens');
    tmp.headers(z).Type=myt{1}{1};
    tmp.headers(z).Num=str2double(myt{1}{2});
    tmp.headers(z).Units=myt{1}{3};
end

TimeIdx = find(strcmp({tmp.headers(:).Type},'Time')==1);
if TimeIdx~=1, msgbox('The time should always be the first column in the axoclamp file.'); return; end

filecontents.Time.Data = tmp.data(:,TimeIdx);
filecontents.Time.Units = tmp.headers(TimeIdx).Units;
filecontents.Time.Res = tmp.data(2,TimeIdx) - tmp.data(1,TimeIdx);

datatypes4one=find([tmp.headers(2:end).Num]==1);
ResultUnits={tmp.headers(1+datatypes4one).Units};
uniqueUnits = unique(ResultUnits);
g=strfind(uniqueUnits,'A');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.CurrentUnits = uniqueUnits{1};
        else
            filecontents.CurrentUnits = uniqueUnits{r};
        end
    end
end
g=strfind(uniqueUnits,'V');
for r=1:length(g)
    if ~isempty(g{r})
        if length(uniqueUnits)==1
            filecontents.VoltageUnits = uniqueUnits{1};
        else
            filecontents.VoltageUnits = uniqueUnits{r};
        end
    end
end
filecontents.ColumnsPerSweep = length(datatypes4one);
   
switch filecontents.ColumnsPerSweep
    case 1
        filecontents.Style='VoltageOnly'; %|'VoltageAndCurrent'|'ExtraChannels';
        filecontents.CurrentColumn=0;
        filecontents.VoltageColumn=1;
        filecontents.CurrentUnits = 'pA';
    case 2
        filecontents.Style='VoltageAndCurrent'; %|'ExtraChannels';
        filecontents.CurrentColumn=find(strcmp(filecontents.CurrentUnits,ResultUnits)==1);
        filecontents.VoltageColumn=find(strcmp(filecontents.VoltageUnits,ResultUnits)==1);
    otherwise
        filecontents.Style='ExtraChannels';
        getinput=inputdlg({['The order of ' FileName ' (' CellType ') data for each current injection is: ' sprintf('%s ',ResultUnits{:}) '. The current injection column is:'],'The recorded membrane potential column is:'});
        filecontents.CurrentColumn=str2num(getinput{1});
        filecontents.VoltageColumn=str2num(getinput{2});
        if isempty(strfind(ResultUnits{filecontents.CurrentColumn},'A')) || isempty(strfind(ResultUnits{filecontents.VoltageColumn},'V'))
            msgbox('Something is not right about your selection')
        end
end

filecontents.Sweeps=unique([tmp.headers(2:end).Num]);
filecontents.NumberSweeps=length(filecontents.Sweeps);

% check if normal current sweep here. If not, divert to another analysis
% script. If normal, continue on.
chkflg=1;

for n=1:filecontents.NumberSweeps
    checkme=tmp.data(:,1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn);
    mystdvals(n) = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
end

if filecontents.CurrentColumn>0
for n=1:filecontents.NumberSweeps
    zerocase=0;
    sqwv=0;
    checkme=tmp.data(:,1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn);
    tmpstd = mystd(checkme); % DetailedData.AxoClampData.Data(n).RecordedVoltage
    if tmpstd==min(mystdvals) && mystdvals(n)<(mean(mystdvals)-std(mystdvals))
        zerocase=1;
    end
    
    minme=min(checkme);
    maxme=max(checkme);
    testidx=find(checkme>(minme+.005) & checkme<(maxme-.005));
    if length(testidx)/length(checkme)<.3
        %checkme = (checkme - minme)/(maxme - minme);
        sqwv=1;
    end
    
    if sum([sqwv zerocase])==0
        chkflg=0;
        break;
    end
end
end

if chkflg==1
    analtype='standard';
else
    analtype='nonstandard';
end
catch ME
    ME
end


function filecontents = standardAnalAxoClATF(filecontents,tmp)
try
lookIdx = find(filecontents.Time.Data>.02,1,'first'); % assume the current injection never starts more than .02 s into the trace
nn=1;
nno=1;
for n=1:filecontents.NumberSweeps
    ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.VoltageColumn;
    filecontents.Data(n).RecordedVoltage = tmp.data(:,ResultIdx);
    filecontents.Data(n).Sweep = filecontents.Sweeps(n);

    mydiff=diff(filecontents.Data(n).RecordedVoltage);
    otherdiff = diff(tmp.data(:,1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn));
    register=.75;
    tmpnn = find(abs(mydiff(lookIdx:end))>register*max(abs(mydiff(lookIdx:end))),1,'first')-1+lookIdx;
    tmpnno = find(abs(otherdiff(lookIdx:end))>register*max(abs(otherdiff(lookIdx:end))),1,'first')-1+lookIdx;
    if ~isempty(tmpnn)
        estimatedOnIdx(nn) = tmpnn;
        nn=nn+1;
    end
    if ~isempty(tmpnno)
        estimatedOnIdxO(nno) = tmpnno;
        nno=nno+1;
    end
    %estimatedOnIdx(n) = find(abs(mydiff(lookIdx:end))>(3*std(abs(mydiff(lookIdx:end))) + mean(abs(mydiff(lookIdx:end)))),1,'first')-1+lookIdx;
end

if mode(estimatedOnIdx) > (mean(estimatedOnIdx) + mystd(estimatedOnIdx)) || mode(estimatedOnIdx) < (mean(estimatedOnIdx) - mystd(estimatedOnIdx)) || (std(estimatedOnIdx) - mystd(estimatedOnIdxO)) > 10000
    [filecontents.Injection.OnIdx, numtimes] = mode(estimatedOnIdxO);
    % numtimes=0;
else
    [filecontents.Injection.OnIdx, numtimes] = mode(estimatedOnIdx);
end
if numtimes==1
    grr=sort(estimatedOnIdx);
    [~, bidx] = min(diff(grr));
    filecontents.Injection.OnIdx = grr(bidx+1);
end
if (filecontents.Injection.OnIdx*filecontents.Time.Res<0.05) %.1)
    htm=figure('Color','w');
    plot(filecontents.Time.Data,filecontents.Data(1).RecordedVoltage)
    hold on
    plot(filecontents.Time.Data,filecontents.Data(end).RecordedVoltage)
    title('Please click where the current injection starts:');
    [x,y]=ginput(1);
    close(htm);
    filecontents.Injection.OnIdx = find(filecontents.Time.Data>=x,1,'first');
end
try
    filecontents.Injection.OffIdx = round(filecontents.Injection.OnIdx+1/filecontents.Time.Res); % mode([filecontents.Data(:).EstimatedOffIdx]);
    filecontents.Injection.Duration = filecontents.Time.Data(filecontents.Injection.OffIdx) - filecontents.Time.Data(filecontents.Injection.OnIdx);
catch
    myle=inputdlg({'How long did the current injection last, in seconds?'},'Confirm injection time',1,{'0.5'});
    filecontents.Injection.OffIdx = round(filecontents.Injection.OnIdx+str2num(myle{:})/filecontents.Time.Res); % mode([filecontents.Data(:).EstimatedOffIdx]);
    filecontents.Injection.Duration = filecontents.Time.Data(filecontents.Injection.OffIdx) - filecontents.Time.Data(filecontents.Injection.OnIdx);
end

%%msgbox(['Just to be sure, did your current pulses last around ' num2str(filecontents.Injection.Duration) ' ' filecontents.Time.Units])
%uiwait(msgbox(['Just to be sure, did your current pulses start around ' num2str(filecontents.Injection.OnIdx*filecontents.Time.Res) ' ' filecontents.Time.Units ' into the sweep time?']))

%getinput=inputdlg({['If a baseline current was applied throughout the experiment, please answer at least one of the following. The target holding potential in ' filecontents.VoltageUnits ' was:'],['The applied baseline current in ' filecontents.CurrentUnits ' was:']});
%filecontents.HoldingVoltage = str2num(getinput{1});
%filecontents.BaselineCurrent = str2num(getinput{2});
filecontents.HoldingVoltage = [];
filecontents.BaselineCurrent = [];

switch filecontents.Style
    case 'VoltageOnly'
        % find the zero current injection
        for n=1:filecontents.NumberSweeps
            mystdval(n) = mystd(filecontents.Data(n).RecordedVoltage); % DetailedData.AxoClampData.Data(n).RecordedVoltage
        end
        [~, n] = min(mystdval);
        if mystdval(n)>=(mean(mystdval)-std(mystdval))
            getinput=inputdlg({['Give the current sweep step size and either the most hyperpolarized or most depolarized current injection used during the sweep. Current sweep step size in ' filecontents.CurrentUnits ':'],['Most hyperpolarized injection in ' filecontents.CurrentUnits ':'],['Most depolarized injection in ' filecontents.CurrentUnits ':']});
            if isempty(getinput)
                return
            end
        else
            getinput=inputdlg(['Give the current sweep step size in ' filecontents.CurrentUnits ':']);
            if isempty(getinput)
                return
            end
        end
        
        if ~isempty(getinput{1})
            filecontents.CurrentStepSize = str2num(getinput{1});
        else
            msgbox('Current step size is required.')
            return;
        end
        if length(getinput)>1 && ~isempty(getinput{2})
            filecontents.Currents = [str2num(getinput{2}):filecontents.CurrentStepSize:(filecontents.NumberSweeps-1)*filecontents.CurrentStepSize+str2num(getinput{2})];
            if ~isempty(getinput{3})
                if filecontents.Currents(end)~=str2num(getinput{3})
                    msgbox('The three numbers you entered are incompatible.')
                    return
                end
            end
        elseif length(getinput)>1 && ~isempty(getinput{3})
            filecontents.Currents = [(str2num(getinput{3}) - (filecontents.NumberSweeps-1)*filecontents.CurrentStepSize):filecontents.CurrentStepSize:str2num(getinput{3})];
        elseif length(getinput)>1
            msgbox('You needed to enter either the max hyper or depol step')
            return;
        else
            filecontents.Currents = [-filecontents.CurrentStepSize*(n-1):filecontents.CurrentStepSize:filecontents.CurrentStepSize*(filecontents.NumberSweeps-n)];
        end
        
        for n=1:filecontents.NumberSweeps
            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
            else
                filecontents.Data(n).BaselineCurrent = 0;
            end

            filecontents.Data(n).CurrentInjection = [zeros(filecontents.Injection.OnIdx-1,1); repmat(filecontents.Currents(n),filecontents.Injection.OffIdx-filecontents.Injection.OnIdx+1,1); zeros(length(filecontents.Time.Data)-filecontents.Injection.OffIdx,1)];
        end
    otherwise % 'ExtraChannels' || 'VoltageAndCurrent'
        for n=1:filecontents.NumberSweeps
            ResultIdx = 1+filecontents.ColumnsPerSweep*(n-1)+filecontents.CurrentColumn;

            if ~isempty(filecontents.BaselineCurrent)
                filecontents.Data(n).BaselineCurrent = filecontents.BaselineCurrent;
                filecontents.Data(n).CurrentInjection = tmp.data(:,ResultIdx)-filecontents.Data(n).BaselineCurrent; % relative to baseline
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection.OnIdx:filecontents.Injection.OffIdx-1,ResultIdx))/10)*10;
            else
                filecontents.Data(n).BaselineCurrent = mymean(tmp.data((lookIdx+1):(filecontents.Injection.OnIdx-1),ResultIdx));
                filecontents.Data(n).CurrentInjection = tmp.data(:,ResultIdx)-filecontents.Data(n).BaselineCurrent; % relative to baseline
                filecontents.Currents(n) = round(mean(filecontents.Data(n).CurrentInjection(filecontents.Injection.OnIdx:filecontents.Injection.OffIdx-1))/10)*10;
            end
        end
        if length(filecontents.Currents)>1
            filecontents.CurrentStepSize = filecontents.Currents(2) - filecontents.Currents(1);
            %filecontents.CurrentStepSize = filecontents.Currents(2) - filecontents.Currents(idx);
        else
            filecontents.CurrentStepSize = NaN;
        end
        
        if isempty(filecontents.BaselineCurrent)
            filecontents.BaselineCurrent=mymean([filecontents.Data(:).BaselineCurrent]);
        end
%         if filecontents.BaselineCurrent~=0
%             verifybase=inputdlg('There a baseline current injection throughout the experiment of:','Confirm baseline injection',1,{num2str(filecontents.BaselineCurrent)});
%             filecontents.BaselineCurrent = str2num(verifybase{:})
%         end
end

%allcurrents = sprintf('%d, ',filecontents.Currents);
%uiwait(msgbox({'Just to be sure, are these all the currents you used:',[allcurrents(1:end-2) '?']}))
catch ME
    handleME(ME)
end



% --- Executes on button press in btn_current.
function btn_current_Callback(hObject, eventdata, handles)
% hObject    handle to btn_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath AllCells
try
    if isfield(handles,'indices') && ~isempty(handles.indices)
        for h=1:length(handles.indices)
            AllCells(handles.indices(h)).DataVerified = 1;
        end
    elseif isfield(handles,'ind') && ~isempty(handles.ind)
        AllCells(handles.ind).DataVerified = 1;
    else
        msgbox('No cell selected')
        return;
    end

saveCells(handles)
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
msgbox('Current Sweep Verified.')
catch ME
    handleME(ME)
end

% --- Executes on button press in btn_analyze.
function btn_analyze_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to btn_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath sl AllCells myInd threshparams DetailedData viewother
try
ShowWaitBar(handles)
UpdateWaitBar(handles,0)


for n=1:length(handles.indices)
    ind = handles.indices(n);
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData)
    try
        eval(['DetailedData = ' AllCells(ind).DetailedData ';']);
    catch
        reorgCellData([ind])
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData)
        eval(['DetailedData = ' AllCells(ind).DetailedData ';']);
    end
    eval(['clear ' AllCells(ind).DetailedData])
    
    if ~isempty(strfind(AllCells(ind).Notes,'Non standard current injection'))
%        DetailedData.ResSagTableData=getResSagData(handles,ind);
%         if isfield(DetailedData,'ResSagTableData')
%             updateTblResSag(handles)
%         else
%             set(handles.tbl_ressag,'Data',{});
%         end  
        continue
    end
    
    myInd = ind;
    threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param handles.Analysis.Window];
    viewother = handles.viewother;

    if isempty(varargin)
        uiwait(evalin('base', 'ReviewAnalysis(2)'))
    end
    AnalyzeCell(ind,handles);
    DetailedData.TableData=getTableData(handles,ind);
    % eval([ AllCells(ind).DetailedData '.TableData=getTableData(handles,ind);'])
    if isfield(DetailedData,'TableData')
        updateTblProps(handles)
    else
        set(handles.tbl_properties,'Data',{});
    end
    
    eval([AllCells(ind).DetailedData ' = DetailedData;'])
    %AllCells(ind).TableData = getTableData(handles,ind);
    AllCells(ind).AnalysisSettings = handles.Analysis;
    AllCells(ind).Analyzed=1;
    % saveCells(handles)
    UpdateWaitBar(handles,n/length(handles.indices-.1))
    save([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData,'-v7.3')
end
%save([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells')


menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
saveCells(handles)
HideWaitBar(handles)

catch ME
    handleME(ME)
end


function ResSagTableData=getResSagData(handles,ind)
global mypath DetailedData

% must addpath biophys and also for AnalyzeChirpMJB

for m=1:length(DetailedData.AxoClampData.Data)
    time=DetailedData.AxoClampData.Time(m).Data;
    current=DetailedData.AxoClampData.Data(m).CurrentInjection;
    voltage=DetailedData.AxoClampData.Data(m).RecordedVoltage;
    entry = AnalyzeChirpMJB(time,current,voltage);
    ResSagTableData(m).resFreq=entry.results.resFreq;
    ResSagTableData(m).peakZ=entry.results.peakZ;
    ResSagTableData(m).Q=entry.results.Q;
    ResSagTableData(m).holdingVoltage=entry.results.holdingVoltage;
    ResSagTableData(m).step=m;
end




function Point = plotPoint(handles,spkidx,previdx,nextidx,h,Time,Data,tmpThreshType)
try
ThreshType = round(tmpThreshType);

myFlag = tmpThreshType - ThreshType;
rez = (Time(2)-Time(1))*1000;
threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param handles.Analysis.Window];
Point.Thresh = getThreshold(Data,spkidx,previdx,rez,ThreshType,threshparams); %1);
if isempty(Point.Thresh)
    [~, tmpstidx]=max(Data(previdx:spkidx));
    [~, tmpspkidx]=max(Data((previdx+tmpstidx-1):nextidx));
    tmpspkidx=tmpspkidx+previdx+tmpstidx-2;
    Point.Thresh = getThreshold(Data,tmpspkidx,previdx,rez,ThreshType,threshparams);
    minusme=10;
    try
    while isempty(Point.Thresh) && minusme<100 && (tmpspkidx-minusme)>previdx
        minusme=minusme+10;
        Point.Thresh = getThreshold(Data,spkidx,tmpspkidx-minusme,rez,ThreshType,threshparams);
    end
    catch me
        me
    end
    if isempty(Point.Thresh)
        Point.Thresh = spkidx;
    end
end
[~, maxi]=max(Data(Point.Thresh:nextidx));
try
    Point.Peak = maxi+Point.Thresh-1;
catch ME
    disp('Plot point')
    ME
end

Point.AHP=NaN;
Point.fAHP=NaN;
Point.ADP=NaN;

if (nextidx-Point.Peak)<2
    Point.AHP = NaN;
    Point.fAHP = NaN;
    Point.ADP = NaN;
else
    try
        g = gausswin(round(handles.Analysis.Window));
        g = g/sum(g);
        y3=conv(Data(Point.Peak:nextidx),g,'same');
    
        tmppeaks=findpeaks(y3);
        if isstruct(tmppeaks)
            y=tmppeaks.loc;
        else
            [~, y]=findpeaks(y3);
        end
    catch
        y=[];
    end
    for mym=length(y):-1:1
        if abs(Data(Point.Peak+y(mym)-1)-y3(y(mym)))>5
            y(mym)=[];
        end
    end
    tmpidx=min([Point.Peak+round(.2/(Time(2)-Time(1))) nextidx]);
    if isempty(y)
        [~, mini]=min(Data(Point.Peak:tmpidx));
        Point.AHP = mini+Point.Peak-1;
        Point.fAHP = NaN;
        Point.ADP = NaN;
    else
        Point.ADP = y(1) + Point.Peak-1;
        [~, mini]=min(Data(Point.Peak:Point.ADP));
        Point.fAHP = Point.Peak+mini-1;
        [~, mini]=min(Data(Point.ADP:tmpidx));
        Point.AHP = Point.ADP+mini-1;
    
        if (Data(Point.fAHP)-Data(Point.AHP))>5 % mV
            if (Data(Point.Peak)-Data(Point.fAHP))<10
                Point.fAHP=NaN;
                Point.ADP=NaN;
            else
                Point.AHP=Point.fAHP;
                Point.fAHP=NaN;
                Point.ADP=NaN;
            end
        end
    end
end
catch ME
    handleME(ME)
end


function AnalyzeCell(ind,handles)
global mypath AllCells DetailedData
try
for z=1:length(DetailedData.AxoClampData.Currents)
    
    for s=1:length(DetailedData.SpikeData(z).Spikes)
        try
            DetailedData.SpikeData(z).Spikes(s).Amplitude = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).PeakIdx) - DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ThreshIdx);
            DetailedData.SpikeData(z).Spikes(s).Threshold = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ThreshIdx);
            DetailedData.SpikeData(z).Spikes(s).Peak = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).PeakIdx);
            try
                DetailedData.SpikeData(z).Spikes(s).AHP = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ThreshIdx) - DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).AHPIdx);
            catch
                DetailedData.SpikeData(z).Spikes(s).AHP = NaN;
                DetailedData.SpikeData(z).Spikes(s).AHPIdx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).PeakIdx:end)<handles.Analysis.ThreshCheck,1,'first')+DetailedData.SpikeData(z).Spikes(s).PeakIdx-1;
            end
            try
                DetailedData.SpikeData(z).Spikes(s).fAHP = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ThreshIdx) - DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).fAHPIdx);
            catch
                DetailedData.SpikeData(z).Spikes(s).fAHP = NaN;
            end
            try
                DetailedData.SpikeData(z).Spikes(s).ADP = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ADPIdx) - DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).AHPIdx); % DetailedData.SpikeData(z).Spikes(s).ThreshIdx);
            catch
                DetailedData.SpikeData(z).Spikes(s).ADP = NaN;
            end
            halfvoltage = mymean([DetailedData.SpikeData(z).Spikes(s).Threshold DetailedData.SpikeData(z).Spikes(s).Peak]);
            halfidxStart = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).ThreshIdx:DetailedData.SpikeData(z).Spikes(s).PeakIdx)>=halfvoltage,1,'first') + DetailedData.SpikeData(z).Spikes(s).ThreshIdx -1;
            halfidxEnd = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.SpikeData(z).Spikes(s).PeakIdx:DetailedData.SpikeData(z).Spikes(s).AHPIdx)<=halfvoltage,1,'first') + DetailedData.SpikeData(z).Spikes(s).PeakIdx - 1;
            DetailedData.SpikeData(z).Spikes(s).HalfWidth = DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(halfidxEnd) - DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(halfidxStart);
        catch
            DetailedData.SpikeData(z).Spikes(s).Amplitude = NaN;
            DetailedData.SpikeData(z).Spikes(s).Threshold = NaN;
            DetailedData.SpikeData(z).Spikes(s).Peak = NaN;
            DetailedData.SpikeData(z).Spikes(s).AHP = NaN;
            DetailedData.SpikeData(z).Spikes(s).fAHP = NaN;
            DetailedData.SpikeData(z).Spikes(s).AHPIdx = NaN;
            DetailedData.SpikeData(z).Spikes(s).ADP = NaN;
            DetailedData.SpikeData(z).Spikes(s).HalfWidth = NaN;
        end
    end
    
    DetailedData.SpikeData(z).ISIs = [];
    DetailedData.SpikeData(z).NumISIs = length(DetailedData.SpikeData(z).Spikes)-1;
    for i=1:length(DetailedData.SpikeData(z).Spikes)-1
        try
            DetailedData.SpikeData(z).ISIs(i).ISI = DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.SpikeData(z).Spikes(i+1).ThreshIdx) - DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.SpikeData(z).Spikes(i).ThreshIdx);
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeAmpRatio = DetailedData.SpikeData(z).Spikes(i+1).Amplitude/DetailedData.SpikeData(z).Spikes(1).Amplitude;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeAHPRatio = DetailedData.SpikeData(z).Spikes(i+1).AHP/DetailedData.SpikeData(z).Spikes(1).AHP;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeThreshRatio = DetailedData.SpikeData(z).Spikes(i+1).Threshold/DetailedData.SpikeData(z).Spikes(1).Threshold;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeHWRatio = DetailedData.SpikeData(z).Spikes(i+1).HalfWidth/DetailedData.SpikeData(z).Spikes(1).HalfWidth;
        catch
            DetailedData.SpikeData(z).ISIs(i).ISI = NaN;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeAmpRatio = NaN;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeAHPRatio = NaN;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeThreshRatio = NaN;
            DetailedData.SpikeData(z).ISIs(i).FirstSpikeHWRatio = NaN;
        end
    end

    if ~isnan(DetailedData.OtherData.SteadyStates(z).Idx)
        DetailedData.OtherData.Potentials(z).SS = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.SteadyStates(z).Idx);
    else
        DetailedData.OtherData.Potentials(z).SS = NaN;
    end
    DetailedData.OtherData.Potentials(z).RMP = mymean(DetailedData.AxoClampData.Data(z).RecordedVoltage(1:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx-1));
    
    [maxDepolAfter, tidx] = max(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx:end));
    DetailedData.OtherData.Rebound(z).Amp = maxDepolAfter-DetailedData.OtherData.Potentials(z).RMP;
    DetailedData.OtherData.Rebound(z).PeakIdx = DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx+tidx-1;

    if ~isnan(DetailedData.OtherData.Sag(z).StartIdx) && ~isnan(DetailedData.OtherData.Sag(z).SSByIdx)
        DetailedData.OtherData.Sag(z).Amp = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).SSByIdx)-DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx);
        prevstr='';
        if z>1 && isfield(DetailedData.OtherData.Sag(z-1),'fitEqStr')
            prevstr=DetailedData.OtherData.Sag(z-1).fitEqStr;
        end
        [Tau, TauFit, fitEqStr] = fitEq('Sag',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.OtherData.Sag(z).SSByIdx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.OtherData.Sag(z).SSByIdx),prevstr);
        DetailedData.OtherData.Sag(z).Tau = Tau; 
        tidx=find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.OtherData.Sag(z).SSByIdx)>=DetailedData.OtherData.Sag(z).Amp*(1-1/exp(1))+DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx),1,'first');
        DetailedData.OtherData.Sag(z).eTau = DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(tidx);
        DetailedData.OtherData.Sag(z).TauFit = TauFit;
        DetailedData.OtherData.Sag(z).fitEqStr = fitEqStr;
        DetailedData.OtherData.Potentials(z).MaxHyper = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx);
    else
        DetailedData.OtherData.Sag(z).Amp = NaN;
        DetailedData.OtherData.Sag(z).Tau = NaN;
        DetailedData.OtherData.Potentials(z).MaxHyper = NaN;
    end
    
    DetailedData.OtherData.Membrane(z).Tau = NaN;
    DetailedData.OtherData.Membrane(z).TauFit = NaN;
    if DetailedData.AxoClampData.Currents(z)<0
        if ~isnan(DetailedData.OtherData.Sag(z).StartIdx)
            if DetailedData.OtherData.Sag(z).StartIdx<DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx
                DetailedData.OtherData.Sag(z).StartIdx=DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx;
            end
            prevstr='';
            if z>1
                prevstr=DetailedData.OtherData.Membrane(z-1).fitEqStr;
            end
            [Tau, TauFit, fitEqStr] = fitEq('Tau',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Sag(z).StartIdx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Sag(z).StartIdx),prevstr);
            DetailedData.OtherData.Membrane(z).Tau = Tau;
            tamp = diff(DetailedData.AxoClampData.Data(z).RecordedVoltage([DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx DetailedData.OtherData.Sag(z).StartIdx]))*(1-1/exp(1))+DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx);
            tidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Sag(z).StartIdx)<=tamp,1,'first');
            DetailedData.OtherData.Membrane(z).eTau =DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(tidx);
            DetailedData.OtherData.Membrane(z).TauFit = TauFit;
            DetailedData.OtherData.Membrane(z).fitEqStr = fitEqStr;
        elseif ~isnan(DetailedData.OtherData.SteadyStates(z).Idx)
            prevstr='';
            if z>1
                prevstr=DetailedData.OtherData.Membrane(z-1).fitEqStr;
            end
            [Tau, TauFit, fitEqStr] = fitEq('Tau',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).Idx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).Idx),prevstr);
            DetailedData.OtherData.Membrane(z).Tau = Tau;
            tamp = diff(DetailedData.AxoClampData.Data(z).RecordedVoltage([DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx DetailedData.OtherData.SteadyStates(z).StartIdx]))*(1-1/exp(1))+DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx);
            tidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).StartIdx)<=tamp,1,'first');
            DetailedData.OtherData.Membrane(z).eTau =DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(tidx);
            DetailedData.OtherData.Membrane(z).TauFit = TauFit;
            DetailedData.OtherData.Membrane(z).fitEqStr = fitEqStr;
        end
    elseif DetailedData.AxoClampData.Currents(z)>0
        if ~isnan(DetailedData.OtherData.Peak(z).EndByIdx)
            prevstr='';
            if z>1 && DetailedData.AxoClampData.Currents(z-1)>0
                prevstr=DetailedData.OtherData.Membrane(z-1).fitEqStr;
            end
            [Tau, TauFit, fitEqStr] = fitEq('TauDepol',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Peak(z).PeakIdx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Peak(z).PeakIdx),prevstr);
            DetailedData.OtherData.Membrane(z).Tau = Tau;
            tamp = diff(DetailedData.AxoClampData.Data(z).RecordedVoltage([DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx DetailedData.OtherData.Peak(z).PeakIdx]))*(1-1/exp(1))+DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx);
            tidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.Peak(z).PeakIdx)>=tamp,1,'first');
            DetailedData.OtherData.Membrane(z).eTau =DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(tidx);
            DetailedData.OtherData.Membrane(z).TauFit = TauFit;
            DetailedData.OtherData.Membrane(z).fitEqStr = fitEqStr;
        elseif ~isnan(DetailedData.OtherData.SteadyStates(z).Idx)
            prevstr='';
            if z>1 && DetailedData.AxoClampData.Currents(z-1)>0
                prevstr=DetailedData.OtherData.Membrane(z-1).fitEqStr;
            end
            [Tau, TauFit, fitEqStr] = fitEq('TauDepol',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).Idx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).Idx),prevstr);
            DetailedData.OtherData.Membrane(z).Tau = Tau;
            tamp = diff(DetailedData.AxoClampData.Data(z).RecordedVoltage([DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx DetailedData.OtherData.SteadyStates(z).Idx]))*(1-1/exp(1))+DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx);
            tidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.OtherData.SteadyStates(z).Idx)>=tamp,1,'first');
            DetailedData.OtherData.Membrane(z).eTau =DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(tidx);
            DetailedData.OtherData.Membrane(z).TauFit = TauFit;
            DetailedData.OtherData.Membrane(z).fitEqStr = fitEqStr;
        end
    end
    
    chktrace=DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(z,length(DetailedData.AxoClampData.Injection))).OffIdx);
    [f, fft]=mycontfft(DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(1:2)*1000,chktrace);
    myrange=find(f>=4 & f<=20);
    mybase=find(f>=.95,1,'first');
    [mpow, mf]=max(fft(myrange));
    DetailedData.OtherData.FFT(z).MaxFreq = f(myrange(mf));
    DetailedData.OtherData.FFT(z).Power = mpow;
    DetailedData.OtherData.FFT(z).Base = mean(fft(myrange));

    if ~isnan(DetailedData.OtherData.SteadyStates(z).Idx) && ~isnan(DetailedData.OtherData.Peak(z).PeakIdx)  %DetailedData.OtherData.Peak(z).EndByIdx)
        DetailedData.OtherData.Peak(z).EndByIdx=DetailedData.OtherData.SteadyStates(z).Idx;
        DetailedData.OtherData.Peak(z).Amp = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx)-DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).EndByIdx);
        prevstr='';
        if z>1
            prevstr=DetailedData.OtherData.Peak(z-1).fitEqStr;
        end
        [Tau, TauFit, fitEqStr] = fitEq('Peak',handles,DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data(DetailedData.OtherData.Peak(z).PeakIdx:DetailedData.OtherData.Peak(z).EndByIdx),DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx:DetailedData.OtherData.Peak(z).EndByIdx),prevstr);
        DetailedData.OtherData.Peak(z).DecayTau = Tau;
        DetailedData.OtherData.Peak(z).DecayTauFit = TauFit;
        DetailedData.OtherData.Peak(z).fitEqStr = fitEqStr;
        DetailedData.OtherData.Potentials(z).MaxDepol = DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx);
    else
        DetailedData.OtherData.Peak(z).Amp = NaN;
        DetailedData.OtherData.Peak(z).DecayTau = NaN;
        DetailedData.OtherData.Peak(z).DecayTauFit = NaN;
        DetailedData.OtherData.Peak(z).fitEqStr = '';
        DetailedData.OtherData.Potentials(z).MaxDepol = NaN;
    end
end
% eval([AllCells(ind).DetailedData ' = DetailedData;'])
% save('data/DetailedData.mat',AllCells(ind).DetailedData,'-append');

catch ME
    handleME(ME)
end

function [Tau, TauFit, fitEqStr] = fitEq(Type,handles,Time,Data,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    fitEqStr = varargin{1};
else
    switch Type
        case 'Tau'
            fitEqStr = handles.Analysis.HyperTauEq; %A*(exp(-t./tau))
        case 'TauDepol'
            fitEqStr = handles.Analysis.DepolTauEq; %A*(1-exp(-t./tau)) 
        case 'Peak'
            fitEqStr = handles.Analysis.PeakTauEq; %A*(exp(-t./tau))  
        case 'Sag'
            fitEqStr = handles.Analysis.SagTauEq; %A*(1-exp(-t./tau)).^4; %
    end
end


eval(['calcI = @(A,t,tau) ' fitEqStr ';']);    

% find the amplitude
A=max(Data)-min(Data);

% zero the data
% do the fit
[Tau, TauFit, Flag]=fit_tau(Time-Time(1),Data-min(Data),calcI,A); 
while (Flag~=1 || isnan(Tau)) && length(Time)>1
    disp(['Flag = ' num2str(Flag) ', Tau = ' num2str(Tau)])
    figure();
    plot(Time-Time(1),Data-min(Data),'b')
    hold on
    tmpdt=calcI(A,Time-Time(1),.03);
    plot(Time-Time(1),tmpdt,'r:')
    legend({'Data','Fit'})
    xlabel('Time')
    ylabel('Zeroed Potential (mV)')
    title([Type ' Eq: ' fitEqStr ' with Tau = .03 (30 ms)'])
    tryneweq=inputdlg(['The ' Type ' Fit Eq. didn''t converge. Modify equation?'],'Modify Fit Equation',1,{fitEqStr});
    if isempty(tryneweq) || isempty(tryneweq{:}) || strcmpi(tryneweq{:},'no') || strcmpi(tryneweq{:},'cancel')
        break;
    end
    fitEqStr = tryneweq{:};
    eval(['calcI = @(A,t,tau) ' fitEqStr ';']);    
    [Tau, TauFit, Flag]=fit_tau(Time-Time(1),Data-min(Data),calcI,A); 
end


function [tau, minval, flag]=fit_tau(t,I,calcI,A)
if isequal(size(t),size(I))==0
    t=t';
end
try
    geterr  = @(tau) trapz(t,(I - calcI(A,t,tau)).^2);
    [tau, minval, flag] = fminbnd(geterr,0,1);
    %[tau minval flag] = fminsearch(geterr,1);
    
    % optimset: Display, TolX, MaxFunEval, MaxIter, FunValCheck, PlotFcns, OutputFcn
catch %#ok<CTCH>
    tau=NaN;
    minval=1;
    flag = -119;
end
if tau>t(end)
    tau=NaN;
    minval=1;
    flag = -119;
end

% --- Executes on button press in btn_view.
function btn_view_Callback(hObject, eventdata, handles)
global mypath sl AllCells outputs cellproperties DetailedData
% hObject    handle to btn_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    cellproperties = handles.cellproperties;
    uiwait(evalin('base', 'PickOutputs'))
    if isempty(outputs)
        return;
    end
    
    % matlab figures
    matlab_figures = outputs.matlab_figures;
    
    % image file types
    other_figures = outputs.other_figures;
    figformats = outputs.figformats;
    
    % figure data xls
    figure_data = outputs.figure_data;
    
    figidx = outputs.figidx; % which figures
%myans = questdlg('Do you want to view the figures, print figures, or export figures?','How do you want the figs?','View','Print','Export','View');

colorvec = {'r','g','b','m','c','k','y'};

celltypeFullNice={'Pyramidal','PV+ Basket','CCK+ Basket','S.C.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform','Proximal Afferent','Distal Afferent'};

findNiceidx={'pyramidal','pvbasket','cck','sca','axoaxonic','bistratified','olm','ivy','ngf','ca3','ec'};


colorstruct.pyramidal.color=[.0 .0 .6];
colorstruct.pvbasket.color=[.0 .75 .65];
colorstruct.cck.color=[1 .75 .0];
colorstruct.sca.color=[1 .5 .3];
colorstruct.axoaxonic.color=[1 .0 .0];
colorstruct.bistratified.color=[.6 .4 .1];
colorstruct.olm.color=[.5 .0 .6];
colorstruct.ivy.color=[.6 .6 .6];
colorstruct.ngf.color=[1 .1 1];




mytypes = unique({AllCells(handles.indices(:)).CellType});

if length(mytypes)>2
    typecolor=1;
else
    typecolor=0;
end

if matlab_figures
    for cidx=1:length(figidx) 
        c = figidx(cidx);
        plotType = handles.cellproperties{c};
        h(cidx) = figure('Color','w','Name',plotType);
        ax = axes;
        legstr ={};
        legh=[];
        for g=1:length(handles.indices)
            try
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(g)).DetailedData '.mat'],AllCells(handles.indices(g)).DetailedData)
                eval(['DetailedData = ' AllCells(handles.indices(g)).DetailedData ';']);
                if isfield(colorstruct,AllCells(handles.indices(g)).CellType)
                    mcolor=colorstruct.(AllCells(handles.indices(g)).CellType).color;
                else
                    mcolor=[ 0 0 1];%colorvec{mod(g-1,length(colorvec))+1};
                end
                if typecolor==0
                    legh(g) = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(g)) ',ax,[' num2str(mcolor) '])']);
                    legstr{g} = AllCells(handles.indices(g)).CellName;
                else
                    m = strmatch(AllCells(handles.indices(g)).CellType,mytypes, 'exact');
                    legh(m) = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(g)) ',ax,[' num2str(mcolor) '])']);
                    z=strmatch(AllCells(handles.indices(g)).CellType,findNiceidx);
                    legstr{m} = celltypeFullNice{z};
                end
            catch ME
                legh(g) = NaN;
                legstr{g} = '';
            end
            hold on
        end
        try
            %b=legend(legh(~isnan(legh)),legstr{~isnan(legh)});
            % b=legend(legh(~isempty(legh)),legstr{~isempty(legh)});
            b=legend(legh,legstr);
            set(b,'Interpreter','None');
        catch ME
            try
            b=legend(legh(~isnan(legh)),legstr{~isnan(legh)});
            set(b,'Interpreter','None');
            catch ME
                ME
            end
            %msgbox(ME.message)
        end
    end
end

if other_figures
    pathname = uigetdir('', 'Pick a Directory to store the figures in');
    % make figure
    for cidx=1:length(figidx) 
        c = figidx(cidx);
        plotType = handles.cellproperties{c};
        h(cidx) = figure('Color','w','Name',plotType,'Visible','Off');
        ax = axes;
        legstr ={};
        for g=1:length(handles.indices)
            try
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(g)).DetailedData '.mat'],AllCells(handles.indices(g)).DetailedData)
                eval(['DetailedData = ' AllCells(handles.indices(g)).DetailedData ';']);
                if typecolor==0
                    legh(g) = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(g)) ',ax,''' colorvec{mod(g-1,length(colorvec))+1} ''')']);
                    legstr{g} = AllCells(handles.indices(g)).CellName;
                else
                    m = strmatch(AllCells(handles.indices(g)).CellType,mytypes,'exact');
                    legh(m) = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(g)) ',ax,''' colorvec{mod(m-1,length(colorvec))+1} ''')']);
                    legstr{m} = AllCells(handles.indices(g)).CellType;
                end
            catch
                legh(g) = NaN;
                legstr{g} = '';
            end
            hold on
        end
        try
            %b=legend(legh(~isnan(legh)),legstr{~isnan(legh)});
            b=legend(legh(~isempty(legh)),legstr{~isempty(legh)});
            set(b,'Interpreter','None');
        catch ME
            msgbox(ME.message)
        end
        % print it out in that format
        for r=1:length(figformats)
            print(h(cidx),['-d' figformats{r}], '-r300',[pathname '\' plotType(isspace(plotType)==0)])
        end
        close(h(cidx))
    end
    system(['explorer ' pathname])
end

if figure_data %xls
    [filename, pathname, filteridx] = uiputfile('*.xls', 'Save Excel file');
    warning off MATLAB:xlswrite:AddSheet

    %system(['rm ' pathname filename]);
    worksheet=[pathname filename];
    mst=3;

    for cidx=1:length(figidx) 
        c = figidx(cidx);
        plotType = handles.cellproperties{c};
        for g=1:length(handles.indices)
            try
                load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(g)).DetailedData '.mat'],AllCells(handles.indices(g)).DetailedData)
                eval(['DetailedData = ' AllCells(handles.indices(g)).DetailedData ';']);
                mydata(g) = eval(['explot_' plotType(isspace(plotType)==0) '(' num2str(handles.indices(g)) ',-1)']);
                myname(g).name = AllCells(handles.indices(g)).CellName;
            catch ME
                msgbox(ME.message)
            end
        end
        sheetname = plotType;
        xlswrite(worksheet, {['Plot of ' mydata(1).yheader]}, sheetname, 'A1');
        if length(mydata)==1 || isequal(mydata(:).x)
            % write header
            header = [{mydata(1).xheader} myname(:).name];
            xlswrite(worksheet, header, sheetname, ['A2:' char(length(header)-1+'A') '2']);
            % write x column once
            xlswrite(worksheet, num2cell(mydata(1).x)', sheetname, ['A' num2str(mst) ':A' num2str(length(mydata(1).x)+mst-1)]); % num2cell
            % then all y columns
            for k=1:length(mydata)
                xlswrite(worksheet, num2cell(mydata(k).y)', sheetname, ['B' num2str(mst) ':' char(length(mydata)-1+'B') num2str(length(mydata(k).x)+mst-1)]); % num2cell
            end
        else
            % write header
            header = [{mydata(:).xheader}; {myname(:).name}];
            xlswrite(worksheet, header(:)', sheetname, ['A2:' char(length(header(:))-1+'A') '2']);
            % write each x column followed by its y column
            for k=1:length(mydata)
                xlswrite(worksheet, num2cell(mydata(k).x)', sheetname, [char((k-1)*2+'A') num2str(mst) ':' char((k-1)*2+'A') num2str(length(mydata(k).x)+mst-1)]); % num2cell
                xlswrite(worksheet, num2cell(mydata(k).y)', sheetname, [char((k-1)*2+'B') num2str(mst) ':' char((k-1)*2+'B') num2str(length(mydata(k).x)+mst-1)]); % num2cell
            end
        end
    end
    system(['explorer ' pathname])
end


catch ME
    handleME(ME)
end



% --- Executes on button press in btn_export.
function btn_export_Callback(hObject, eventdata, handles)
global mypath sl AllCells DetailedData
% hObject    handle to btn_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
myans = questdlg('What format?','How do you want the table data?','xls','tab','csv','xls');
%

for mz=1:length(handles.indices)
    load([mypath sl 'data' sl 'DetailedData' sl AllCells(handles.indices(mz)).DetailedData '.mat'],AllCells(handles.indices(mz)).DetailedData)
end

switch myans
    case 'xls'
        [filename, pathname, filteridx] = uiputfile('*.xls', 'Save Excel file');
        warning off MATLAB:xlswrite:AddSheet
        ShowWaitBar(handles)

        %system(['rm ' pathname filename]);
        worksheet=[pathname filename];
        sheetname='Sheet1';
        xlswrite(worksheet, {'File Name','Cell Name','Cell Type'}, sheetname, 'A1:C1');
        if length({DetailedData.TableData(:).Name})>(25-1)
            xtr=char(floor(length({DetailedData.TableData(:).Name})/25)+'A'-1);
            xlswrite(worksheet, {DetailedData.TableData(:).Name}, sheetname, ['D1:' xtr char(mod(length({DetailedData.TableData(:).Name}),24)-1+floor(length({DetailedData.TableData(:).Name})/24)*(-2)+'D') '1']);
        else
            xlswrite(worksheet, {DetailedData.TableData(:).Name}, sheetname, ['D1:' char(length({DetailedData.TableData(:).Name})-1+'D') '1']);
        end

        mst=2;
        mend=mst+length(handles.indices)-1;
        
        xlswrite(worksheet, {AllCells(handles.indices).FileName}', sheetname, ['A' num2str(mst) ':A' num2str(mend)]); % num2cell
        xlswrite(worksheet, {AllCells(handles.indices).CellName}', sheetname, ['B' num2str(mst) ':B' num2str(mend)]); % num2cell
        xlswrite(worksheet, {AllCells(handles.indices).CellType}', sheetname, ['C' num2str(mst) ':C' num2str(mend)]); % num2cell
        UpdateWaitBar(handles,.1)
        
        for r=1:length({DetailedData.TableData(:).Name})
            b={};
            for h=1:length(handles.indices)
                eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);
                b{h} = DetailedData.TableData(r).Mean;
            end
            try
                if r>(24-1)
                    xtr=char(floor(r/24)+'A'-1);
                else
                    xtr='';
                end
                xlswrite(worksheet, b', sheetname, [xtr char(mod(r,24)-1+floor(r/24)*(-2)+'D') num2str(mst) ':' xtr char(mod(r,24)-1+floor(r/24)*(-2)+'D') num2str(mend)]); % num2cell
            catch me
                disp('Exporting ran into trouble at r:')
                r
            end
            UpdateWaitBar(handles,.1+.9*(r/length({DetailedData.TableData(:).Name})))
        end
        HideWaitBar(handles)
        if ispc
        system(['explorer ' pathname])
        end
        msgbox('The Excel file is ready for viewing.')
    case 'tab'
        [filename, pathname, filteridx] = uiputfile('*.txt', 'Save text (tab delimited) file');
        fid = fopen([pathname filename],'w');
        tmp = sprintf('%s\t', DetailedData.TableData(:).Name);
        mystr{1}=[sprintf('File Name\tCell Name\tCell Type\t') tmp(1:end-1)];
        for h=1:length(handles.indices)
            eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);
            %eval(['mystd(' AllCells(handles.indices(h)).DetailedData ');']);
            for pp=1:length(DetailedData.TableData)
                if isempty(DetailedData.TableData(pp).Mean)
                    DetailedData.TableData(pp).Mean=NaN;
                end
            end
            tmp = sprintf('%.2f\t', [DetailedData.TableData(:).Mean]);
            mystr{h+1}=[sprintf('%s\t%s\t%s\t',AllCells(handles.indices(h)).FileName,AllCells(handles.indices(h)).CellName,AllCells(handles.indices(h)).CellType) tmp(1:end-1)];
        end
        fprintf(fid,'%s\n',mystr{:});
        fclose(fid);
        if ispc
            system([' ' pathname filename ' &'])
        end
    case 'csv'
        [filename, pathname, filteridx] = uiputfile('*.csv', 'Save CSV file');
        fid = fopen([pathname filename],'w');
        tmp = sprintf('%s,', DetailedData.TableData(:).Name);
        mystr{1}=['File Name,Cell Name,Cell Type,' tmp(1:end-1)];
        for h=1:length(handles.indices)
            eval(['DetailedData = ' AllCells(handles.indices(h)).DetailedData ';']);
            for pp=1:length(DetailedData.TableData)
                if isempty(DetailedData.TableData(pp).Mean)
                    DetailedData.TableData(pp).Mean=NaN;
                end
            end
            tmp = sprintf('%.2f,', [DetailedData.TableData(:).Mean]);
            mystr{h+1}=[AllCells(handles.indices(h)).FileName ',' AllCells(handles.indices(h)).CellName ',' AllCells(handles.indices(h)).CellType ',' tmp(1:end-1)];
        end
        fprintf(fid,'%s\n',mystr{:});
        fclose(fid);
        if ispc
        system([' ' pathname filename ' &'])
        end
end
catch ME
    handleME(ME)
end

% --- Executes on selection change in menu_figure.
function menu_figure_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData
% hObject    handle to menu_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_figure contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_figure
try
    if AllCells(handles.ind).DataVerified==0
        plotQuickCurrent(handles.ind,handles,handles.ax_display);
    elseif AllCells(handles.ind).Analyzed==0
        explot_Sweep(handles.ind,handles.ax_display);
        title('Analyze cell (Step #4) to see other plot types')
    else
        contents = get(handles.menu_figure,'String');
        plotType = contents{get(handles.menu_figure,'Value')};
        if ~isempty(plotType)
            eval(['explot_' plotType(isspace(plotType)==0) '(handles.ind,handles.ax_display);']);
        end
        if isfield(DetailedData,'TableData')
            updateTblProps(handles)
        else
            set(handles.tbl_properties,'Data',{});
        end
%         if isfield(DetailedData,'ResSagTableData')
%             updateTblResSag(handles)
%         else
%             set(handles.tbl_ressag,'Data',{});
%         end  
    end

% http://undocumentedmatlab.com/blog/controlling-plot-data-tips/
catch ME
    handleME(ME)
end


function updateTblProps(handles)
global mypath AllCells DetailedData

ind = handles.ind;

mydata={};
for r=1:length(DetailedData.TableData)
    mydata{r,1} = DetailedData.TableData(r).Name;
    mydata{r,2} = DetailedData.TableData(r).Mean;
    mydata{r,3} = DetailedData.TableData(r).Std;
    mydata{r,4} = DetailedData.TableData(r).Units;
    mydata{r,5} = DetailedData.TableData(r).Desc;
end
set(handles.tbl_properties,'Data',mydata);



function updateTblResSag(handles)
global mypath AllCells DetailedData

ind = handles.ind;

mydata={};
% for r=1:length(DetailedData.ResSagTableData)
%     mydata{r,1} = DetailedData.ResSagTableData(r).resFreq;
%     mydata{r,2} = DetailedData.ResSagTableData(r).peakZ;
%     mydata{r,3} = DetailedData.ResSagTableData(r).Q;
%     mydata{r,4} = DetailedData.ResSagTableData(r).holdingVoltage;
%     %mydata{r,5} = DetailedData.ResSagTableData(r).step;
% end
% % set(handles.tbl_ressag,'Data',mydata);





function TableData = getTableData(handles,ind)
global mypath AllCells DetailedData


tblfields = {'Name','Mean','Std','Units','Desc'};

r=1;
TableData(r).Name = 'RMP';
TableData(r).Mean = mymean([DetailedData.OtherData.Potentials(:).RMP]);
TableData(r).Std = mystd([DetailedData.OtherData.Potentials(:).RMP]);
TableData(r).Units = 'mV';
TableData(r).Desc = 'Resting Membrane Potential';

r=2;
TableData(r).Name = 'Baseline';
baseline = mymean([DetailedData.AxoClampData.Data(:).BaselineCurrent]);
basestd = mystd([DetailedData.AxoClampData.Data(:).BaselineCurrent]);
baseunits = DetailedData.AxoClampData.CurrentUnits;
basedesc = 'Average baseline current injected';
if isempty(baseline) || isnan(baseline)
    baseline = DetailedData.AxoClampData.BaselineCurrent;
    basestd = [];
    baseunits = DetailedData.AxoClampData.CurrentUnits;
    basedesc = 'Overall baseline current injected';
end
if isempty(baseline) || isnan(baseline)
    baseline = DetailedData.AxoClampData.HoldingVoltage;
    basestd = [];
    baseunits = DetailedData.AxoClampData.VoltageUnits;
    basedesc = 'Holding potential used during sweeps';
end

TableData(r).Mean = baseline;
TableData(r).Std = basestd;
TableData(r).Units = baseunits;
TableData(r).Desc = basedesc;

if DetailedData.AxoClampData.Currents(1)<0
    hidx = find(DetailedData.AxoClampData.Currents<0,1,'last');
r=r+1; %3;
TableData(r).Name = 'Input Resistance #1';
TableData(r).Mean = (DetailedData.OtherData.Potentials(hidx).MaxHyper-DetailedData.OtherData.Potentials(hidx).RMP).*10^3./DetailedData.AxoClampData.Currents(hidx);
TableData(r).Std = [];
TableData(r).Units = 'MegaOhm';
TableData(r).Desc = 'Input resistance calculated from least hyperpolarized step';

r=r+1; %4;
%allofem = ([DetailedData.OtherData.Potentials(1:hidx).MaxHyper]-[DetailedData.OtherData.Potentials(1:hidx).RMP]).*10^3./DetailedData.AxoClampData.Currents(1:hidx);
for h=1:hidx
    meanInjection(h) = mymean(DetailedData.AxoClampData.Data(h).CurrentInjection(DetailedData.AxoClampData.Injection(min(h,length(DetailedData.AxoClampData.Injection))).OnIdx:DetailedData.AxoClampData.Injection(min(h,length(DetailedData.AxoClampData.Injection))).OffIdx-1));
end
P = polyfit(meanInjection,([DetailedData.OtherData.Potentials(1:hidx).MaxHyper]-[DetailedData.OtherData.Potentials(1:hidx).RMP]).*10^3,1);
% use meanInjection instead of DetailedData.AxoClampData.Currents(1:hidx)

TableData(r).Name = 'Input Resistance #2';
TableData(r).Mean = P(1); % slope
TableData(r).Std = [];
TableData(r).Units = 'MegaOhm';
TableData(r).Desc = 'Input resistance fitted to hyperpolarization line';

didx = find(DetailedData.AxoClampData.Currents>0,1,'first');
r=r+1; %4;
TableData(r).Name = 'Input Resistance #3';
TableData(r).Mean = [];
TableData(r).Std = [];
TableData(r).Units = 'MegaOhm';
TableData(r).Desc = 'Input resistance calc from least depol. and hyperpol. steps';
if ~isempty(didx) && DetailedData.SpikeData(didx).NumSpikes==0
    hyperone = (DetailedData.OtherData.Potentials(hidx).MaxHyper-DetailedData.OtherData.Potentials(hidx).RMP).*10^3./DetailedData.AxoClampData.Currents(hidx);
    depolone = (DetailedData.OtherData.Potentials(didx).MaxDepol-DetailedData.OtherData.Potentials(didx).RMP).*10^3./DetailedData.AxoClampData.Currents(didx);
    TableData(r).Mean = mymean([hyperone depolone]);
    TableData(r).Std = mystd([hyperone depolone]);
end
r=r+1; %5;
TableData(r).Name = 'Sag Amplitude';
TableData(r).Mean = DetailedData.OtherData.Sag(1).Amp;
TableData(r).Std = [];
TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
TableData(r).Desc = 'Peak of sag for most hyperpolarized step';

r=r+1; %6;
TableData(r).Name = 'Sag Tau';
TableData(r).Mean = DetailedData.OtherData.Sag(1).Tau*1000;
TableData(r).Std = [];
TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
TableData(r).Desc = 'Tau of sag for most hyperpolarized step';

r=r+1; %6;
TableData(r).Name = 'Sag e Tau';
TableData(r).Mean = DetailedData.OtherData.Sag(1).eTau*1000;
TableData(r).Std = [];
TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
TableData(r).Desc = 'Time to 63.2% of steady state (sag)';

r=r+1; %7;
TableData(r).Name = 'Membrane Tau';
TableData(r).Mean = DetailedData.OtherData.Membrane(hidx).Tau*1000;
TableData(r).Std = [];
TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
TableData(r).Desc = 'Tau of membrane for least hyperpolarized step';

r=r+1; %7;
TableData(r).Name = 'Membrane e Tau';
TableData(r).Mean = DetailedData.OtherData.Membrane(hidx).eTau*1000;
TableData(r).Std = [];
TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
TableData(r).Desc = 'Time to 63.2% of steady state';

r=r+1; %8;
TableData(r).Name = 'Rebound Amplitude';
TableData(r).Mean = DetailedData.OtherData.Rebound(1).Amp;
TableData(r).Std = [];
TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
TableData(r).Desc = 'Rebound amplitude after end of most hyperpolarized step';
else
    tmpstr={'Input Resistance #1','Input Resistance #2','Input Resistance #3','Sag Amplitude','Sag Tau','Sag e Tau','Membrane Tau','Membrane e Tau','Rebound Amplitude'};
    for rr=r+1:r+length(tmpstr)
        for b=1:5
            TableData(rr).(tblfields{b}) = '';
        end
        TableData(rr).Name = tmpstr{rr-r};
    end
    r=r+length(tmpstr);
end

preidx = find([DetailedData.SpikeData(:).NumSpikes]==0,1,'last');
if (DetailedData.AxoClampData.Currents(preidx)>0)
    r=r+1; %9;
    TableData(r).Name = 'Peak Amplitude';
    TableData(r).Mean = DetailedData.OtherData.Peak(preidx).Amp;
    TableData(r).Std = [];
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Transient peak amplitude at most depolarized quiet step';

    r=r+1; %10;
    TableData(r).Name = 'Peak Decay Tau';
    TableData(r).Mean = DetailedData.OtherData.Peak(preidx).DecayTau*1000;
    TableData(r).Std = [];
    TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
    TableData(r).Desc = 'Transient peak decay time constant at most depolarized quiet step';


else
    tmpstr={'Peak Amplitude','Peak Decay Tau'};
    for rr=r+1:r+length(tmpstr)
        for b=1:5
            TableData(rr).(tblfields{b}) = '';
        end
        TableData(rr).Name = tmpstr{rr-r};
    end
    r=r+length(tmpstr);
end

idx = find([DetailedData.SpikeData(:).NumSpikes]>0 & [DetailedData.AxoClampData.Currents]>0,1,'first');
if isempty(idx)
    tmpstr={'Pre Rheobase','Rheobase','Max Freq','Max Power','Power Ratio','Delay to 1st Spike','First Reg. Spiking','SFA','ISI','Threshold','Spike Amplitude','Half-Width','Fast AHP Amplitude','Slow AHP Amplitude','ADP Amplitude','1st Threshold (Max Current)','Avg. Threshold (Max Current)','1st Spike Amplitude (Max Current)','Avg. Spike Amplitude (Max Current)','1st Half-Width (Max Current)','Avg. Half-Width (Max Current)','1st Fast AHP Amplitude (Max Current)','Avg. Fast AHP Amplitude (Max Current)','1st Slow AHP Amplitude (Max Current)','Slow AHP Amplitude (Max Current)','1st ADP Amplitude (Max Current)','Avg. ADP Amplitude (Max Current)'};
    for rr=r+1:r+length(tmpstr)
        for b=1:5
            TableData(rr).(tblfields{b}) = '';
        end
        TableData(rr).Name = tmpstr{rr-r};
    end
    r=r+length(tmpstr);
else
r=r+1; %11;
TableData(r).Name = 'Pre Rheobase';
TableData(r).Mean = DetailedData.AxoClampData.Currents(idx-1);
TableData(r).Std = [];
TableData(r).Units = DetailedData.AxoClampData.CurrentUnits;
TableData(r).Desc = 'Most depolarized step without any spikes';

r=r+1; %12;
TableData(r).Name = 'Rheobase';
TableData(r).Mean = DetailedData.AxoClampData.Currents(idx);
TableData(r).Std = [];
TableData(r).Units = DetailedData.AxoClampData.CurrentUnits;
TableData(r).Desc = 'Least depolarized step with spikes';

    if isfield(DetailedData.OtherData,'FFT')
    r=r+1;
    TableData(r).Name = 'Max Freq';
    TableData(r).Mean = DetailedData.OtherData.FFT(idx).MaxFreq;
    TableData(r).Std = [];
    TableData(r).Units = 'Hz';
    TableData(r).Desc = 'Dominant oscillation frequency between 4-20 Hz at rheobase';

    r=r+1;
    TableData(r).Name = 'Max Power';
    TableData(r).Mean = DetailedData.OtherData.FFT(idx).Power;
    TableData(r).Std = [];
    TableData(r).Units = ['|Y|'];
    TableData(r).Desc = 'FFT power of dominant oscillation between 4-20 Hz at rheobase'; % most depolarized quiet step

    r=r+1;
    TableData(r).Name = 'Power Ratio';
    TableData(r).Mean = DetailedData.OtherData.FFT(idx).Power/DetailedData.OtherData.FFT(idx).Base;
    TableData(r).Std = [];
    TableData(r).Units = ['|Y|'];
    TableData(r).Desc = 'Ratio of FFT power of dominant oscillation and mean power between 4-20 Hz at rheobase'; % most depolarized quiet step
    else
    r=r+1;
    TableData(r).Name = 'Max Freq';
    TableData(r).Mean = NaN;
    TableData(r).Std = [];
    TableData(r).Units = 'Hz';
    TableData(r).Desc = 'Dominant oscillation frequency between 4-20 Hz at rheobase';

    r=r+1;
    TableData(r).Name = 'Max Power';
    TableData(r).Mean = NaN;
    TableData(r).Std = [];
    TableData(r).Units = ['|Y|'];
    TableData(r).Desc = 'FFT power of dominant oscillation between 4-20 Hz at rheobase';

    r=r+1;
    TableData(r).Name = 'Power Ratio';
    TableData(r).Mean = NaN;
    TableData(r).Std = [];
    TableData(r).Units = ['|Y|'];
    TableData(r).Desc = 'Ratio of FFT power of dominant oscillation and mean power between 4-20 Hz at rheobase';
    end
    
r=r+1; %13;
TableData(r).Name = 'Delay to 1st Spike';
TableData(r).Mean = (DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.SpikeData(idx).Spikes(1).ThreshIdx) - DetailedData.AxoClampData.Time(min(idx,length(DetailedData.AxoClampData.Time))).Data(DetailedData.AxoClampData.Injection(min(idx,length(DetailedData.AxoClampData.Injection))).OnIdx))*1000;
TableData(r).Std = [];
TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
TableData(r).Desc = 'At rheobase, spike time after injection starts';

Regidx = find([DetailedData.SpikeData(:).NumSpikes]>=3,1,'first');
if isempty(Regidx)
    tmpstr={'First Reg. Spiking','SFA','ISI','Threshold','Spike Amplitude','Half-Width','Fast AHP Amplitude','Slow AHP Amplitude','ADP Amplitude','1st Threshold (Max Current)','Avg. Threshold (Max Current)','1st Spike Amplitude (Max Current)','Avg. Spike Amplitude (Max Current)','1st Half-Width (Max Current)','Avg. Half-Width (Max Current)','1st Fast AHP Amplitude (Max Current)','Avg. Fast AHP Amplitude (Max Current)','1st Slow AHP Amplitude (Max Current)','Slow AHP Amplitude (Max Current)','1st ADP Amplitude (Max Current)','Avg. ADP Amplitude (Max Current)'};
    for rr=r+1:r+length(tmpstr) %14:20
        for b=1:5
            TableData(rr).(tblfields{b}) = '';
        end
        TableData(rr).Name = tmpstr{rr-r};
    end
    r=r+length(tmpstr);
else
    r=r+1; %14;
    TableData(r).Name = 'First Reg. Spiking';
    TableData(r).Mean = DetailedData.AxoClampData.Currents(Regidx);
    TableData(r).Std = [];
    TableData(r).Units = DetailedData.AxoClampData.CurrentUnits;
    TableData(r).Desc = 'Least depolarized step with regular spiking (at least 3 spikes)';

    r=r+1; %15;
    TableData(r).Name = 'SFA';
    z=length(DetailedData.SpikeData);
    if length(DetailedData.SpikeData(z).ISIs)>6
        SFA=mean([DetailedData.SpikeData(z).ISIs(end-2:end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1:3).ISI]);
    elseif length(DetailedData.SpikeData(z).ISIs)>2
        SFA=mean([DetailedData.SpikeData(z).ISIs(end).ISI])/mean([DetailedData.SpikeData(z).ISIs(1).ISI]);
    else
        SFA=NaN;
    end
    TableData(r).Mean = SFA;
    TableData(r).Std = [];
    TableData(r).Units = ['(1)'];
    TableData(r).Desc = 'Ratio of ending ISIs over beginning ISIs at most depol injection';

    r=r+1; %15;
    TableData(r).Name = 'ISI';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).ISIs(:).ISI].*1000);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).ISIs(:).ISI].*1000);
    TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
    TableData(r).Desc = 'Average of all ISIs at first regular spiking step';

    r=r+1; %16;
    TableData(r).Name = 'Threshold';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).Threshold]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).Threshold]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. threshold of first 3 spikes (first regular spiking step)';

    r=r+1; %17;
    TableData(r).Name = 'Spike Amplitude';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).Amplitude]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).Amplitude]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. amplitude of first 3 spikes (first regular spiking step)';

    r=r+1; %18;
    TableData(r).Name = 'Half-Width';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).HalfWidth].*1000);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).HalfWidth].*1000);
    TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
    TableData(r).Desc = 'Avg. duration of first 3 spikes at half amplitude (first regular spiking step)';

    r=r+1; %19;
    TableData(r).Name = 'Fast AHP Amplitude';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).fAHP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).fAHP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. Fast AHP of first 3 spikes (first regular spiking step)';

    r=r+1; %19;
    TableData(r).Name = 'Slow AHP Amplitude';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).AHP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).AHP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. Slow AHP of first 3 spikes (first regular spiking step)';

    r=r+1; %20;
    TableData(r).Name = 'ADP Amplitude';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Regidx).Spikes(1:3).ADP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Regidx).Spikes(1:3).ADP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. ADP of first 3 spikes (first regular spiking step)';

Lastidx = find([DetailedData.SpikeData(:).NumSpikes]>=4,1,'last');
if isempty(Lastidx)
    tmpstr={'1st Threshold (Max Current)','Avg. Threshold (Max Current)','1st Spike Amplitude (Max Current)','Avg. Spike Amplitude (Max Current)','1st Half-Width (Max Current)','Avg. Half-Width (Max Current)','1st Fast AHP Amplitude (Max Current)','Avg. Fast AHP Amplitude (Max Current)','1st Slow AHP Amplitude (Max Current)','Slow AHP Amplitude (Max Current)','1st ADP Amplitude (Max Current)','Avg. ADP Amplitude (Max Current)'};
    for rr=r+1:r+length(tmpstr) %14:20
        for b=1:5
            TableData(rr).(tblfields{b}) = '';
        end
        TableData(rr).Name = tmpstr{rr-r};
    end
    r=r+length(tmpstr);
else
    r=r+1; %16;
    TableData(r).Name = '1st Threshold (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).Threshold;
    TableData(r).Std = 0;
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Threshold of 1st spike (most depolarized spiking step)';
    r=r+1; %16;
    TableData(r).Name = 'Avg. Threshold (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).Threshold]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).Threshold]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. threshold of spikes 2 - 4 (most depolarized spiking step)';

    r=r+1; %17;
    TableData(r).Name = '1st Spike Amplitude (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).Amplitude;
    TableData(r).Std = 0;
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Amplitude of 1st spike (most depolarized spiking step)';

    r=r+1; %17;
    TableData(r).Name = 'Avg. Spike Amplitude (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).Amplitude]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).Amplitude]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. amplitude of spikes 2 - 4 (most depolarized spiking step)';

    r=r+1; %18;
    TableData(r).Name = '1st Half-Width (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).HalfWidth.*1000;
    TableData(r).Std = 0;
    TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
    TableData(r).Desc = 'Duration of 1st spike at half amplitude (most depolarized spiking step)';

    r=r+1; %18;
    TableData(r).Name = 'Avg. Half-Width (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).HalfWidth].*1000);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).HalfWidth].*1000);
    TableData(r).Units = ['m' DetailedData.AxoClampData.Time(1).Units];
    TableData(r).Desc = 'Avg. duration of spikes 2 - 4 at half amplitude (most depolarized spiking step)';

    r=r+1; %19;
    TableData(r).Name = '1st Fast AHP Amplitude (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).fAHP;
    TableData(r).Std = 0;
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Fast AHP of 1st spike (most depolarized spiking step)';

    r=r+1; %19;
    TableData(r).Name = 'Avg. Fast AHP Amplitude (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).fAHP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).fAHP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. Fast AHP of spikes 2 - 4 (most depolarized spiking step)';

    r=r+1; %19;
    TableData(r).Name = '1st Slow AHP Amplitude (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).AHP;
    TableData(r).Std = 0;
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Slow AHP of first spike (most depolarized spiking step)';

    r=r+1; %19;
    TableData(r).Name = 'Slow AHP Amplitude (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).AHP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).AHP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. Slow AHP of spikes 2 - 4 (most depolarized spiking step)';

    r=r+1; %20;
    TableData(r).Name = '1st ADP Amplitude (Max Current)';
    TableData(r).Mean = DetailedData.SpikeData(Lastidx).Spikes(1).ADP;
    TableData(r).Std = 0;
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'ADP of first spike (most depolarized spiking step)';

    r=r+1; %20;
    TableData(r).Name = 'Avg. ADP Amplitude (Max Current)';
    TableData(r).Mean = mymean([DetailedData.SpikeData(Lastidx).Spikes(2:4).ADP]);
    TableData(r).Std = mystd([DetailedData.SpikeData(Lastidx).Spikes(2:4).ADP]);
    TableData(r).Units = DetailedData.AxoClampData.VoltageUnits;
    TableData(r).Desc = 'Avg. ADP of spikes 2 - 4 (most depolarized spiking step)';
end
end
end
    


% --- Executes during object creation, after setting all properties.
function menu_figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when entered data in editable cell(s) in tbl_cells.
function tbl_cells_CellEditCallback(hObject, eventdata, handles)
global mypath AllCells mymode

mymode=1;
data = get(handles.tbl_cells,'Data');
for b=1:size(data,1)
    idx = searchRuns('FileName',data{b,2},0,'==');
    AllCells(idx).Notes = data{b,end};
    AllCells(idx).CellName = data{b,3};
    AllCells(idx).CellType = data{b,1};
end

saveCells(handles)
mymode=0;


% hObject    handle to tbl_cells (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_about_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('You are using version 1.2')


% --------------------------------------------------------------------
function menuitem_usermanual_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_usermanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
system([handles.general.pdfviewer ' ExperimentalDataManual.pdf']);

% --------------------------------------------------------------------
function menuitem_backup_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_backup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveCells(handles)

[FILENAME, PATHNAME] = uiputfile('.mat', 'Save Back-Up File',['ExperimentalData_Backup_' datestr(now,'yyyymmdd')]);

if ischar(PATHNAME)==0
    return;
end
saveCells(handles,[PATHNAME FILENAME]);

% --------------------------------------------------------------------
function menuitem_archive_Callback(hObject, eventdata, handles)
global mypath AllCells DetailedData
% hObject    handle to menuitem_archive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FILENAME, PATHNAME] = uiputfile('.mat', 'Archive File',['ExperimentalData_Archive_' datestr(now,'yyyymmdd')]);

if ischar(PATHNAME)==0
    return;
end



idx = handles.indices;
    
saveCells(handles,[PATHNAME FILENAME],idx);

% then delete selected cells
AllCells(idx)=[];
saveCells(handles)
handles.indices=[];
handles.ind=[];
DetailedData=[];
guidata(hObject,handles);
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);


% --- Executes on button press in btn_review.
function btn_review_Callback(hObject, eventdata, handles)
global mypath sl myInd AllCells threshparams viewother
% hObject    handle to btn_review (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ShowWaitBar(handles)

thresh=handles.Analysis.ThreshCheck;
h(1)=0;
for n=1:length(handles.indices)
    ind = handles.indices(n);
    try
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData)
        eval(['DetailedData = ' AllCells(ind).DetailedData ';']);
    catch
        reorgCellData(ind)
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData)
        eval(['DetailedData = ' AllCells(ind).DetailedData ';']);
    end
    eval(['clear ' AllCells(ind).DetailedData])
    AllCells(ind).ThreshCheck = handles.Analysis.ThreshCheck;
    for z=1:length(DetailedData.AxoClampData.Data)
        if length(DetailedData.AxoClampData.Injection)>1
            zi=z;
        else
            zi=1;
        end
        spikes = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(1:end-1)<AllCells(ind).ThreshCheck & DetailedData.AxoClampData.Data(z).RecordedVoltage(2:end)>AllCells(ind).ThreshCheck);
        DetailedData.SpikeData(z).NumSpikes = length(spikes);
        DetailedData.SpikeData(z).Spikes = [];
        DetailedData.OtherData.FFT(z).MaxFreq = NaN;
        DetailedData.OtherData.FFT(z).Power = NaN;
        DetailedData.OtherData.FFT(z).Base = NaN;
        UpdateWaitBar(handles,(n - 1 + .8*(z-.7)/length(DetailedData.AxoClampData.Data))/length(handles.indices))
        if sum(spikes)>0
            for s=1:length(spikes)
                if s==1
                    if spikes(s)<DetailedData.AxoClampData.Injection(zi).OnIdx
                        prevspike = 1;
                    else
                        prevspike = round(mean([DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx DetailedData.AxoClampData.Injection(zi).OnIdx spikes(s)]));
                    end
                end
                if s<length(spikes)
                    nextspike = spikes(s+1);
                else
                    if spikes(s)>DetailedData.AxoClampData.Injection(zi).OffIdx
                        nextspike = length(DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data);
                    else
                        nextspike = DetailedData.AxoClampData.Injection(zi).OffIdx;
                    end
                end
                ThreshType = AllCells(ind).ThresholdType;
                Point = plotPoint(handles,spikes(s),prevspike,nextspike,[],DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage,ThreshType);
                if s==1 && (Point.Thresh-DetailedData.AxoClampData.Injection(zi).OnIdx)<5 && spikes(s)>(prevspike+5)
                    Point = plotPoint(handles,spikes(s),prevspike+5,nextspike,[],DetailedData.AxoClampData.Time(min(z,length(DetailedData.AxoClampData.Time))).Data,DetailedData.AxoClampData.Data(z).RecordedVoltage,ThreshType);
                elseif s==length(spikes) & Point.AHP>=DetailedData.AxoClampData.Injection(zi).OffIdx & ~isnan(Point.fAHP)
                    Point.AHP=Point.fAHP;
                    Point.fAHP=NaN;
                    Point.ADP=NaN;
                end
                DetailedData.SpikeData(z).Spikes(s).ThreshIdx = Point.Thresh;
                DetailedData.SpikeData(z).Spikes(s).PeakIdx = Point.Peak;
                DetailedData.SpikeData(z).Spikes(s).AHPIdx = Point.AHP;
                DetailedData.SpikeData(z).Spikes(s).ADPIdx = Point.ADP;
                DetailedData.SpikeData(z).Spikes(s).fAHPIdx = Point.fAHP;

                prevspike = DetailedData.SpikeData(z).Spikes(s).PeakIdx;
            end
            %saveCells(handles)
        end
        UpdateWaitBar(handles,(n - .9 + .7*z/length(DetailedData.AxoClampData.Data))/length(handles.indices))
        if DetailedData.AxoClampData.Currents(z)>0 && (DetailedData.SpikeData(z).NumSpikes==0  || DetailedData.SpikeData(z).Spikes(1).PeakIdx>DetailedData.AxoClampData.Injection(zi).OffIdx)
            % check for peak
            chktrace=DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(zi).OnIdx:DetailedData.AxoClampData.Injection(zi).OffIdx);
            g = gausswin(round(handles.Analysis.Window)*10);
            g = g/sum(g);
            y3=conv(chktrace,g,'same');
            t=[];
            tmppeaks=findpeaks(y3);
            if isstruct(tmppeaks)
                y=tmppeaks.loc;
                t=tmppeaks.loc;
            else
                [t, y]=findpeaks(y3);
            end
            if isempty(t)
                [~, maxi] = max(chktrace);
            else
                maxi=y(1);
            end

            DetailedData.OtherData.Peak(z).PeakIdx = maxi+DetailedData.AxoClampData.Injection(zi).OnIdx-1; 

            ss = mode(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx:DetailedData.AxoClampData.Injection(zi).OffIdx));
            DetailedData.OtherData.SteadyStates(z).Idx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)==ss,1,'first') + DetailedData.OtherData.Peak(z).PeakIdx - 1; % calc me
            fidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Peak(z).PeakIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)<=DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.SteadyStates(z).Idx),1,'first');
            DetailedData.OtherData.Peak(z).EndByIdx = fidx + DetailedData.OtherData.Peak(z).PeakIdx-1; 
            DetailedData.OtherData.Sag(z).SSByIdx = NaN;
            DetailedData.OtherData.Sag(z).StartIdx = NaN;
        elseif DetailedData.SpikeData(z).NumSpikes==0 || DetailedData.SpikeData(z).Spikes(1).PeakIdx>DetailedData.AxoClampData.Injection(zi).OffIdx
            % check for sag
            [~, mini] = min(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.AxoClampData.Injection(zi).OnIdx:DetailedData.AxoClampData.Injection(zi).OffIdx));
            DetailedData.OtherData.Sag(z).StartIdx = mini+DetailedData.AxoClampData.Injection(zi).OnIdx-1; 

            %ss = mode(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx));
            myvec=DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx);
            grr=find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)>mean(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)),1,'first');

            if isempty(grr)
                DetailedData.OtherData.SteadyStates(z).Idx = NaN;
                DetailedData.OtherData.Sag(z).SSByIdx = NaN;
            else
                [biv, bi]=min(diff(myvec(grr:end)));
                gr2=find(diff(myvec(grr:end))==biv,1,'last');
                ss=myvec(grr+gr2);
                tmpss=find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)==ss,1,'first');
                DetailedData.OtherData.SteadyStates(z).Idx = tmpss + DetailedData.OtherData.Sag(z).StartIdx - 1; % calc me
             
                fidx = find(DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.Sag(z).StartIdx:DetailedData.AxoClampData.Injection(zi).OffIdx)>=DetailedData.AxoClampData.Data(z).RecordedVoltage(DetailedData.OtherData.SteadyStates(z).Idx),1,'first');
                DetailedData.OtherData.Sag(z).SSByIdx = fidx + DetailedData.OtherData.Sag(z).StartIdx-1; 
           end

            DetailedData.OtherData.Peak(z).EndByIdx = NaN;
            DetailedData.OtherData.Peak(z).PeakIdx = NaN;
        else
            DetailedData.OtherData.SteadyStates(z).Idx = NaN;
            DetailedData.OtherData.Peak(z).EndByIdx = NaN;
            DetailedData.OtherData.Peak(z).PeakIdx = NaN;
            DetailedData.OtherData.Sag(z).SSByIdx = NaN;
            DetailedData.OtherData.Sag(z).StartIdx = NaN;
        end
        if DetailedData.SpikeData(z).NumSpikes>0 & DetailedData.SpikeData(z).Spikes(1).ThreshIdx < DetailedData.AxoClampData.Injection(zi).OffIdx
            DetailedData.OtherData.SteadyStates(z).Idx = NaN;
        end
    end
    
    eval([AllCells(ind).DetailedData ' = DetailedData;'])
    save([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData,'-v7.3')
    
    saveCells(handles)

    myInd = ind; %handles.ind;
    threshparams = [handles.Analysis.Thresh_1_param handles.Analysis.Thresh_2_param handles.Analysis.Window];
    viewother = handles.viewother;
    uiwait(evalin('base', 'ReviewAnalysis(1)'))
    % evalin('base', 'ReviewAnalysis')

    handles.ga = [];
    guidata(handles.ax_waitbar,handles);

    UpdateWaitBar(handles,(n - .2)/length(handles.indices))
    % saveCells(handles)
    eval([AllCells(ind).DetailedData ' = DetailedData;'])
    save([mypath sl 'data' sl 'DetailedData' sl AllCells(ind).DetailedData '.mat'],AllCells(ind).DetailedData,'-v7.3')
end

mydata = get(handles.tbl_cells,'Data');
if isempty(handles.ind)
    b=size(mydata,2);
else
    b = find(strcmp(AllCells(handles.ind).FileName,mydata(:,2))==1);
end
try
    eventdata.Indices = [b 2];
    tbl_cells_CellSelectionCallback(handles.tbl_cells, eventdata, handles)
catch
    mystruct.Indices=[b 2];
    tbl_cells_CellSelectionCallback(handles.tbl_cells, mystruct, handles)
end
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
HideWaitBar(handles)

% AllCells(myInd).ThresholdsVerified = 1
% AllCells(myInd).ManuallyChanged = 1


% --------------------------------------------------------------------
function menu_settings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuitem_analysis_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menuitem_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

defaults = {num2str(handles.Analysis.ThreshCheck),num2str(handles.Analysis.ThresholdCalc),num2str(handles.Analysis.Thresh_1_param),num2str(handles.Analysis.Thresh_2_param),handles.Analysis.SagTauEq,handles.Analysis.PeakTauEq,handles.Analysis.HyperTauEq,handles.Analysis.DepolTauEq,num2str(handles.Analysis.Window)};
getinput = inputdlg({'Check for Threshold above (mV):','Default Threshold Calculation Option (Enter a number between 1 and 3):','Std deviations away from mean for Threshold method #1','dV/dt (mV/ms) threshold for Threshold method #2','Equation to fit Sag Time Constant:','Equation to fit Peak Decay Constant:','Equation to fit hyperpolarized membrane time constant:','Equation to fit depolarized membrane time constant:','Smoothing window to find ADP, AHP (50=wide, 5=narrow):'},'Settings',1,defaults);

if isempty(getinput)
    return;
end
handles.Analysis.ThreshCheck = str2num(getinput{1});
handles.Analysis.ThresholdCalc = str2num(getinput{2});
handles.Analysis.Thresh_1_param = str2num(getinput{3});
handles.Analysis.Thresh_2_param = str2num(getinput{4});
handles.Analysis.SagTauEq = getinput{5};
handles.Analysis.PeakTauEq = getinput{6};
handles.Analysis.HyperTauEq = getinput{7};
handles.Analysis.DepolTauEq = getinput{8};
handles.Analysis.Window = str2num(getinput{9});

Analysis = handles.Analysis;

save([mypath sl 'data' sl 'Analysis.mat'],'Analysis','-v7.3')
guidata(hObject, handles);


% --- Executes on selection change in menu_filter.
function menu_filter_Callback(hObject, eventdata, handles)
global mypath AllCells
% hObject    handle to menu_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'All'
        idx = 1:length(AllCells);
    case 'Data Loaded'
        idx=searchRuns('DataVerified',0,1,'==');
    case 'Sweep Verified'
        idx1=searchRuns('DataVerified',1,1,'==');
        idx2=searchRuns('ThresholdsVerified',0,1,'==');
        idx=intersect(idx1,idx2);
    case 'Thresholds Reviewed'
        idx1=searchRuns('ThresholdsVerified',1,1,'==');
        idx2=searchRuns('Analyzed',0,1,'==');
        idx=intersect(idx1,idx2);
    case 'Analyzed'
        idx=searchRuns('Analyzed',1,1,'==');
    case 'Date Range'
        daterange = inputdlg({'Start Date','End Date'},'Enter Date Range',1,{datestr(now,'dd-mmm-yy'),datestr(now,'dd-mmm-yy')});
        idx1=searchRuns('Date',datenum(daterange{1},'dd-mmm-yy'),1,'>=');
        idx2=searchRuns('Date',datenum(daterange{2},'dd-mmm-yy'),1,'<=');
        idx=intersect(idx1,idx2);
    case 'Cell Type'
        celltype = inputdlg('Enter the cell type:','Cell Type Search',1,{'calbindin'});
        idx=searchRuns('CellType',celltype{:},0,'==');
    case 'Cell Name'
        cellname = inputdlg('Enter the cell name:','Cell Type Search',1,{'cell 3'});
        idx=searchRuns('CellName',cellname{:},0,'==');
    case 'Search Notes'
        notes = inputdlg('Search for the following word or phrase in the notes:','Notes Search',1,{'Case Sensitive'});
        idx=searchRuns('Notes',notes{:},0,'*');
    case 'With Notes'
        idx=searchRuns('Notes','',0,'<');
    case 'Custom Filter'
        searchparams = inputdlg({'Property to search:','Value to search for:','Property type (String: 0, Number: 1):','(Optional) Type (=,~,>,<,*):'},'Enter Search Properties');
        if ~isempty(searchparams)
            searchfield = searchparams{1};
            searchval = searchparams{2};
            numtype = str2double(searchparams{3});
            searchstyle = searchparams{4};
            if numtype==1
                searchval = str2num(searchval);
            end
            if isempty(searchstyle)
                idx=searchRuns(searchfield,searchval,numtype);
            else
                idx=searchRuns(searchfield,searchval,numtype,searchstyle);
            end
        else
            idx=1:length(AllCells);
        end
    otherwise
        idx=1:length(AllCells);
end

updateTable(handles,idx)

function idx=searchRuns(searchfield,searchval,numtype,varargin)
% This function searches through all the runs in RunArray using the
% user-provided search critera: which field to search, which value to
% search for, and what type of relation between the search value and the
% results (should equal, not equal, etc)

global mypath AllCells

searchstyle='==';
searchidx=1:length(AllCells);
if ~isempty(varargin)
    searchstyle=varargin{1};
    if length(varargin)>1
        searchidx=varargin{2};
    end
end
if numtype==0 % string
    % search text fields
    if strcmp(searchstyle,'*')==1
        myt = regexp({AllCells(searchidx).(searchfield)},['[A-Za-z0-9_]*' strrep(searchval,'*','[A-Za-z0-9_]*') '[A-Za-z0-9_]*']);
        tmpidx=[];
        for r=1:length(myt)
            if ~isempty(myt{r})
                tmpidx=[tmpidx searchidx(r)];
            end
        end
    else
        try
        eval(['tmpidx=find(strcmp(searchval,{AllCells(searchidx).(searchfield)})' searchstyle '1);'])
        catch
            tmpidx=[];
        end
    end
elseif numtype==1
    % search numeric fields
    try
    eval(['tmpidx=find([AllCells(searchidx).(searchfield)]' searchstyle 'searchval);'])
    catch
        tmpidx=[];
    end

else
    tmpidx=[];
end
idx=searchidx(tmpidx);

% --- Executes during object creation, after setting all properties.
function menu_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuitem_trainwhistle_Callback(hObject, eventdata, handles)
global wbflg
% hObject    handle to menuitem_trainwhistle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.menuitem_trainwhistle,'Checked'),'on')
    set(handles.menuitem_trainwhistle,'Checked','off')
else
    set(handles.menuitem_trainwhistle,'Checked','on')
end
if wbflg==1
set(handles.btn_website,'Visible','On')
end


% --- Executes on button press in btn_website.
function btn_website_Callback(hObject, eventdata, handles)
global mypath sl AllCells
% hObject    handle to btn_website (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(websitepath,'dir')==0
    mkdir(websitepath)
end
makecellsite(AllCells,handles,websitepath)

msgbox({'Your website template is available in:',websitepath})



% --- Executes on button press in btn_import.
function btn_import_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load(['data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end

cellclamppath = [myrepos(q).dir sl 'cellclamp_results'];

uiwait(evalin('base', 'PickCellClampResults'))
if exist([mypath sl 'data' sl 'MyCells.mat'],'file')==0
    return;
end

load([mypath sl 'data' sl 'MyCells.mat'])

for r=1:length(MyCells)
    results2use{r}=MyCells(r).Run;
end

%results2use = {'667','668','669','670','785','786'}; % {'822'};

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
websitepath=[myrepos(q).dir(1:wtmp(end)) 'websites' myrepos(q).dir(wtmp(end):end)];
if exist(websitepath,'dir')==0
    mkdir(websitepath)
end

cellfilespath=[mypath sl 'cellfiles'];

makeaxoclampfile(cellclamppath, results2use,cellfilespath,websitepath) % cellclamppath, results2use, cellfilespath, websitepath

files={};
for r=1:length(MyCells)    
    bcells=regexp(MyCells(r).Cells,';','split');    
    for b=1:length(bcells)-1
        files{length(files)+1} = [bcells{b} '_' MyCells(r).Run '.atf'];
    end    
end

% files={'pyramidalcell_786.atf','olmcell_670.atf','scacell_668.atf'};

if ispc
    sl='\';
else
    sl='/';
end
btn_load_Callback(hObject,eventdata,handles,files,[cellfilespath sl])


% --------------------------------------------------------------------
function menuitem_openother_Callback(hObject, eventdata, handles)
global mypath sl AllCells

% hObject    handle to menuitem_openother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveCells(handles)

[FILENAME, PATHNAME] = uigetfile('.mat', 'Pick Cells File','AllCellsData');
if ischar(PATHNAME)==0
    return;
end

handles.viewother = [PATHNAME FILENAME];
guidata(hObject, handles);
try
    load(handles.viewother,'AllCells')
    for m=1:length(AllCells)
        load(handles.viewother,AllCells(m).DetailedData)
        save([mypath sl 'data' sl 'DetailedData' sl AllCells(m).DetailedData '.mat'],AllCells(m).DetailedData,'-v7.3')
    end
catch
    load(handles.viewother,'ArchivedCells')
    AllCells = ArchivedCells;
    for m=1:length(AllCells)
        load(handles.viewother,AllCells(m).DetailedData)
        save([mypath sl 'data' sl 'DetailedData' sl AllCells(m).DetailedData '.mat'],AllCells(m).DetailedData,'-v7.3')
    end
end
set(handles.menuitem_closeother,'Enable','On')
set(handles.menuitem_openother,'Enable','Off')
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
msgbox('Now in view mode.')

% --------------------------------------------------------------------
function menuitem_closeother_Callback(hObject, eventdata, handles)
global mypath sl AllCells

% hObject    handle to menuitem_closeother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myans = questdlg('Save changes to this dataset before closing?','Save Changes','Yes','No','Cancel','No');
switch myans
    case 'Yes'
        save(handles.viewother,'AllCells','-v7.3');
    case 'No'
        %save(handles.viewother,'AllCellsNew','-append');
    case 'Cancel'
        return
end
handles.viewother = '';
guidata(hObject, handles);
if exist([mypath sl 'data' sl 'AllCellsData.mat'],'file')
    load([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells');
else
    AllCells=[];
end
set(handles.menuitem_closeother,'Enable','Off')
set(handles.menuitem_openother,'Enable','On')
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
msgbox('Closed viewing mode and reloaded original cells')



% --------------------------------------------------------------------
function menuitem_addother_Callback(hObject, eventdata, handles)
global mypath sl AllCells
% hObject    handle to menuitem_addother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.viewother)
    msgbox('Can''t append cells in view mode.')
    return;
end

saveCells(handles)

[FILENAME, PATHNAME] = uigetfile('.mat', 'Pick Cells File','AllCellsData');
if ischar(PATHNAME)==0
    return;
end

guidata(hObject, handles);
myi=[];
try
    tmpCells = load([PATHNAME FILENAME],'AllCells');
    addCells=chknames(tmpCells.AllCells);
    AllCells=[AllCells addCells];
    for m=1:length(addCells)
        if ~isempty(addCells(m).DetailedData)
            load([PATHNAME FILENAME],addCells(m).DetailedData)
        end
        if exist(addCells(m).DetailedData,'var')
            save([mypath sl 'data' sl 'DetailedData' sl addCells(m).DetailedData '.mat'],addCells(m).DetailedData,'-v7.3')
        else
            myi = [myi (length(AllCells)-length(addCells)+m)];
        end
    end
catch
    tmpCells = load([PATHNAME FILENAME],'ArchivedCells');
    addCells=chknames(tmpCells.ArchivedCells);
    AllCells=[AllCells addCells];
    for m=1:length(addCells)
        if ~isempty(addCells(m).DetailedData)
            load([PATHNAME FILENAME],addCells(m).DetailedData)
        end
        if exist(addCells(m).DetailedData,'var')
            save([mypath sl 'data' sl 'DetailedData' sl addCells(m).DetailedData '.mat'],addCells(m).DetailedData,'-v7.3')
        else
            myi = [myi (length(AllCells)-length(addCells)+m)];
        end
    end
end
if length(addCells)<1
    return
end
%AllCells=[AllCells tmpCells.AllCells];
%myi=(length(AllCells)-length(addCells)+1):length(AllCells);
reorgCellData(myi)
saveCells(handles)
menu_filter_Callback(handles.menu_filter,[],handles) % updateTable(handles);
msgbox('Cells have been added to your collection.')

function newcells=chknames(newcells)
global mypath AllCells

for i=length(newcells):-1:1
    idx = searchRuns('FileName',newcells(i).FileName,0,'==');
    if isempty(idx)
        continue
    end
    myans=questdlg(['File "' newcells(i).FileName '" is already loaded. Keep old file or replace with new file?'],'Which file','Old','New','Old');
    switch myans
        case 'Old'
            newcells(i)=[];
        case 'New'
            AllCells(idx)=[];
    end
end


% --------------------------------------------------------------------
function menuitem_general_Callback(hObject, eventdata, handles)
% hObject    handle to menuitem_general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ismac
    handles.general.pdfviewer= 'open';
elseif isunix
    handles.general.pdfviewer= 'xdg-open';
else
    handles.general.pdfviewer = ' ';
end
guidata(hObject, handles);


function reorgCellData(varargin)
global mypath sl AllCells

if length(varargin)>1 || isempty(varargin)
    save([mypath sl 'data' sl 'AllCellsDataBackup.mat'],'AllCells','-v7.3')
end

rrange=1:length(AllCells);
if ~isempty(varargin)
    rrange=varargin{1};
end

for r=rrange
    AllCells(r).DetailedData=['t' strrep(strrep(strrep(strrep(strrep(strrep(AllCells(r).CellName,' ',''),'-',''),'(',''),')',''),'.',''),',','')];
    if exist([mypath sl 'data' sl 'DetailedData' sl AllCells(r).DetailedData '.mat'],'file')
        load([mypath sl 'data' sl 'DetailedData' sl AllCells(r).DetailedData '.mat'],AllCells(r).DetailedData)
    end

    if ~isempty(AllCells(r).AxoClampData)
        eval([AllCells(r).DetailedData '.AxoClampData = AllCells(r).AxoClampData;'])
    end
    if ~isempty(AllCells(r).SpikeData)
        eval([AllCells(r).DetailedData '.SpikeData = AllCells(r).SpikeData;'])
    end
    if ~isempty(AllCells(r).OtherData)
        eval([AllCells(r).DetailedData '.OtherData = AllCells(r).OtherData;'])
    end
    if ~isempty(AllCells(r).TableData)
        eval([AllCells(r).DetailedData '.TableData = AllCells(r).TableData;'])
    end
    if exist(AllCells(r).DetailedData,'var')==0
        AllCells(r).DetailedData='';
        continue
    end
    save([mypath sl 'data' sl 'DetailedData' sl AllCells(r).DetailedData '.mat'],AllCells(r).DetailedData,'-v7.3')
    eval(['DetailedData = ' AllCells(r).DetailedData ';'])
    AllCells(r).CurrentRange = [num2str(DetailedData.AxoClampData.Currents(1)) ':' num2str(DetailedData.AxoClampData.CurrentStepSize) ':' num2str(DetailedData.AxoClampData.Currents(end))];
    AllCells(r).AxoClampData=[];
    AllCells(r).SpikeData=[];
    AllCells(r).OtherData=[];
    AllCells(r).TableData=[];
end
if length(varargin)>1 || isempty(varargin)
    save([mypath sl 'data' sl 'AllCellsData.mat'],'AllCells','-v7.3')
end

function m=mymean(myvec)
myvec(isnan(myvec))=[];
if isempty(myvec)
    m=NaN;
else
    m=mean(myvec);
end

function s=mystd(myvec)
myvec(isnan(myvec))=[];
if isempty(myvec)
    s=NaN;
else
    s=std(myvec);
end


% --------------------------------------------------------------------
function menuitem_reanalyze_Callback(hObject, eventdata, handles)
global mypath AllCells
% hObject    handle to menuitem_reanalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for h=length(handles.indices):-1:1
    if AllCells(handles.indices(h)).Analyzed==0
        handles.indices(h)=[];
    end
end

guidata(handles.btn_analyze,handles)

btn_analyze_Callback(handles.btn_analyze, [], handles,1)


% --- Executes when selected cell(s) is changed in tbl_ressag.
function tbl_ressag_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tbl_ressag (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global mypath DetailedData

return

if (isfield(eventdata,'Indices') ||  isprop(eventdata,'Indices')) && numel(eventdata.Indices)>0  && length(eventdata.Indices)>0
    m=eventdata.Indices(1,1);


    cla(handles.ax_display)
    hold(handles.ax_display,'off')
    plotyy(handles.ax_display,DetailedData.AxoClampData.Time(m).Data,DetailedData.AxoClampData.Data(m).CurrentInjection,DetailedData.AxoClampData.Time(m).Data,DetailedData.AxoClampData.Data(m).RecordedVoltage);
    clipboard('copy', [DetailedData.AxoClampData.Time(m).Data(:) DetailedData.AxoClampData.Data(m).CurrentInjection(:)])
end
