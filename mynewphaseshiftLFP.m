function [anglebase, anglepv, anglesom, h, mydata]=mynewphaseshiftLFP()
global mypath myFontSize myFontWeight sl savepath
lowrange=7;
highrange=9;
thetaper=125;
h=[];
percof=10;
pwelchflag=1;
normflag=1;
lfpflag=0;
newlfp=0;
addylim=0;
addme=.00;
if newlfp==1
    shiftme = 0;
else
    shiftme = 6;  %<-- Ivan asked for this shift to be set to 6 so that the histogram lines up with full network histograms and experimental histograms
end
bins = 12;
stepsize = thetaper/bins;

lw=1.0;
ls='-';

if isempty(myFontSize)
    myFontSize=8;
end
if isempty(myFontWeight)
    myFontWeight='normal';
end

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);


% % example code to compute SDF
% binned= histc(handles.curses.spikerast(idx(idt),1),[handles.general.crop:1:RunArray(ind).SimDuration]); % binned by 1 ms
% window=3; % ms
% kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
% sdf = conv(binned,kernel,'same');
% sdf=sdf-sum(sdf)/length(sdf);

ModelDirectory=myrepos(q).dir;

MyRunName='phasic123';%'ca1_nlfp_long_exc_065_01_02'; % CutMor_032_ReallyLong
CtrlNum='00003';        %  Cutmor: '00006';
CtrlNoNaNum='00009';    %  Cutmor: '00003';

tstop=20000; %20000;
SimDuration=tstop; %20000;
lfp_dt=.5;
PVNum='00005'; % 10%: 00042  50%: 00043                Cutmor: '00001';
SOMNum='00006'; % 10%: 00049  50%: 00048    Cutmor: '00005';
PVNoNaNum='00008'; % 10%: 00045  50%: 00044             Cutmor: '00002';
SOMNoNaNum='00007'; % 10%: 00046  50%: 00047       Cutmor: '00004';



basespkdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl CtrlNum sl 'spikeraster.dat']); % 54
pvspkdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl PVNum sl 'spikeraster.dat']); % 54
somspkdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl SOMNum sl 'spikeraster.dat']); % 54

basespk = basespkdata(basespkdata(:,2)==21310,1);
pvspk = pvspkdata(pvspkdata(:,2)==21310,1);
somspk = somspkdata(somspkdata(:,2)==21310,1);

baseISI=diff(basespk(:,1));
pvISI=diff(pvspk(:,1));
somISI=diff(somspk(:,1));

basespkmod = mod(basespk(:,1),thetaper);
pvspkmod = mod(pvspk(:,1),thetaper);
somspkmod = mod(somspk(:,1),thetaper);


fid=fopen([savepath sl 'NetClamp_Control_Raster.txt'],'w');
for p=1:length(basespk)
    fprintf(fid,'%f\n',basespk(p))
end
fclose(fid)

fid=fopen([savepath sl 'NetClamp_SOMdisinh_Raster.txt'],'w');
for p=1:length(somspk)
    fprintf(fid,'%f\n',somspk(p))
end
fclose(fid)

fid=fopen([savepath sl 'NetClamp_PVdisinh_Raster.txt'],'w');
for p=1:length(pvspk)
    fprintf(fid,'%f\n',pvspk(p))
end
fclose(fid)

[mybaseangle, mybasemag]=getangle(basespk,thetaper);
[mypvangle, mypvmag]=getangle(pvspk,thetaper);
[mysomangle, mysommag]=getangle(somspk,thetaper);


%%%%%%%%%%%%%%%%%%%%%%%%% 
% Added new stuff for LFP

baselfp=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl CtrlNum sl 'lfp.dat']); % 54
pvlfp=baselfp;%importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl PVNum sl 'lfp.dat']); % 54
somlfp=baselfp;%importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl SOMNum sl 'lfp.dat']); % 54

mydata(1)=getlfpphase(basespk,baselfp,SimDuration,lfp_dt);
mydata(2)=getlfpphase(pvspk,pvlfp,SimDuration,lfp_dt);
mydata(3)=getlfpphase(somspk,somlfp,SimDuration,lfp_dt);
mydata(1).color=[.0 .0 .6];
mydata(2).color=[.0 1 .0];
mydata(3).color=[.8 .2 1];

if newlfp
    mybaseangle = mydata(1).phase;
    mybasemag = mydata(1).mod;
    mypvangle = mydata(2).phase;
    mypvmag = mydata(2).mod;
    mysomangle = mydata(3).phase;
    mysommag = mydata(3).mod;
