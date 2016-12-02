function h=SDFwalkthru(handles)
global RunArray myFontName myFontSize myFontWeight

ind = handles.curses.ind;

cropme=0;
posflag=1;

if isfield(handles.curses.cells(1),'mygids')==0
    myhandles= NearElectrode([],handles); % lfpposition(handles);      
    handles.curses.cells=myhandles.curses.cells;
    if isfield(handles,'btn_generate')
        guidata(handles.btn_generate, handles);
    end
end

datarange=[1000 2000];%[0 handles.runinfo.SimDuration];
h=[];
ridx=1;
r=4;

h(ridx)=figure('Color','w','Name',['IvyRast'],'Units','inches','PaperUnits','inches','Position',[.5 .5 4 1.5],'PaperPosition',[0 0 4 1.5],'PaperSize',[4 1.5]);
ridx=ridx+1;

if posflag==1
    plotind = find(ismember(handles.curses.spikerast(:,2),handles.curses.cells(r).mygids)==1);
    plotinda=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
    mma=plot(handles.curses.spikerast(plotinda,1),handles.curses.spikerast(plotinda,2),'Color',[.5 .5 .5],'LineStyle','none','Marker','.','MarkerSize',5);
    hold on
    myylim=[min(handles.curses.spikerast(plotinda,2)) max(handles.curses.spikerast(plotinda,2))];
else
    plotind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
    myylim=[min(handles.curses.spikerast(plotind,2)) max(handles.curses.spikerast(plotind,2))];
end
mm=plot(handles.curses.spikerast(plotind,1),handles.curses.spikerast(plotind,2),'Color','k','LineStyle','none','Marker','.','MarkerSize',5);

xlim(datarange)
ylim(myylim)
ylabel('Ivy Cell GIDs')
xlabel('Time (ms)')
% set(gca,'YTickLabel',{},'YTick',[])

h(ridx)=figure('Color','w','Name',['IvyHist'],'Units','inches','PaperUnits','inches','Position',[.5 .5 4 1.5],'PaperPosition',[0 0 4 1.5],'PaperSize',[4 1.5]);
ridx=ridx+1;
% histogram
binsize=5; %5
N=histc(handles.curses.spikerast(plotind,1),[0:binsize:handles.runinfo.SimDuration]);
hbar=bar([0:binsize:handles.runinfo.SimDuration],N);
%ylim([0 max(max(N(binsize*6:end))*1.1,1)])
set(hbar,'EdgeColor','none')
set(hbar,'FaceColor','k')
box off
xlim(datarange)
xlabel('Time (ms)')
ylabel('# Ivy Cell Spikes')

h(ridx)=figure('Color','w','Name',['IvySDF'],'Units','inches','PaperUnits','inches','Position',[.5 .5 4 1.5],'PaperPosition',[0 0 4 1.5],'PaperSize',[4 1.5]);
ridx=ridx+1;
% spike density function
if cropme
idt = find(handles.curses.spikerast(plotind,1)>handles.general.crop);
else
idt = 1:length(plotind);
end

window=3; % ms
kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
if cropme
    binned= histc(handles.curses.spikerast(plotind(idt),1),[handles.general.crop:1:handles.runinfo.SimDuration]); % binned by 1 ms
else
    binned= histc(handles.curses.spikerast(plotind(idt),1),[0:1:handles.runinfo.SimDuration]); % binned by 1 ms
end
sdf = conv(binned,kernel,'same');
sdf=sdf-sum(sdf)/length(sdf);
if cropme
    me=plot([handles.general.crop:1:handles.runinfo.SimDuration],sdf,'Color','k');
else
    me=plot([0:1:handles.runinfo.SimDuration],sdf,'Color','k');
end
xlim(datarange)
box off
ylabel('Spike Density Function')
xlabel('Time (ms)')


h(ridx)=figure('Color','w','Name',['IvyGram'],'Units','inches','PaperUnits','inches','Position',[.5 .5 4 1.5],'PaperPosition',[0 0 4 1.5],'PaperSize',[4 1.5]);
ridx=ridx+1;
% pwelch of SDF
% [fft_results, f]=periodogram(sdf,[],[],1000,'onesided','power');
[fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
plot(f,fft_results) % semilogy
xlim([0 100])
box off
title('Welch''s periodogram of SDF')
xlabel('Frequency (Hz)')
ylabel('Power')

for b=1:length(h)
    hh=h(b);
    bf = findall(hh,'Type','text');
    for bt=1:length(bf)
        set(bf(bt),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
    bf = findall(hh,'Type','axes');
    for bt=1:length(bf)
        set(bf(bt),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
    end
end