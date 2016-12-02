function [anglebase, anglepv, anglesom, h]=mynewphaseshift()
global mypath myFontSize myFontWeight sl 
lowrange=7;
highrange=9;
thetaper=125;
h=[];
percof=10;
pwelchflag=1;
normflag=1;
lfpflag=0;
addylim=0;
addme=.00;
shiftme = 6;
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

MyRunName='ca1_lfp_1x_27_00'; % CutMor_032_ReallyLong
CtrlNum='00051';        %  Cutmor: '00006';
CtrlNoNaNum='00058';    %  Cutmor: '00003';

tstop=20000; %20000;
if percof==10
    PVNum='00059'; % 10%: 00042  50%: 00043                Cutmor: '00001';
    SOMNum='00060'; % 10%: 00049  50%: 00048    Cutmor: '00005';
    PVNoNaNum='00056'; % 10%: 00045  50%: 00044             Cutmor: '00002';
    SOMNoNaNum='00057'; % 10%: 00046  50%: 00047       Cutmor: '00004';
else % 50% 
    CtrlNum='00041';        %  Cutmor: '00006';
    CtrlNoNaNum='00050';    %  Cutmor: '00003';
    tstop=5000; %20000;
    PVNum='00043'; % 10%: 00042  50%: 00043                Cutmor: '00001';
    SOMNum='00048'; % 10%: 00049  50%: 00048    Cutmor: '00005';
    PVNoNaNum='00044'; % 10%: 00045  50%: 00044             Cutmor: '00002';
    SOMNoNaNum='00047'; % 10%: 00046  50%: 00047       Cutmor: '00004';
end


if 1==0 % check that removing pyr inputs to network clamped cell does not affect findings
    MyRunName='phasic123';
    CtrlNum='00012';
    PVNum='00014'; % 10%: 00042  50%: 00043                Cutmor: '00001';
    SOMNum='00015'; % 10%: 00049  50%: 00048    Cutmor: '00005';
end
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


h(length(h)+1) = figure('GraphicsSmoothing','off', 'Renderer', 'painters','Color','w','Name','NCSpkHist','Units','inches','PaperSize',[1 1.5],'Position',[.1 .1 1 1.5],'PaperUnits','inches','PaperPosition',[0 0 1 1.5]);

[mybaseangle, mybasemag]=getangle(basespk,thetaper);
[mypvangle, mypvmag]=getangle(pvspk,thetaper);
[mysomangle, mysommag]=getangle(somspk,thetaper);

z=0;
subplot('Position',[.02 1-(z+1)/3+.22+.01 .72 .07]);
axis off
b = text(0,addme,'Control');
set(b,'VerticalAlignment','bottom','Color',[.0 .0 .6],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
subplot('Position',[.98 1-(z+1)/3+.22+.01 .01 .07]);
b = text(0,addme,[num2str(mod(round(mybaseangle),360)) '^o']);
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[1 1 1],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
%set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.0 .0 .6],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1
hbar = perfireratehistLFP(ModelDirectory,MyRunName,CtrlNum,basespk(:,1),thetaper,stepsize,tstop);
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
if mypvmag<.05
    b = text(0,addme,['n.s.']);
else
%b = text(0,addme,[num2str(mod(round(mypvangle-mybaseangle),360)) '^o']);
b = text(0,addme,sprintf('%+.0f^o', mod(round(mypvangle-mybaseangle),360)));
end
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.0 1 0],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1
hbar = perfireratehistLFP(ModelDirectory,MyRunName,PVNum,pvspk(:,1),thetaper,stepsize,tstop);
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
if mysommag<.05
    b = text(0,addme,['n.s.']);
else
    %b = text(0,addme,[num2str(mod(round(mysomangle-mybaseangle),360)) '^o']);
    b = text(0,addme,sprintf('%+.0f^o', mod(round(mysomangle-mybaseangle+180),360)-180));
end
set(b,'VerticalAlignment','bottom','HorizontalAlignment','right','Color',[.8 .2 1],'FontWeight',myFontWeight,'FontName','ArialMT','FontSize',myFontSize)
axis off
subplot('Position',[.02 1-(z+1)/3+.01 .96 .22])
if lfpflag==1
hbar = perfireratehistLFP(ModelDirectory,MyRunName,SOMNum,somspk(:,1),thetaper,stepsize,tstop);
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
set(gca,'TickDir','out','XTick',5:10)


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
gw=gausswin(50);

