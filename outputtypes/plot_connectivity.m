function figh=plot_connectivity(hObject,handles)
global mypath RunArray tableh sl

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
tmp=lower(deblank(handles.optarg));

switch tmp
    case 'convdiv'
        mycontextmenud=uicontextmenu('Tag','menu_copyd');
        uimenu(mycontextmenud,'Label','Copy Table','Tag','context_copytableh1','Callback',myfunc);

        mycontextmenuc=uicontextmenu('Tag','menu_copyc');
        uimenu(mycontextmenuc,'Label','Copy Table','Tag','context_copytableh2','Callback',myfunc);
        tableh(1) = uitable(figh, 'Data', div,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamed,'Position',[0 0 .9 .45],'UIContextMenu',mycontextmenud);
        tableh(2) = uitable(figh, 'Data', conv,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamec,'Position',[0 .45 .9 .45],'UIContextMenu',mycontextmenuc);
        textend=get(tableh(1),'Extent');
        textenc=get(tableh(2),'Extent');
        textent=[textend;textenc];
        titlestr='Convergence & Divergence';

    case 'divconv'
        mycontextmenud=uicontextmenu('Tag','menu_copyd');
        uimenu(mycontextmenud,'Label','Copy Table','Tag','context_copytableh1','Callback',myfunc);

        mycontextmenuc=uicontextmenu('Tag','menu_copyc');
        uimenu(mycontextmenuc,'Label','Copy Table','Tag','context_copytableh2','Callback',myfunc);
        tableh(1) = uitable(figh, 'Data', div,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamed,'Position',[0 0 .9 .45],'UIContextMenu',mycontextmenud);
        tableh(2) = uitable(figh, 'Data', conv,'ColumnFormat',colform, 'ColumnName', cellnames, 'RowName', cellnamec,'Position',[0 .45 .9 .45],'UIContextMenu',mycontextmenuc);
        textend=get(tableh(1),'Extent');
        textenc=get(tableh(2),'Extent');
        textent=[textend;textenc];
        titlestr='Convergence & Divergence';
        
    case 'weights'
        mycontextmenuw=uicontextmenu('Tag','menu_copyw');
        uimenu(mycontextmenuw,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
        tableh = uitable(figh, 'Data', wgt,'ColumnFormat',colformwgt, 'ColumnName', cellnames, 'RowName', cellnamew,'Position',[0 0 .9 .9],'UIContextMenu',mycontextmenuw);
        textent=get(tableh,'Extent');
        titlestr='Synapse Weights';
        
    case 'axondist'
        myans=questdlg('This one can take a long time if you have recorded a lot of cells in a large network. Continue?','Proceed?','Yes','No','Yes');
        if strcmp(myans,'No')
            close(figh);
            return
        end
        if isfield(handles.curses,'connections')==0 || isempty(handles.curses.connections)
            getcellsyns(hObject,handles);
            handles = guidata(hObject);
        end
        
        
        for b=1:size(handles.curses.position,1)
            midx=find(handles.curses.connections(:,1)==handles.curses.position(b,1));
            handles.curses.connections(midx,4:6)=repmat(handles.curses.position(b,2:4),length(midx),1);
            midx=find(handles.curses.connections(:,2)==handles.curses.position(b,1));
            handles.curses.connections(midx,7:9)=repmat(handles.curses.position(b,2:4),length(midx),1);
        end
        
        for r=1:length(handles.curses.cells)
            for w=1:length(handles.curses.cells)
                mydx=[];
                pos1=[];
                pos2=[];
                mydist=[];
                mydx=find(handles.curses.connections(:,1)>=handles.curses.cells(r).range_st & handles.curses.connections(:,1)<=handles.curses.cells(r).range_en ...
                    & handles.curses.connections(:,2)>=handles.curses.cells(w).range_st & handles.curses.connections(:,2)<=handles.curses.cells(w).range_en);
                mydist=sqrt((handles.curses.connections(mydx,4)-handles.curses.connections(mydx,7)).^2+(handles.curses.connections(mydx,5)-handles.curses.connections(mydx,8)).^2); % only calculate the distance in the xy plane
                subplot(length(handles.curses.cells),length(handles.curses.cells),(r-1)*length(handles.curses.cells)+w)
                hist(mydist)
                xlim([0 1500])
                set(gca,'XTickLabel',{},'YTickLabel',{})
                if r==length(handles.curses.cells(w).name)
                    xlabel(handles.curses.cells(w).name(1:3))
                end
                if w==1
                    ylabel(handles.curses.cells(r).name(1:3))
                end
            end
        end
        
        axh=axes('Units','Normalized','Position',[0 .9 1 .1],'xlim',[0 1],'ylim',[0 1]);
        axis off
        text(.5,.5,'Axonal Distributions computed from recorded cells (synapses v. microns from soma to soma)','Parent',axh,'FontSize',14,'HorizontalAlignment','center')
        return
    case 'grade'
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
        mycontextmenuh=uicontextmenu('Tag','menu_copyh');
        uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
        tableh = uitable(figh, 'Data', numcon, 'ColumnName', cellnames, 'RowName', cellnamet,'Position',[0 0 .9 .9],'UIContextMenu',mycontextmenuh);
        textent=get(tableh,'Extent');
        titlestr='Actual v. Desired (1: match, other #: fraction of conns made)';
        
    otherwise % 'matrix' or blank
        mycontextmenuh=uicontextmenu('Tag','menu_copyh');
        uimenu(mycontextmenuh,'Label','Copy Table','Tag','context_copytableh','Callback',myfunc);
        tableh = uitable(figh, 'Data', numcon, 'ColumnName', cellnames, 'RowName', cellnamet,'Position',[0 0 .9 .9],'UIContextMenu',mycontextmenuh);
        textent=get(tableh,'Extent');
        titlestr='Connection Matrix';

end

myfigpos=get(figh,'Position');
mynewfigpos=[myfigpos(1) myfigpos(2) textent(1,3) sum(textent(:,4))+space4title];
set(figh,'Position',mynewfigpos);
us = get(figh,'Units');
set(figh,'Units','inches');
setpos=get(figh,'Position');
set(figh,'Units',us);
set(figh,'PaperUnits', 'inches','PaperSize',[setpos(3) setpos(4)])
set(figh,'PaperUnits','normalized')

curpos = get(figh,'Position');
set(figh,'PaperPosition',[0 0 1 mynewfigpos(4)/curpos(4)])


for t=1:length(tableh)
    set(tableh(t),'Position',[0 sum(textent(1:t-1,4)) textent(1,3) textent(t,4)]);
end

axh=axes('Units',get(figh,'Units'),'Position',[0 sum(textent(:,4)) textent(1,3) space4title],'xlim',[0 1],'ylim',[0 1]);
axis off
text(.5,.5,titlestr,'Parent',axh,'FontSize',18,'HorizontalAlignment','center')


function context_copytable_Callback(hObject,eventdata)
% hObject    handle to context_copytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath  tableh

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
