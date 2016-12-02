function varargout = parameterset(varargin)
global sl
% PARAMETERSET MATLAB code for parameterset.fig
%      PARAMETERSET, by itself, creates a new PARAMETERSET or raises the existing
%      singleton*.
%
%      H = PARAMETERSET returns the handle to a new PARAMETERSET or the handle to
%      the existing singleton*.
%
%      PARAMETERSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERSET.M with the given input arguments.
%
%      PARAMETERSET('Property','Value',...) creates a new PARAMETERSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parameterset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parameterset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parameterset

% Last Modified by GUIDE v2.5 25-May-2016 15:57:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parameterset_OpeningFcn, ...
                   'gui_OutputFcn',  @parameterset_OutputFcn, ...
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


% --- Executes just before parameterset is made visible.
function parameterset_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parameterset (see VARARGIN)

% Choose default command line output for parameterset
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
btn_reload_Callback(handles.btn_reload, [], handles)
% UIWAIT makes parameterset wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if isdeployed
    set(handles.btn_addline,'Visible','Off')
    set(handles.btn_print,'Visible','Off')
    %set(handles.btn_save,'Visible','Off')
    %set(handles.btn_reload,'Visible','Off')
    set(handles.tbl_changeable,'ColumnEditable', [false,false,false,false,true,true,true,true,true])
    set(handles.tbl_fixed,'ColumnEditable', [false,false,false,false,true,true,true,true,true])
end


% --- Outputs from this function are returned to the command line.
function varargout = parameterset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sl mypath realpath

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=[myrepos(:).current]==1;
modeldir=myrepos(q).dir;

load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defixparams')
    
if exist([modeldir sl 'setupfiles' sl 'parameters.mat'],'file')
    load([modeldir sl 'setupfiles' sl 'parameters.mat'],'chparams')
else
    load([realpath sl 'defaults' sl 'defaultparameters.mat'],'defchparams')
    chparams=defchparams;
end


cr=1;fr=1;
for r=1:length(defixparams)
    if strcmp(defixparams(r).table,'Fixed')
        fixedtabledata{fr,1} = defixparams(r).name;
        fixedtabledata{fr,2} = defixparams(r).type;
        fixedtabledata{fr,3} = defixparams(r).default;
        fixedtabledata{fr,4} = defixparams(r).format;
        fixedtabledata{fr,5} = defixparams(r).list;
        fixedtabledata{fr,6} = logical(defixparams(r).form);
        fixedtabledata{fr,7} = logical(defixparams(r).file);
        fixedtabledata{fr,8} = defixparams(r).description;
        fixedtabledata{fr,9} = defixparams(r).nickname;
        fr=fr+1;
    end
end

for r=1:length(chparams)
    if strcmp(chparams(r).table,'Changeable')
        changetabledata{cr,1} = chparams(r).name;
        changetabledata{cr,2} = chparams(r).type;
        changetabledata{cr,3} = chparams(r).default;
        changetabledata{cr,4} = chparams(r).format;
        changetabledata{cr,5} = chparams(r).list;
        changetabledata{cr,6} = logical(chparams(r).form);
        changetabledata{cr,7} = logical(chparams(r).file);
        changetabledata{cr,8} = chparams(r).description;
        changetabledata{cr,9} = chparams(r).nickname;
        cr=cr+1;
    end
end

set(handles.tbl_changeable,'Data',changetabledata)
set(handles.tbl_fixed,'Data',fixedtabledata)


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
global sl mypath realpath
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load('/home/casem/matlab/work/SimTracker/data/parameters.mat','parameters')

changetabledata=get(handles.tbl_changeable,'Data');
fixedtabledata=get(handles.tbl_fixed,'Data');

%idx=find(strcmp({parameters(:).table},'Changeable')==1);
defixparams=[];
g=length(defixparams)+1;
for fr=1:size(fixedtabledata,1)
    if ~isempty(fixedtabledata{fr,1})
        defixparams(g).name=fixedtabledata{fr,1};
        defixparams(g).table='Fixed';
        defixparams(g).type=fixedtabledata{fr,2};
        defixparams(g).default=fixedtabledata{fr,3};
        defixparams(g).format=fixedtabledata{fr,4};
        defixparams(g).list=fixedtabledata{fr,5};
        defixparams(g).form=+fixedtabledata{fr,6};
        defixparams(g).file=+fixedtabledata{fr,7};
        defixparams(g).description=fixedtabledata{fr,8};
        defixparams(g).nickname=fixedtabledata{fr,9};
        g=g+1;
    end
end

chparams=[];
g=length(chparams)+1;
for cr=1:size(changetabledata,1)
    if ~isempty(changetabledata{cr,1})
        chparams(g).name=changetabledata{cr,1};
        chparams(g).table='Changeable';
        chparams(g).type=changetabledata{cr,2};
        chparams(g).default=changetabledata{cr,3};
        chparams(g).format=changetabledata{cr,4};
        chparams(g).list=changetabledata{cr,5};
        chparams(g).form=+changetabledata{cr,6};
        chparams(g).file=+changetabledata{cr,7};
        chparams(g).description=changetabledata{cr,8};
        chparams(g).nickname=changetabledata{cr,9};
        g=g+1;
    end
