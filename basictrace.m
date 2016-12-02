function [h, mytrace]=basictrace(resultname,handles,zoomrange)
global mypath myFontSize
totrange=0;
myw=6;
olderflag=1;

        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        q=find([myrepos.current]==1);

posflag=0;
if isfield(handles.curses.cells(1),'mygids')
    posflag=1;
end

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'pyramidalcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_pyramidalcell99180.dat']);
end
mytrace.pyramidal.trace=zztrace.data;
mytrace.pyramidal.color=[.0 .0 .6];
mytrace.pyramidal.pos=1;
mytrace.pyramidal.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.pyramidal.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'pvbasketcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_pvbasketcell333500.dat']);
end
mytrace.pvbasket.trace=zztrace.data;
mytrace.pvbasket.color=[.0 .75 .65];
mytrace.pvbasket.pos=2;
mytrace.pvbasket.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.pvbasket.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'cckcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_cckcell5840.dat']);
end
mytrace.cck.trace=zztrace.data;
mytrace.cck.color=[1 .75 .0];
mytrace.cck.pos=3;
mytrace.cck.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.cck.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'scacell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_scacell338400.dat']);
end
mytrace.sca.trace=zztrace.data;
mytrace.sca.color=[1 .5 .3];
mytrace.sca.pos=4;
mytrace.sca.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.sca.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'axoaxoniccell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_axoaxoniccell360.dat']);
end
mytrace.axoaxonic.trace=zztrace.data;
mytrace.axoaxonic.color=[1 .0 .0];
mytrace.axoaxonic.pos=5;
mytrace.axoaxonic.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.axoaxonic.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'bistratifiedcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_bistratifiedcell1800.dat']);
end
mytrace.bistratified.trace=zztrace.data;
mytrace.bistratified.color=[.6 .4 .1];
mytrace.bistratified.pos=6;
mytrace.bistratified.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.bistratified.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'olmcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_olmcell20900.dat']); % 20818
end
mytrace.olm.trace=zztrace.data;
mytrace.olm.color=[.5 .0 .6];
mytrace.olm.pos=7;
mytrace.olm.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.olm.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'ivycell');
end
zztrace=[];
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_ivycell10360.dat']); % 13000
end
mytrace.ivy.trace=zztrace.data;
mytrace.ivy.color=[.6 .6 .6];
mytrace.ivy.pos=8;
mytrace.ivy.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.ivy.range;

zztrace=[];
if posflag==1
    zztrace=loadmyfile(handles,resultname,'ngfcell');
end
if isempty(zztrace)
    zztrace=importdata([myrepos(q).dir sl resultname sl 'trace_ngfcell17870.dat']);
end
mytrace.ngf.trace=zztrace.data;
mytrace.ngf.color=[1 .1 1];
mytrace.ngf.pos=9;
mytrace.ngf.range=max(zztrace.data(:,2))-min(zztrace.data(:,2))+2;
totrange = totrange + mytrace.ngf.range;

matchstr={'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell'};
NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.'};
handles.formatP.left = .065;
handles.formatP.bottom=.065;

intracehgt=4;
if olderflag==1
    h=figure('Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[myw intracehgt],'PaperPosition',[0 0  myw intracehgt],'Position',[.5 .5  myw intracehgt],'Name','Trace');
else
    h=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[myw intracehgt],'PaperPosition',[0 0  myw intracehgt],'Position',[.5 .5  myw intracehgt],'Name','Trace');
end
%pos=get(gcf,'Units');
%set(gcf,'Units','normalized','Position',[0.1 0.1 .9 .9]);
%set(gcf,'Units',pos);

