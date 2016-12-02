function h=plot_spiketrain(handles) % idx contains the column in the spikeraster that gives the cell type index
global RunArray sl

h=[]; %figure;
idx = handles.curses.ind;
%sl = handles.curses.sl;

if isempty(deblank(handles.optarg))
    gidstr=inputdlg('Enter the gid of the cell of interest');
    gid=str2num(gidstr{:});
else
    gid=str2num(handles.optarg);
    gidstr={num2str(gid)};
end

mycells = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/celltype.dat']);
typeidx = find(gid>=mycells.data(:,2) & gid<=mycells.data(:,3));

spikeraster = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/spikeraster.dat']);
spiketrain = spikeraster(spikeraster(:,2)==gid,1);

h = figure('Color', 'w', 'Name', ['Trace for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}]);
pos = get(h,'Position');
set(h,'Position',[pos(1) pos(2) pos(3)*2 pos(4)])

subplot(2,1,1)
plot(spiketrain, gid*ones(size(spiketrain)),'LineStyle','none','Marker','.','MarkerSize',15)
title([RunArray(idx).RunName ' spiketrain for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}],'Interpreter','none')
xlim([0 RunArray(idx).SimDuration])
xlabel('Time (ms)')
ylabel('Gid')



%h(2) = figure('Color', 'w', 'Name', ['Spike FFT for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}]);
subplot(2,2,3)
rez=1; % .1 is simulation resolution

Fs = 1000/rez; % sampling frequency (per s)

bins=[0:rez:RunArray(idx).SimDuration];
y=histc(spiketrain,bins);
y = y-sum(y)/length(y);

NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
Y = fft(y,NFFT)/length(y);
f = Fs/2*linspace(0,1,NFFT/2+1);
fft_results = 2*abs(Y(1:NFFT/2+1));

theta_range=find(f(:)>=4 & f(:)<=12);
[~, peak_idx] = max(fft_results(theta_range));
rel_range=find(f(:)>2 & f(:)<=100);
[~, over_idx] = max(fft_results(rel_range));

% Plot single-sided amplitude spectrum.
plot(f, fft_results)
xlim([0 100])

title([RunArray(idx).RunName ' Spike FFT for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}],'Interpreter','none')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
    
tracefile = [RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/trace_' mycells.textdata{1+typeidx, 1} gidstr{:} '.dat'];
if exist(tracefile,'file')>0
    %h(3) = figure('Color', 'w', 'Name', ['MP FFT for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}]);
    subplot(2,2,4)

    b=importdata(tracefile);
    
    
    rez=b.data(2,1)-b.data(1,1); % .1 is simulation resolution

    Fs = 1000/rez; % sampling frequency (per s)

    y = b.data(:,2)-sum(b.data(:,2))/length(b.data(:,2));

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));
    
    plot(f, fft_results)
    xlim([0 100])
    title([RunArray(idx).RunName ' MP FFT for ' mycells.textdata{1+typeidx, 1} ' ' gidstr{:}],'Interpreter','none')
    xlabel('Time (ms)')
    ylabel('|Y(f)|')
end
    
