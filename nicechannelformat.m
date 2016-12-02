function outrep=nicechannelformat(repotype)
global figm

for nc=1:length(repotype.channels)
    mydata{nc,1}=repotype.channels(nc).techname;
    mydata{nc,2}=repotype.channels(nc).formatname;
    mydata{nc,3}=repotype.channels(nc).nicename;
end

figm=figure('Color','w','Name','Channel Names','Units','inches','Position',[.5 .5 7.5 6.5],'CloseRequestFcn',@savedata);
handles.repotype = repotype;
handles.tbl_nicenames=uitable('Data',mydata,'ColumnName',{'Technical Name','Formatted Name','Long Name'},'ColumnWidth',{100 100 200},'ColumnEditable',[false true true]);
set(handles.tbl_nicenames,'Units','inches','Position',[.25 .25 7 6])
set(handles.tbl_nicenames,'CellSelectionCallback',@tbl_nicenames_CellSelectionCallback,'CellEditCallback',@tbl_nicenames_CellEditCallback);
guidata(figm,handles)
uiwait(figm)


function savedata(hObject,~)
handles = guidata(figm);

newrepotype=handles.repotype;

assignin('base','newrepotype',newrepotype);
assignin('caller','newrepotype',newrepotype);
outrep=handles.repotype;
delete(hObject);
end
end

function tbl_nicenames_CellSelectionCallback(~, eventdata, ~) %#ok<DEFNU>
global figm
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

handles=guidata(figm);

if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
    handles.nc=eventdata.Indices(1,1);
    guidata(figm, handles);
end
end

function tbl_nicenames_CellEditCallback(~, eventdata, ~) %#ok<DEFNU>
global figm
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

handles=guidata(figm);
mydata=get(handles.tbl_nicenames,'Data');

if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
    for m=1:size(eventdata.Indices,1)
        handles.nc=eventdata.Indices(m,1);   
        nc=handles.nc;
        
        handles.repotype.channels(nc).techname=mydata{nc,1};
        handles.repotype.channels(nc).formatname=mydata{nc,2};
        handles.repotype.channels(nc).nicename=mydata{nc,3};
    end
    set(handles.tbl_nicenames,'Data',mydata);
    guidata(figm, handles);
end
end