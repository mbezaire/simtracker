function setmachinemenu(handles,editme,varargin)
global RunArray

if strcmp(get(handles.menu_machine,'Style'),'popupmenu') || editme
    fl=1;
    nickstr={handles.machines.Nickname};
    if ~isempty(varargin) && ~isempty(varargin{1}) && varargin{1}>0 && varargin{1}<=length(RunArray)
        for r=1:length(nickstr)
            if strcmp(RunArray(varargin{1}).Machine,nickstr{r})==1
                fl=r;
            end
        end
    end
    set(handles.menu_machine,'Style','popupmenu','String',{handles.machines.Nickname},'Value',fl)
elseif ~isempty(varargin) && ~isempty(varargin{1}) && varargin{1}>0 && varargin{1}<=length(RunArray)
    set(handles.menu_machine,'String',RunArray(varargin{1}).Machine);
end