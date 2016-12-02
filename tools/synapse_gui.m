function varargout = synapse_gui(varargin)
% SYNAPSE_GUI M-file for synapse_gui.fig
%      SYNAPSE_GUI, by itself, creates a new SYNAPSE_GUI or raises the existing
%      singleton*.
%
%      H = SYNAPSE_GUI returns the handle to a new SYNAPSE_GUI or the handle to
%      the existing singleton*.
%
%      SYNAPSE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNAPSE_GUI.M with the given input arguments.
%
%      SYNAPSE_GUI('Property','Value',...) creates a new SYNAPSE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synapse_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synapse_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synapse_gui

% Last Modified by GUIDE v2.5 05-Mar-2013 14:11:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synapse_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @synapse_gui_OutputFcn, ...
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


% --- Executes just before synapse_gui is made visible.
function synapse_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synapse_gui (see VARARGIN)
global mypath sl

% Choose default command line output for synapse_gui
handles.output = hObject;
load([mypath sl 'data' sl 'myrepos.mat'], 'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end
handles.repos = myrepos(q).dir;

if exist([handles.repos sl 'datasets' sl 'syns.mat'])
load([handles.repos sl 'datasets' sl 'syns.mat'],'syns');
%load tools/syns.mat syns
handles.syns = syns;
else
    handles.syns = [];
end

if ispc
    handles.dl = ' & ';
else %if isunix
    handles.dl = ';';
end

load([mypath sl 'data' sl 'MyOrganizer.mat'], 'general')

handles.general=general;
clear general

cellnums_CreateFcn(handles.cellnums, [], handles)
contents = cellstr(get(handles.cellnums,'String'));
handles.curnumfile = ['cellnumbers_' contents{get(handles.cellnums,'Value')} '.dat'];
fid = fopen([handles.repos sl 'datasets' sl handles.curnumfile],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

artcells=[];
realcells=[];
for v=1:length(filedata{1}) %RunArray(ind).NumCellTypes % rows
    % filedata{1}{v}; % cell type
    % filedata{2}{v}; % tech type
    % filedata{5}(v); % is art
    if filedata{5}(v)==1
        artcells=[artcells v];
    else
        realcells=[realcells v];
    end
end






% a=dir(handles.repos '/cellframes/class_*cell.hoc');
% for t=1:length(a)
%     a(t).name = a(t).name(7:end-4);
% end
% b=dir(handles.repos '/cells/class_pp*.hoc');
% for t=1:length(b)
%     b(t).name = b(t).name(7:end-4);
% end

handles.cellnames ={filedata{1}{realcells}};
handles.artcells = {filedata{1}{artcells}};
precells = [handles.artcells handles.cellnames];
handles.prop = {'precell','syntype','seclist','range_st','range_en','scaling','tau1','tau2','e','tau1a','tau2a','ea','tau1b','tau2b','eb'}; %, 'strength', 'numcons'};
handles.data=[];
for r=1:length(handles.cellnames)
    handles.data.(handles.cellnames{r})=[];
    for v=1:length(precells)
        handles.data.(handles.cellnames{r}).(precells{v})=[];
        handles.data.(handles.cellnames{r}).(precells{v}).syns=[];
        handles.data.(handles.cellnames{r}).(precells{v}).syns.(handles.prop{1})='';
        for z=2:length(handles.prop)
            handles.data.(handles.cellnames{r}).(precells{v}).syns.(handles.prop{z})=[];
        end
    end
end

clear syns
%set(handles.tableh,'ColumnFormat',{'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'});
numcon = get(handles.tableh, 'Data');
numcon = repmat(numcon(1,1:length(handles.prop)),length(handles.cellnames)*2,1);
set(handles.tableh, 'Data', numcon);
handles.blanknumcon = numcon;

set(handles.menu_postcell,'String',handles.cellnames);
set(handles.menu_section,'String',precells);

handles.oldpostcell=handles.cellnames{1};
% Update handles structure
guidata(hObject, handles);
menu_conndatas_CreateFcn(handles.menu_conndatas, [], handles)
menu_conndatas_Callback(handles.menu_conndatas, [], handles)

% --- Executes on selection change in menu_conndatas.
function menu_conndatas_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_conndatas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conndatas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conndatas

contents = cellstr(get(hObject,'String'));
handles.curfile = ['syndata_' contents{get(hObject,'Value')} '.dat'];
guidata(hObject, handles);

x = str2num(handles.curfile([end-6:end-4]));
if ~isempty(handles.syns)
    sidx = 1;
    for r=1:length(handles.syns)
        if handles.syns(r).num==str2num(contents{get(hObject,'Value')})
            sidx = r;
        end
    end
        
    contents = cellstr(get(handles.cellnums,'String'));
    if ~isfield(handles.syns,'numdata')
        handles.syns(sidx).numdata = [];
    end
    mynumdata = strmatch(num2str(handles.syns(sidx).numdata),contents);
    if length(mynumdata)==1
        set(handles.cellnums,'Value',mynumdata)
    else
        set(handles.cellnums,'Value',1)
    end
set(handles.txt_comment,'String', handles.syns(sidx).comments)
end

%gohere


if isfield(handles,'numcon')
    set_numcons(hObject,handles)
else
    if isempty(handles.syns)
        x=1;

        t = dir([handles.repos sl 'datasets' sl handles.curfile]);
        contents = cellstr(get(handles.cellnums,'String'));
        NumDataStr = contents{get(handles.cellnums,'Value')};

        handles.syns(x).name = handles.curfile;
        handles.syns(x).date = t.date;
        handles.syns(x).comments = '';
        handles.syns(x).num = 100;
        handles.syns(x).numdata = str2num(NumDataStr);
        guidata(hObject, handles);
    end
    reload(handles.btn_new,handles)
end


% UIWAIT makes synapse_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function set_numcons(hObject,handles)
%ind = handles.curses.ind;
space4title = 42*2+21; %pixels

if exist(handles.curfile)
    reload(hObject,handles);
end
handles=guidata(hObject);

fig_units = get(handles.figure1,'Units');
tbl_units = get(handles.tableh,'Units');

btn_array={'btn_view','menu_section','btn_add','submitNumCon','btn_reload','menu_conndatas','btn_new','cellnums','txt_comment','lbl_pre','lbl_post','menu_postcell'};

for r=1:length(btn_array)
    btn_units.(btn_array{r}) = get(handles.(btn_array{r}), 'Units');
    set(handles.(btn_array{r}),'Units','Pixels');
    btn_pos.(btn_array{r}) = get(handles.(btn_array{r}),'Position');
end

set(handles.figure1,'Color', 'w', 'Visible', 'on', 'Units', 'pixels'); %, 'Position', [520 380 560 420]);

