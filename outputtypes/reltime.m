function h=reltime(handles)

ind = handles.curses.ind;
sl = handles.curses.sl;

    msgbox('This may not work right anymore: findobj figure')
for r=length(findobj('Type','figure')):-1:1
    str=get(figure(r),'Name');
    if length(str)>11 & strmatch(str(end-11:end),'Spike Raster')
        [timerange cellrange]=ginput(2);

        [gidrange, celltype]=getrange(cellrange,handles);
        idx = find(handles.curses.spikerast(:,1)>timerange(1) & handles.curses.spikerast(:,1)<timerange(2) & handles.curses.spikerast(:,2)>=gidrange(1) & handles.curses.spikerast(:,2)<=gidrange(2));

        subset=handles.curses.spikerast(idx,:);

        [~, minidx] = min(subset(:,1));
        [~, maxidx] = max(subset(:,1));

        disp(['-- ' celltype ' --']);
        disp(['Between ' num2str(subset(minidx,1)) ' ms and ' num2str(subset(maxidx,1)) ' ms (' num2str(subset(maxidx,1)-subset(minidx,1)) ' ms), there were ' num2str(length(subset)) ' spikes by ' num2str(length(unique(subset(:,2)))) ' different cells']);
        disp(['The first cell to spike was gid ' num2str(subset(minidx,2)) ' and the last one was ' num2str(subset(maxidx,2))]);
        disp('  --  ');
        break;
    end
end
h=[];

[~, idx]=sort(pulses(:,1));
pulses=pulses(idx);
cells=cells(idx);

figure;
for r=1:size(pulses,1)
    plot(pulses(r,1),r,'LineStyle','None','Marker','.','MarkerSize',10)
    hold on
    plot([pulses(r,3) pulses(r,4)], [r r],'-')
    text(pulses(r,1),r-.5,cells{r})
end

yl = get(gca,'ylim');
ylim([yl(1)-1 yl(2)+1])

xl = get(gca,'xlim');
xlim([-1 xl(2)])

xlabel('Lag time relative to first pyramidal cell spike of pulse (ms)')
ylabel('Cell type')


function [gidrange, celltype]=getrange(cellrange,handles)
global mypath RunArray

gidrange=[];
celltype='';
ind = handles.curses.ind;
sl = handles.curses.sl;

mycells = importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'celltype.dat']);
for r=1:size(mycells.data,1)
    if cellrange(1)>mycells.data(r,2) && cellrange(2)<mycells.data(r,3)
        gidrange = [mycells.data(r,2) mycells.data(r,3)];
        celltype=char(mycells.textdata(1+r));
    end
end