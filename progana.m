function h=progana(handles)
global RunArray

ind = handles.curses.ind;

cropme=0;

posflag=0;
if strfind(handles.optarg,'pos') %isfield(handles.curses,'epos')
    posflag=1;
end

if posflag==1 && isfield(handles.curses,'epos')==0
    [~, ~, ~, myhandles]=lfpposition(handles);      
    handles.curses.epos=myhandles.curses.epos;
    handles.curses.cells=myhandles.curses.cells;
    guidata(handles.btn_generate, handles);
end

datarange=[0 RunArray(ind).SimDuration];
if ~isempty(strfind(handles.optarg,'['))
    myrangestr=regexp(handles.optarg,'\[[0-9\s]+\]','match');
    handles.optarg=strrep(handles.optarg,myrangestr{:},'');
    datarange=eval(myrangestr{:});
end
h=[];
ridx=1;
handles.optarg=deblank(handles.optarg);
for r=1:length(handles.curses.cells)
    if ~isempty(handles.optarg) && isempty(strfind(handles.optarg,handles.curses.cells(r).name(1:3)))
        continue
    end
    h(ridx)=figure('Color','w','Name',['Breakdown of ' handles.curses.cells(r).name ' activity']);
    subplot(4,1,1)
    % spike raster
    if posflag==1
        plotind = find(ismember(handles.curses.spikerast(:,2),handles.curses.cells(r).mygids)==1);
        plotinda=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
        mma=plot(handles.curses.spikerast(plotinda,1),handles.curses.spikerast(plotinda,2),'Color',[.5 .5 .5],'LineStyle','none','Marker','.','MarkerSize',10);
        hold on
        myylim=[min(handles.curses.spikerast(plotinda,2)) max(handles.curses.spikerast(plotinda,2))];
    else
        plotind=find(handles.curses.spikerast(:,3)==handles.curses.cells(r).ind);
        myylim=[min(handles.curses.spikerast(plotind,2)) max(handles.curses.spikerast(plotind,2))];
    end
    mm=plot(handles.curses.spikerast(plotind,1),handles.curses.spikerast(plotind,2),'Color','k','LineStyle','none','Marker','.','MarkerSize',10);
    ax(1)=gca;
    title(handles.curses.cells(r).name)
    xlim(datarange)
    if diff(myylim)==0
        ylim([myylim(1)-.5 myylim(1)+.5])
    elseif isempty(myylim)
        ylim([-.5 .5])
    else
        ylim(myylim)
    end
    set(gca,'YTickLabel',{},'YTick',[])

    subplot(4,1,2)
    % histogram
    binsize=5; %5
    N=histc(handles.curses.spikerast(plotind,1),[0:binsize:RunArray(ind).SimDuration]);
    hbar=bar([0:binsize:RunArray(ind).SimDuration],N);
    %ylim([0 max(max(N(binsize*6:end))*1.1,1)])
    set(hbar,'EdgeColor','none')
    set(hbar,'FaceColor','k')
    ax(2)=gca;
    title('Histogram of spikes')
    xlim(datarange)

    subplot(4,1,3)
    % spike density function
    if cropme
    idt = find(handles.curses.spikerast(plotind,1)>handles.general.crop);
    else
    idt = 1:length(plotind);
    end
    
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    if cropme
        binned= histc(handles.curses.spikerast(plotind(idt),1),[handles.general.crop:1:RunArray(ind).SimDuration]); % binned by 1 ms
    else
        binned= histc(handles.curses.spikerast(plotind(idt),1),[0:1:RunArray(ind).SimDuration]); % binned by 1 ms
    end
    sdf = conv(binned,kernel,'same');
    sdf=sdf-sum(sdf)/length(sdf);
    if cropme
        me=plot([handles.general.crop:1:RunArray(ind).SimDuration],sdf,'Color','k');
    else
        me=plot([0:1:RunArray(ind).SimDuration],sdf,'Color','k');
    end
    xlim(datarange)
 
    ax(3)=gca;
    title('Spike Density Function')
    
    linkaxes(ax,'x')

    gg=subplot(4,2,7);
    pos=get(gg,'Position');
    set(gg,'Position',[pos(1) pos(2) pos(3) pos(4)*.8]);
    % fft of spikes
    rez=1;
    Fs = 1000/rez; % sampling frequency (per s)

    if cropme
        bins=[handles.general.crop:rez:RunArray(ind).SimDuration];
    else
        bins=[0:rez:RunArray(ind).SimDuration];
    end
    y=histc(handles.curses.spikerast(plotind(idt),1),bins);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));
    plot(f,fft_results) % semilogy
    xlim([0 200])
    title('FFT of spikes')

    gg=subplot(4,2,8);
    pos=get(gg,'Position');
    set(gg,'Position',[pos(1) pos(2) pos(3) pos(4)*.8]);
    % pwelch of SDF
    % [fft_results, f]=periodogram(sdf,[],[],1000,'onesided','power');
    [fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
    plot(f,fft_results) % semilogy
    xlim([0 200])
    title('Pwelch periodogram of SDF')
    
    ridx=ridx+1;
end