set(handles.tableh, 'Data', handles.numcon,'Units','pixels');

textent = get(handles.tableh,'Extent');

myfigpos = get(handles.figure1,'Position');
mynewfigpos = [myfigpos(1) myfigpos(2) textent(3) textent(4)+space4title];

for r=1:length(btn_array)
    btndiff = myfigpos(4) - btn_pos.(btn_array{r})(2);
    newbtnpos = mynewfigpos(4)-btndiff;
    btn_pos.(btn_array{r})(2)=newbtnpos;
    set(handles.(btn_array{r}),'Position',btn_pos.(btn_array{r}));
    %btndiff = myfigpos(3:4) - btn_pos.(btn_array{r})(1:2);
    %newbtnpos = mynewfigpos(3:4)-btndiff;
    %btn_pos.(btn_array{r})(1:2)=newbtnpos;
    %set(handles.(btn_array{r}),'Position',btn_pos.(btn_array{r}));
end

set(handles.figure1,'Position',mynewfigpos);
set(handles.figure1,'Units',fig_units);
set(handles.tableh,'Position',[0 0 textent(3) textent(4)]);
set(handles.tableh,'Units',tbl_units);

for r=1:length(btn_array)
    set(handles.(btn_array{r}),'Units',btn_units.(btn_array{r}));