end

for r=1:length(defixparams)
    if isempty(defixparams(r).nickname)
        defixparams(r).nickname=defixparams(r).name;
    end
end

for r=1:length(chparams)
    if isempty(chparams(r).nickname)
        chparams(r).nickname=chparams(r).name;
    end
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=[myrepos(:).current]==1;

save([realpath sl 'defaults' sl 'defaultparameters.mat'],'defixparams','-append')
save([myrepos(q).dir sl 'setupfiles' sl 'parameters.mat'],'chparams','-v7.3')
checkAndcommitParams(handles,myrepos(q).dir,1)


% --- Executes on button press in btn_addline.
function btn_addline_Callback(hObject, eventdata, handles)
% hObject    handle to btn_addline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_changeable,'Data');

y=size(tabledata,1)+1;

for r=[1:4 8:9]
    tabledata{y,r}='';
end
    tabledata{y,5}=0;
for r=6:7
    tabledata{y,r}=false;
end
set(handles.tbl_changeable,'Data',tabledata)


% --- Executes on button press in btn_print.
function btn_print_Callback(hObject, eventdata, handles)
global mypath sl
% hObject    handle to btn_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


btn_save_Callback(handles.btn_save, [], handles)


load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=[myrepos(:).current]==1;
modeldir=myrepos(q).dir;

if isdeployed==0
parameters=switchSimRun('',modeldir);

% First print the new SimRun class, then print the parameters.hoc file in
% the model code

n=1;
%%%%%%%%%%%%%
classlines(n).line='classdef SimRun < handle';n=n+1;
classlines(n).line='   properties % (Hidden) (SetAccess = private)';n=n+1;   
classlines(n).line='       % displayed in list view and form view';n=n+1;
classlines(n).line='       % we may need to move the initializations to the constructor fcn';n=n+1;
classlines(n).line='       % (but keep the list of properties in here, obviously)';n=n+1;

