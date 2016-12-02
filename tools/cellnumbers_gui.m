function varargout = cellnumbers_gui(varargin)
% CELLNUMBERS_GUI MATLAB code for cellnumbers_gui.fig
%      CELLNUMBERS_GUI, by itself, creates a new CELLNUMBERS_GUI or raises the existing
%      singleton*.
%
%      H = CELLNUMBERS_GUI returns the handle to a new CELLNUMBERS_GUI or the handle to
%      the existing singleton*.
%
%      CELLNUMBERS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLNUMBERS_GUI.M with the given input arguments.
%
%      CELLNUMBERS_GUI('Property','Value',...) creates a new CELLNUMBERS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellnumbers_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellnumbers_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellnumbers_gui

% Last Modified by GUIDE v2.5 07-Feb-2013 16:57:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellnumbers_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @cellnumbers_gui_OutputFcn, ...
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


% --- Executes just before cellnumbers_gui is made visible.
function cellnumbers_gui_OpeningFcn(hObject, eventdata, handles, varargin)
global mypath sl
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellnumbers_gui (see VARARGIN)

% Choose default command line output for cellnumbers_gui
handles.output = hObject;

try
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')

q=find([myrepos(:).current]==1);

if isempty(q)
    msgbox('No current repository')
    return
end
handles.repos = myrepos(q).dir;

if exist([handles.repos sl 'datasets' sl 'cells.mat'])
    load([handles.repos sl 'datasets' sl 'cells.mat'],'cells');
%if exist('tools/cells.mat')
%    load tools/cells.mat cells
else
    cells = [];
end
handles.cells = cells;

%a=dir([handles.repos '/cellframes/class_*.hoc']);
a=dir([handles.repos sl 'cells' sl 'class_*.hoc']);
for r=1:length(a)
    a(r).name=a(r).name(7:end-4);
end

set(handles.list_techtype,'String',{a(:).name})
set(handles.list_celltype,'String',{a(:).name})
handles.numcon = get(handles.tableh,'Data');


% Update handles structure
guidata(hObject, handles);
list_sets_CreateFcn(handles.list_sets, [], handles)
list_sets_Callback(handles.list_sets, [], handles)
% UIWAIT makes cellnumbers_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
catch ME
    handleME(ME)
end


% --- Outputs from this function are returned to the command line.
function varargout = cellnumbers_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_sets.
function list_sets_Callback(hObject, eventdata, handles)
global sl

% hObject    handle to list_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_sets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_sets

% update the handles structure with current file
contents = cellstr(get(hObject,'String'));
if isempty(contents)
    return
end
handles.curfile = ['cellnumbers_' contents{get(hObject,'Value')} '.dat'];
handles.idx=str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);

% load the selected data into the table
if exist([handles.repos sl 'datasets' sl handles.curfile])
    reload(hObject,handles);
end
handles=guidata(hObject);

function reload(hObject,handles)
global sl

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'r');                
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

