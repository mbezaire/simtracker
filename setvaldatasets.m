function setvaldatasets(handles,ind,sl,myrep,folderstr,varname,myfield,menuname)
global mypath RunArray
if  isempty(ind) || ind==0 || ind>length(RunArray)
    msgbox(['No index to get value for ' myfield])
elseif RunArray(ind).(myfield)~=1
    if strcmp(get(handles.(['menu_' menuname]),'Style'),'popupmenu')
        numdataval = mystrfind(get(handles.(['menu_' menuname]),'String'),[num2str(RunArray(ind).(myfield)) ':']);
        try
        set(handles.(['menu_' menuname]),'Value',numdataval);
        catch
        set(handles.(['menu_' menuname]),'Value',1);
        end
    else % if text
        % get list of all entries and comments
        if exist([myrep sl  folderstr sl varname '.mat'],'file')
            load([myrep sl  folderstr sl varname '.mat'],varname)
            eval(['m=find([' varname '(:).num]==RunArray(ind).(myfield));'])
            if isempty(m)
                eval(['m=length(' varname ')+1;' varname '(m).num=RunArray(ind).(myfield);' varname '(m).comments=''Unknown set'';']);
            end
        else
            eval(['m=1;' varname '(m).num=RunArray(ind).(myfield);' varname '(m).comments=''Unknown set'';']);
        end
        set(handles.(['menu_' menuname]),'String',eval(['[num2str(' varname '(m).num) '': '' ' varname '(m).comments]']))
    end
end