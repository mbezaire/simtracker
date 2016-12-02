function updatemenu(myrep,sl,handles,editme,menuname,foldername,filestr,varargin) %updatemenu(myrepos(q).dir,sl,handles,
global mypath RunArray
if strcmp(get(handles.(['menu_' menuname]),'Style'),'popupmenu') || editme
    mystim={};
    fl=1;
    a=dir([myrep sl foldername sl '*_' filestr '.hoc']);
    for r=1:length(a)
        b=mystrfind(a(r).name,['_' filestr]);
        mystim{length(mystim)+1}=a(r).name(1:b-1); %#ok<AGROW>
    end
    set(handles.(['menu_' menuname]),'Style','popupmenu','String',mystim)
    if ~isempty(varargin) && ~isempty(varargin{1}) && ~isempty(varargin{2}) && varargin{1}>0 && varargin{1}<=length(RunArray)
        fl=find(strncmp(RunArray(varargin{1}).(varargin{2}),get(handles.(['menu_' menuname]),'String'),100)==1);
    end
    if isempty(fl) || fl>length(mystim)
        fl=length(mystim);
    end
    set(handles.(['menu_' menuname]),'Value',fl)
elseif ~isempty(varargin) && ~isempty(varargin{1}) && ~isempty(varargin{2}) && varargin{1}>0 && varargin{1}<=length(RunArray)
    set(handles.(['menu_' menuname]),'String',RunArray(varargin{1}).(varargin{2}));
end