function varargout = numcons_gui(varargin)
% NUMCONS_GUI M-file for numcons_gui.fig
%      NUMCONS_GUI, by itself, creates a new NUMCONS_GUI or raises the existing
%      singleton*.
%
%      H = NUMCONS_GUI returns the handle to a new NUMCONS_GUI or the handle to
%      the existing singleton*.
%
%      NUMCONS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUMCONS_GUI.M with the given input arguments.
%
%      NUMCONS_GUI('Property','Value',...) creates a new NUMCONS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before numcons_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to numcons_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help numcons_gui

% Last Modified by GUIDE v2.5 16-Feb-2013 19:50:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @numcons_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @numcons_gui_OutputFcn, ...
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


% --- Executes just before numcons_gui is made visible.
function numcons_gui_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl mytableh
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to numcons_gui (see VARARGIN)

% Choose default command line output for numcons_gui
handles.output = hObject;
try
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
set(handles.menu_numdata,'String',numvec);

if exist([handles.repos sl 'datasets' sl 'conns.mat'])
load([handles.repos sl 'datasets' sl 'conns.mat'],'conns');
handles.conns = conns;
else
handles.conns = [];
end
handles.prop = {'weight', 'numcon','numsyn'};
handles.excl = {'ppspont','ppsept','ppstim','ppvec','pyramidalcell','dgbasketcell','dgbistratifiedcell'};

a=dir([handles.repos sl 'cells' sl 'class_*.hoc']);
newcells={};

for r=1:length(a)
    if isempty(find(strcmp(a(r).name(7:end-4),handles.excl)==1, 1))
        newcells{length(newcells)+1} = a(r).name(7:end-4);
    end
end

handles.cellnames = newcells;


a=dir([handles.repos sl 'cells' sl 'class_*cell.hoc']);
newcells={};

for r=1:length(a)
    if isempty(find(strcmp(a(r).name(7:end-4),handles.excl)==1, 1))
        newcells{length(newcells)+1} = a(r).name(7:end-4);
    end
end

handles.columnnames = newcells';

rownames={};
for x=1:length(newcells)
    for z=1:length(handles.prop)
        st = [newcells{x} ' - ' handles.prop{z}];
        rownames = [rownames; st];
    end
end

a=dir([handles.repos sl 'cells' sl 'class_pp*.hoc']);
newcells={};

for r=1:length(a)
    if isempty(find(strcmp(a(r).name(7:end-4),handles.excl)==1, 1))
        newcells{length(newcells)+1} = a(r).name(7:end-4);
    end
end
for x=1:length(newcells)
    for z=length(handles.prop):-1:1
        st = [newcells{x} ' - ' handles.prop{z}];
        rownames = [st; rownames];
    end
end

handles.rownames = rownames;