prevend=.96;%+handles.formatP.bottom*2;
mycells=fieldnames(mytrace);
for m=1:length(mycells)
    %subplot(length(mycells),1,mytrace.(mycells{m}).pos)
    tidx=find(mytrace.(mycells{m}).trace(:,1)>=zoomrange(1) & mytrace.(mycells{m}).trace(:,1)<=zoomrange(2));
    g(m)=subplot('Position',[handles.formatP.left*2 prevend-mytrace.(mycells{m}).range/totrange*(.96-handles.formatP.bottom*2) .9-handles.formatP.left .95*mytrace.(mycells{m}).range/totrange*(.96-handles.formatP.bottom*2)]);
    prevend=prevend-mytrace.(mycells{m}).range/totrange*(.96-handles.formatP.bottom*2);
    plot(g(m),mytrace.(mycells{m}).trace(tidx,1),mytrace.(mycells{m}).trace(tidx,2),'Color',mytrace.(mycells{m}).color,'LineWidth',1.0)
    if mytrace.(mycells{m}).pos==9
        ylim([min(mytrace.(mycells{m}).trace(tidx,2))-5 max(mytrace.(mycells{m}).trace(tidx,2))+1])
    else
        ylim([min(mytrace.(mycells{m}).trace(tidx,2))-1*3 max(mytrace.(mycells{m}).trace(tidx,2))+1])
    end
    z=strmatch([mycells{m} 'cell'],matchstr,'exact');
    bd=ylabel(NiceAbbrev{z},'Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',myFontSize);
    set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);
    box off
    set(g(m),'Clipping','off','ycolor',mytrace.(mycells{m}).color,'xcolor','w','YTick',[],'YTickLabel',{},'LineWidth',0.5)
%     if mytrace.(mycells{m}).pos==9
%         xlabel('Time (ms)','FontName','ArialMT','FontWeight','bold','FontSize',myFontSize)
%         set(g(m),'FontName','ArialMT','FontWeight','bold','FontSize',myFontSize,'xcolor','w')
%     else
        set(g(m),'XTick',[],'XTickLabel',{})
%     end
    ax2(m) = axes('Position', get(g(m), 'Position'),'Color','none');
    set(ax2(m),'XTick',[],'YTick',[],'XColor','w','YColor','w','box','on','layer','top','LineWidth',1.1)
end
linkaxes(g,'x');

axes(g(end))
hold on
yL=get(gca,'YLim');
xL=get(gca,'XLim');
plot([xL(2)-3 xL(2)-3],[yL(1)+2 yL(1)+52],'k','LineWidth',2)
plot([xL(2)-103 xL(2)-3],[yL(1)+2 yL(1)+2],'k','LineWidth',2)
%text(xL(2)-30,yL(2),{'100 ms','20 mV'},'HorizontalAlignment','right','FontName','ArialMT','FontSize',myFontSize)
pospos=get(gca,'Position');
ngfdiff=(50/diff(ylim))*pospos(4);

if olderflag==1
    h(2)=figure('Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw 1.2],'PaperPosition',[.3 .3 myw 1.2],'Name','LFP','Units','inches','Position',[.5 .5 myw 1.2]);
else
    h(2)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw 1.2],'PaperPosition',[.3 .3 myw 1.2],'Name','LFP','Units','inches','Position',[.5 .5 myw 1.2]);
end
%pos=get(gcf,'Units');
%set(gcf,'Units','normalized','Position',[0.1 0.1 .9 .3]);
%set(gcf,'Units',pos);
subplot('Position',[handles.formatP.left*2 handles.formatP.bottom*2 .9-handles.formatP.left .95*(1-handles.formatP.bottom*2)]);
tidx=find(handles.curses.lfp(:,1)>=zoomrange(1) & handles.curses.lfp(:,1)<=zoomrange(2));


% if posflag==1
%     plot(handles.curses.lfp(tidx,1),handles.curses.epos.lfp(tidx),'Color','k','LineWidth',2)
% else
    plot(handles.curses.lfp(tidx,1),handles.curses.lfp(tidx,2),'Color','k','LineWidth',2)
% end
bd=ylabel('LFP','Rotation',0,'HorizontalAlignment','Right','FontName','ArialMT','FontWeight','bold','FontSize',myFontSize);
set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);
box off
xlabel('Time (ms)','FontName','ArialMT','FontWeight','bold','FontSize',myFontSize)
set(gca,'Clipping','off','ycolor','k','xcolor','w','YTick',[],'YTickLabel',{})
ax2 = axes('Position', get(gca, 'Position'),'Color','none');
set(ax2,'XTick',[],'YTick',[],'XColor','w','YColor','w','box','on','layer','top')

lfpht=.55;%.7; %.55;

filteredlfp=mikkofilter(handles.curses.lfp,1000/handles.runinfo.lfp_dt);
if olderflag==1
    h(3)=figure('Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw lfpht],'PaperPosition',[0 0 myw lfpht],'Name','Filtered LFP','Units','inches','Position',[.5 .5 myw 1]);
else
    h(3)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw lfpht],'PaperPosition',[0 0 myw lfpht],'Name','Filtered LFP','Units','inches','Position',[.5 .5 myw lfpht]);