end
% Stopped adding after here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h(length(h)+1) = figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','NCSpkHist','Units','inches','PaperSize',[1 1.5],'Position',[.1 .1 1 1.5],'PaperUnits','inches','PaperPosition',[0 0 1 1.5]);
plotthehist(h,addylim,addme,shiftme,ModelDirectory,MyRunName,CtrlNum,mydata,basespk,pvspk,somspk,thetaper,stepsize,tstop,newlfp,lfpflag,mybaseangle,mypvangle,mysomangle,mypvmag,mysommag)

disp(['Base Spike angle is: ' num2str(mybaseangle)])
disp(['100% PV Spike angle is: ' num2str(mypvangle) ' (' num2str(mypvangle-mybaseangle) ')'])
disp(['100% SOM Spike angle is: ' num2str(mysomangle) ' (' num2str(mysomangle-mybaseangle) ')'])

disp(['Base Spike mag is: ' num2str(mybasemag)])
disp(['100% PV Spike mag is: ' num2str(mypvmag) ' (' num2str(mypvmag-mybasemag) ')'])
disp(['100% SOM Spike mag is: ' num2str(mysommag) ' (' num2str(mysommag-mybasemag) ')'])

basedata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl CtrlNoNaNum sl 'mytrace_21310_soma.dat']); % 54
pvdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl PVNoNaNum sl 'mytrace_21310_soma.dat']); % 55
somdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl SOMNoNaNum sl 'mytrace_21310_soma.dat']); % 56

base = basedata.data;
pv = pvdata.data;
som = somdata.data;

basedata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl CtrlNum sl 'mytrace_21310_soma.dat']); % 54
pvdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl PVNum sl 'mytrace_21310_soma.dat']); % 55
somdata=importdata([myrepos(q).dir sl 'networkclamp_results' sl MyRunName sl SOMNum sl 'mytrace_21310_soma.dat']); % 56

baseNa = basedata.data;
pvNa = pvdata.data;
somNa = somdata.data;


fid=fopen([savepath sl 'NetClamp_Membrane_Potential.txt'],'w');
fprintf(fid,'Time\tControl\tPVdisinh\tSOMdisinh\tControlNaBlock\tPVdisinhNaBlock\tSOMdisinhNaBlock\n')
for p=1:length(base)
    fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t%f\n', base(p,1), base(p,2), pv(p,2), som(p,2), baseNa(p,2), pvNa(p,2), somNa(p,2));
end
fclose(fid)