set(handles.tableh, 'Data', numcon) %, 'ColumnEditable', logical(ones(size(cellnames))'), 'ColumnName', cellnames, 'RowName', rownames,'Units','pixels');
handles.numcon = numcon;

if isempty(handles.cells)
    x=1;
    handles.cells(x).num=handles.idx;
    handles.cells(x).comments='This dataset was not added via SimTracker. Please add comments.';
else
    x = find([handles.cells(:).num]==handles.idx);
    if isempty(x)
        x=length(handles.cells)+1;
        handles.cells(x).num=handles.idx;
        handles.cells(x).comments='This dataset was not added via SimTracker. Please add comments.';
    end
end

set(handles.edit_caption,'String', handles.cells(x).comments)

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function list_sets_CreateFcn(hObject, eventdata, handles)
global sl mypath

% hObject    handle to list_sets (see GCBO)
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
guidata(hObject, handles);


%if (isfield(handles,'cells') && ~isempty(handles.cells)) || (isfield(handles,'curfile') && ~isempty(handles.curfile))
    a=dir([handles.repos sl 'datasets' sl 'cellnumbers_*.dat']);
    numvec={};
    for r=1:length(a)
        tk = regexp(a(r).name,'cellnumbers_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>90
            numvec{length(numvec)+1}=tk{1}{:};
        end
    end
    set(hObject,'String',fliplr(numvec));

    %handles.curfile = ['cellnumbers_' numvec{get(hObject,'Value')} '.dat'];
    guidata(hObject, handles);
%end


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reload(hObject,handles)

% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global sl

% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gf.line=[];

numcon = get(handles.tableh,'Data');

if isempty(handles.cells)
    x=1;
    handles.cells(x).comments='';
    handles.cells(x).num=100;
    handles.idx=handles.cells(x).num;
    handles.curfile = ['cellnumbers_' sprintf('%03.0f', handles.idx) '.dat'];
end


fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');   

numlines=0;
for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    if ~isempty(numcon{v,1}) && ~isempty(numcon{v,2})
        numlines=numlines+1;
    end
end
fprintf(fid,'%d\n', numlines);

for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    fl=1;
    if isempty(numcon{v,1}) || isempty(numcon{v,2})
        continue
    end
    if strcmp(numcon{v,2}(end-3:end),'cell')
        fl=0;
    end
    fprintf(fid,'%s %s %.0f %.0f %.0f\n', numcon{v,1}, numcon{v,2}, numcon{v,3}, numcon{v,4}, fl); % 3 = length(handles.prop)
    %fprintf(fid,'%s %s %.0f %.0f %.0f\n', numcon{v,1}, numcon{v,2}, numcon{v,3}, numcon{v,4}, numcon{v,5}); % 3 = length(handles.prop)
end

fclose(fid);

msgstr={};
msgstr{1}='Axonal distribution files were created for the following cells:';
for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    if isempty(numcon{v,1}) || isempty(numcon{v,2})
        continue
    end
    if exist([handles.repos sl 'cells' sl 'axondists' sl 'dist_' numcon{v,1} '.hoc'],'file')==0
        fid = fopen([handles.repos sl 'cells' sl 'axondists' sl 'dist_' numcon{v,1} '.hoc'],'w');                
        fprintf(fid,'1\n0\n1000\n')
        fclose(fid)
        msgstr{length(msgstr)+1}=numcon{v,1};
    end
end
if length(msgstr)>1
    msgbox(msgstr)
end

try
    x = find([handles.cells(:).num]==handles.idx);
catch me
    x=length(handles.cells)+1;
    handles.cells(x).num=handles.idx;
end
if isempty(x)
    x=length(handles.cells)+1;
    handles.cells(x).num=handles.idx;
end
% set(handles.edit_caption,'String', handles.cells(x).comments)
mystr = get(handles.edit_caption,'String');
try
    handles.cells(x).comments=mystr{:};
catch
    handles.cells(x).comments=mystr;
end
handles.cells(x).date = date;

cells = handles.cells;
save([handles.repos sl 'datasets' sl 'cells.mat'],'cells','-v7.3');

guidata(hObject, handles);

% --- Executes on button press in btn_new.
function btn_new_Callback(hObject, eventdata, handles)
global sl

% hObject    handle to btn_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

maxcon=99;
a=dir([handles.repos sl 'datasets' sl 'cellnumbers_*.dat']);
if ~isempty(a)
    for r=1:length(a)
        tk = regexp(a(r).name,'cellnumbers_(\d*).dat','tokens');
        numtk = str2num(tk{1}{:});
        if numtk>maxcon
            maxcon = numtk;
        end
    end
end

handles.curfile = ['cellnumbers_' sprintf('%03.0f', maxcon+1) '.dat'];

numcon = get(handles.tableh,'Data');

fid = fopen([handles.repos sl 'datasets' sl handles.curfile],'w');  
try
fprintf(fid,'%d\n', size(numcon,1));

for v=1:size(numcon,1) %RunArray(ind).NumCellTypes % rows
    fl=1;
    if ~isempty(numcon{v,2})
        if strcmp(numcon{v,2}(end-3:end),'cell')
            fl=0;
        end
        fprintf(fid,'%s %s %.0f %.0f %.0f\n', numcon{v,1}, numcon{v,2}, numcon{v,3}, numcon{v,4}, fl); % 3 = length(handles.prop)
        %fprintf(fid,'%s %s %.0f %.0f %.0f\n', numcon{v,1}, numcon{v,2}, numcon{v,3}, numcon{v,4}, numcon{v,5}); % 3 = length(handles.prop)
    end
end
catch ME
 fclose(fid);
 ME
end  
fclose(fid);

t = dir([handles.repos sl 'datasets' sl handles.curfile]);
comments = inputdlg('Enter comments about this cell numbers set:','Comments');

x = length(handles.cells)+1;
handles.cells(x).name = handles.curfile;
handles.cells(x).date = t.date;
handles.cells(x).comments = comments{:};
handles.cells(x).num = maxcon+1;

cells = handles.cells;
save([handles.repos sl 'datasets' sl 'cells.mat'],'cells','-v7.3');
%save cells.mat cells

set(handles.edit_caption,'String', handles.cells(x).comments)

guidata(hObject, handles);

list_sets_CreateFcn(handles.list_sets, [], handles)
set(handles.list_sets,'Value',1) %length(get(handles.list_sets,'String')))
contents = cellstr(get(handles.list_sets,'String'));
handles.curfile = ['cellnumbers_' contents{get(handles.list_sets,'Value')} '.dat'];
handles.idx=str2num(contents{get(handles.list_sets,'Value')});
guidata(hObject, handles);

function edit_caption_Callback(hObject, eventdata, handles)
% hObject    handle to edit_caption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_caption as text
%        str2double(get(hObject,'String')) returns contents of edit_caption as a double


% --- Executes during object creation, after setting all properties.
function edit_caption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_caption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_celltype.
function list_celltype_Callback(hObject, eventdata, handles)
% hObject    handle to list_celltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_celltype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_celltype


% --- Executes during object creation, after setting all properties.
function list_celltype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_celltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_techtype.
function list_techtype_Callback(hObject, eventdata, handles)
% hObject    handle to list_techtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_techtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_techtype


% --- Executes during object creation, after setting all properties.
function list_techtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_techtype (see GCBO)
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

contents=get(handles.list_techtype,'String');
techtype=contents{get(handles.list_techtype,'Value')};
contents=get(handles.list_celltype,'String');
celltype=contents{get(handles.list_celltype,'Value')};

numcon=handles.numcon;

r=size(numcon,1)+1;
while r>1 && isempty(numcon{r-1,1}) && isempty(numcon{r-1,2})
    r=r-1;
end

numcon{r,1}=celltype;
numcon{r,2}=techtype;
set(handles.tableh,'Data',numcon);
handles.numcon = numcon;
guidata(hObject, handles);

