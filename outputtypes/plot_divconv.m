function figh=plot_divconv(hObject,handles)
global mypath RunArray tableh tablec tablew tabled

addformatP(handles,hObject);
getcelltypes(hObject,guidata(hObject));
handles=guidata(hObject);
numcons(hObject,handles);
handles=guidata(hObject);

ind = handles.curses.ind;
space4title=42; %pixels

ConnData=RunArray(ind).ConnData;

% Load in weights
fid = fopen([RunArray(ind).ModelDirectory '/datasets/conndata_' num2str(ConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid)

weights=filedata{3};

figh=figure('Color', 'w', 'Visible', 'on', 'Units', 'pixels', 'Position', [520 380 560 420]);
numcon=zeros(RunArray(ind).NumCellTypes+1,RunArray(ind).NumCellTypes+1);
div=zeros(RunArray(ind).NumCellTypes+1,RunArray(ind).NumCellTypes+1);
conv=zeros(RunArray(ind).NumCellTypes+1,RunArray(ind).NumCellTypes+1);
wgt=zeros(RunArray(ind).NumCellTypes+1,RunArray(ind).NumCellTypes+1);
cellnames={'#' handles.curses.cells(:).name};
cellnamet={'CONNECTIONS - #' handles.curses.cells(:).name};
cellnamed={'DIVERGENCE - #' handles.curses.cells(:).name};
cellnamec={'CONVERGENCE - #' handles.curses.cells(:).name};
cellnamew={'WEIGHTS - #' handles.curses.cells(:).name};
colform{1}='numeric';
colformwgt{1}='numeric';
for v=1:RunArray(ind).NumCellTypes % rows
    colform{1+v}='bank';
    colformwgt{1+v}='numeric';
    numcon(v+1,1)=handles.curses.cells(v).numcells;
    div(v+1,1)=1;
    conv(v+1,1)=handles.curses.cells(v).numcells;
    wgt(v+1,1)=handles.curses.cells(v).numcells;
    for w=1:RunArray(ind).NumCellTypes    % columns
        numcon(1,w+1)=handles.curses.cells(w).numcells;
        div(1,w+1)=handles.curses.cells(w).numcells;
        conv(1,w+1)=1;
        wgt(1,w+1)=handles.curses.cells(w).numcells;
        thistype=find(handles.curses.numcons(:,2)==handles.curses.cells(v).ind & handles.curses.numcons(:,3)==handles.curses.cells(w).ind);
        thiswgttype=find(strcmp(filedata{1},handles.curses.cells(v).name)==1 & strcmp(filedata{2},handles.curses.cells(w).name)==1);
        numcon(v+1,w+1)=sum(handles.curses.numcons(thistype,4)); % total conns
        div(v+1,w+1)=sum(handles.curses.numcons(thistype,4))/handles.curses.cells(v).numcells; % divergence
        conv(v+1,w+1)=sum(handles.curses.numcons(thistype,4))/handles.curses.cells(w).numcells; % convergence
        if isempty(thiswgttype)
            wgt(v+1,w+1)=0;
        else
            wgt(v+1,w+1)=weights(thiswgttype); % convergence
        end
    end
end
myfunc=@context_copytable_Callback;
mycontextmenuh=uicontextmenu('Tag','menu_copyh');
uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);

mycontextmenud=uicontextmenu('Tag','menu_copyd');
uimenu(mycontextmenud,'Label','Copy Table','Tag','context_copytabled','Callback',myfunc);

mycontextmenuc=uicontextmenu('Tag','menu_copyc');
uimenu(mycontextmenuc,'Label','Copy Table','Tag','context_copytablec','Callback',myfunc);

mycontextmenuw=uicontextmenu('Tag','menu_copyw');
uimenu(mycontextmenuw,'Label','Copy Table','Tag','context_copytablew','Callback',myfunc);

tableh = uitable(figh, 'Data', numcon, 'ColumnName', cellnames, 'RowName', cellnamet,'Position',[0 0 .3 .3],'UIContextMenu',mycontextmenuh);
tabled = uitable(figh, 'Data', div,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamed,'Position',[0 0 .6 .3],'UIContextMenu',mycontextmenud);
tablec = uitable(figh, 'Data', conv,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamec,'Position',[0 0 .9 .3],'UIContextMenu',mycontextmenuc);
tablew = uitable(figh, 'Data', wgt,'ColumnFormat',colformwgt, 'ColumnName', cellnames, 'RowName', cellnamew,'Position',[0 0 .9 .3],'UIContextMenu',mycontextmenuw);

textent=get(tableh,'Extent');
textend=get(tabled,'Extent');
textenc=get(tablec,'Extent');
textenw=get(tablew,'Extent');

myfigpos=get(figh,'Position');
mynewfigpos=[myfigpos(1) myfigpos(2) textent(3) textent(4)+textend(4)+textenc(4)+textenw(4)+space4title];
set(figh,'Position',mynewfigpos);
us = get(figh,'Units');
set(figh,'Units','inches');
setpos=get(figh,'Position');
set(figh,'Units',us);
set(figh,'PaperUnits', 'inches','PaperSize',[setpos(3) setpos(4)])
set(figh,'PaperUnits','normalized')

curpos = get(figh,'Position');
set(figh,'PaperPosition',[0 0 1 mynewfigpos(4)/curpos(4)])


set(tableh,'Position',[0 0 textent(3) textent(4)]);
set(tabled,'Position',[0 textent(4) textend(3) textend(4)]);
set(tablec,'Position',[0 textent(4)+textend(4) textenc(3) textenc(4)]);
set(tablew,'Position',[0 textent(4)+textend(4)+textenc(4) textenw(3) textenw(4)]);

axh=axes('Units',get(figh,'Units'),'Position',[0 textent(4)+textend(4)+textenc(4)+textenw(4) textent(3) space4title],'xlim',[0 1],'ylim',[0 1]);
axis off
%set(axh,'Visible','Off');  

text(.5,.5,'Connection Matrix','Parent',axh,'FontSize',18,'HorizontalAlignment','center')

function context_copytable_Callback(hObject,eventdata)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath  tableh tablec tablew tabled

%mystr=get(hObject,'Tag');
tablestr=gco; %mystr(end);
mydata=get(tablestr,'Data');
myrow=get(tablestr,'RowName');
mycol=get(tablestr,'ColumnName');
% 
% eval(['mydata=get(table' tablestr ',''Data'');']);
% eval(['myrow=get(table' tablestr ',''RowName'');']);
% eval(['mycol=get(table' tablestr ',''ColumnName'');']);


%load parameters
% create a header
% copy each row
str = sprintf ('\t');
for j=1:size(mydata,2)
    str = sprintf ( '%s%s\t', str, mycol{j} );
end
str = sprintf ( '%s\n', str(1:end-1));
for i=1:size(mydata,1)
    str = sprintf ( '%s%s\t', str, myrow{i} );
    for j=1:size(mydata,2)
        str = sprintf ( '%s%f\t', str, mydata(i,j) );
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);
