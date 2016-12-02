function figh=plot_numcons(handles)
global RunArray tableh sl

ind = handles.curses.ind;
space4title=42; %pixels

figh=figure('Color', 'w', 'Visible', 'on', 'Units', 'pixels', 'Position', [100 100 560 420]);
numcon=zeros(RunArray(ind).NumCellTypes,RunArray(ind).NumCellTypes);
for v=1:RunArray(ind).NumCellTypes % rows
    for w=1:RunArray(ind).NumCellTypes    % columns
        thistype=find(handles.curses.numcons(:,2)==handles.curses.cells(v).ind & handles.curses.numcons(:,3)==handles.curses.cells(w).ind);
        numcon(v,w)=sum(handles.curses.numcons(thistype,4));
    end
end
if RunArray(ind).NumConnections==0
    RunArray(ind).NumConnections=sum(numcon(:));
else
    disp([RunArray(ind).RunName ' summed numcon=' num2str(sum(numcon(:))) ', NumConnections=' num2str(RunArray(ind).NumConnections)])
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

text(.5,.5,'Connection Matrix','Parent',axh,'FontSize',18,'HorizontalAlignment','center')


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