end

%axh = axes('Units',get(handles.figure1,'Units'),'Position',[0 textent(4) textent(3) space4title],'xlim',[0 1],'ylim',[0 1]);
%axis off

%text(.5,.5,'Connection Matrix','Parent',axh,'FontSize',18,'HorizontalAlignment','center')


% --- Outputs from this function are returned to the command line.
function varargout = synapse_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in submitNumCon.
function submitNumCon_Callback(hObject, eventdata, handles)
% hObject    handle to submitNumCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath sl

% update handles structure
numcon = get(handles.tableh, 'Data');

handles.data.(handles.oldpostcell)=[];
for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    precell = numcon{v,1};
    if isempty(precell)
        continue
    end
    if ~isfield(handles.data.(handles.oldpostcell),precell)
        handles.data.(handles.oldpostcell) = setfield(handles.data.(handles.oldpostcell),precell,[]);
        handles.data.(handles.oldpostcell).(precell).syns = [];
    end
    z=length(handles.data.(handles.oldpostcell).(precell).syns)+1;

    for w = 2:length(handles.prop)
        handles.data.(handles.oldpostcell).(precell).syns(z).(handles.prop{w}) = numcon{v,w};
    end
end



% get numsyns
postcells = fieldnames(handles.data);
numsyns = 0;
for r=1:length(postcells)
    if ~isempty(handles.data.(postcells{r}))
        level_2_fields = fieldnames(handles.data.(postcells{r}));
        for z=1:length(level_2_fields)
            numsyns = numsyns + length(handles.data.(postcells{r}).(level_2_fields{z}).syns);
        end
    end
end

pf = fieldnames(handles.data);
for p=1:length(pf)
    try
    pr = fieldnames(handles.data.(pf{p}));
    catch me
        continue
    end
    for r=1:length(pr)
        ff=fieldnames(handles.data.(pf{p}).(pr{r}).syns);
        for f=1:length(ff)
            for s=1:length(handles.data.(pf{p}).(pr{r}).syns)
                if isnumeric(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})=[];
                    end
                elseif iscell(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}){:})
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})='';
                    end
                else
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})='';
                    end
                end
            end
        end
    end
end

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');                
fprintf(fid,'%d\n', numsyns);
for w=1:length(postcells) % postcell
    if ~isempty(handles.data.(postcells{w}))
        precells = fieldnames(handles.data.(postcells{w}));
        for v=1:length(precells) % precell
            if ~isempty(handles.data.(postcells{w}))
                for z = 1:length(handles.data.(postcells{w}).(precells{v}).syns)
                    try
                        fprintf(fid,'%s %s', postcells{w}, precells{v});
                    catch
                        fprintf(fid,'%s %s', postcells{w}, precells{v});
                    end
                    if isempty(handles.data.(postcells{w}).(precells{v}).syns(z).scaling) || (iscell(handles.data.(postcells{w}).(precells{v}).syns(z).scaling) && isempty(handles.data.(postcells{w}).(precells{v}).syns(z).scaling{1})) || strcmp(handles.data.(postcells{w}).(precells{v}).syns(z).scaling,'none')==1
                        handles.data.(postcells{w}).(precells{v}).syns(z).scaling = '';
                        if isempty(handles.data.(postcells{w}).(precells{v}).syns(z).tau1a)
                            fprintf(fid,' %s', 'MyExp2Sid');
                        else
                            fprintf(fid,' %s', 'ExpGABAab');
                        end
                    else
                        fprintf(fid,' %s', 'MyExp2Sidnw'); %'MyExp2Sidnw');
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).seclist{:});
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).seclist);
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_st{:});
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_st);
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_en{:});
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_en);
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).scaling{:});
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).scaling);
                    end
                    for k=7:length(handles.prop)
                        try
                            fprintf(fid,' %f', handles.data.(postcells{w}).(precells{v}).syns(z).(handles.prop{k}));
                        catch
                            fprintf(fid,' %f', handles.data.(postcells{w}).(precells{v}).syns(z).(handles.prop{k}){:});
                        end
                    end
                    fprintf(fid,'\n');
                end
            end
        end
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%