set(handles.tableh, 'ColumnName', handles.columnnames, 'ColumnEditable', logical(ones(size(handles.columnnames))'), 'RowName', handles.rownames);
handles.numcon = get(handles.tableh,'Data');
handles.numcon = repmat({[]}, length(handles.rownames), length(handles.columnnames));



myzfunc=@context_copymytable_Callback;
myxfunc=@context_pastemytable_Callback;
mycontextmenuz=uicontextmenu('Tag','menu_copy1','Parent',handles.output);
uimenu(mycontextmenuz,'Label','Copy Table','Tag','context_copytable1','Callback',myzfunc);
uimenu(mycontextmenuz,'Label','Paste Into Table','Tag','context_pastetable1','Callback',myxfunc);
set(handles.tableh,'UIContextMenu',mycontextmenuz)

mytableh = handles.tableh;
% Update handles structure
guidata(hObject, handles);
clear conns

%set_numcons(hObject,handles)
menu_conndatas_CreateFcn(handles.menu_conndatas, [], handles)
menu_conndatas_Callback(handles.menu_conndatas, [], handles)
catch ME
    handleME(ME)
end

function context_pastemytable_Callback(hObject,eventdata)
global mypath mytableh

str = clipboard('pastespecial');
set(mytableh,'Data',str.A_pastespecial);


function context_copymytable_Callback(hObject,eventdata)
global mypath mytableh
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mydata=get(mytableh,'Data');
mycol=get(mytableh,'ColumnName');
myrow=get(mytableh,'RowName');

%load parameters
% create a header
% copy each row

str = '\t';
for j=1:size(mydata,2)
    str = sprintf ( '%s%s\t', str, mycol{j} );
end
str = sprintf ( '%s\n', str(1:end-1));
for i=1:size(mydata,1)
    str = sprintf ( '%s%s\t', str,  myrow{i} );
    for j=1:size(mydata,2)
        if ischar(mydata(i,j))
            str = sprintf ( '%s%s\t', str, mydata(i,j) );
        elseif isinteger(mydata(i,j))
            str = sprintf ( '%s%d\t', str, mydata(i,j) );
        else
            str = sprintf ( '%s%f\t', str, mydata(i,j) );
        end
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);

% --- Executes on selection change in menu_conndatas.
function menu_conndatas_Callback(hObject, eventdata, handles)
% hObject    handle to menu_conndatas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_conndatas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_conndatas

contents = cellstr(get(hObject,'String'));
handles.curfile = ['conndata_' contents{get(hObject,'Value')} '.dat'];
guidata(hObject, handles);

if isfield(handles,'curfile') && ~isempty(handles.curfile)  %exist(handles.curfile)
    reload(hObject,handles);
end
handles=guidata(hObject);

set_numcons(hObject,handles)

% UIWAIT makes numcons_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function set_numcons(hObject,handles)
%ind = handles.curses.ind;
space4title = 42*2; %pixels

fig_units = get(handles.figure1,'Units');
tbl_units = get(handles.tableh,'Units');

btn_array={'submitNumCon','btn_reload','menu_conndatas','menu_numtype','btn_new','menu_numdata','txt_comment'}; %,'btn_types'

for r=1:length(btn_array)
    btn_units.(btn_array{r}) = get(handles.(btn_array{r}), 'Units');
    set(handles.(btn_array{r}),'Units','Pixels');
    btn_pos.(btn_array{r}) = get(handles.(btn_array{r}),'Position');
end

set(handles.figure1,'Color', 'w', 'Visible', 'on', 'Units', 'pixels'); %, 'Position', [520 380 560 420]);

