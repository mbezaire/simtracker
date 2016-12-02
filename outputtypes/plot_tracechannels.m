function h=plot_tracechannels(handles) % idx contains the column in the spikeraster that gives the cell type index
global RunArray sl

h=[]; %figure;
idx = handles.curses.ind;
%sl = handles.curses.sl;
d=1;

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the gid of the cell of interest');
    gid=str2num(gidstr{:});
else
    gid=str2num(handles.optarg);
    gidstr={num2str(gid)};
end

a=dir([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl 'trace_*cell' gidstr{:} '.dat']);

if isempty(a)
    msgbox('There is no trace available for that gid.')
    return
end

mycell = a.name(7:end-4);
x = length(gidstr{:});
celltype = mycell(1:end-x);
colorvec={'m','g','r','k'};
h(1) = figure('Color', 'w', 'Name', [RunArray(idx).RunName ' trace for ' mycell]);
pos=get(h(1),'Position');
set(h(1),'Position',[pos(1) pos(2) pos(3)*2 pos(4)])
b=importdata([RunArray(idx).ModelDirectory sl 'results' sl RunArray(idx).RunName sl a.name]);
if size(b.data,2)>2
    [ax, legm(1), legm(2)]=plotyy(b.data(:,1),b.data(:,2),b.data(:,1),b.data(:,3));
    set(legm(1),'Color',[.5 .5 .5])
    set(legm(2),'Color','b')
    set(ax(1),'YColor',[.5 .5 .5])
    set(ax(2),'YColor','k','YLimMode','auto','YTickLabelMode','auto','YTickMode','auto')
    axes(ax(2))

    for z=4:size(b.data,2)
        hold on
        legm(z-1)=plot(ax(2),b.data(:,1),b.data(:,z),'Color',colorvec{z-3});
    end
    ylabel(ax(1),'Potential (mV)')
    ylabel(ax(2),'Current (nA)')

    legend(legm,b.colheaders(2:end))

    lims=get(ax(2),'ylim');
    mybound=min(abs(lims));
    set(ax(2),'ylim',[-mybound mybound])

    avgtrace=median(b.data(:,2));
    midline=round(avgtrace);
    set(ax(1),'ylim',[midline-30 midline+30])
else
    plot(b.data(:,1),b.data(:,2))
    ylabel('Potential (mV)')
end
xlabel('Time (ms)')
title([RunArray(idx).RunName ': ' strrep(strrep(a.name(7:end),'cell',' cell, gid: '),'.dat','')])



