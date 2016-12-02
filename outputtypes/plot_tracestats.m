function h = plot_tracestats(handles)
global mypath RunArray

h=[]; %figure;
idx = handles.curses.ind;

skip=10;
mycells = importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/celltype.dat']);

for z=1:size(mycells.data,1)
    traces=dir([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/trace_' char(mycells.textdata(1+z, 1)) '*.dat']);
    if isempty(traces)
        continue
    end
    data=importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/' traces(1).name]);
    data=data.data;

    for r=2:length(traces)
        tmp=importdata([RunArray(idx).ModelDirectory '/results/' RunArray(idx).RunName '/' traces(r).name]);
        data(:,1+r)=tmp.data(:,2);
    end

    ni = size(data,2);

    for r=1:length(data)
        data(r,ni+1)=mean(data(r,2:ni)); % mean
        data(r,ni+2)=min(data(r,2:ni));  % min
        data(r,ni+3)=max(data(r,2:ni));  % max
        data(r,ni+4)=std(data(r,2:ni));  % stdev
    end

    % Plot time stats
    h(length(h)+1)=figure;plot(data(:,1),data(:,ni+1));title(['Mean for selected ' char(mycells.textdata(1+z, 1)) 's (n=' num2str(length(traces)) ')']);
    xlabel('Time (ms)');ylabel('Intracellular Potential (mV)');title([RunArray(idx).RunName ' ' char(mycells.textdata(1+z, 1))],'Interpreter','none');
    hold on
    plot(data(:,1),data(:,ni+1)-data(:,ni+4),'g')
    plot(data(:,1),data(:,ni+1)+data(:,ni+4),'g')
    plot(data(:,1),data(:,ni+2),'r')
    plot(data(:,1),data(:,ni+3),'r')
    set(gcf,'Color','w','Name',['Trace Stats for ' char(mycells.textdata(1+z, 1))])
    legend('mean','+std','-std','max','min')

%     % FFT
%     rez=.1*skip; % .1 is simulation resolution
% 
%     Fs = 1000/rez; % sampling frequency (per s)
% 
%     %bins=[0:rez:RunArray(ind).SimDuration];
%     y=data(1:skip:end,ni+1);
% 
%     NFFT = 2^nextpow2(length(y)); % Next power of 2 from length of y
%     Y = fft(y,NFFT)/length(y);
%     f = Fs/2*linspace(0,1,NFFT/2+1);
% 
%     % Plot single-sided amplitude spectrum.
%     h(length(h)+1)=figure;
%     plot(f,2*abs(Y(1:NFFT/2+1))) 
%     title(['Single-Sided Amplitude Spectrum of selected ' char(mycells.textdata(1+z, 1)) ' MEAN activity (res=' num2str(rez) ')'])
%     xlabel('Frequency (Hz)')
%     ylabel('|Y(f)|')
%     set(gcf,'Color','w','Name',['Amplitude Spectrum for ' char(mycells.textdata(1+z, 1))])
end