x = str2num(handles.curfile([end-6:end-4]));

if isempty(handles.syns)
    sidx=1;
    handles.cells(sidx).num=x;
    handles.cells(sidx).comments='This dataset was not added via SimTracker. Please add comments.';
else
    sidx = find([handles.syns(:).num]==x);
    if isempty(sidx)
        sidx=length(handles.syns)+1;
        handles.cells(sidx).num=x;
        handles.cells(sidx).comments='This dataset was not added via SimTracker. Please add comments.';
    end
end

try
    handles.syns(sidx).comments=char(get(handles.txt_comment,'String'));
catch
    handles.syns(sidx).comments=get(handles.txt_comment,'String');
end
if isfield(handles.syns(sidx),'date')==0 || isempty(handles.syns(sidx).date)
    t = dir([handles.repos sl 'datasets' sl handles.curfile]);
    handles.syns(sidx).date=t.date;
end
syns = handles.syns;
save([handles.repos sl 'datasets' sl 'syns.mat'],'syns','-v7.3');
%save tools/syns.mat syns;
guidata(hObject, handles);


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reload(hObject,handles)

function reload(hObject,handles)
%c = importdata([handles.repos '/datasets/' handles.curfile], ' ', 1);
%handles.prop = {'secname', 'secpos','tau1','tau2','e','sid', 'strength', 'numcons'};
global mypath sl

if isempty(handles.curfile) || exist([handles.repos sl 'datasets' sl handles.curfile],'file')==0
    return
end
fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'r'); %gohere
numlines = textscan(fid,'%d\n',1);
propstr=' %f %f %f %f %f %f %f %f %f';
c = textscan(fid,['%s %s %s %s %s %s %s' propstr '\n'],'Delimiter',' ', 'MultipleDelimsAsOne',0);
st = fclose(fid);

numcon = handles.blanknumcon;
handles.data=[];

if size(c{1,1},1)>0
    for r=1:numlines{1,1}
        try
        postcell = c{1,1}{r};
        catch
            'test'
        end
        precell = c{1,2}{r};
%         if strcmp(precell,'bistratifiedcell')==1
%             'test'
%         end
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
        handles.data.(postcell).(precell).syns(n).syntype = c{1,3}(r);
        handles.data.(postcell).(precell).syns(n).seclist = c{1,4}(r);
        handles.data.(postcell).(precell).syns(n).range_st = c{1,5}(r);
        handles.data.(postcell).(precell).syns(n).range_en = c{1,6}(r);
        handles.data.(postcell).(precell).syns(n).scaling = c{1,7}(r);
        for z = 7:length(handles.prop)
            handles.data.(postcell).(precell).syns(n).(handles.prop{z}) = c{1,z+1}(r);
        end
    end
else
    for r=1:length(handles.cellnames)
        handles.data.(handles.cellnames{r})=[];
        for v=1:length(handles.cellnames)
            handles.data.(handles.cellnames{r}).(handles.cellnames{v})=[];
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns=[];
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{2})='';
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{3})='';
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{4})='';
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{5})='';
            handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{6})='';
            for z=7:length(handles.prop)
                handles.data.(handles.cellnames{r}).(handles.cellnames{v}).syns.(handles.prop{z})=[];
            end
        end
    end
end

cellnames = fieldnames(handles.data);

% set the postcell menu to the first cellname
%set(handles.menu_postcell,'String', handles.cellnames)
set(handles.menu_postcell,'Value', 1)

postcell = cellnames{1};
handles.oldpostcell = postcell;

