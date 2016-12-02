function outrep=nicecellcolor(repotype)
global figo


for nc=1:length(repotype.cells)
    mydata{nc,1}=['<html><body color="' repotype.cells(nc).colorcode '">' repotype.cells(nc).nicename '</body></html>'];
    mydata{nc,2}=['<html><body color="' repotype.cells(nc).colorcode '">' repotype.cells(nc).techname '</body></html>'];
    mydata{nc,3}=['<html><body color="' repotype.cells(nc).colorcode '">' repotype.cells(nc).color '</body></html>'];
    mydata{nc,4}=['<html><body color="' repotype.cells(nc).colorcode '">' repotype.cells(nc).colorcode '</body></html>'];
    mydata{nc,5}=['<html><body color="' repotype.cells(nc).colorcode '">' num2str(repotype.cells(nc).rgb) '</body></html>'];
end

figo=figure('Color','w','Name','Cell Names and Colors','Units','inches','Position',[.5 .5 7.5 6.5],'CloseRequestFcn',@savedata);
handles.repotype = repotype;
handles.tbl_nicenames=uitable('Data',mydata,'ColumnName',{'Formatted Name','Technical Name','Color','Hex Code','RGB'},'ColumnWidth',{120 120 100 60 40},'ColumnEditable',[true false true true true]);
set(handles.tbl_nicenames,'Units','inches','Position',[.25 .25 7 6])
mycontextmenuh=uicontextmenu('Tag','menu_copyh');
uimenu(mycontextmenuh,'Label','Select cell color','Tag','context_copytableh','Callback',@changecolor);
guidata(figo,handles)
set(handles.tbl_nicenames,'UIContextMenu',mycontextmenuh,'CellSelectionCallback',@tbl_nicenames_CellSelectionCallback,'CellEditCallback',@tbl_nicenames_CellEditCallback);
guidata(figo,handles)
uiwait(figo)

function savedata(hObject,~)
handles = guidata(figo);

newrepotype=handles.repotype;

assignin('base','newrepotype',newrepotype);
assignin('caller','newrepotype',newrepotype);
outrep=handles.repotype;
delete(hObject);
end
end

function changecolor(hObject,~)
global figo
handles = guidata(figo);
nc = handles.nc;

handles.repotype.cells(nc).rgb = uisetcolor(handles.repotype.cells(nc).rgb,'Select cell color');
handles.repotype.cells(nc).colorcode = rgb2hex(handles.repotype.cells(nc).rgb);

mydata=get(handles.tbl_nicenames,'Data');

mydata{nc,1}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).nicename '</body></html>'];
mydata{nc,2}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).techname '</body></html>'];
mydata{nc,3}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).color '</body></html>'];
mydata{nc,4}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).colorcode '</body></html>'];
mydata{nc,5}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' num2str(handles.repotype.cells(nc).rgb) '</body></html>'];

set(handles.tbl_nicenames,'Data',mydata);
guidata(figo,handles)
end

function tbl_nicenames_CellSelectionCallback(~, eventdata, ~) %#ok<DEFNU>
global figo
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

handles=guidata(figo);

if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
    handles.nc=eventdata.Indices(1,1);
    guidata(figo, handles);
end
end

function tbl_nicenames_CellEditCallback(~, eventdata, ~) %#ok<DEFNU>
global figo
% This function opens the results folder or specific file associated with
% the results figure list row the user clicked on

handles=guidata(figo);
mydata=get(handles.tbl_nicenames,'Data');

if (isprop(eventdata,'Indices') || isfield(eventdata,'Indices')) && numel(eventdata.Indices)>0
    for m=1:size(eventdata.Indices,1)
        handles.nc=eventdata.Indices(m,1);   
        nc=handles.nc;
        if eventdata.Indices(m,2)==5 && ~isempty(mydata{nc,5})
            handles.repotype.cells(nc).rgb=str2num(rmhtml(mydata{nc,5}));
            if isnumeric(handles.repotype.cells(nc).rgb) && length(handles.repotype.cells(nc).rgb)==3
                handles.repotype.cells(nc).colorcode=rgb2hex(handles.repotype.cells(nc).rgb);
            end
        end

        handles.repotype.cells(nc).colorcode=rmhtml(mydata{nc,4});
        if isempty(handles.repotype.cells(nc).colorcode)
            handles.repotype.cells(nc).colorcode = '#000000';
        elseif strcmp(handles.repotype.cells(nc).colorcode(1),'#')~=1
            handles.repotype.cells(nc).colorcode=['#' handles.repotype.cells(nc).colorcode];
        end

        if length(handles.repotype.cells(nc).colorcode)<7
            handles.repotype.cells(nc).colorcode=[handles.repotype.cells(nc).colorcode repmat('0',1,7-length(handles.repotype.cells(nc).colorcode))];
        elseif length(handles.repotype.cells(nc).colorcode)>7
            handles.repotype.cells(nc).colorcode=handles.repotype.cells(nc).colorcode(1:7);
        end
        handles.repotype.cells(nc).colorcode=upper(handles.repotype.cells(nc).colorcode);
        try
            tmp=hex2rgb(handles.repotype.cells(nc).colorcode);
            handles.repotype.cells(nc).rgb=tmp;
        catch
            handles.repotype.cells(nc).colorcode = '#000000';
            handles.repotype.cells(nc).rgb = [0 0 0];
        end
        
        if isempty(handles.repotype.cells(nc).rgb)
            handles.repotype.cells(nc).colorcode = '#000000';
            handles.repotype.cells(nc).rgb = [0 0 0];
        end
        
        handles.repotype.cells(nc).nicename = rmhtml(mydata{nc,1});
        handles.repotype.cells(nc).techname = rmhtml(mydata{nc,2});
        handles.repotype.cells(nc).color = rmhtml(mydata{nc,3});
        
        mydata{nc,1}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).nicename '</body></html>'];        
        mydata{nc,2}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).techname '</body></html>'];        
        mydata{nc,3}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).color '</body></html>'];        
        mydata{nc,4}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' handles.repotype.cells(nc).colorcode '</body></html>'];        
        mydata{nc,5}=['<html><body color="' handles.repotype.cells(nc).colorcode '">' num2str(handles.repotype.cells(nc).rgb) '</body></html>'];        
    end
    set(handles.tbl_nicenames,'Data',mydata);
    guidata(figo, handles);
end
end

function newstr=rmhtml(mystr)
tmpstr=regexp(mystr,'<html><body color="[#A-Z0-9]*">([^\<]+)</body></html>','tokens');
if ~isempty(tmpstr)
    newstr=tmpstr{1}{:};
elseif strcmp(mystr(1:6),'<html>')
    newstr='';
else
    newstr=mystr;
end
if length(newstr)>length('></body></html>') && strcmp(newstr(end-length('></body></html>')+1:end),'></body></html>')
    newstr='';
end
end