set(handles.tableh, 'Data', handles.numcon, 'ColumnName', handles.columnnames, 'ColumnEditable', logical(ones(size(handles.columnnames))'), 'RowName', handles.rownames,'Units','pixels');

textent = get(handles.tableh,'Extent');

myfigpos = get(handles.figure1,'Position');
myval=700;
mynewfigpos = [myfigpos(1) myfigpos(2) max(textent(3),myval) textent(4)+space4title];

for r=1:length(btn_array)
    btndiff = myfigpos(3:4) - btn_pos.(btn_array{r})(1:2);
    newbtnpos = mynewfigpos(3:4)-btndiff;
    btn_pos.(btn_array{r})(1:2)=newbtnpos;
    set(handles.(btn_array{r}),'Position',btn_pos.(btn_array{r}));
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
function varargout = numcons_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in submitNumCon.
function submitNumCon_Callback(hObject, eventdata, handles)
global mypath sl 
% hObject    handle to submitNumCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.menu_numtype,'Value',1) % Total Conn.s should be value 1

% have to call this too? menu_numtype_Callback(handles.menu_numtype, [], handles)

gf.line=[];

numcon = get(handles.tableh,'Data');
rows = get(handles.tableh,'RowName');
cols =  get(handles.tableh,'ColumnName');

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');                
fprintf(fid,'%d\n', length(rows)/3*length(cols));

for v=1:length(rows)/3 %RunArray(ind).NumCellTypes % rows
    myr = rows{(v-1)*3+1};
    m = strfind(myr,' ');
    myrow = myr(1:m(1)-1);
    for w=1:length(cols) %RunArray(ind).NumCellTypes    % columns
        try
            if isnan(numcon{(v-1)*3+1,w})
                numcon{(v-1)*3+1,w}=[];
            end
            if isnan(numcon{(v-1)*3+2,w})
                numcon{(v-1)*3+2,w}=[];
            end
            if isnan(numcon{(v-1)*3+3,w})
                numcon{(v-1)*3+3,w}=[];
            end
            fprintf(fid,'%s %s %f %f %f\n', myrow, cols{w}, numcon{(v-1)*3+1,w}, numcon{(v-1)*3+2,w}, numcon{(v-1)*3+3,w}); % 3 = length(handles.prop)
        catch
            if isnan(numcon((v-1)*3+1,w))
                numcon((v-1)*3+1,w)=0;
            end
            if isnan(numcon((v-1)*3+2,w))
                numcon((v-1)*3+2,w)=0;
            end
            if isnan(numcon((v-1)*3+3,w))
                numcon((v-1)*3+3,w)=0;
            end
            fprintf(fid,'%s %s %f %f %f\n', myrow, cols{w}, numcon((v-1)*3+1,w), numcon((v-1)*3+2,w), numcon((v-1)*3+3,w)); % 3 = length(handles.prop)
        end
    end
end

fclose(fid);

x = str2num(handles.curfile(10:end-4));
if isempty(handles.conns)
    idx=[];
else
    idx = find([handles.conns(:).num]==x);
end
if isempty(idx)
    idx=length(handles.conns)+1;
end

mystr = get(handles.txt_comment,'String');
try
    handles.conns(idx).comments=mystr{:};
catch
    handles.conns(idx).comments=mystr;
end
handles.conns(idx).num = x;
handles.conns(idx).name = handles.curfile;
handles.conns(idx).date = date;

% open file, load in cell types for 
contents = cellstr(get(handles.menu_numdata,'String'));
handles.conns(idx).numdata=str2num(contents{get(handles.menu_numdata,'Value')});
conns = handles.conns;
save([handles.repos sl 'datasets' sl 'conns.mat'],'conns','-v7.3');
%save tools/conns.mat conns;
guidata(hObject, handles);


% function old_submit(handles)
% numcon = get(handles.tableh,'Data');
% 
% for v=1:length(handles.cellnames) %RunArray(ind).NumCellTypes % rows
%     for w=1:length(handles.cellnames) %RunArray(ind).NumCellTypes    % columns
%         printstr='';
%         if sum(numcon((v-1)*length(handles.prop)+[1:length(handles.prop)],w)) == 0
% %             warning off MATLAB:fileNotFound;
% %             delete([handles.repos '/datasets/' handles.cellnames{v} '.' handles.cellnames{w}]);
% %             warning on MATLAB:fileNotFound;
%             continue
%         end
%         for p=1:length(handles.prop)
%             if ~isempty(numcon((v-1)*length(handles.prop)+p,w))
%                 printstr = sprintf('%s%f\n', printstr, (numcon((v-1)*length(handles.prop)+p,w)));
%             end
%         end
%         fid = fopen([handles.repos '/datasets/' handles.cellnames{v} '.' handles.cellnames{w}],'w');                
%         fprintf(fid,'%s', printstr); % weight, delay, probability, numcon
%         fclose(fid);
%     end
% end


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reload(hObject,handles)

function reload(hObject,handles)
global mypath sl
if exist([handles.repos sl 'datasets' sl handles.curfile],'file')==0
    return
end

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

rows = sort(unique(filedata{1}));
gs = strfind(rows,'pp');
fl=[];
bd=1:length(rows);
for r=length(gs):-1:1
    if ~isempty(gs{r})
        fl(length(fl)+1)=r;
        bd(r)=[];
    end
end
bd = [fl bd];
rows=rows(bd);

cols = sort(unique(filedata{2}));
rownames={};

for v=1:length(rows) %RunArray(ind).NumCellTypes % rows
    for p=1:length(handles.prop)
        rownames{(v-1)*length(handles.prop)+p} = [rows{v} ' - ' handles.prop{p}];
    end
end

for v=1:length(rows) %RunArray(ind).NumCellTypes % rows
    for w = 1:length(cols)        
        A = strcmp(filedata{1},rows{v});
        B = strcmp(filedata{2},cols{w});
        idx=find(A==1 & B==1);
        try
            numcon((v-1)*3+1,w) = filedata{3}(idx);
            numcon((v-1)*3+2,w) = filedata{4}(idx);
            numcon((v-1)*3+3,w) = filedata{5}(idx);
        catch
            numcon((v-1)*3+1,w) = 0;
            numcon((v-1)*3+2,w) = 0;
            numcon((v-1)*3+3,w) = 0;
        end
    end
end

set(handles.tableh, 'Data', numcon) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
set(handles.tableh, 'RowName', rownames) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
set(handles.tableh, 'ColumnName', cols) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
handles.cellnames = rows;
handles.rownames = rownames;
handles.columnnames = cols;
handles.numcon = numcon;

if isempty(handles.curfile) || isempty(handles.conns)
    return
end
x = str2num(handles.curfile(10:end-4));
idx = find([handles.conns(:).num]==x);
if isempty(idx)
    msgbox('Can''t find conns entry for this number')
end


set(handles.txt_comment,'String', handles.conns(idx).comments)
contents = cellstr(get(handles.menu_numdata,'String'));
if ~isfield(handles.conns,'numdata')
    handles.conns(idx).numdata = [];
end
nidx = strmatch(num2str(handles.conns(idx).numdata),contents);
if isempty(nidx)
    nidx=1;
end
set(handles.menu_numdata,'Value',nidx(1))

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function menu_conndatas_CreateFcn(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_conndatas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

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

a=dir([handles.repos sl 'datasets' sl 'conndata_*.dat']);
numvec={};
if ~isempty(a)
    for r=1:length(a)
        tk = regexp(a(r).name,'conndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=tk{1}{:};
        end
    end
    set(hObject,'String',fliplr(numvec));

    handles.curfile = ['conndata_' numvec{get(hObject,'Value')} '.dat'];
end
guidata(hObject, handles);


% --- Executes on button press in btn_new.
function btn_new_Callback(hObject, eventdata, handles)
global mypath sl 
% hObject    handle to btn_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.menu_numtype,'Value',1) % Total Conn.s should be value 1

% have to call this too? menu_numtype_Callback(handles.menu_numtype, [], handles)

contents = cellstr(get(handles.menu_conndatas,'String'));
oldx = contents{get(handles.menu_conndatas,'Value')};
oldidx = find([handles.conns(:).num]==str2num(oldx));

maxcon=99;
a=dir([handles.repos sl 'datasets' sl 'conndata_*.dat']);
if ~isempty(a)
    for r=1:length(a)
        tk = regexp(a(r).name,'conndata_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>maxcon
            maxcon = numtk;
        end
    end
end

handles.curfile = ['conndata_' sprintf('%03.0f', maxcon+1) '.dat'];

numcon = get(handles.tableh,'Data');
rows = get(handles.tableh,'RowName');
cols = get(handles.tableh,'ColumnName');

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');                
fprintf(fid,'%d\n', length(rows)/3*length(cols));

for v=1:length(rows)/3 %RunArray(ind).NumCellTypes % rows
    myr = rows{(v-1)*3+1};
    m = strfind(myr,' ');
    myrow = myr(1:m(1)-1);
    for w=1:length(cols) %RunArray(ind).NumCellTypes    % columns
        fprintf(fid,'%s %s %f %f %f\n', myrow, cols{w}, numcon((v-1)*3+1,w), numcon((v-1)*3+2,w), numcon((v-1)*3+3,w)); % 3 = length(handles.prop)
    end
end

fclose(fid);

menu_conndatas_CreateFcn(handles.menu_conndatas, [], handles)
set(handles.menu_conndatas,'Value',1) %length(get(handles.menu_conndatas,'String')))

t = dir([handles.repos sl 'datasets' sl handles.curfile]);
comments = inputdlg('Enter comments about this connection set:','Comments');

x = str2num(handles.curfile(10:end-4));
idx = find([handles.conns(:).num]==x);
if isempty(idx)
    idx=length(handles.conns)+1;
end



handles.conns(idx).name = handles.curfile;
handles.conns(idx).date = t.date;
handles.conns(idx).comments = comments{:};
handles.conns(idx).num = x;
contents=get(handles.menu_numdata,'String');
handles.conns(idx).numdata = str2num(contents{get(handles.menu_numdata,'Value')}); % handles.conns(oldidx).numdata;

conns = handles.conns;
save([handles.repos sl 'datasets' sl 'conns.mat'],'conns','-v7.3');
%save tools/conns.mat conns

set(handles.txt_comment,'String', handles.conns(idx).comments)

guidata(hObject, handles);


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


% --- Executes on button press in menu_numdata.
function menu_numdata_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_numdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% open file, load in cell types for menu_numdata
contents = cellstr(get(hObject,'String'));
handles.cellcurfile = ['cellnumbers_' contents{get(hObject,'Value')} '.dat'];
handles.cellidx=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);

fid = fopen([handles.repos sl 'datasets' sl handles.cellcurfile],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

cellnum={};
for v=1:length(filedata{1}) %RunArray(ind).NumCellTypes % rows
    cellnum{v,1} = filedata{1}{v}; % celltype
    cellnum{v,2} = filedata{2}{v}; % techtype
    cellnum{v,3} = filedata{3}(v); % number of cells
    cellnum{v,4} = filedata{4}(v); % layer
end


% check if they differ from list of cell types already showing in table -
% er, already in the previous cellnum  
numcon = get(handles.tableh,'Data');
rownames = get(handles.tableh,'RowName');
columnnames = get(handles.tableh,'ColumnName');
try
    columnnames{1};
catch
    columnnames = handles.columnnames;
end

if length(columnnames)==length(cellnum(:,1)) && sum(strcmp(sort(cellnum(:,1)),sort(columnnames)))==length(columnnames)
    % same
else
    % delete old cells
    oldcells=[];
    for v=1:length(columnnames)
        m = strmatch(columnnames{v},cellnum(:,1));
        if isempty(m)
            oldcells = [oldcells v];
        end
    end    
    
    % now ... edit the rownames, columnnames, and table data to remove the indices
    % in oldcells
    columnnames(oldcells)=[];
    numcon(:,oldcells)=[];
    
    oldcellrows=[];
    for zz=0:length(handles.prop)-1
        oldcellrows = [oldcellrows; oldcells(:)*length(handles.prop)-zz];
    end
    oldcellrows = sort(oldcellrows);
    rownames(oldcellrows)=[];
    numcon(oldcellrows,:)=[];
    
    % add new cells (which happens below)
end

% then update the cell numbers for each cell type in the final dataset. And
% update the conns(x).numdata to the new value
% make sure on total conn.s view before doing all of this?

%%% Also - way to make previously used conndata's (ones with RunArray
%%% execution dates) uneditable? and same thing for numdata and syndata




a=filedata{1}; %dir([handles.repos sl 'cells' sl 'class_*.hoc']);
newcells={};
newcellstech={};
for r=1:length(a)
    if sum(strcmp(handles.cellnames,a{r}))==0;
        newcells{length(newcells)+1} = a{r};
        newcellstech{length(newcellstech)+1} = cellnum{r,2};
    end
end



gs = strfind(rownames,'pp');
fl=[];
for r=1:length(gs)
    if ~isempty(gs{r})
        fl=r;
        break;
    end
end
if isempty(fl)
    fl=1;
end
% add pp rows
rs=length(handles.prop);
if isempty(numcon)
    pprow=zeros(rs,1);
else
    pprow=numcon(fl:fl+rs-1,:);
end

gs = strfind(newcellstech,'pp');
fl=[];
for r=1:length(gs)
    if ~isempty(gs{r})
        fl(length(fl)+1)=r;
    end
end

for x=1:length(fl)
    numcon = [pprow; numcon];
    for z=length(handles.prop):-1:1
        st = [newcells{fl(x)} ' - ' handles.prop{z}];
        rownames = [st; rownames];
    end
end

% add cell rows - assume last row in table is a cell (not pp)
cellrow = numcon(end-rs+1:end,:);

gs = strfind(newcellstech,'cell');
fl=[];
for r=1:length(gs)
    if ~isempty(gs{r})
        fl(length(fl)+1)=r;
    end
end

for x=1:length(fl)
    numcon = [numcon; cellrow];
    for z = 1:length(handles.prop)
        st = [newcells{fl(x)} ' - ' handles.prop{z}];
        rownames = [rownames; st];
    end
    columnnames = [columnnames; newcells{fl(x)}];
end

% fill out new columns as well
cellcol=numcon(:,1);
xstart=size(numcon,2)+1;
for x=1:length(fl) % for x=xstart:length(fl)
    numcon = [numcon cellcol];
end

set(handles.tableh,'Data', numcon);
set(handles.tableh,'RowName', rownames);
set(handles.tableh,'ColumnName', columnnames);

handles.cellnames = columnnames;
handles.rownames = rownames;
handles.columnnames = columnnames;
handles.numcon = numcon;
guidata(hObject, handles);
set_numcons(hObject,handles)


% --- Executes on selection change in menu_numtype.
function menu_numtype_Callback(hObject, eventdata, handles)
% hObject    handle to menu_numtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_numtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_numtype


% --- Executes during object creation, after setting all properties.
function menu_numtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_numtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function menu_numdata_CreateFcn(hObject, eventdata, handles)
global mypath sl
% hObject    handle to menu_numtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