n = 1;
precells = fieldnames(handles.data.(postcell));
for v=1:length(precells) % RunArray(ind).NumCellTypes % rows
    precell = precells{v};
    if isfield(handles.data.(postcell).(precell), 'syns') && ~isempty(handles.data.(postcell).(precell).syns)
        for z = 1:length(handles.data.(postcell).(precell).syns)
            if isempty(handles.data.(postcell).(precell).syns(z).tau1) && isempty(handles.data.(postcell).(precell).syns(z).tau1a)
                continue
            end
            numcon{n,1} = precell;
            try
                numcon{n,2} = handles.data.(postcell).(precell).syns(z).syntype{:};
            catch
                numcon{n,2} = handles.data.(postcell).(precell).syns(z).syntype;
            end
            try
                numcon{n,3} = handles.data.(postcell).(precell).syns(z).seclist{:};
            catch
                numcon{n,3} = handles.data.(postcell).(precell).syns(z).seclist;
            end
            try
                numcon{n,4} = handles.data.(postcell).(precell).syns(z).range_st{:};
            catch
                numcon{n,4} = handles.data.(postcell).(precell).syns(z).range_st;
            end
            try
                numcon{n,5} = handles.data.(postcell).(precell).syns(z).range_en{:};
            catch
                numcon{n,5} = handles.data.(postcell).(precell).syns(z).range_en;
            end
            try
                numcon{n,6} = handles.data.(postcell).(precell).syns(z).scaling{:};
            catch
                numcon{n,6} = handles.data.(postcell).(precell).syns(z).scaling;
            end
            for w = 7:length(handles.prop)
                if ~isnan(handles.data.(postcell).(precell).syns(z).(handles.prop{w}))
                    try
                        numcon(n,w) = handles.data.(postcell).(precell).syns(z).(handles.prop{w});
                    catch
                        numcon(n,w) = {handles.data.(postcell).(precell).syns(z).(handles.prop{w})};
                    end
                end
            end
            n=n+1;
        end
    end
end

set(handles.tableh, 'Data', numcon, 'ColumnName', handles.prop) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
%handles.cellnames = cellnames;
handles.numcon = numcon;

x = str2num(handles.curfile([9:end-4]));
b=[];
for r=1:length(handles.syns)
    if handles.syns(r).num==x
        b=r;
    end
end
%b=find([handles.syns.num]==x);
set(handles.txt_comment,'String', handles.syns(b).comments)

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_conndatas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_conndatas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mypath sl

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

load([mypath sl 'data' sl 'myrepos.mat'], 'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end
handles.repos = myrepos(q).dir;
guidata(hObject, handles);


a=dir([handles.repos sl 'datasets' sl 'syndata_*.dat']);
if ~isempty(a)
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'syndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>20
            numvec{length(numvec)+1}=tk{1}{:};
        end
    end
    set(hObject,'String',fliplr(numvec));


    contents = cellstr(get(hObject,'String'));
    handles.curfile = ['syndata_' contents{get(hObject,'Value')} '.dat'];
end
guidata(hObject, handles);



% --- Executes on button press in btn_new.
function btn_new_Callback(hObject, eventdata, handles)
% hObject    handle to btn_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath sl

maxsyn=99;
a=dir([handles.repos sl 'datasets' sl 'syndata_*.dat']);
for r=1:length(a)
    tk = regexp(a(r).name,'syndata_(\d*).dat','tokens');
    numtk = str2num(tk{1}{:});
    if numtk>maxsyn
        maxsyn = numtk;
    end
end

handles.curfile = ['syndata_' sprintf('%03.0f', maxsyn+1) '.dat'];

% handles.prop = {'secname', 'secpos','tau1','tau2','e','sid', 'strength', 'numcons'};
pr = length(handles.prop);

% get numsyns
postcells = fieldnames(handles.data);
precells = [handles.artcells handles.cellnames];
numsyns = 0;
for w=1:length(postcells)
    if ~isempty(handles.data.(postcells{w}))
        %level_2_fields = fieldnames(handles.data.(postcells{r}));
        for v=1:length(precells)
            if isfield(handles.data.(postcells{w}), precells{v}) && ~isempty(handles.data.(postcells{w}).(precells{v}))
                numsyns = numsyns + length(handles.data.(postcells{w}).(precells{v}).syns);
            end
        end
    end
end

pf = fieldnames(handles.data);
for p=1:length(pf)
    pr = fieldnames(handles.data.(pf{p}));
    for r=1:length(pr)
        ff=fieldnames(handles.data.(pf{p}).(pr{r}).syns);
        for f=1:length(ff)
            for s=1:length(handles.data.(pf{p}).(pr{r}).syns)
                if isnumeric(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})=[];
                    end
                elseif iscell(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}){:})
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})='';
                    end
                else
                    if isnan(handles.data.(pf{p}).(pr{r}).syns(s).(ff{f}))
                        handles.data.(pf{p}).(pr{r}).syns(s).(ff{f})='';
                    end
                end
            end
        end
    end