h(length(h)+1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','NCfftSpk','Units','inches','PaperUnits','inches','PaperSize',[2 1.5],'Position',[.5 .5 2 1.5],'PaperPosition',[0 0 2 1.5]);

if pwelchflag==1
    % code to compute SDF
    binned= histc(basespk,[0:1:tstop]); % binned by 1 ms
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    sdf = conv(binned,kernel,'same');
    sdf=sdf-sum(sdf)/length(sdf);
    [fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
else
    [f, fft_results]=myfft(basespk,tstop);
end
basefft.f = f;
basefft.fft_results = fft_results;

if pwelchflag==1
    % code to compute SDF
    binned= histc(pvspk,[0:1:tstop]); % binned by 1 ms
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    sdf = conv(binned,kernel,'same');
    sdf=sdf-sum(sdf)/length(sdf);
    [fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
else
    [f, fft_results]=myfft(pvspk,tstop);
end
pvfft.f = f;
pvfft.fft_results = fft_results;

if pwelchflag==1
    % code to compute SDF
    binned= histc(somspk,[0:1:tstop]); % binned by 1 ms
    window=3; % ms
    kernel=mynormpdf(-floor((window*6+1)/2):floor((window*6+1)/2),0,window);
    sdf = conv(binned,kernel,'same');
    sdf=sdf-sum(sdf)/length(sdf);
    [fft_results, f]=pwelch(sdf,[],[],[],1000,'onesided','power');
else
    [f, fft_results]=myfft(somspk,tstop);
end
somfft.f = f;
somfft.fft_results = fft_results;


if normflag==1
    plot(basefft.f,basefft.fft_results/max(basefft.fft_results),'Color',[.0 .0 .6],'LineWidth',lw,'LineStyle',ls)
    hold on
    plot(somfft.f,somfft.fft_results/max(somfft.fft_results),'Color',[.8 .2 1],'LineWidth',lw,'LineStyle',ls)
    plot(pvfft.f,pvfft.fft_results/max(pvfft.fft_results),'Color',[.0 1 0],'LineWidth',lw,'LineStyle',ls)
    plot(basefft.f,basefft.fft_results/max(basefft.fft_results),'Color',[.0 .0 .6],'LineWidth',lw,'LineStyle',ls)
else
    plot(basefft.f,basefft.fft_results,'Color',[.0 .0 .6],'LineWidth',lw,'LineStyle',ls)
    hold on
    plot(somfft.f,somfft.fft_results,'Color',[.8 .2 1],'LineWidth',lw,'LineStyle',ls)
    plot(pvfft.f,pvfft.fft_results,'Color',[.0 1 0],'LineWidth',lw,'LineStyle',ls)
    plot(basefft.f,basefft.fft_results,'Color',[.0 .0 .6],'LineWidth',lw,'LineStyle',ls)
end
xlim([5 10])

formatter(xlabel('Frequency (Hz)'))
formatter(ylabel('Norm. Theta Power'))
formatter(gca)
set(get(gca,'xlabel'),'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName','ArialMT')
set(get(gca,'ylabel'),'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName','ArialMT')
set(gca,'Position',[.25 .28 .7 .7])
set(get(gca,'ylabel'),'Position',[2.3 0.3000 -1])
set(get(gca,'xlabel'),'Position',[8.0000   -0.2   -1.0000])
set(gca,'TickDir','out','XTick',[5:10])


h(length(h)+1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','NetClampTrace','Units','inches','PaperUnits','inches','PaperSize',[3 2],'Position',[.5 .5 3 2],'PaperPosition',[0 0 3 2]);
    subplot('Position',[.05 .02 .9 .96])
plot(baseNa(:,1),baseNa(:,2),'Color',[.0 .0 .6])
xlim([1000 6205])
ylim([-60 40])

hold on
stpt=4000; %6200;
enpt=-20; %-65;
axis off
plot([3800 4300 4300 3800 3800],[-60 -60 -35 -35 -60],'Color',[0 0 0]) %.4 .4 .4

rez=base(2,1)-base(1,1);

inFs = 1000/rez; % sampling frequency (per s)

filtbase = mikkofilter(base,inFs);
filtpv = mikkofilter(pv,inFs);
filtsom = mikkofilter(som,inFs);

filtbase(:,1)=filtbase(:,1)/1000;
filtpv(:,1)=filtpv(:,1)/1000;
filtsom(:,1)=filtsom(:,1)/1000;

baseloc=findpeaks(filtbase(:,2));
if isstruct(baseloc)
    baseloc = baseloc.loc; % filtbase(baseloc.loc,1);
else
    [~, baseloc]=findpeaks(filtbase(:,2));
    %peaks = filtbase(baseloc,1);
end

pvloc=findpeaks(filtpv(:,2));
if isstruct(pvloc)
    pvloc = pvloc.loc; % filtbase(baseloc.loc,1);
else
    [~, pvloc]=findpeaks(filtpv(:,2));
    %peaks = filtbase(baseloc,1);
end

somloc=findpeaks(filtsom(:,2));
if isstruct(somloc)
    somloc = somloc.loc; % filtbase(baseloc.loc,1);
else
    [~, somloc]=findpeaks(filtsom(:,2));
end



disp('get angle (like plot compass) of peaks in MP for Na blocked traces')


[anglebase, magbase]=getangle(filtbase(baseloc,1)*1000,thetaper);
[anglepv, magpv]=getangle(filtpv(pvloc,1)*1000,thetaper);
[anglesom, magsom]=getangle(filtsom(somloc,1)*1000,thetaper);

mydataMP(1)=getlfpphase(filtbase(baseloc,1)*1000,baselfp,SimDuration,lfp_dt);
mydataMP(2)=getlfpphase(filtpv(pvloc,1)*1000,pvlfp,SimDuration,lfp_dt);
mydataMP(3)=getlfpphase(filtsom(somloc,1)*1000,somlfp,SimDuration,lfp_dt);
mydataMP(1).color=[.0 .0 .6];
mydataMP(2).color=[.0 1 .0];
mydataMP(3).color=[.8 .2 1];

if newlfp
    anglebase = mydataMP(1).phase;
    magbase = mydataMP(1).mod;
    anglepv = mydataMP(2).phase;
    magpv = mydataMP(2).mod;
    anglesom = mydataMP(3).phase;
    magsom = mydataMP(3).mod;
end

h(length(h)+1) = figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','NCMPHist','Units','inches','PaperSize',[1 1.5],'Position',[.1 .1 1 1.5],'PaperUnits','inches','PaperPosition',[0 0 1 1.5]);
plotthehist(h,addylim,addme,shiftme,ModelDirectory,MyRunName,CtrlNum,mydataMP,filtbase(baseloc,1)*1000,filtpv(pvloc,1)*1000,filtsom(somloc,1)*1000,thetaper,stepsize,tstop,newlfp,lfpflag,anglebase,anglepv,anglesom,magpv,magsom)

disp(['Base angle is: ' num2str(anglebase)])
disp(['100% PV angle is: ' num2str(anglepv) ' (' num2str(anglepv-anglebase) ')'])
disp(['100% SOM angle is: ' num2str(anglesom) ' (' num2str(anglesom-anglebase) ')'])

disp(['Base mag is: ' num2str(magbase)])
disp(['100% PV mag is: ' num2str(magpv) ' (' num2str(magpv-magbase) ')'])
disp(['100% SOM mag is: ' num2str(magsom) ' (' num2str(magsom-magbase) ')'])

h(length(h)+1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','FilteredTrace','Units','inches','PaperUnits','inches','PaperSize',[3 1.8],'Position',[.5 .5 3 1.8],'PaperPosition',[0 0 3 1.8]);
subplot('Position',[.05 .05 .9 .9])
ad(1)=plot(filtbase(:,1)*1000,filtbase(:,2),'LineWidth',lw,'Color',[.0 .0 .6]);
hold on
ad(2)=plot(filtpv(:,1)*1000,filtpv(:,2),'LineWidth',lw,'Color',[.0 1 .0]);
ad(3)=plot(filtsom(:,1)*1000,filtsom(:,2),'LineWidth',lw,'Color',[.8 .2 1]);
bb=legend(ad,{'Control','PV+ Disinhibition','SOM+ Disinhibition'},'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize,'Position',[.5 .7 .4 .3]);%'Location','NorthEast');
legend boxoff
xlim([3800 4300])
ylim([-3.5 5.5])
plot([4300 4300],[-3.5 -2.5],'k','LineWidth',2)
plot([4200 4300],[-3.5 -3.5],'k','LineWidth',2)
%formatter(text(3850,3.6,'100 ms'))
%formatter(text(3840,4.5,'1 mV','HorizontalAlignment','Right'))

formatter(gca)
formatter(bb)
% formatter(xlabel('Time (ms)'))
% formatter(ylabel('Filtered potential (mV)'))
% set(get(gca,'xlabel'),'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize)
% set(get(gca,'ylabel'),'FontWeight','Bold','FontName','ArialMT','FontSize',myFontSize)
box off
axis off

h(length(h)+1)=figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','RawTrace','Units','inches','PaperUnits','inches','PaperOrientation','landscape','PaperSize',[3 .75],'Position',[.5 .5 3 .75],'PaperPosition',[0 0 3 .75]);
subplot('Position',[.05 .05 .9 .9])
ad(1)=plot(base(:,1),base(:,2),'LineWidth',lw,'Color',[.0 .0 .6]);
hold on

formatter(gca)
formatter(bb)
% formatter(xlabel('Time (ms)'))
% formatter(ylabel('Control raw potential (mV)'))
xlim([3800 4300])
ylim([-60 -50])
box off
axis off


function [myangle, magnitude]=getangle(spiketimes,thetaper)
    n=length(spiketimes);
    modspiketimes = mod(spiketimes, thetaper);

    xbar = 1/n*sum(sin(modspiketimes*pi/(thetaper/2)));
    ybar = 1/n*sum(cos(modspiketimes*pi/(thetaper/2)));

    magnitude=sqrt(xbar^2+ybar^2);
    if xbar>0
        myangle = acos(ybar/magnitude);
    else
        myangle = 2*pi - acos(ybar/magnitude);
    end
    myangle=myangle*180/pi;
    
function formatter(ax,varargin)
global mypath myFontSize myFontWeight

if isempty(varargin)
    set(ax,'LineWidth',1.0,'FontName','ArialMT','FontWeight',myFontWeight,'FontSize',myFontSize)  
elseif varargin{1}==0
    set(ax,'FontName','ArialMT','FontWeight',myFontWeight,'FontSize',myFontSize)  
else
    set(ax,'FontName','ArialMT','FontWeight',myFontWeight,'FontSize',myFontSize)  
end
box off

%%%%%%%%%%%%%%%%%%%%%%%%% 
% Added new stuff for LFP
function mydata=getlfpphase(spikes,lfp,SimDuration,lfp_dt)
filteredlfp=mikkofilter(lfp,1000/lfp_dt,[8 8]);
tmppeaks=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
if isstruct(tmppeaks)
    peaks = filteredlfp(tmppeaks.loc,1);
else
[~, tmppeaks]=findpeaks(max(filteredlfp(:,2))-filteredlfp(:,2));
    peaks = filteredlfp(tmppeaks,1);
end
thetaper = 125;
bins=12;
[angle, magnitude]=getspikephase(peaks, thetaper);
shift = angle*180/pi;
refstr='lfp trough=0^o';

stepsize = thetaper/bins;
    [angle, magnitude, modactivitytimes]=getspikephase(spikes, thetaper, [peaks(1)-thetaper; peaks; [peaks(end)+thetaper:thetaper:(SimDuration+thetaper)]']);
    mydata.modactivitytimes=modactivitytimes;
    mydata.phase = angle*180/pi; % phase computed relative to local reference phase
    mydata.mod = magnitude;
    [pval, zval] = circ_rtest(mydata.modactivitytimes*pi/(thetaper/2));
    mydata.pval = pval;
    mydata.zval = zval;

    N = histc(mydata.modactivitytimes,[0:stepsize:thetaper]);
    N(end-1)=sum(N(end-1:end));
    N(end)=[];
    mydata.hist.y=[N(:); N(:)];
    if length([0:stepsize:thetaper*2-stepsize])==length(mydata.hist.y)
        mydata.hist.x=[0:stepsize:thetaper*2-stepsize];
    else
        mydata.hist.x=[0:stepsize:thetaper*2-stepsize*2];
    end
    mydata.hist.plot='hbar=bar(mydata(r).hist.x,mydata(r).hist.y,''histc'');if ~isempty(hbar) && hbar~=0,set(hbar,''EdgeColor'',''none'');set(hbar,''FaceColor'',mydata(r).color);end;set(gca, ''xLim'', [0 thetaper*2])';

    
function [angle, magnitude, varargout]=getspikephase(activitytimes, thetaper, varargin)
if isempty(varargin)
    modactivitytimes = mod(activitytimes, thetaper);
else
    peaks=varargin{1};
    modactivitytimes=zeros(length(activitytimes),1);
    for a=1:length(activitytimes)
        % these next two lines take up most of the time in this function
        idx=find(activitytimes(a)>=peaks(1:end-1) & activitytimes(a)<peaks(2:end),1,'first');  
        try
        modactivitytimes(a)=(activitytimes(a)-peaks(idx))/(peaks(idx+1)-peaks(idx))*thetaper;
        catch me
            me
        end
    end
end
n=length(activitytimes);
xbar = 1/n*sum(sin(modactivitytimes*pi/(thetaper/2)));
ybar = 1/n*sum(cos(modactivitytimes*pi/(thetaper/2)));

magnitude=sqrt(xbar^2+ybar^2);
if xbar>0
    angle = acos(ybar/magnitude);
else
    angle = 2*pi - acos(ybar/magnitude);
end

if nargout>2
    varargout{1}=modactivitytimes;
end

% Stopped adding after here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function plotthehist(h,addylim,addme,shiftme,ModelDirectory,MyRunName,CtrlNum,mydata,basespk,pvspk,somspk,thetaper,stepsize,tstop,newlfp,lfpflag,mybaseangle,mypvangle,mysomangle,mypvmag,mysommag)
global mypath myFontWeight myFontSize

z=0;
subplot('Position',[.02 1-(z+1)/3+.22+.01 .72 .07]);
axis off
b = text(0,addme,'Control');
set(b,'VerticalAlignment','bottom','Color',[.0 .0 .6],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
subplot('Position',[.98 1-(z+1)/3+.22+.01 .01 .07]);
b = text(0,addme,[num2str(mod(round(mybaseangle),360)) '^o']);
% set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.0 .0 .6],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[1 1 1],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1 && newlfp==0
hbar = perfireratehistLFP(ModelDirectory,MyRunName,CtrlNum,basespk(:,1),thetaper,stepsize,tstop);
elseif newlfp
    r=z+1;
    eval(mydata(z+1).hist.plot)
else
hbar = perfireratehist([],basespk(:,1),thetaper,stepsize,tstop,shiftme,1,h(end));  %shiftme is the i'th bar, move it to the first position
end
if ~isempty(hbar) && hbar~=0
    set(hbar,'EdgeColor','none')
    set(hbar,'FaceColor',[.0 .0 .6])
end
if addylim==1
ylim([0 .11])%max(max(get(get(gca,'Children'),'ydata')))])
end
xlim([0 thetaper*2])
hold on
xL=get(gca,'xLim');
yL=get(gca,'yLim');
fst = (xL(2) - xL(1))/4;
snd= (xL(2) - xL(1))*3/4;
plot([fst fst], yL, 'Color',[.5 .5 .5],'LineStyle','--')
plot([snd snd], yL, 'Color',[.5 .5 .5],'LineStyle','--')
plot(xL, [yL(1) yL(1)],'Color',[.75 .75 .75])
axis off


z=1;
subplot('Position',[.02 1-(z+1)/3+.22+.01 .72 .07]);
axis off
b = text(0,addme,'PV+ Disinh.');
set(b,'VerticalAlignment','bottom','Color',[.0 1 .0],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
subplot('Position',[.98 1-(z+1)/3+.22+.01 .01 .07]);
% b = text(0,addme,[num2str(mod(round(mypvangle),360)) '^o']);
if mypvmag<.05
    b = text(0,addme,['n.s.']);
else
    b = text(0,addme,sprintf('%+.0f^o', mod(round(mypvangle-mybaseangle),360)));
end
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.0 1 0],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1 && newlfp==0
hbar = perfireratehistLFP(ModelDirectory,MyRunName,PVNum,pvspk(:,1),thetaper,stepsize,tstop);
elseif newlfp
    r=z+1;
    eval(mydata(z+1).hist.plot)
else
hbar = perfireratehist([],pvspk(:,1),thetaper,stepsize,tstop,shiftme,1,h(end));  %shiftme is the i'th bar, move it to the first position
end
if ~isempty(hbar) && hbar~=0
    set(hbar,'EdgeColor','none')
    set(hbar,'FaceColor',[.0 1 .0])
end
if addylim==1
ylim([0 .11])%max(max(get(get(gca,'Children'),'ydata')))])
end
xlim([0 thetaper*2])
                hold on
                xL=get(gca,'xLim');
                yL=get(gca,'yLim');
                fst = (xL(2) - xL(1))/4;
                snd= (xL(2) - xL(1))*3/4;
                plot([fst fst], yL, 'Color',[.5 .5 .5],'LineStyle','--')
                plot([snd snd], yL, 'Color',[.5 .5 .5],'LineStyle','--')
                plot(xL, [yL(1) yL(1)],'Color',[.75 .75 .75])
                axis off


z=2;
subplot('Position',[.02 1-(z+1)/3+.22+.01 .72 .07]);
axis off
b = text(0,addme,'SOM+ Disinh.');
set(b,'VerticalAlignment','bottom','Color',[.8 .2 1],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
subplot('Position',[.98 1-(z+1)/3+.22+.01 .01 .07]);
% b = text(0,addme,[num2str(mod(round(mysomangle),360)) '^o']);
if mysommag<.05
    b = text(0,addme,['n.s.']);
else
    b = text(0,addme,sprintf('%+.0f^o', mod(round(mysomangle-mybaseangle+180),360)-180));
end
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.8 .2 1],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1 && newlfp==0
hbar = perfireratehistLFP(ModelDirectory,MyRunName,SOMNum,somspk(:,1),thetaper,stepsize,tstop);
elseif newlfp
    r=z+1;
    eval(mydata(z+1).hist.plot)
else
hbar = perfireratehist([],somspk(:,1),thetaper,stepsize,tstop,shiftme,1,h(end));  %shiftme is the i'th bar, move it to the first position
end
if ~isempty(hbar) && hbar~=0
    set(hbar,'EdgeColor','none')
    set(hbar,'FaceColor',[.8 .2 1])
end
if addylim==1
ylim([0 .11])%max(max(get(get(gca,'Children'),'ydata')))])
end
xlim([0 thetaper*2])
                hold on
                xL=get(gca,'xLim');
                yL=get(gca,'yLim');
                fst = (xL(2) - xL(1))/4;
                snd= (xL(2) - xL(1))*3/4;
                plot([fst fst], yL, 'Color',[.5 .5 .5],'LineStyle','--')
                plot([snd snd], yL, 'Color',[.5 .5 .5],'LineStyle','--')
                plot(xL, [yL(1) yL(1)],'Color',[.75 .75 .75])
                axis off