function h=getpyramidalphase(handles,varargin)
global mypath RunArray sl
% This is really for networkclamp results.


ind = handles.curses.ind;
resultsfolder = '00001';

ploton=1;
if ~isempty(varargin)
    thetarange=varargin{1};
    thetaper=1000/mean(thetarange);
    if length(varargin)>1
        ploton=varargin{2};
    end
else
    thetarange=[4 12];
    thetaper=1000/mean(thetarange);
end
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);


d=dir([myrepos(q).dir 'networkclamp_results' sl RunArray(ind).RunName sl resultsfolder sl 'myvrec*.dat']);
% d=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'trace_pyramidalcell*.dat']);
% if isempty(d)
%     celltypestr=inputdlg('No pyramidalcell found, enter name of dominant cell type:');
%     d=dir([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl 'trace_' celltypestr{:} '*.dat']);    
% end
for r=1:length(d)
    mystr(r)=importdata([myrepos(q).dir 'networkclamp_results' sl RunArray(ind).RunName sl resultsfolder sl d(r).name]);
    %mystr(r)=importdata([RunArray(ind).ModelDirectory sl 'results' sl RunArray(ind).RunName sl d(r).name]);
    if ploton
        if r==1
            hz=figure('Color','w');
           lh(1)=plot(mystr(r).data(:,1)/1000,mystr(r).data(:,2)-sum(mystr(r).data(:,2))/length(mystr(r).data(:,2)),'k');
        else
            plot(mystr(r).data(:,1)/1000,mystr(r).data(:,2)-sum(mystr(r).data(:,2))/length(mystr(r).data(:,2)),'k')
        end
        hold on
    end
end

dt=RunArray(ind).TemporalResolution;
Fs=1000/dt;
results_avg=[];
results_vec=[];
vec=[];

for r=1:length(mystr)
    zvec(r)=length(mystr(r).data(:,2));
end

for z=1:min(zvec)
    vec=[];
    for r=1:length(mystr)
        vec(r)=mystr(r).data(z,2);
%         if z==1
%             tmp = mikkoscript(repmat(mystr(r).data(:,2)',1,20),Fs,thetarange,0);
%             results_vec(:,r) = tmp(:,2);
%         end
    end
    myavg(z)=sum(vec); % instead of mean, I think we should add all the lfp contributions together?
%     results_avg(:,1) = tmp(:,1);
%     results_avg(:,2) = mean(results_vec,2);
end
starttime = 40;
gg = mod(length(myavg(starttime/dt:end)),thetaper/dt);
%avg_results = mikkoscript(repmat(myavg(starttime/dt:end),1,20),Fs,thetarange,0);
try
    avg_results = mikkoscript(repmat(myavg(starttime/dt:end-round(gg)),1,25),Fs,thetarange,0);
catch
    avg_results = 0;
end
results = avg_results; %results_avg; %avg_results is the usual one

%if ploton==0
    [~,LOCS]= findpeaks(results(:,2));
    peaktimes=results(LOCS,1);
    peaktimes=1000*peaktimes+starttime;
    modpeaktimes = mod(peaktimes, thetaper);
    n=length(modpeaktimes);
    xbar = 1/n*sum(sin(modpeaktimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modpeaktimes*pi/(thetaper/2)));
    magnitude=sqrt(xbar^2+ybar^2);
    angle = mod(acos(ybar/magnitude),2*pi); % angle of peak of LFP, relative to 0 degrees at t = 0
    h = mod(angle+pi,2*pi); % assume trough angle is 180 degrees out of phase with peak angle (else we will have to invert the results and do findpeaks on that)
    if isnan(h)
        h=0;
    end
if ploton==1
    lh(2)=plot(results(1:round(length(results)/20),1)+starttime/1000,results(1:round(length(results)/20),2),'g','LineWidth',2);
    hold on
    for a=angle*thetaper/1000/(2*pi):thetaper/1000:RunArray(ind).SimDuration/1000
        lh(3)=plot([a a],[-20 20],'c','LineWidth',2)
    end
    for a=h*thetaper/1000/(2*pi):thetaper/1000:RunArray(ind).SimDuration/1000
        lh(4)=plot([a a],[-20 20],'y','LineWidth',2)
    end

    cidx=strmatch('pyramidalcell',{handles.curses.cells(:).name});
    idx=find(handles.curses.spikerast(:,2)>=handles.curses.cells(cidx).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(cidx).range_en);
    spiketimes=round(handles.curses.spikerast(idx,1))/1000;
    spiketimes = unique(spiketimes);
    for g=1:length(spiketimes)
        gidx=find((results(:,1)+starttime/1000)>=spiketimes(g),1,'first');
        if g==1
            lh(5)=plot(results(gidx,1)+starttime/1000,results(gidx,2),'r.','MarkerSize',10);
        else
            plot(results(gidx,1)+starttime/1000,results(gidx,2),'r.','MarkerSize',10)
        end
    end
    ylim([-20 20])
    title({[RunArray(ind).RunName ': Filtered theta range (' num2str(thetarange(1))  ' - ' num2str(thetarange(2)) ' Hz)'],'Spike times on filtered sample LFP trace'},'Interpreter','none')
    legend(lh,{[ num2str(length(d)) ' LFP traces'],['Filtered average of those ' num2str(length(d)) ' traces'],'Est LFP peak',['Est LFP trough'],'Spikes of all pyramidal cells'})
    xlabel('Time (s)')
    ylabel('Relative membrane potential (centered around 0, mV)')
end