end

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');                
fprintf(fid,'%d\n', numsyns);
for w=1:length(postcells) % postcell
    if ~isempty(handles.data.(postcells{w}))
        for v=1:length(precells) % precell
            if isfield(handles.data.(postcells{w}), precells{v}) && ~isempty(handles.data.(postcells{w}).(precells{v}))
                for z = 1:length(handles.data.(postcells{w}).(precells{v}).syns)
                    try
                        fprintf(fid,'%s %s', postcells{w}, precells{v});
                    catch
                        fprintf(fid,'%s %s', postcells{w}, precells{v});
                    end
                    if isempty(handles.data.(postcells{w}).(precells{v}).syns(z).scaling) || (iscell(handles.data.(postcells{w}).(precells{v}).syns(z).scaling) && isempty(handles.data.(postcells{w}).(precells{v}).syns(z).scaling{1})) || strcmp(handles.data.(postcells{w}).(precells{v}).syns(z).scaling,'none')==1
                        handles.data.(postcells{w}).(precells{v}).syns(z).scaling = '';
                        if isempty(handles.data.(postcells{w}).(precells{v}).syns(z).tau1a)
                            fprintf(fid,' %s', 'MyExp2Sid');
                        else
                            fprintf(fid,' %s', 'ExpGABAab');
                        end
                    else
                        fprintf(fid,' %s', 'MyExp2Sidnw'); %'MyExp2Sidnw');
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).seclist);
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).seclist{:});
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_st);
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_st{:});
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_en);
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).range_en{:});
                    end
                    try
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).scaling);
                    catch
                        fprintf(fid,' %s', handles.data.(postcells{w}).(precells{v}).syns(z).scaling{:});
                    end
                    for k=7:length(handles.prop)
                        try
                            fprintf(fid,' %f', handles.data.(postcells{w}).(precells{v}).syns(z).(handles.prop{k}));
                        catch
                            fprintf(fid,' %f', handles.data.(postcells{w}).(precells{v}).syns(z).(handles.prop{k}){:});
                        end
                    end
                    fprintf(fid,'\n');
                end
            end
        end
    end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%
x = str2num(handles.curfile([9:end-4]));
%handles.syns(x).comments=get(handles.txt_comment,'String');

%%%%%%%%%%%%%%%%%%

t = dir([handles.repos sl 'datasets' sl handles.curfile]);
comments = inputdlg('Enter comments about this connection set:','Comments');comments=comments{:};
if isempty(comments)
    return
end
contents = cellstr(get(handles.cellnums,'String'));
NumDataStr = contents{get(handles.cellnums,'Value')};

handles.syns(x).name = handles.curfile;
handles.syns(x).date = t.date;
handles.syns(x).comments = comments;
handles.syns(x).num = x;
handles.syns(x).numdata = str2num(NumDataStr);

syns = handles.syns;
save([handles.repos sl 'datasets' sl 'syns.mat'],'syns','-v7.3');
guidata(hObject, handles);

menu_conndatas_CreateFcn(handles.menu_conndatas, [], handles)
set(handles.menu_conndatas,'Value',1) % length(get(handles.menu_conndatas,'String')))

set(handles.txt_comment,'String', handles.syns(x).comments)
guidata(hObject, handles);

reload(hObject,handles)