for g=1:length(parameters)
    if strcmp(parameters(g).type,'string')==1
        fieldval=['''' parameters(g).default ''''];
    else
        fieldval=num2str(parameters(g).default);
    end
    classlines(n).line=['        ' parameters(g).name ' = ' fieldval ' % ' parameters(g).description ];n=n+1;
end

classlines(n).line='end';n=n+1;
   
classlines(n).line='   methods';n=n+1;
classlines(n).line='      function BA = SimRun(RunName,ResultsDirectory,UID)';n=n+1;
classlines(n).line='          global RunArray';n=n+1;
classlines(n).line='         if nargin < 2';n=n+1;
classlines(n).line='            error(''SimRun:InvalidInitialization'',...';n=n+1;
classlines(n).line='               ''You must provide a Run Name and directory to uniquely identify this simulation record'')';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='         BA.RunName  = RunName;';n=n+1;
classlines(n).line='         BA.ModelDirectory = ResultsDirectory;';n=n+1;
classlines(n).line='         BA.UID = UID;';n=n+1;
         
classlines(n).line='         if exist(''RunArray'')==0 || strcmp(class(RunArray),''double'') % double happens when the variable didn''t exist and was then declared global';n=n+1;
classlines(n).line='            RunArray=BA;';n=n+1;
classlines(n).line='         else';n=n+1;
classlines(n).line='            RunArray(length(RunArray)+1)=BA;';n=n+1;
classlines(n).line='            while sum(strcmp({RunArray(:).RunName},BA.RunName))>1';n=n+1;
classlines(n).line='                newname=inputdlg(''Run Name already used. Enter a new one:'');';n=n+1;
classlines(n).line='                BA.RunName=newname{1};';n=n+1;
classlines(n).line='            end';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='      end % SimRun';n=n+1;

classlines(n).line='      function set.UID(BA,val)';n=n+1;
classlines(n).line='         if (isempty(BA.UID) || strcmp(BA.UID,''0''))';n=n+1;
classlines(n).line='            BA.UID = val;';n=n+1;
classlines(n).line='         else';n=n+1;
classlines(n).line='             msgbox({''Cannot change UID. UID already set to:'',BA.UID});';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='      end';n=n+1;
classlines(n).line='      function set.RunName(BA,val)';n=n+1;
classlines(n).line='         if isempty(BA.ExecutionDate)';n=n+1;
classlines(n).line='            BA.RunName = val;';n=n+1;
classlines(n).line='         else';n=n+1;
classlines(n).line='             msgbox(''Cannot change Run Name after run has been executed'');';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='      end';n=n+1;

classlines(n).line='      function loadexecdata(BA)';n=n+1;
classlines(n).line='          sl=''/'';';n=n+1;
classlines(n).line='          tmpdir = BA.ModelDirectory; % right now it is set to the local directory, but during the while statement it will be set to the remote directory';n=n+1;
classlines(n).line='         if exist([BA.ModelDirectory sl ''results'' sl BA.RunName sl ''runreceipt.txt'']) > 0';n=n+1;
classlines(n).line='            sl=''/'';';n=n+1;
classlines(n).line='            fid = fopen([BA.ModelDirectory sl ''results'' sl BA.RunName sl ''runreceipt.txt''],''r'');';n=n+1;
classlines(n).line='            while ~feof(fid)';n=n+1;
classlines(n).line='                setval=fgetl(fid);';n=n+1;
classlines(n).line='                myprop=regexp(setval,''([\w]+)'',''tokens'',''once'');';n=n+1;
classlines(n).line='                if sum(strcmp(myprop,properties(BA))) && strcmp(myprop,''RunName'')==0 && (strcmp(myprop,''UID'')==0 || isempty(BA.UID))';n=n+1;
classlines(n).line='                    eval([''BA.'' setval]);';n=n+1;
classlines(n).line='                end';n=n+1;
classlines(n).line='            end';n=n+1;
classlines(n).line='            fclose(fid);';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='         BA.RemoteDirectory = BA.ModelDirectory;';n=n+1;
classlines(n).line='         BA.ModelDirectory = tmpdir;';n=n+1;
classlines(n).line='         if exist([BA.ModelDirectory sl ''results'' sl BA.RunName sl ''sumnumout.txt'']) > 0';n=n+1;
classlines(n).line='            fid = fopen([BA.ModelDirectory sl ''results'' sl BA.RunName sl ''sumnumout.txt''],''r'');';n=n+1;
classlines(n).line='            while ~feof(fid)';n=n+1;
classlines(n).line='                setval=fgetl(fid);';n=n+1;
classlines(n).line='                myprop=regexp(setval,''([\w]+)'',''tokens'',''once'');';n=n+1;
classlines(n).line='                if sum(strcmp(myprop,properties(BA)))';n=n+1;
classlines(n).line='                    eval([''BA.'' setval]);';n=n+1;
classlines(n).line='                end';n=n+1;
classlines(n).line='            end';n=n+1;
classlines(n).line='            fclose(fid);';n=n+1;
classlines(n).line='         end';n=n+1;
classlines(n).line='      end % loadexecdata';n=n+1;
      
% classlines(n).line='      function loaddesigndata(BA)';n=n+1;
% for g=1:length(parameters)
%     if strcmp(parameters(g).type,'string')==1
%         fieldval=['''' parameters(g).default ''''];
%     else
%         fieldval=num2str(parameters(g).default);
%     end
%     classlines(n).line=['        BA.' parameters(g).name ' = ' fieldval '; % ' parameters(g).description ];n=n+1;
% end
% classlines(n).line='      end % loaddesigndata';n=n+1;
classlines(n).line='   end % methods';n=n+1;
classlines(n).line='end % classdef';n=n+1;
%%%%%%%%%%%%%


fid = fopen([modeldir sl 'setupfiles' sl '@SimRun' sl 'SimRun.m'],'w');
for n=1:length(classlines)
    fprintf(fid,'%s\n', classlines(n).line);
end
fclose(fid)

end

n=1;
%%%%%%%%%%%%%
parameterlines(n).line = '// This file sets the default values of parameters';n=n+1;
parameterlines(n).line = '//  in such a way that they can be overridden using';n=n+1;
parameterlines(n).line = '//  certain options at the command line';n=n+1;
parameterlines(n).line = ' ';n=n+1;

for g=1:length(parameters)
    if parameters(g).file==1
        if strcmp(parameters(g).type,'string')==1
            fieldval=['"' parameters(g).default '"'];
        else
            fieldval=num2str(parameters(g).default);
        end
        parameterlines(n).line = ['default_var("' parameters(g).name '",' fieldval ')		// ' parameters(g).description ];n=n+1;
    end
end

fid = fopen([modeldir sl 'setupfiles' sl 'parameters.hoc'],'w');
for n=1:length(parameterlines)
    fprintf(fid,'%s\n', parameterlines(n).line);
end
fclose(fid)

if isdeployed==0
msgbox({'SimRun class in the SimTracker',' and setupfiles/parameters.hoc file',' in model code updated.'})
else
msgbox('Updated setupfiles/parameters.hoc file')
end


% --- Executes on button press in btn_delete.
function btn_delete_Callback(hObject, eventdata, handles)
% hObject    handle to btn_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabledata=get(handles.tbl_changeable,'Data');

for p=1:length(handles.selparamname)
%     pidx=strmatch(handles.selparamname,{chparams.name});
%     chparams(pidx)=[];
    pidx=strmatch(handles.selparamname,tabledata(:,1));
    tabledata(pidx,:)=[];
end

set(handles.tbl_changeable,'Data',tabledata)
btn_save_Callback(handles.btn_save, eventdata, handles)

btn_reload_Callback(handles.btn_reload, [], handles)
handles.selparamname={};
guidata(hObject, handles);

% --- Executes when selected cell(s) is changed in tbl_changeable.
function tbl_changeable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tbl_changeable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
try
    if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
        mydata=get(handles.tbl_changeable,'Data');
        handles.selparamname=mydata(eventdata.Indices(:,1),1);
    else
        handles.selparamname={};
    end
    guidata(hObject, handles);
catch ME
    handleME(ME)
end