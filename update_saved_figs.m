function update_saved_figs(handles)
global RunArray
try
if isempty(handles.curses.ind) || isfield(handles,'savedfigs')==0 || isempty(handles.savedfigs)
    set(handles.tbl_savedfigs,'Data',{});
    return
end

ind = handles.curses.ind;


idx=find(strcmp(RunArray(ind).RunName,{handles.savedfigs.runname})==1);
if isempty(idx)
    set(handles.tbl_savedfigs,'Data',{});
    return
end
avail=repmat({''},length(idx),4);
for r=1:length(idx)
    avail{r,1}=getstr(handles.savedfigs(idx(r)).figtype);
    avail{r,2}=getstr(handles.savedfigs(idx(r)).figformat);
    avail{r,3}=getstr(handles.savedfigs(idx(r)).datetimenow);
    avail{r,4}=getstr(handles.savedfigs(idx(r)).fullfigname);
end
set(handles.tbl_savedfigs,'Data',avail);
catch ME
    handleME(ME)
end

function myresult = getstr(myentry)

if iscell(myentry)
    myresult = myentry{1};
else
    myresult = myentry;
end