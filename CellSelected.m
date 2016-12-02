function CellSelected(hObject, eventdata, handles)
% This function updates the handles structure with the currently selected
% run(s); the selected rows are available in the Indices field of eventdata
global RunArray


if isempty(RunArray)
    handles.curses=[];handles.curses.ind=0;
    guidata(handles.list_view,handles)
    return
end

if ~isempty(eventdata) && ((isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0)
    myrow=eventdata.Indices(1,1);
    handles.indices = eventdata.Indices;
    guidata(hObject, handles);
elseif isfield(handles,'indices') && ~isempty(handles.indices)
    myrow=handles.indices(1,1);
else
    myrow=1;
    handles.indices=[1 1];
    guidata(hObject, handles);
%    set(handles.tbl_runs,'Data',[]);
end

tmpdata=get(handles.tbl_runs,'Data');
if ~isempty(tmpdata)
    if myrow>size(tmpdata,1)
        myrow=1;
        handles.indices=[1 1];
        guidata(hObject, handles);
    end
    RunName=tmpdata{myrow,1};
    if iscell(RunName)
        RunName=RunName{:};
    end
    handles.curses=[];handles.curses.ind=find(strcmp(RunName,{RunArray.RunName})==1, 1 ); % delete min for real data
    if isempty(handles.curses.ind)
        for m=1:length(RunArray)
            if iscell(RunArray(m).RunName)
                RunArray(m).RunName=RunArray(m).RunName{:};
                m
            end
        end
    end
    guidata(hObject, handles);
    formdata(handles);
    fielddata(handles,eventdata);
    groupdata(handles);
    update_avail_outputs(handles);
    update_saved_figs(handles);
    set(handles.txt_figname,'String',RunName);
%     distidx=6;
%     preidx=4;
%     postidx=5;
%     getdetailedconns(handles.btn_generate,handles,preidx,postidx); % precell type column (4), postcelltype column (5)
%     handles=guidata(handles.btn_generate);
end