
function groupdata(handles)
% This function updates the field that displays the groups of the currently
% selected run and also selects those options in group listbox

global RunArray
try
ind = handles.curses.ind;
if isempty(ind)
    return
end

set(handles.txt_group,'String',RunArray(ind).Groups);

contents = cellstr(get(handles.list_groups,'String'));
groupcell = regexp(RunArray(ind).Groups,',','split');

myval=[];
for r = 1:length(groupcell)
    m=find(strncmp(groupcell{r},contents,length(groupcell{r}))==1);
    if ~isempty(m)
        myval = [myval m]; %#ok<AGROW>
    end
end

set(handles.list_groups,'Value',myval)
catch ME
    handleME(ME)
end