filtbase = [base(:,1)./1000 conv(base(:,2),gw,'same')];%mikkoscript(base(:,2),inFs,[lowrange highrange]);
filtpv = [pv(:,1)./1000 conv(pv(:,2),gw,'same')];%mikkoscript(pv(:,2),inFs,[lowrange highrange]);
filtsom = [som(:,1)./1000 conv(som(:,2),gw,'same')];%mikkoscript(som(:,2),inFs,[lowrange highrange]);
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
    %peaks = filtbase(baseloc,1);
end

disp('Zeroth way - findpeaks average from gaussian smooth')
try
    disp(['PV shift: mean = ' num2str(mean(filtpv(pvloc,1)-filtbase(baseloc,1))*1000/thetaper*360) ' median = ' num2str(median(filtpv(pvloc,1)-filtbase(baseloc,1))*1000/thetaper*360)])
    disp(['SOM shift: mean = ' num2str(mean(filtsom(somloc,1)-filtbase(baseloc,1))*1000/thetaper*360) ' median = ' num2str(median(filtsom(somloc,1)-filtbase(baseloc,1))*1000/thetaper*360)])
catch
    disp(['PV shift: mean = ' num2str((mean(mod(filtpv(pvloc,1)*1000,thetaper))-mean(mod(filtbase(baseloc,1)*1000,thetaper)))/thetaper*360)])
    disp(['SOM shift: mean = ' num2str((mean(mod(filtsom(somloc,1)*1000,thetaper))-mean(mod(filtbase(baseloc,1)*1000,thetaper)))/thetaper*360)])
end
    
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

basespkmod = mod(filtbase(baseloc,1),thetaper);
pvspkmod = mod(filtpv(pvloc,1),thetaper);
somspkmod = mod(filtsom(somloc,1),thetaper);

pwelchflag=0;
    
[anglebase, magbase]=getangle(filtbase(baseloc,1)*1000,thetaper);
[anglepv, magpv]=getangle(filtpv(pvloc,1)*1000,thetaper);
[anglesom, magsom]=getangle(filtsom(somloc,1)*1000,thetaper); 
    
disp('First way - findpeaks average from mikkoscript filter')
try
    disp(['PV shift: mean = ' num2str(mean(filtpv(pvloc,1)-filtbase(baseloc,1))*1000/thetaper*360) ' median = ' num2str(median(filtpv(pvloc,1)-filtbase(baseloc,1))*1000/thetaper*360)])
    disp(['SOM shift: mean = ' num2str(mean(filtsom(somloc,1)-filtbase(baseloc,1))*1000/thetaper*360) ' median = ' num2str(median(filtsom(somloc,1)-filtbase(baseloc,1))*1000/thetaper*360)])
catch
    disp(['PV shift: mean = ' num2str((mean(mod(filtpv(pvloc,1)*1000,thetaper))-mean(mod(filtbase(baseloc,1)*1000,thetaper)))/thetaper*360)])
    disp(['SOM shift: mean = ' num2str((mean(mod(filtsom(somloc,1)*1000,thetaper))-mean(mod(filtbase(baseloc,1)*1000,thetaper)))/thetaper*360)])
end

disp('Second way - avg peak delays from mikkoscript filter')

disp('Third way - get angle (like plot compass) of peaks in MP')

[anglebase, magbase]=getangle(filtbase(baseloc,1)*1000,thetaper);
[anglepv, magpv]=getangle(filtpv(pvloc,1)*1000,thetaper);
[anglesom, magsom]=getangle(filtsom(somloc,1)*1000,thetaper);

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


disp('Fourth way - find one peak in average MP of all periods')
idx=find(filtbase(:,1)>=125/1000,1,'first');
newbase=reshape(filtbase(1:end-mod(length(filtbase(:,2)),idx-1),2),idx-1,floor(length(filtbase(:,2))/(idx-1)));
[~, maxbase]=max(mean(newbase'));
newpv=reshape(filtpv(1:end-mod(length(filtpv(:,2)),idx-1),2),idx-1,floor(length(filtpv(:,2))/(idx-1)));
[~, maxpv]=max(mean(newpv'));
newsom=reshape(filtsom(1:end-mod(length(filtsom(:,2)),idx-1),2),idx-1,floor(length(filtsom(:,2))/(idx-1)));
[~, maxsom]=max(mean(newsom'));

disp(['Base angle is: ' num2str(filtbase(maxbase,1)/.125*360)]);
disp(['100% PV angle is: ' num2str(filtbase(maxpv,1)/.125*360) ' (' num2str(filtbase(maxpv,1)/.125*360-filtbase(maxbase,1)/.125*360) ')']);
disp(['100% SOM angle is: ' num2str(filtbase(maxsom,1)/.125*360) ' (' num2str(filtbase(maxsom,1)/.125*360-filtbase(maxbase,1)/.125*360) ')']);
    

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