end
subplot('Position',[handles.formatP.left*2 handles.formatP.bottom .9-handles.formatP.left .95*(1-handles.formatP.bottom*2)]);
tidx=find(filteredlfp(:,1)>=zoomrange(1) & filteredlfp(:,1)<=zoomrange(2));
plot(filteredlfp(tidx,1),filteredlfp(tidx,2),'Color','k','LineWidth',2)
bd=ylabel({'Theta','Filtered','LFP'},'FontName','ArialMT','FontWeight','bold','FontSize',myFontSize,'Rotation',0,'HorizontalAlignment','Right');
set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);
set(bd,'Units','character')
box off
set(gca,'XTick',[],'XTickLabel',{},'XColor','w')
ylim([min(filteredlfp(tidx,2))-(max(filteredlfp(tidx,2))-min(filteredlfp(tidx,2)))*.1 max(filteredlfp(tidx,2))+(max(filteredlfp(tidx,2))-min(filteredlfp(tidx,2)))*.1])
hold on

disp(['Scale difference: 1 mV on ngf scale = ' num2str(ngfdiff/(.95*(1-handles.formatP.bottom*2))*diff(ylim)) ' mV on here'])

set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',myFontSize)
set(gca,'Clipping','off','ycolor','k','xcolor','k','YTick',[],'YTickLabel',{})
ax2 = axes('Position', get(gca, 'Position'),'Color','none');
set(ax2,'XTick',[],'YTick',[],'XColor','w','YColor','w','box','off','layer','top','LineWidth',2)

filteredlfp=mikkofilter(handles.curses.lfp,1000/handles.runinfo.lfp_dt,[25 40]);
if olderflag==1
    h(4)=figure('Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw lfpht],'PaperPosition',[0 0 myw lfpht],'Name','Filtered LFP Gamma','Units','inches','Position',[.5 .5 myw lfpht]);
else
    h(4)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Visible','on','Color','w','PaperUnits','inches','PaperSize',[myw lfpht],'PaperPosition',[0 0 myw lfpht],'Name','Filtered LFP','Units','inches','Position',[.5 .5 myw lfpht]);
end
subplot('Position',[handles.formatP.left*2 handles.formatP.bottom .9-handles.formatP.left .95*(1-handles.formatP.bottom*2)]);
tidx=find(filteredlfp(:,1)>=zoomrange(1) & filteredlfp(:,1)<=zoomrange(2));
plot(filteredlfp(tidx,1),filteredlfp(tidx,2),'Color','k','LineWidth',2)
bd=ylabel({'Gamma','Filtered','LFP'},'FontName','ArialMT','FontWeight','bold','FontSize',myFontSize,'Rotation',0,'HorizontalAlignment','Right');
set(bd, 'Units', 'Normalized', 'Position', [-0.03, 0.3, 0]);
set(bd,'Units','character')
box off
set(gca,'XTick',[],'XTickLabel',{},'XColor','w')
ylim([min(filteredlfp(tidx,2))-(max(filteredlfp(tidx,2))-min(filteredlfp(tidx,2)))*.1 max(filteredlfp(tidx,2))+(max(filteredlfp(tidx,2))-min(filteredlfp(tidx,2)))*.1])
hold on

disp(['Scale difference: 1 mV on ngf scale = ' num2str(ngfdiff/(.95*(1-handles.formatP.bottom*2))*diff(ylim)) ' mV on here'])

set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',myFontSize)
set(gca,'Clipping','off','ycolor','k','xcolor','k','YTick',[],'YTickLabel',{})
ax2 = axes('Position', get(gca, 'Position'),'Color','none');
set(ax2,'XTick',[],'YTick',[],'XColor','w','YColor','w','box','off','layer','top','LineWidth',2)


function trace=loadmyfile(handles,resultname,celltype)
    trace=[];
    fd=strmatch(celltype,{handles.curses.cells.name});
    myfile='';
    r=1;
    while ~isempty(fd) && r<=length(handles.curses.cells(fd).mygids) && isempty(myfile)
        if exist([myrepos(q).dir sl resultname sl 'trace_' celltype num2str(handles.curses.cells(fd).mygids(r)) '.dat'],'file')==2
            myfile=[myrepos(q).dir sl resultname sl 'trace_' celltype num2str(handles.curses.cells(fd).mygids(r)) '.dat'];
        end
        r=r+1;
    end
    if isempty(myfile)
        disp(['no ' celltype ' cells within area were recorded'])
    else
        trace=importdata(myfile);
        disp(['Importing: ' myfile])
    end