function txt_comment_Callback(hObject, eventdata, handles)
% hObject    handle to txt_comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_comment as text
%        str2double(get(hObject,'String')) returns contents of txt_comment as a double

% --- Executes during object creation, after setting all properties.
function txt_comment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_postcell.
function menu_postcell_Callback(hObject, eventdata, handles)
% hObject    handle to menu_postcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_postcell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_postcell

% save previous data
numcon = get(handles.tableh, 'Data');

handles.data.(handles.oldpostcell)=[];
for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    precell = numcon{v,1};
    if isempty(precell)
        continue
    end
    if ~isfield(handles.data.(handles.oldpostcell),precell)
        handles.data.(handles.oldpostcell) = setfield(handles.data.(handles.oldpostcell),precell,[]);
        handles.data.(handles.oldpostcell).(precell).syns = [];
    end
    z=length(handles.data.(handles.oldpostcell).(precell).syns)+1;
    for w = 2:length(handles.prop)
        handles.data.(handles.oldpostcell).(precell).syns(z).(handles.prop{w}) = numcon{v,w};
    end
end

numcon = handles.blanknumcon;

% load in new data
contents = cellstr(get(hObject,'String'));
postcell = contents{get(hObject,'Value')};

if isfield(handles.data, postcell) && ~isempty(handles.data.(postcell))
    precells = fieldnames(handles.data.(postcell));
    n=1;
    for v=1:length(precells) %RunArray(ind).NumCellTypes % rows
        precell = precells{v};
        for z=1:length(handles.data.(postcell).(precell).syns)
            if isempty(handles.data.(postcell).(precell).syns(z).tau1) && isempty(handles.data.(postcell).(precell).syns(z).tau1a)
                continue
            end
            numcon{n,1} = precell;
            try
                numcon{n,2} = handles.data.(postcell).(precell).syns(z).syntype{:};
            catch
                numcon{n,2} = handles.data.(postcell).(precell).syns(z).syntype;
            end
            try
                numcon{n,3} = handles.data.(postcell).(precell).syns(z).seclist{:};
            catch
                numcon{n,3} = handles.data.(postcell).(precell).syns(z).seclist;
            end
            try
                numcon{n,4} = handles.data.(postcell).(precell).syns(z).range_st{:};
            catch
                numcon{n,4} = handles.data.(postcell).(precell).syns(z).range_st;
            end
            try
                numcon{n,5} = handles.data.(postcell).(precell).syns(z).range_en{:};
            catch
                numcon{n,5} = handles.data.(postcell).(precell).syns(z).range_en;
            end
            try
                numcon{n,6} = handles.data.(postcell).(precell).syns(z).scaling{:};
            catch
                numcon{n,6} = handles.data.(postcell).(precell).syns(z).scaling;
            end
            for w = 7:length(handles.prop)
                if isnan(handles.data.(postcell).(precell).syns(z).(handles.prop{w}))
                    handles.data.(postcell).(precell).syns(z).(handles.prop{w})=[];
                end
                try
                    numcon(n,w) = handles.data.(postcell).(precell).syns(z).(handles.prop{w});
                catch
                    numcon(n,w) = {handles.data.(postcell).(precell).syns(z).(handles.prop{w})};
                end
            end
            n = n + 1;
        end
    end
    set(handles.tableh, 'Data', numcon) %, 'RowName', rowname, 'ColumnName', handles.prop) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
else
    set(handles.tableh, 'Data', handles.blanknumcon)
end

% handles.cellnames = rowname;
% handles.rownames = rowname;
handles.numcon = numcon;
handles.oldpostcell = postcell;


% [~, o]=system(['grep "create " handles.repos/cellframes/class_' postcell '.hoc']);
% parts = regexp(o,'\n','split');
% section={};
% for r=1:length(parts)
%     if length(parts{r})>6 && strcmp(parts{r}(1:6),'create')
%         sectmp = regexp(parts{r}(7:end),' ','split');
%         section = [section sectmp];
%     end
% end
% 
% for r=length(section):-1:1
%     if isempty(section{r})
%         section(r)=[];
%     elseif strcmp(section{r}(end),',')
%         section{r}=section{r}(1:end-1);
%     end
% end
% 
% section=sort(section);

