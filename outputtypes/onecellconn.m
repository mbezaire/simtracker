function figh=onecellconn(hObject,handles)
global RunArray sl

ind = handles.curses.ind;
%sl = handles.curses.sl;

preidx = 4; %type
postidx = 5; %type

if ~isempty(deblank(handles.optarg)) & ~isempty(str2num(handles.optarg))
    COI=str2num(handles.optarg);
else
    tmp = inputdlg('Enter the GID of the cell of interest:');
    COI = str2num(tmp{1}); % This should be choosable
end
syntype = 'inputs';
w = [];

getcelltypes(hObject,handles)
handles=guidata(hObject);

for r=1:RunArray(ind).NumCellTypes
    if(COI<=handles.curses.cells(r).range_en && COI>=handles.curses.cells(r).range_st)
        w = r; % COI type
        break;
    end
end

% check if detailed conns file available
if exist([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/connections.dat'],'file')
    getdetailedconns(hObject,handles,preidx,postidx,'connections.dat');    
else % if not, use cell_syns and check for that cell being included
    a=dir([RunArray(ind).ModelDirectory '/results/' RunArray(ind).RunName '/trace_*cell' num2str(COI) '.dat']);

    if isempty(a)
        msgbox('All connections were not tracked for that gid.')
        figh=[];
        return
    end
    getdetailedconns(hObject,handles,preidx,postidx,'cell_syns.dat');
end

handles=guidata(hObject);

switch syntype
    case 'inputs'
        idx= handles.curses.connections(:,2)==COI;

        SOI=handles.curses.connections(idx,:);

        numcon=zeros(RunArray(ind).NumCellTypes,RunArray(ind).NumCellTypes);
        for v=1:RunArray(ind).NumCellTypes % rows
            thistype= find(SOI(:,4)==handles.curses.cells(v).ind+1);
            numcon(v,w)=length(thistype);
        end
    case 'outputs'
        idx= handles.curses.connections(:,1)==COI;

        SOI=handles.curses.connections(idx,:);

        numcon=zeros(RunArray(ind).NumCellTypes,RunArray(ind).NumCellTypes);
        for b=1:RunArray(ind).NumCellTypes % rows
            thistype= find(SOI(:,5)==handles.curses.cells(b).ind+1);
            numcon(w,b)=length(thistype);
        end
end

% make a figure
ind = handles.curses.ind;
space4title=42; %pixels

figh=figure('Color', 'w', 'Visible', 'on', 'Units', 'pixels', 'Position', [520 380 560 420]);

tableh = uitable(figh, 'Data', numcon, 'ColumnName', {handles.curses.cells(:).name}, 'RowName', {handles.curses.cells(:).name});

textent=get(tableh,'Extent');

myfigpos=get(figh,'Position');
mynewfigpos=[myfigpos(1) myfigpos(2) textent(3) textent(4)+space4title];
set(figh,'Position',mynewfigpos);
set(tableh,'Position',[0 0 textent(3) textent(4)]);

axh=axes('Units',get(figh,'Units'),'Position',[0 textent(4) textent(3) space4title],'xlim',[0 1],'ylim',[0 1]);
axis off
%set(axh,'Visible','Off');

text(.5,.5,[syntype ' Synapses for ' num2str(COI)],'Parent',axh,'FontSize',18,'HorizontalAlignment','center')
