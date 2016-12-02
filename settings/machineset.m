function varargout = machineset(varargin)
% MACHINESET MATLAB code for machineset.fig
%      MACHINESET, by itself, creates a new MACHINESET or raises the existing
%      singleton*.
%
%      H = MACHINESET returns the handle to a new MACHINESET or the handle to
%      the existing singleton*.
%
%      MACHINESET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MACHINESET.M with the given input arguments.
%
%      MACHINESET('Property','Value',...) creates a new MACHINESET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before machineset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to machineset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help machineset

% Last Modified by GUIDE v2.5 07-Sep-2013 12:53:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @machineset_OpeningFcn, ...
                   'gui_OutputFcn',  @machineset_OutputFcn, ...
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


% --- Executes just before machineset is made visible.
function machineset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to machineset (see VARARGIN)

% Choose default command line output for machineset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes machineset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = machineset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([mypath sl 'data' sl 'MyOrganizer.mat'],'machines')

for r=1:length(machines)
    tabledata{r,1} = machines(r).Nickname;
    tabledata{r,2} = machines(r).Address;
    tabledata{r,3} = machines(r).Username;
    tabledata{r,4} = machines(r).Repos;
    tabledata{r,5} = machines(r).Allocation;%='TG-IBN140007';
    tabledata{r,6} = machines(r).CoresPerNode;
    tabledata{r,7} = machines(r).SubCmd;
    tabledata{r,8} = machines(r).gsi;
    tabledata{r,9} = machines(r).Submitchkr;
    tabledata{r,10} = machines(r).Conn;
    if ~isfield(machines,'TopCmd') || isempty(machines(r).TopCmd)
        machines(r).TopCmd='';
    elseif isnan(machines(r).TopCmd)
        machines(r).TopCmd='';
    end
    tabledata{r,11} = machines(r).TopCmd;
%     if isfield(machines,'Script') && ~isempty(machines(r).Script)
%         tabledata{r,7} = machines(r).Script(1).mfile;
%     end
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores
    
set(handles.tbl_machine,'Data',tabledata)
set(handles.list_machines,'String',{machines(:).Nickname});



% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
load([mypath sl 'data' sl 'MyOrganizer.mat'],'machines')


tabledata=get(handles.tbl_machine,'Data');
mymachs=zeros(length(machines));
for r=1:size(tabledata,1)
    if ~isempty(tabledata{r,1}) % && ~isempty(tabledata{r,2}) && ~isempty(tabledata{r,3})
        idx=[];
        if ~isempty(machines) && isfield(machines,'Nickname')
            idx = strmatch(tabledata{r,1}, {machines(:).Nickname},'exact');
            mymachs(idx)=1;
        end
        if isempty(idx)
            idx = length(machines)+1;
        end
        machines(idx).Nickname=tabledata{r,1};
        machines(idx).Address=tabledata{r,2};
        machines(idx).Username=tabledata{r,3};
        machines(idx).Repos=tabledata{r,4};
        machines(idx).Allocation=tabledata{r,5};
        machines(idx).CoresPerNode=tabledata{r,6};
        machines(idx).SubCmd=tabledata{r,7};
        machines(idx).gsi=tabledata{r,8};
        machines(idx).Submitchkr=tabledata{r,9};
        machines(idx).Conn=tabledata{r,10};
        machines(idx).TopCmd=tabledata{r,11};
        %machines(idx).Script(1).mfile=tabledata{r,7};
        machsl='/';
        if ~isempty(strfind(machines(idx).Repos,'\'))
            machsl='\';
        end
        if ~isempty(machines(idx).Repos) && ~strcmp(machines(idx).Repos(end),machsl)
            machines(idx).Repos=[machines(idx).Repos machsl];
        end
    end
end

for r=length(mymachs):-1:1
    if mymachs(r)==0
        machines(r)=[];
    end
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores

[~, sorti]=sort({machines(:).Nickname});
machines=machines(sorti);

%%%% Save Queues %%%%
tabledata=get(handles.tbl_queues,'Data');

contents = cellstr(get(handles.list_machines,'String'));
idx = strmatch(contents{get(handles.list_machines,'Value')}, {machines(:).Nickname},'exact');

if ~isempty(idx)
    for r=1:size(tabledata,1)
        if ~isempty(tabledata{r,1}) && ~isempty(tabledata{r,2}) && ~isempty(tabledata{r,3})
            machines(idx).Queues(r).Name=tabledata{r,1};
            machines(idx).Queues(r).RunHours=tabledata{r,2};
            machines(idx).Queues(r).Cores=tabledata{r,3};
        end
    end
end

save([mypath sl 'data' sl 'MyOrganizer.mat'],'machines','-append')
set(handles.list_machines,'String',{machines(:).Nickname});
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

% --- Executes on button press in btn_addline.
function btn_addline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_machine,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';
tabledata{y,2}='';
tabledata{y,3}='';
tabledata{y,4}='';
tabledata{y,5}='';
tabledata{y,6}=0;
tabledata{y,7}='';
tabledata{y,8}='';
tabledata{y,9}='';
if ispc
    tabledata{y,10}='ssh2';
else
    tabledata{y,10}='ssh';
end
tabledata{y,11}='';

set(handles.tbl_machine,'Data',tabledata)


% --- Executes on button press in btn_addqueueline.
function btn_addqueueline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addqueueline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledata=get(handles.tbl_queues,'Data');

y=size(tabledata,1)+1;

tabledata{y,1}='';
tabledata{y,2}=0;
tabledata{y,3}=0;

set(handles.tbl_queues,'Data',tabledata)


% --- Executes on selection change in list_machines.
function list_machines_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to list_machines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_machines contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_machines


load([mypath sl 'data' sl 'MyOrganizer.mat'],'machines')

contents = cellstr(get(handles.list_machines,'String'));

idx = strmatch(contents{get(handles.list_machines,'Value')}, {machines(:).Nickname},'exact');

if isfield(machines(idx),'Queues') && ~isempty(machines(idx).Queues)
    for r=1:length(machines(idx).Queues)
        tabledata{r,1} = machines(idx).Queues(r).Name;
        tabledata{r,2} = machines(idx).Queues(r).RunHours;
        tabledata{r,3} = machines(idx).Queues(r).Cores;
    end

    set(handles.tbl_queues,'Data',tabledata)
else
    set(handles.tbl_queues,'Data',[])
end

%           Queues: [1x4 struct]
% Name
% RunHours
% Cores


% --- Executes during object creation, after setting all properties.
function list_machines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_machines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function docerr(ME)
global logloc

fid = fopen([logloc 'SimTrackerOutput.log'],'a');
fprintf(fid,'%s\n',ME.identifier);
fprintf(fid,'%s\n\n',ME.message);
for r=1:length(ME.stack)
    fprintf(fid,'%s\n\t%s\n\t%g\n\n', ME.stack(r).file, ME.stack(r).name, ME.stack(r).line);
end
fclose(fid);

%msgbox(ME.identifier)
errordlg(ME.message)
%for r=1:length(ME.stack)
%    msgbox({ME.stack(r).file,ME.stack(r).name,num2str(ME.stack(r).line)})
%end