set(handles.menu_section,'String',[handles.artcells handles.cellnames]);
set(handles.menu_section,'Value', 1);

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function menu_postcell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_postcell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lbl_pre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbl_pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


        

% --- Executes on selection change in menu_section.
function menu_section_Callback(hObject, eventdata, handles)
% hObject    handle to menu_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_section contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_section


% --- Executes during object creation, after setting all properties.
function menu_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_add.
function btn_add_Callback(hObject, eventdata, handles)
% hObject    handle to btn_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

numcon = get(handles.tableh, 'Data');
g=0;
for r=1:size(numcon,1)
    if isempty(numcon{r,1})
        g=1;
        break;
    end
end
if g==0
    r=r+1;
end

contents = cellstr(get(handles.menu_section,'String'));
precell = contents{get(handles.menu_section,'Value')};

numcon{r,1} = precell;

set(handles.tableh, 'Data', numcon);


% --- Executes on button press in btn_view.
function btn_view_Callback(hObject, eventdata, handles)
% hObject    handle to btn_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mat=[];

postcells = fieldnames(handles.data);
precells='';

for r=1:length(postcells)
    try
    precells = [precells; fieldnames(handles.data.(postcells{r}))];
    catch
        'test'
    end
end
precells = sort(unique(precells));
postcells = sort(postcells);

for c=1:length(postcells)
    for r=1:length(precells)
        if isfield(handles.data.(postcells{c}),precells{r}) && (~isempty(handles.data.(postcells{c}).(precells{r}).syns(1).tau1) || ~isempty(handles.data.(postcells{c}).(precells{r}).syns(1).tau1a))
            mat(r,c)=length(handles.data.(postcells{c}).(precells{r}).syns);
        else
            mat(r,c)=0;
        end
    end
end

fh=figure();
th = uitable(fh,'Data',mat,'RowName', precells, 'ColumnName', postcells);
ext = get(th,'Extent');
pos = get(th,'Position');
figpos = get(fh,'Position');
figpos(3) = ext(3);
figpos(4) = ext(4);
pos(1)=0;
pos(2)=0;
pos(3)=ext(3);
pos(4)=ext(4);
set(fh,'Position', figpos,'Name','# Synapse Types')
set(th,'Position', pos)


% --- Executes on selection change in cellnums.
function cellnums_Callback(hObject, eventdata, handles)
% hObject    handle to cellnums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath sl

% Hints: contents = cellstr(get(hObject,'String')) returns cellnums contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cellnums
contents = cellstr(get(handles.cellnums,'String'));
handles.curnumfile = ['cellnumbers_' contents{get(handles.cellnums,'Value')} '.dat'];
fid = fopen([handles.repos sl 'datasets' sl handles.curnumfile],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

x = str2num(handles.curfile([end-6:end-4]));
sidx = find([handles.syns(:).num]==x);
handles.syns(sidx).numdata=str2num(contents{get(handles.cellnums,'Value')});



artcells=[];
realcells=[];
for v=1:length(filedata{1}) %RunArray(ind).NumCellTypes % rows
    % filedata{1}{v}; % cell type
    % filedata{2}{v}; % tech type
    % filedata{5}(v); % is art
    if filedata{5}(v)==1
        artcells=[artcells v];
    else
        realcells=[realcells v];
    end
end

handles.cellnames ={filedata{1}{realcells}};
handles.artcells = {filedata{1}{artcells}};
precells = [handles.artcells handles.cellnames];

set(handles.menu_postcell,'String',handles.cellnames);
set(handles.menu_section,'String',precells);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cellnums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellnums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mypath sl

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end
handles.repos = myrepos(q).dir;
guidata(hObject, handles);


a=dir([handles.repos sl 'datasets' sl 'cellnumbers_*.dat']);
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'cellnumbers_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=tk{1}{:};
        end
    end
    set(hObject,'String',numvec);
