function figh=plot_numcondiff(handles)
global RunArray tableh sl

if isfield(handles.curses,'cells')==0
    getcelltypes(handles.btn_generate,guidata(handles.btn_generate))
    handles=guidata(handles.btn_generate);
end
if isfield(handles.curses,'numcons')==0
    numcons(handles.btn_generate,handles);
    handles=guidata(handles.btn_generate);
end

ind = handles.curses.ind;


%%%%%%%%%%%%%%%%%


fid = fopen([RunArray(ind).ModelDirectory sl 'datasets' sl 'conndata_' num2str(RunArray(ind).ConnData) '.dat'],'r');                
numlines = fscanf(fid,'%d\n',1) ;
filedata = textscan(fid,'%s %s %f %f %f\n') ;
fclose(fid);

%%%%%%%%%%%%%%%%%


space4title=42; %pixels

figh=figure('Color', 'w', 'Visible', 'on', 'Units', 'pixels', 'Position', [520 380 560 420]);
numcon=zeros(RunArray(ind).NumCellTypes,RunArray(ind).NumCellTypes);
for v=1:RunArray(ind).NumCellTypes % rows
    for w=1:RunArray(ind).NumCellTypes    % columns
        thistype=find(handles.curses.numcons(:,2)==handles.curses.cells(v).ind & handles.curses.numcons(:,3)==handles.curses.cells(w).ind);
        actualconns=sum(handles.curses.numcons(thistype,4))/handles.curses.cells(w).numcells; % convergence
        
        A = strcmp(filedata{1},handles.curses.cells(v).name);
        B = strcmp(filedata{2},handles.curses.cells(w).name);
        idx=find(A==1 & B==1);
        if isempty(idx)
            desiredconns = 0;
        else
            try
                desiredconns = filedata{4}(idx);
            catch
                desiredconns = 0;
            end
        end
        
        if (actualconns+desiredconns)==0
            numcon(v,w)=1;
        elseif actualconns==0
            numcon(v,w)=0;
        else
            numcon(v,w)=actualconns/desiredconns;
        end
    end
end
myfunc=@context_copytable_Callback;
mycontextmenuh=uicontextmenu('Tag','menu_copyh');
uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);

tableh = uitable(figh, 'Data', numcon, 'ColumnName', {handles.curses.cells(:).name}, 'RowName', {handles.curses.cells(:).name},'UIContextMenu',mycontextmenuh);

textent=get(tableh,'Extent');

myfigpos=get(figh,'Position');
mynewfigpos=[myfigpos(1) myfigpos(2) textent(3) textent(4)+space4title];
set(figh,'Position',mynewfigpos);
us = get(figh,'Units');
set(figh,'Units','inches');
setpos=get(figh,'Position');
set(figh,'Units',us);
set(figh,'PaperUnits', 'inches','PaperSize',[setpos(3) setpos(4)])
set(figh,'PaperUnits','normalized')
set(figh,'PaperPosition',[0 0 1 1])

set(tableh,'Position',[0 0 textent(3) textent(4)]);

axh=axes('Units',get(figh,'Units'),'Position',[0 textent(4) textent(3) space4title],'xlim',[0 1],'ylim',[0 1]);
axis off
%set(axh,'Visible','Off');

text(.5,.5,'Convergence Validation','Parent',axh,'FontSize',18,'HorizontalAlignment','center')


function context_copytable_Callback(hObject,eventdata)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  tableh

mydata=get(tableh,'Data');
myrow=get(tableh,'RowName');
mycol=get(tableh,'ColumnName');


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
        str = sprintf ( '%s%d\t', str, mydata(i,j) );
    end
    str = sprintf ( '%s\n', str(1:end-1));
end
clipboard ('copy', str);

