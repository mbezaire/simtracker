function FinalMakePaperFigs()
global mypath RunArray refphase sl myFontSize disspath ca1_lfp_1x_27_00 colorvec



myfigs = myotherfigs; %getmyfigs; altmyfigs; fftmyfigs; myotherfigs;
usenorm=0;

myFontSize=8;

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
disspath=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end)];
if exist(disspath,'dir')==0
    mkdir(disspath)
end

addpath disspath
addpath outputtypes
addpath tools
repospath=myrepos(q).dir;

paperpath = disspath;

load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')
ca1_lfp_1x_27_00.general = general;

if ispc
    sl='\';
else
    sl='/';
end

        colorvec=[.0 .0 .6;
                  .0 .75 .65;
                  1 .75 .0;
                  1 .5 .3;
                  1 .0 .0;
                  .6 .4 .1;
                  .5 .0 .6;
                  .6 .6 .6;
                  1 .1 1;
                  1 0 0;
                  0 0 1;];
              

eval(['myresultsstruct=' myfigs(1).name ';']);

% Figure 3: Spectrogram and FFT
myresultsstruct.optarg='lfp';
h(1)=plot_spectro(myresultsstruct);
title('LFP')
colormap(jet)
cbar_axes=colorbar;
set(get(cbar_axes,'ylabel'),'string','Power')
bf = findall(h(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
end
bf = findall(h(1),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
end
set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
ylim([0 20])
set(h(1),'Units','inches','PaperUnits','inches','PaperSize',[5 3.5],'PaperPosition',[1 1 5 3.5],'Position',[.5 .5 5 3.5])
printeps(h(1),[disspath 'Spectrogram'])

mrr=ver;
if datenum(mrr(1).Date)<735749 % if an older version of MATLAB (<2014b) where it doesn't print white diagonal lines on this figure
    myresultsstruct.optarg='sdf,type,heat,norm,pwelch';
    h(2)=plot_spectral(myresultsstruct);
    title('Spike Density Function')
    bf = findall(h(2),'Type','text');
    for b=1:length(bf)
        set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
    end
    bf = findall(h(2),'Type','axis');
    for b=1:length(bf)
        set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
    end
    set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
    xlim([0 20])
    set(h(2),'Units','inches','PaperUnits','inches','PaperSize',[4 3.5],'PaperPosition',[1 1 4 3.5],'Position',[.5 .5 4 3.5])
    printeps(h(2),[disspath 'FFT'])
end


global ca1_olmVar_gH_30_03
% Figure 4: Spike Raster, LFP, traces
[hh, colorstruct]=basictrace('ca1_olmVar_gH_30_03',ca1_olmVar_gH_30_03); % myfigs(1).name,myresultsstruct
zoomrange=[1500 2500];
printeps(hh(1),[disspath 'IntracellularTrace'])
printeps(hh(2),[disspath 'LFP'])
printeps(hh(3),[disspath 'FilteredLFP'])
close(hh(2))

if datenum(mrr(1).Date)<735749 % if an older version of MATLAB (<2014b)where it doesn't take 60 min to print this fig
    hh(4)=figure('Visible','on','Color','w','Units','inches','PaperUnits','inches','PaperSize',[11 7],'PaperPosition',[1 1 7 4.2],'Position',[.5 .5 7 4.2]);
    %pos=get(gcf,'Units');
    %set(gcf,'Units','normalized','Position',[0.1 0.1 .9 .9]);
    %set(gcf,'Units',pos);

    ca1_olmVar_gH_30_03.optarg='pyremph';
    hh(4)=plot_raster(ca1_olmVar_gH_30_03,gca,colorstruct); % myresultsstruct
    xlim(zoomrange)
    set(hh(4),'Name','SpikeRaster','Color','w','Units','inches','PaperUnits','inches','PaperSize',[11 7],'PaperPosition',[1 1 7 4.2],'Position',[.5 .5 7 4.2]);
    set(get(hh(4),'Children'),'xLim',zoomrange)
    %printeps(hh(4),[disspath 'SpikeRaster'])


bc=get(hh(4),'Children');
for b=1:length(bc)
    set(bc(b),'Units','inches')
end
set(hh(4),'Units','inches')
pos=get(hh(4),'Position');
set(hh(4),'Position',[pos(1) pos(2) pos(3) pos(4)*2],'PaperPosition',[pos(1) pos(2) pos(3) pos(4)*2])
for b=1:length(bc)
    pos=get(bc(b),'Position');
    set(bc(b),'Position',[pos(1) pos(2)+4 pos(3) pos(4)])
end
bd=get(hh(1),'Children');
for b=1:length(bd)
    set(bd(b),'Units','inches')
    set(bd(b),'Parent',hh(4))
end
close(hh(1))
pos=get(hh(4),'Position');
set(hh(4),'Position',[pos(1) pos(2) pos(3) pos(4)+1.2],'PaperPosition',[pos(1) pos(2) pos(3) pos(4)+1.2],'PaperSize',[8 14],'PaperOrientation','portrait')
be=get(hh(3),'Children');
for b=1:length(be)
    set(be(b),'Units','inches')
    pos=get(be(b),'Position');
    set(be(b),'Position',[pos(1) pos(2)+8 pos(3) pos(4)]);
    set(be(b),'Parent',hh(4))
end
close(hh(3))
bf = findall(hh(4),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontSize',get(bf(b),'FontSize')-4)
end
bf = findall(hh(4),'Type','axes');
for b=1:length(bf)
    set(bf(b),'FontSize',get(bf(b),'FontSize')-4)
end
bc=get(hh(4),'Children');
for b=1:length(bc)
    pos=get(bc(b),'Position');
    set(bc(b),'Position',[pos(1) pos(2)-.5 pos(3) pos(4)])
end

printeps(hh(4),[disspath 'SpikeRaster'])
end


% Figure 5: Firing rates & phases
tmporg=myresultsstruct;
tmporg.curses.cells=myresultsstruct.curses.cells([7 8 3 9 1 2 6 4 5]);
tmporg.optarg='subset';
hhh(1) = plot_firingrates(tmporg);
NiceAbbrev = {'Pyr.','PV+B.','CCK+B.','S.C.A.','Axo.','Bis.','O-LM','Ivy','NGF.'};

set(hhh(1),'color','w','Name','Active Cell Firing Rates','units','inches','PaperUnits','inches','Position',[.5 .5 6 3],'PaperPosition',[0 0 6 3]);
formatter(gca)
ty=ylabel('Firing frequency (Hz)');
formatter(ty)
set(gca,'FontSize',myFontSize)
set(ty,'FontSize',myFontSize)
legstr={'Model','Exp. Anesth.','Exp. Awake'};
bfm=legend(legstr,'Location','NorthEast');
legend boxoff
formatter(bfm);
set(bfm,'FontSize',myFontSize)
title('')
bf = findall(hhh(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',12)
end
bf = findall(hhh(1),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',12)
end
    set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',12)
set(gca,'xticklabel',NiceAbbrev,'FontSize',10,'xlim',[.5 9.25])

printeps(hhh(1),[disspath 'ActiveCellFiringRates'])

hexp=printExpData(disspath,myresultsstruct);
% printeps(hexp(1),[disspath 'ThetaExpHist'])
% printeps(hexp(2),[disspath 'MiniThetaExpLFP'])



myresultsstruct.optarg='hist';
[tmp, mydata] = plot_phasemod([],myresultsstruct,1,myfigs(1).mydata);
%printeps(tmp,[disspath 'ThetaHist'])
for r=1:length(myfigs(1).mydata)
    myresultsstruct.curses.cells(r).phase=myfigs(1).mydata(r).phase;
    myresultsstruct.curses.cells(r).color=myfigs(1).mydata(r).color;
    myresultsstruct.curses.cells(r).offset=[0 0];
end

bc=get(hexp(1),'Children');
for b=1:length(bc)
    set(bc(b),'Units','inches')
end
set(hexp(1),'Units','inches')
pos=get(hexp(1),'Position');
set(hexp(1),'Position',[pos(1) pos(2) pos(3)*2 pos(4)],'PaperPosition',[pos(1) pos(2) pos(3)*2 pos(4)],'PaperSize',[pos(3)*2 pos(4)],'PaperOrientation','portrait')
movew=pos(3);
bd=get(tmp,'Children');
for b=1:length(bd)
    set(bd(b),'Units','inches')
    pos=get(bd(b),'Position');
    set(bd(b),'Position',[pos(1)+movew pos(2) pos(3) pos(4)])
    set(bd(b),'Parent',hexp(1))
end
close(tmp)

hhh(2)=MiniPhaseShift_Figure(myresultsstruct.curses.cells(1:9),myfigs(1).tbldata{7,2},[]);
%printeps(hhh(2),[disspath 'MiniThetaLFP'])

bc=get(hexp(2),'Children');
for b=1:length(bc)
    set(bc(b),'Units','inches')
end
set(hexp(2),'Units','inches')
pos=get(hexp(2),'Position');
set(hexp(2),'Position',[pos(1) pos(2) pos(3)*2 pos(4)],'PaperPosition',[pos(1) pos(2) pos(3)*2 pos(4)],'PaperSize',[pos(3)*2 pos(4)])
movew=pos(3);
bd=get(hhh(2),'Children');
for b=1:length(bd)
    set(bd(b),'Units','inches')
    pos=get(bd(b),'Position');
    set(bd(b),'Position',[pos(1)+movew pos(2) pos(3) pos(4)])
    set(bd(b),'Parent',hexp(2))
end
close(hhh(2))


printeps(hexp(1),[disspath 'ThetaExpHist'])
printeps(hexp(2),[disspath 'MiniThetaExpLFP'])


% Table 1: FFT Spike Power, Frequency (theta and gamma candidates), & theta
% firing rate & phase & mod & gamma mod
myfigs(1).phasedata=myfigs(1).tbldata(:,1:5);
for r=1:size(myfigs(1).tbldata,1)
    myfigs(1).phasedata{r,2}=myfigs(1).mydata(r).phase;
    myfigs(1).phasedata{r,3}=myfigs(1).mydata(r).mod;
    myfigs(1).phasedata{r,4}=myfigs(1).mydata(r).phase;
    myfigs(1).phasedata{r,5}=myfigs(1).mydata(r).mod;
end

makeLaTeXtable(myfigs(1).tbldata,{'Type','Theta Freq. (Hz)','Theta Power','Gamma Freq. (Hz)','Gamma Power','Peak Freq. (Hz)','Peak Power'},'OscPower','Spectral Analysis of Network Activity','Theta and gamma peak frequencies and power of each cell type''s spike density function using Welsch''s Periodogram.')
makeLaTeXtable(myfigs(1).phasedata,{'Type','Theta Phase ($^o$)','Modulation'},'Phases','Preferred Spike Phases','Preferred theta firing phases for each cell type.')

% Figure 6: Varying excitation level, GABAab, outputs, diversity
% 6a: excitation
Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==2))
        Runs2Use=[Runs2Use r];
    end
end
exclevel=[myfigs(Runs2Use).exc];
thetafreq=arrayfun(@(x) x.tbldata{7,2}, myfigs(Runs2Use));
thetapow=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use));
thetanorm=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));

% gammafreq=arrayfun(@(x) x.tbldata{7,4}, myfigs(Runs2Use));
% gammapow=arrayfun(@(x) x.tbldata{7,5}, myfigs(Runs2Use));
% gammanorm=arrayfun(@(x) x.tbldata{7,5}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));
% 
% allfreq=arrayfun(@(x) x.tbldata{7,6}, myfigs(Runs2Use));
% allpow=arrayfun(@(x) x.tbldata{7,7}, myfigs(Runs2Use));

[exclevel, sorti]=sort(exclevel);
thetafreq=thetafreq(sorti);
thetapow=thetapow(sorti);
thetanorm=thetanorm(sorti);
% gammafreq=gammafreq(sorti);
% gammapow=gammapow(sorti);
% gammanorm=gammanorm(sorti);


% hhhh(1)=figure('Color','w','Name','Excitation - Theta Frequency','Units','inches','Position',[.5 .5 4 3],'PaperPosition',[0 0 4 3],'PaperUnits','inches','PaperSize',[4 3]);
% plot(exclevel,thetafreq,'LineWidth',2)
% formatter(gca)
% formatter(xlabel({'Mean of Poission Distributed','Excitation (Hz)'}))
% formatter(ylabel('Theta Frequency (Hz)'))
% bf = findall(hhhh(1),'Type','text');
% for b=1:length(bf)
%     set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',12)
% end
% bf = findall(hhhh(1),'Type','axis');
% for b=1:length(bf)
%     set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
% end
% 
% 
% set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
% printeps(hhhh(1),[disspath 'VaryExcFreq'])
% %print(hhhh(1),[disspath 'VaryExcFreq'],'-depsc')
% 
% hhhh(2)=figure('Color','w','Name','Excitation - Theta Power Rel. to Control','Units','inches','Position',[.5 .5 4 3],'PaperPosition',[0 0 4 3],'PaperUnits','inches','PaperSize',[4 3]);
% plot(exclevel,thetanorm,'LineWidth',2)
% formatter(gca)
% formatter(ylabel('Relative Normalized Theta Power'))
% formatter(xlabel({'Mean of Poission Distributed','Excitation (Hz)'}))
% bf = findall(hhhh(2),'Type','text');
% for b=1:length(bf)
%     set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',12)
% end
% bf = findall(hhhh(2),'Type','axis');
% for b=1:length(bf)
%     set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
% end
% set(gca,'FontName','ArialMT','FontWeight','bold','FontSize',14)
% printeps(hhhh(2),[disspath 'VaryExcPower'])
% %print(hhhh(2),[disspath 'VaryExcPower'],'-depsc')
% 
% 

% 6a: altered excitation
Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==2))
        Runs2Use=[Runs2Use r];
    end
end
exclevel=[myfigs(Runs2Use).exc];
[exclevel, sorti]=sort(exclevel);
Runs2Use=Runs2Use(sorti);

thetafreq=arrayfun(@(x) x.tbldata{7,2}, myfigs(Runs2Use));
thetapow=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use));
thetanorm=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));

myname='DiffExcLevel';
mytitle='Tonic Excitation Level';
myapp='';

if usenorm==1
    myplotvals=thetanorm;
else
    myplotvals=thetapow;
end
mysize=[length(Runs2Use) 2];
for r=1:length(Runs2Use)
    xL{r}=sprintf('%.2f Hz',myfigs(Runs2Use(r)).exc);
end

%xL={myfigs(Runs2Use).label};
%xL={myfigs(1).mydata.name};
if usenorm==1
yL={'Norm. Theta Power','Relative to Control'};
else
yL='Theta Power';
end

mycolors=[];
myfreqs=[];
freqstruct=[];
for r=1:length(Runs2Use)
    tt=strmatch(myfigs(Runs2Use(r)).label,{myfigs(1).mydata.name});
    %if isempty(tt)
        mycolors(r,:)=[0 0 0];
    %else
    %    mycolors(r,:)=myfigs(1).mydata(tt).color;
    %end
    myfreqs(r,:)=[myfigs(Runs2Use(r)).tbldata{7,2} myfigs(Runs2Use(r)).tbldata{7,4} myfigs(Runs2Use(r)).tbldata{7,6}];
    freqstruct(r).freqs= myfigs(Runs2Use(r)).tbldata{3,4};%unique([myfigs(Runs2Use(r)).tbldata{:,6}]);
end
myplotvals(isnan(myplotvals))=0;
if datenum(mrr(1).Date)>735749 % if a newer version of MATLAB (>=2014b) where it can print blank x axes
    plotme(myname, mycolors, myplotvals,mysize,xL,yL,myfreqs,freqstruct,mytitle,myapp)
end


% 6b: reduced complexity
Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==3))
        Runs2Use=[Runs2Use r];
    end
end
thetafreq=arrayfun(@(x) x.tbldata{7,2}, myfigs(Runs2Use));
thetapow=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use));
thetanorm=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));

myname='DiffCellEphys';
mytitle='Uniform inhibitory electrophysiological profile';
myapp='';%'Profile';
if usenorm==1
    myplotvals=thetanorm;
else
    myplotvals=thetapow;
end
mysize=[4 2];
xL={myfigs(Runs2Use).label};
%xL={myfigs(1).mydata.name};
if usenorm==1
yL={'Norm. Theta Power','Relative to Control'};
else
yL='Theta Power';
end
mycolors=[];
myfreqs=[];
freqstruct=[];
for r=1:length(Runs2Use)
    tt=strmatch(myfigs(Runs2Use(r)).label,{myfigs(1).mydata.name});
    if isempty(tt)
        mycolors(r,:)=[0 0 0];
    else
        mycolors(r,:)=myfigs(1).mydata(tt).color;
    end
    myfreqs(r,:)=[myfigs(Runs2Use(r)).tbldata{7,2} myfigs(Runs2Use(r)).tbldata{7,4} myfigs(Runs2Use(r)).tbldata{7,6}];
    freqstruct(r).freqs= myfigs(Runs2Use(r)).tbldata{3,4};%unique([myfigs(Runs2Use(r)).tbldata{:,6}]);
end
myplotvals(isnan(myplotvals))=0;
if datenum(mrr(1).Date)>735749 % if a newer version of MATLAB (>=2014b) where it can print blank x axes
    plotme(myname, mycolors, myplotvals,mysize,xL,yL,myfreqs,freqstruct,mytitle,myapp)
end



% 6bb: reduced complexity
Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==8))
        Runs2Use=[Runs2Use r];
    end
end
thetafreq=arrayfun(@(x) x.tbldata{7,2}, myfigs(Runs2Use));
thetapow=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use));
thetanorm=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));

myname='Converge2PVB';
mytitle='Converge to PV+ interneurons';
myapp='';
if usenorm==1
    myplotvals=thetanorm;
else
    myplotvals=thetapow;
end
mysize=[4 2];
xL={'1','2','3','4'};%{myfigs(Runs2Use).label};
%xL={myfigs(1).mydata.name};
if usenorm==1
yL={'Norm. Theta Power','Relative to Control'};
else
yL='Theta Power';
end
mycolors=[];
myfreqs=[];
freqstruct=[];
for r=1:length(Runs2Use)
    tt=strmatch(myfigs(Runs2Use(r)).label,{myfigs(1).mydata.name});
    if isempty(tt)
        mycolors(r,:)=[0 0 0];
    else
        mycolors(r,:)=myfigs(1).mydata(tt).color;
    end
    myfreqs(r,:)=[myfigs(Runs2Use(r)).tbldata{7,2} myfigs(Runs2Use(r)).tbldata{7,4} myfigs(Runs2Use(r)).tbldata{7,6}];
    freqstruct(r).freqs= myfigs(Runs2Use(r)).tbldata{3,4};%unique([myfigs(Runs2Use(r)).tbldata{:,6}]);
end
myplotvals(isnan(myplotvals))=0;
if datenum(mrr(1).Date)>735749 % if a newer version of MATLAB (>=2014b) where it can print blank x axes
    plotme(myname, mycolors, myplotvals,mysize,xL,yL,myfreqs,freqstruct,mytitle,myapp)
end


% 6c: muted
Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==4))
        Runs2Use=[Runs2Use r];
    end
end

thetafreq=arrayfun(@(x) x.tbldata{7,2}, myfigs(Runs2Use));
thetapow=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use));
thetanorm=arrayfun(@(x) x.tbldata{7,3}, myfigs(Runs2Use))./arrayfun(@(x) x.tbldata{7,end}, myfigs(Runs2Use));

myname='2All';
mytitle='Outputs muted by cell type';
myapp='';%'Muted';
if usenorm==1
    myplotvals=thetanorm;
else
    myplotvals=thetapow;
end
mysize=[8 2];
xL={myfigs(Runs2Use).label};
%xL={myfigs(1).mydata.name};
mycolors=[];
myfreqs=[];
freqstruct=[];
for r=1:length(Runs2Use)
    tt=strmatch(myfigs(Runs2Use(r)).label,{myfigs(1).mydata.name});
    if isempty(tt)
        mycolors(r,:)=[0 0 0];
    else
        mycolors(r,:)=myfigs(1).mydata(tt).color;
    end
    myfreqs(r,:)=[myfigs(Runs2Use(r)).tbldata{7,2} myfigs(Runs2Use(r)).tbldata{7,4} myfigs(Runs2Use(r)).tbldata{7,6}];
    freqstruct(r).freqs= myfigs(Runs2Use(r)).tbldata{3,4};%unique([myfigs(Runs2Use(r)).tbldata{:,6}]);
end
if usenorm==1
yL={'Norm. Theta Power','Relative to Control'};
else
yL='Theta Power';
end
myplotvals(isnan(myplotvals))=0;
if datenum(mrr(1).Date)>735749 % if a newer version of MATLAB (>=2014b) where it can print blank x axes
    plotme(myname, mycolors,  myplotvals,mysize,xL,yL,myfreqs,freqstruct,mytitle,myapp)
end

% GABAab:
% gabaBtimes={'cl1x27s_GABAb_01','cl1x27s_GABAb_02','cl1x27_GABAb_03','cl1x27_GABAb_04','cl1x27_GABAb_05'};
% gabaAonly={'cl1x27s_GABAb_02','cl1x27_GABAb_06','cl1x27_GABAb_07','cl1x27_GABAb_08','cl1x27_GABAb_09','cl1x27_GABAb_10'};
% 
% 6d: GABAab

mycolors=   [0 1 0;
            0 .85 .2;
            0 .65 .35;
            0 .35 .65;
            .3 .2 1;
            .7 0 0;
            1 .1 .1;
            1 .5 .2;
            1 .7 .2;
            1  1 .2;];


gb=load('mygabas');
ff=fieldnames(gb);
for f=1:length(ff)
    myfigname=['Newcl1x27_' ff{f}(1:5) '_' ff{f}(6:7)];
    m=strmatch(myfigname,{myfigs.name});
    if isempty(m)
        disp(['couldnt find for ' ff{f} ', aka figname = ' myfigname ', using m=9'])
        m=9;
        %continue
    end
    myfigs(m).total = trapz(gb.(ff{f}).fig.axis.data(11).y);
    myfigs(m).x = gb.(ff{f}).fig.axis.data(11).x;
    myfigs(m).y = gb.(ff{f}).fig.axis.data(11).y;
    try
    myfigs(m).color=mycolors(f,:);
    catch
        myfigs(m).color=[0 0 0];
    end
end


  
hz(1)=figure('Color','w','Units','inches','Position',[1 1 8 4],'Name','GABA AB Power');
set(gca,'Position',[.1 .15 .5 .8]);
bb=gca;
bgak=axes('Position',[.4 .2 .4 .4]);

hz(2)=figure('Color','w','Units','inches','Position',[1 1 8 4],'Name','GABA AB Freq');
%subplot(3,1,3)
set(gca,'Position',[.1 .15 .5 .8]);
cc=gca;


Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==5))
        Runs2Use=[Runs2Use r];
    end
end

x1=[];
y1=[];
z1=[];
for r=1:length(Runs2Use)
    x1(r)=myfigs(Runs2Use(r)).total;
    y1(r)=myfigs(Runs2Use(r)).tbldata{7,3}/myfigs(Runs2Use(r)).tbldata{7,7};
    z1(r)=myfigs(Runs2Use(r)).tbldata{7,2};
end   
[x1, sortI]=sort(x1);
y1=y1(sortI);
z1=z1(sortI);


plot(bb,x1,y1,'k','LineWidth',3)
hold(bb,'on')

plot(cc,x1,z1,'k','LineWidth',3)
hold(cc,'on')


for r=1:length(Runs2Use)
    plot(bb,myfigs(Runs2Use(r)).total,myfigs(Runs2Use(r)).tbldata{7,3}/myfigs(Runs2Use(r)).tbldata{7,7},'Color',myfigs(Runs2Use(r)).color,'LineStyle','none','Marker','.','MarkerSize',30)

    plot(cc,myfigs(Runs2Use(r)).total,myfigs(Runs2Use(r)).tbldata{7,2},'Color',myfigs(Runs2Use(r)).color,'LineStyle','none','Marker','.','MarkerSize',30)

    plot(bgak,myfigs(Runs2Use(r)).x,myfigs(Runs2Use(r)).y*1000,'Color',myfigs(Runs2Use(r)).color,'LineWidth',2)
    hold(bgak,'on')
end

Runs2Use=[];
for r=1:length(myfigs)
    if ~isempty(find(myfigs(r).figs==6))
        Runs2Use=[Runs2Use r];
    end
end

x2=[];
y2=[];
z2=[];
for r=1:length(Runs2Use)
    x2(r)=myfigs(Runs2Use(r)).total;
    y2(r)=myfigs(Runs2Use(r)).tbldata{7,3}/myfigs(Runs2Use(r)).tbldata{7,7};
    z2(r)=myfigs(Runs2Use(r)).tbldata{7,2};
end   
[x2, sortI]=sort(x2);
y2=y2(sortI);
z2=z2(sortI);


plot(bb,x2,y2,'Color',[.5 .5 .5],'LineWidth',3)
plot(cc,x2,z2,'Color',[.5 .5 .5],'LineWidth',3)


for r=1:length(Runs2Use)
    plot(bb,myfigs(Runs2Use(r)).total,myfigs(Runs2Use(r)).tbldata{7,3}/myfigs(Runs2Use(r)).tbldata{7,7},'Color',myfigs(Runs2Use(r)).color,'LineStyle','none','Marker','.','MarkerSize',30)
    plot(cc,myfigs(Runs2Use(r)).total,myfigs(Runs2Use(r)).tbldata{7,2},'Color',myfigs(Runs2Use(r)).color,'LineStyle','none','Marker','.','MarkerSize',30)
    plot(bgak,myfigs(Runs2Use(r)).x,myfigs(Runs2Use(r)).y*1000,'Color',myfigs(Runs2Use(r)).color,'LineWidth',2)
end

set(bb,'ylim',[0 1.05])
box(bb,'off')

axes(bb)
formatter(xlabel('Total Charge Transfer per Connection (nC)'))
formatter(ylabel('Normalized Theta Power'))
formatter(bb)
bleg=legend({'Altered B kinetics','Control','Slower kinetics','Fast kinetics','Faster kinetics','Even faster kinetics','Fastest kinetics','A component only','A x1','A x3','A x10','A x15','A x30'},'Location','Best');
%bleg=legend({'Altered GABA_{B} kinetics','GABA_{A} only, variable amp.','GABA_{A,B,slower}','GABA_{A,B}','GABA_{A,B,fast}','GABA_{A,B,faster}','GABA_{A,B,fastest}','GABA_{A} only','GABA_{A} x3','GABA_{A} x10','GABA_{A} x15','GABA_{A} x30'},'Location','Best');

plot(bgak,[200 300],[4 4],'k','LineWidth',2)
plot(bgak,[200 200],[4 6],'k','LineWidth',2)
axes(bgak)
text(195,5,'2 pA','HorizontalAlignment','right','FontName','ArialMT','FontWeight','bold')
text(200,3.5,'100 ms','HorizontalAlignment','left','FontName','ArialMT','FontWeight','bold')
plot([0 1000],[0 0],'k')
box off
axis off
set(gca,'Color','none');
set(gca,'XTickLabel',{})
set(gca,'XTick',[])
set(gca,'YTickLabel',{})
set(gca,'YTick',[])

axes(cc)
ylabel('Theta Frequency (Hz)')

bf = findall(hz(1),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
end
bf = findall(hz(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
end
formatter(bleg);
set(bleg,'FontWeight','normal','FontSize',12,'Position',[.65 .37 .3 .5],'EdgeColor',[1 1 1])
set(bb,'FontName','ArialMT','FontWeight','bold','FontSize',14)
printeps(hz(1),[disspath 'GABAab'])

close(hz(2))

if datenum(mrr(1).Date)<735749 % if an older version of MATLAB (<2014b)where it doesn't add white diagonal lines

    [anglebase, anglepv, anglesom, hpp]=mynewphaseshift();
    for zp=1:length(hpp)
        printeps(hpp(zp),[disspath strrep(get(hpp(zp),'Name'),' ','')]);
    end
    close(hpp)
end

return

if datenum(mrr(1).Date)>735749 % if an newer version of MATLAB (>2014b)
    tmph=GABAab();
print(tmph(1),[disspath 'GABAab'],'-depsc')
    printeps(tmph(1),[disspath 'GABAab']);
    close(h);
end


% Figure 7: Network clamp
    
%     hbb=plot_graphidiv();
%     pos=get(hbb(end),'Position');
%     set(hbb(end),'Position',[pos(1) pos(2) pos(3)*1.3 pos(4)*1.4]);
%     printeps(hbb(end),[disspath strrep(get(hbb(end),'Name'),' ','')]);

% Figure 8: Model performance (or put in other paper?)

ca1_lfp_1x_27_00.optarg='GB';
load([mypath sl 'data' sl 'MyOrganizer.mat'],'machines')
ca1_lfp_1x_27_00.machines=machines;
h=getmemory(ca1_lfp_1x_27_00);
print(h,[disspath 'Memory'],'-depsc')
print(h,[disspath 'Time'],'-depsc')

% Macro variable values
% 
%         fprintf(fid,'\\newcommand{\\SimRun%s}{%s}\n', char(p-1+'A'), subsint(p).desc);
%         fprintf(fid,'\\newcommand{\\SR%sModel}{%s}\n', char(p-1+'A'), subsint(p).model);
%         fprintf(fid,'\\newcommand{\\SR%sCoverage}{%s}\n', char(p-1+'A'), subsint(p).coverage);        
%         fprintf(fid,'\\newcommand{\\SR%sGammaPower}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Gamma.power)/100);
%         fprintf(fid,'\\newcommand{\\SR%sGamma}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Gamma.freq)/100);
%         modegamma=[];
%         for ttm=1:length(myRuns(myridx).Cells)
%             modegamma(ttm) = round(100*myRuns(myridx).Cells(ttm).gamma.freq)/100;
%         end
%         fprintf(fid,'\\newcommand{\\SR%sGammaInrn}{%.2f}\n', char(p-1+'A'), mode(modegamma));
%         fprintf(fid,'\\newcommand{\\SR%sGammaNorm}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Gamma.norm)/100);
%         fprintf(fid,'\\newcommand{\\SR%sTheta}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Theta.freq)/100);
%         fprintf(fid,'\\newcommand{\\SR%sThetaPower}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Theta.power)/100);
%         fprintf(fid,'\\newcommand{\\SR%sThetaNorm}{%.2f}\n', char(p-1+'A'), round(100*myRuns(myridx).Theta.norm)/100); 

ftmp = figure('Color','w','Name','Theta ExpHist','Units','inches','Position',[.1 .1 1.5 6.6],'PaperUnits','inches','PaperPosition',[0 0 1.5 6.6]);
nrninput = gettheta(-2);

a1=subplot('Position',[.05 1-1/10+.01 .9 1/10-.03]);
nrninputmp=nrninput;
for fg=1:length(nrninputmp)
    nrninputmp(fg).name=nrninputmp(fg).tech;
end
h=Phases_Figure(nrninputmp,myRuns(myridx).Theta.freq,gca);

for r=1:length(handles.curses.cells)
    celltype = handles.curses.cells(r).name; %celltypevec{r};
    z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
    if isempty(z)
        continue;
    end
        subplot('Position',[.05 1-(z+1)/10+.05+.01 .72 .03]);
        % subplot('Position',[.05 1-marg-(z+1)/10+(1/10-.05) .72 1/10-.05]);
        axis off
        b(r) = text(0,.45,celltypeNice{z});
        %if p==1
            set(b(r),'Color',colorvec(z,:),'FontWeight','Bold','FontName','ArialMT')
%                 else
%                     set(b(r),'Color','w','FontWeight','Bold','FontName','ArialMT')
%                 end
        subplot('Position',[.95 1-(z+1)/10+.05+.01 .04 .03]);
        % subplot('Position',[.95 1-marg-(z+1)/10+(1/10-.05) .04 1/10-.05]);
        myz=strmatch(celltype,{nrninput.tech},'exact');
        if isempty(myz)
            myz=strmatch('cckcell',{nrninput.name},'exact');
        end
        if isempty(myz)
            b(r) = text(0,.5,[num2str(round(0)) '^o']);
            set(b(r),'HorizontalAlignment','right')
            axis off
            set(b(r),'Color','w','FontWeight','Bold','FontName','ArialMT')
        else
            b(r) = text(0,.5,[num2str(round(nrninput(myz).phase)) '^o']);
            set(b(r),'HorizontalAlignment','right')
            axis off
            set(b(r),'Color',colorvec(z,:),'FontWeight','Bold','FontName','ArialMT')
        end

        subplot('Position',[.05 1-(z+1)/10+.01 .9 .05])
    myim=imread([mypath sl 'KS08' sl celltype(1:end-4) '.bmp']);
    image(myim)
    %axis equal
    axis off
end
printeps(ftmp,[disspath 'ThetaExpHist'])

function plotme(myname, mycolors, myplotvals, mysize,xL,yL,varargin)
global mypath myFontSize disspath

if isempty(varargin)
    myfreqs=[];
    freqstruct=[];
    mytitle='';
    myapp='';
    gy=figure('Color','w','Name',myname,'Units','inches','PaperUnits','inches','Position',[.5 .5 mysize(1)*.8 mysize(2)],'PaperPosition',[0 0 mysize(1)*.8 mysize(2)]);
else
    myfreqs=varargin{1};
    freqstruct=varargin{2};
    mytitle=varargin{3};
    myapp=varargin{4};
    gy=figure('Color','w','Name',myname,'Units','inches','PaperUnits','inches','Position',[.5 .5 mysize(1)*.8 mysize(2)*2.5],'PaperPosition',[0 0 mysize(1)*.8 mysize(2)*2.5]);
    if 1==0 % don't sort again
    [~, sorti]=sort(myfreqs(:,3));
    sorti=[1; sorti(sorti~=1)];
    mycolors=mycolors(sorti,:);
    myplotvals=myplotvals(sorti);
    myfreqs=myfreqs(sorti,:);
    xL=xL(sorti);
    freqstruct=freqstruct(sorti);
    end
end
if ~isempty(myapp)
    for x=1:length(xL)
        xL{x}={xL{x},myapp};
    end
end

N = numel(myplotvals);
if isempty(myfreqs)
    bargraph=subplot('Position',[.2 .2 .75 .7]);
else
    bargraph=subplot('Position',[.2 .2*.8 .75 .2*.8]);
end
for i=1:N
    h(i) = bar(i, myplotvals(i));
    if i == 1, hold on, end
    set(h(i), 'FaceColor', mycolors(i,:),'EdgeColor','none','BarWidth',.8) % get(h(i),'BarWidth')*.7
end   
set(gca, 'XTickLabel', '') 
yy=ylim;
set(gca,'ylim',[0 yy(2)])
ypos = -max(ylim)/10;
gw=text(1:N,repmat(ypos,N,1),xL','horizontalalignment','center','Rotation',0,'FontSize',myFontSize);
formatter(gw)
btmp=ylabel(yL);
btmp2=xlabel(mytitle);
%btmp2 = get(gca,'XLabel');
set(btmp2,'Position',get(btmp2,'Position') - [0 diff(get(gca,'ylim'))/5 0])

formatter(btmp)
formatter(btmp2)
set(btmp,'FontSize',myFontSize)
set(btmp2,'FontSize',myFontSize)
formatter(gca)
try
    set(get(gy,'Children'),'FontSize',myFontSize)
end

if ~isempty(myfreqs)
    xrange=get(bargraph,'XLim');

    thetagraph=subplot('Position',[.2 .37 .75 .45]);
    thetapos=get(thetagraph,'Position');
    set(thetagraph,'XLim',get(bargraph,'XLim'),'YLim',[0 80])
    %set(thetagraph,'XLim',get(bargraph,'XLim'),'YLim',[0 10])
    th=.02*diff(get(thetagraph,'YLim'))*(.2/thetapos(4));
    formatter(ylabel({'Frequency of','Modulation of SDF (Hz)'}),'VerticalAlignment','top')
    %formatter(ylabel('         Theta (Hz)'),'VerticalAlignment','top')
    patch([xrange(1) xrange(2) xrange(2) xrange(1) xrange(1)],[5 5 10 10 5],[.94 .94 .94],'EdgeColor','none')
    hold on
    patch([xrange(1) xrange(2) xrange(2) xrange(1) xrange(1)],[25 25 80 80 25],[.94 .94 .94],'EdgeColor','none')
    for i=1:N
        ht=myfreqs(i,3);
        %ht=myfreqs(i,1);
        st=get(h(i),'XData')-get(h(i),'BarWidth')/2;
        en=get(h(i),'XData')+get(h(i),'BarWidth')/2;
        plot([st en],[ht ht],'Color',mycolors(i,:))
        hold on
        for r=1:length(freqstruct(i).freqs)
            hold on
            plot([get(h(i),'XData')-get(h(i),'BarWidth')/2 get(h(i),'XData')+get(h(i),'BarWidth')/2],[freqstruct(i).freqs(r) freqstruct(i).freqs(r)],'Color',mycolors(i,:),'LineStyle','-.') %mycolors(i,:)
        end
    end

    set(thetagraph, 'XTickLabel', '','XTick',[]) 
    
    formatter(thetagraph)
    set(thetagraph,'XColor','none');
    set(thetagraph,'Layer','top');
    set(thetagraph,'Clipping','Off')
    
    if strcmp(mytitle,'Tonic Excitation Level')==1
        leggraph=subplot('Position',[.2 .85 .75 .1]);
        legpos=get(leggraph,'Position');
        i=1;
        plot([get(h(i),'XData')-get(h(i),'BarWidth')/2 get(h(i),'XData')+get(h(i),'BarWidth')/2],[.85 .85],'Color',mycolors(i,:),'LineStyle','-.')
        text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,.85,'Dominant Frequency of Interneuron SDFs')
        set(leggraph,'XLim',get(bargraph,'XLim'),'YLim',[0 1])
        hold on

        st=get(h(i),'XData')-get(h(i),'BarWidth')/2;
        en=get(h(i),'XData')+get(h(i),'BarWidth')/2;
        th=.02*diff(get(leggraph,'YLim'))*(.2/legpos(4));
        ht=.45;
        plot([st en],[ht ht],'Color',mycolors(i,:))
        text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,.45,'Dominant Frequency of Pyramidal Cell SDF')

        patch([st en en st st],[0 0 .2 .2 0],[.9 .9 .9],'EdgeColor','none')
        text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,.1,'Theta/Gamma Freq. Range')
        axis off
    end
end

printeps(gy,[disspath strrep(get(gy,'Name'),' ','')])
    
function formatter(ax,varargin)
global mypath myFontSize
if isempty(varargin)
    set(ax,'LineWidth',2,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
elseif varargin{1}==0
    set(ax,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
else
    set(ax,'FontName','ArialMT','FontWeight','normal','FontSize',myFontSize)  
end
box off



function myfigs=myotherfigs()
global mypath sl
if exist('myotherfigs.mat','file')
    load('myotherfigs.mat','myfigs')
else
    global  ca1_lfp_1x_27_00 ca1_lfp_1x_28 ca1_lfp_1x_30 ca1_lfp_1x_31 ca1_lfp_1x_32 ca1_lfp_1x_34 ca1_lfp_1x_35 ca1_lfp_1x_27_00_comp ca1_lfp_1x_36
    global  cl1x27_PV_01_long cl1x27_NGF_01_long cl1x27_CCK_01_long cl1x27_OLM_01_long cl1x27_PV_02_long cl1x27_PV_03_long cl1x27_PV_04_long
    global  cl1x27_nopyr_long cl1x27_noolm_long cl1x27_nobis_long cl1x27_noaxo_long cl1x27_nopvb_long cl1x27_nocck_long cl1x27_nosca_long cl1x27_noivy_long cl1x27_nongf_long
    global  Newcl1x27_GABAa_01 Newcl1x27_GABAa_02 Newcl1x27_GABAa_03 Newcl1x27_GABAa_04 Newcl1x27_GABAa_05
    global  Newcl1x27_GABAb_01 Newcl1x27_GABAb_02 Newcl1x27_GABAb_03 Newcl1x27_GABAb_04 Newcl1x27_GABAb_05

    load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')
    load([mypath sl 'myfigs.mat'],'myfigs')
    for k=1:length(myfigs)
        eval(['myresultsstruct = ' myfigs(k).name ';']);
        [h, mygids, myd, myhandles]=lfpposition(myresultsstruct);
        myresultsstruct.curses.epos=myhandles.curses.epos;
        myresultsstruct.curses.cells=myhandles.curses.cells;
        myresultsstruct.general=general;
        myresultsstruct.optarg='pwelch,sdf,type,table';
        [~, tbldata]=plot_spectral(myresultsstruct);
        myfigs(k).tbldata=tbldata;
        myfreq=tbldata{strmatch('Pyr.',tbldata(:,1)),2};

        if myresultsstruct.runinfo.SimDuration>3500
            myresultsstruct.optarg=['table,' num2str(myfreq)];
        else
            myresultsstruct.optarg=['table,abs,' num2str(myfreq)];
        end
        [~, mydata]=plot_phasemod([],myresultsstruct);
        if k>1
            myfigs(k).mydata=rmfield(rmfield(mydata,'activitytimes'),'modactivitytimes');
        else
            myfigs(k).mydata=mydata; %rmfield(rmfield(mydata,'activitytimes'),'modactivitytimes');
        end
        
        disp(['Just finished k=' num2str(k)])
    end
    save('myotherfigs.mat','myfigs','-v7.3')
end


function myfigs=getmyfigs()
global mypath
if exist('myfigs.mat','file')
    load('myfigs.mat','myfigs')
else
    global ca1_lfp_1x_27_00 ca1_lfp_1x_28 ca1_lfp_1x_30 ca1_lfp_1x_31 ca1_lfp_1x_32 ca1_lfp_1x_34 ca1_lfp_1x_35 ca1_lfp_1x_27_00_comp ca1_lfp_1x_36
    global  cl1x27_PV_01_long cl1x27_NGF_01_long cl1x27_CCK_01_long cl1x27_OLM_01_long cl1x27_PV_02_long cl1x27_PV_03_long cl1x27_PV_04_long
    global  cl1x27_nopyr_long cl1x27_noolm_long cl1x27_nobis_long cl1x27_noaxo_long cl1x27_nopvb_long cl1x27_nocck_long cl1x27_nosca_long cl1x27_noivy_long cl1x27_nongf_long
    global  Newcl1x27_GABAa_01 Newcl1x27_GABAa_02 Newcl1x27_GABAa_03 Newcl1x27_GABAa_04 Newcl1x27_GABAa_05
    global  Newcl1x27_GABAb_01 Newcl1x27_GABAb_02 Newcl1x27_GABAb_03 Newcl1x27_GABAb_04 Newcl1x27_GABAb_05
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')


    k=1;
    myfigs(k).name='ca1_lfp_1x_27_00';
    myfigs(k).label='Control';
    myfigs(k).exc=0.65;
    myfigs(k).figs=[1 2];


    k=k+1;
    myfigs(k).name='ca1_lfp_1x_28';
    myfigs(k).label='';
    myfigs(k).exc=0.8;
    myfigs(k).figs=[2];

    k=k+1;
    myfigs(k).name='ca1_lfp_1x_30';
    myfigs(k).label='';
    myfigs(k).exc=1.0;
    myfigs(k).figs=[2];


    k=k+1;
    myfigs(k).name='ca1_lfp_1x_31';
    myfigs(k).label='';
    myfigs(k).exc=1.2;
    myfigs(k).figs=[2];


    k=k+1;
    myfigs(k).name='ca1_lfp_1x_32';
    myfigs(k).label='';
    myfigs(k).exc=1.4;
    myfigs(k).figs=[2];

    k=k+1;
    myfigs(k).name='ca1_lfp_1x_34';
    myfigs(k).label='';
    myfigs(k).exc=.4;
    myfigs(k).figs=[2];

    k=k+1;
    myfigs(k).name='ca1_lfp_1x_35';
    myfigs(k).label='';
    myfigs(k).exc=.5;
    myfigs(k).figs=[2];
    
    k=k+1;
    myfigs(k).name='ca1_lfp_1x_36';
    myfigs(k).label='';
    myfigs(k).exc=.2;
    myfigs(k).figs=[2];
    
%     ca1_lfp_1x_27_00_comp=ca1_lfp_1x_27_00;
%     idx=find(ca1_lfp_1x_27_00_comp.curses.spikerast(:,1)>=600);
%     ca1_lfp_1x_27_00_comp.curses.spikerast(idx,:)=[];

    k=k+1;
    myfigs(k).name='ca1_lfp_1x_27_00_comp';
    myfigs(k).label='Control';
    myfigs(k).exc=.65;
    myfigs(k).figs=[3 4];

    k=k+1;
    myfigs(k).name='cl1x27_PV_01_long';
    myfigs(k).label='PV+ B.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[3 8];
    
    k=k+1;
    myfigs(k).name='cl1x27_PV_02_long';
    myfigs(k).label='Ephys & Incoming Weights';
    myfigs(k).exc=.65;
    myfigs(k).figs=[8];

    k=k+1;
    myfigs(k).name='cl1x27_PV_03_long';
    myfigs(k).label='Ephys & Convergence';
    myfigs(k).exc=.65;
    myfigs(k).figs=[8];

    k=k+1;
    myfigs(k).name='cl1x27_PV_04_long';
    myfigs(k).label='Ephys, Convergence, Divergence';
    myfigs(k).exc=.65;
    myfigs(k).figs=[8];

    k=k+1;
    myfigs(k).name='cl1x27_NGF_01_long';
    myfigs(k).label='NGF.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[3];

    k=k+1;
    myfigs(k).name='cl1x27_CCK_01_long';
    myfigs(k).label='CCK+ B.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[3];

    k=k+1;
    myfigs(k).name='cl1x27_OLM_01_long';
    myfigs(k).label='O-LM';
    myfigs(k).exc=.65;
    myfigs(k).figs=[3];


    k=k+1;
    myfigs(k).name='cl1x27_nopyr_long';
    myfigs(k).label='Pyr.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4 7];

    k=k+1;
    myfigs(k).name='cl1x27_noolm_long';
    myfigs(k).label='O-LM';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_nobis_long';
    myfigs(k).label='Bis.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_noaxo_long';
    myfigs(k).label='Axo.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_nopvb_long';
    myfigs(k).label='PV+ B.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4 7];

    k=k+1;
    myfigs(k).name='cl1x27_nocck_long';
    myfigs(k).label='CCK+ B.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_nosca_long';
    myfigs(k).label='S.C.-A';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_noivy_long';
    myfigs(k).label='Ivy';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='cl1x27_nongf_long';
    myfigs(k).label='NGF.';
    myfigs(k).exc=.65;
    myfigs(k).figs=[4];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAb_01';
    myfigs(k).label='Slower GABAB';
    myfigs(k).exc=.65;
    myfigs(k).figs=[5];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAb_02';
    myfigs(k).label='Fast GABAB';
    myfigs(k).exc=.65;
    myfigs(k).figs=[5];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAb_03';
    myfigs(k).label='Faster GABAB';
    myfigs(k).exc=.65;
    myfigs(k).figs=[5];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAb_04';
    myfigs(k).label='Fastest GABAB';
    myfigs(k).exc=.65;
    myfigs(k).figs=[5];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAb_05';
    myfigs(k).label='Most Fastest GABAB';
    myfigs(k).exc=.65;
    myfigs(k).figs=[5];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAa_01';
    myfigs(k).label='GABAA only';
    myfigs(k).exc=.65;
    myfigs(k).figs=[6];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAa_02';
    myfigs(k).label='GABAA x3';
    myfigs(k).exc=.65;
    myfigs(k).figs=[6];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAa_03';
    myfigs(k).label='GABAA x10';
    myfigs(k).exc=.65;
    myfigs(k).figs=[6];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAa_04';
    myfigs(k).label='GABAA x15';
    myfigs(k).exc=.65;
    myfigs(k).figs=[6];

    k=k+1;
    myfigs(k).name='Newcl1x27_GABAa_05';
    myfigs(k).label='GABAA x30';
    myfigs(k).exc=.65;
    myfigs(k).figs=[6];    


    for k=1:length(myfigs)
        eval(['myresultsstruct = ' myfigs(k).name ';']);
        myresultsstruct.general=general;
        myresultsstruct.optarg='pwelch,sdf,type,table';
        [~, tbldata]=plot_spectral(myresultsstruct);
        myfigs(k).tbldata=tbldata;
        myfreq=tbldata{strmatch('Pyr.',tbldata(:,1)),2};

        if myresultsstruct.runinfo.SimDuration>3500
            myresultsstruct.optarg=['table,' num2str(myfreq)];
        else
            myresultsstruct.optarg=['table,abs,' num2str(myfreq)];
        end
        [~, mydata]=plot_phasemod([],myresultsstruct);
        if k>1
            myfigs(k).mydata=rmfield(rmfield(mydata,'activitytimes'),'modactivitytimes');
        else
            myfigs(k).mydata=mydata; %rmfield(rmfield(mydata,'activitytimes'),'modactivitytimes');
        end
        disp(['Just finished k=' num2str(k)])
    end
    save('myfigs.mat','myfigs','-v7.3')
end



function myfigs=fftmyfigs()
global mypath sl
if exist('fftmyfigs.mat','file')
    load('fftmyfigs.mat','myfigs')
else
    global  ca1_lfp_1x_27_00 ca1_lfp_1x_28 ca1_lfp_1x_30 ca1_lfp_1x_31 ca1_lfp_1x_32 ca1_lfp_1x_34 ca1_lfp_1x_35 ca1_lfp_1x_27_00_comp ca1_lfp_1x_36
    global  cl1x27_PV_01_long cl1x27_NGF_01_long cl1x27_CCK_01_long cl1x27_OLM_01_long cl1x27_PV_02_long cl1x27_PV_03_long cl1x27_PV_04_long
    global  cl1x27_nopyr_long cl1x27_noolm_long cl1x27_nobis_long cl1x27_noaxo_long cl1x27_nopvb_long cl1x27_nocck_long cl1x27_nosca_long cl1x27_noivy_long cl1x27_nongf_long
    global  Newcl1x27_GABAa_01 Newcl1x27_GABAa_02 Newcl1x27_GABAa_03 Newcl1x27_GABAa_04 Newcl1x27_GABAa_05
    global  Newcl1x27_GABAb_01 Newcl1x27_GABAb_02 Newcl1x27_GABAb_03 Newcl1x27_GABAb_04 Newcl1x27_GABAb_05
    load([mypath sl 'data' sl 'MyOrganizer.mat'],'general')
    load([mypath sl 'myfigs.mat'],'myfigs')
    for k=1:length(myfigs)
        eval(['myresultsstruct = ' myfigs(k).name ';']);
        myresultsstruct.general=general;
        myresultsstruct.optarg='fft,sdf,type,table';
        [~, tbldata]=plot_spectral(myresultsstruct);
        myfigs(k).tbldata=tbldata;
        myfreq=tbldata{strmatch('Pyr.',tbldata(:,1)),2};
        disp(['Just finished k=' num2str(k)])
    end
    save([mypath sl 'fftmyfigs.mat'],'myfigs','-v7.3')
end

function myfigs=altmyfigs()
global mypath sl

if exist([mypath sl 'myaltfigs.mat'],'file')
    load([mypath sl 'myaltfigs.mat'],'myfigs')
else
    global  ca1_lfp_1x_27_00 ca1_lfp_1x_28 ca1_lfp_1x_30 ca1_lfp_1x_31 ca1_lfp_1x_32 ca1_lfp_1x_34 ca1_lfp_1x_35 ca1_lfp_1x_27_00_comp ca1_lfp_1x_36
    global  cl1x27_PV_01_long cl1x27_NGF_01_long cl1x27_CCK_01_long cl1x27_OLM_01_long cl1x27_PV_02_long cl1x27_PV_03_long cl1x27_PV_04_long
    global  cl1x27_nopyr_long cl1x27_noolm_long cl1x27_nobis_long cl1x27_noaxo_long cl1x27_nopvb_long cl1x27_nocck_long cl1x27_nosca_long cl1x27_noivy_long cl1x27_nongf_long
    global  Newcl1x27_GABAa_01 Newcl1x27_GABAa_02 Newcl1x27_GABAa_03 Newcl1x27_GABAa_04 Newcl1x27_GABAa_05
    global  Newcl1x27_GABAb_01 Newcl1x27_GABAb_02 Newcl1x27_GABAb_03 Newcl1x27_GABAb_04 Newcl1x27_GABAb_05
    load([mypath sl MyOrganizer.mat'],'general')
    load([mypath sl 'myfigs.mat'],'myfigs')
    for k=1:length(myfigs)
        eval(['myresultsstruct = ' myfigs(k).name ';']);
        myresultsstruct.general=general;
        myresultsstruct.optarg='periodogram,sdf,type,table';
        [~, tbldata]=plot_spectral(myresultsstruct);
        myfigs(k).tbldata=tbldata;
        myfreq=tbldata{strmatch('Pyr.',tbldata(:,1)),2};
        disp(['Just finished k=' num2str(k)])
    end
    save('myaltfigs.mat','myfigs','-v7.3')
end


function h=printExpData(disspath,myresultsstruct)
global mypath colorvec
        ftmp = figure('Color','w','Name','Theta ExpHist','Units','inches','Position',[.1 .1 1.5 6.6],'PaperUnits','inches','PaperPosition',[0 0 1.5 6.6]);
        nrninput = gettheta(-2);
        
        a1=subplot('Position',[.05 1-1/10+.01 .9 1/10-.03]);
        nrninputmp=nrninput;
        for fg=1:length(nrninputmp)
            nrninputmp(fg).name=nrninputmp(fg).tech;
        end
        %h=Phases_Figure(nrninputmp,myRuns(myridx).Theta.freq,gca);
        period = 125;
        Hzval = 8;
        trace.data=0:.025:(period*2);
        trace.data=trace.data';

        excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi
        plot(trace.data,excell,'k','LineWidth',2)
        ylim([-1.1 1.1])
        xlim([0 max(trace.data)])
        set(gca,'XTickLabel',{})
        set(gca,'YTickLabel',{})
        set(gca,'XColor','w')
        set(gca,'YColor','w')
        celltypeNice={'Pyr.','PV+ B.','CCK+ B.','S.C.-A.','Axo.','Bis.','O-LM','Ivy','NGF.'};
        for r=1:length(myresultsstruct.curses.cells)
            celltype = myresultsstruct.curses.cells(r).name; %celltypevec{r};
            z = strmatch(celltype,{'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'});
            if isempty(z)
                continue;
            end
                subplot('Position',[.05 1-(z+1)/10+.05+.01 .72 .03]);
                % subplot('Position',[.05 1-marg-(z+1)/10+(1/10-.05) .72 1/10-.05]);
                axis off
                b(r) = text(0,.45,celltypeNice{z});
                %if p==1
                    set(b(r),'Color',colorvec(z,:),'FontWeight','Bold','FontName','ArialMT')
%                 else
%                     set(b(r),'Color','w','FontWeight','Bold','FontName','ArialMT')
%                 end
                subplot('Position',[.95 1-(z+1)/10+.05+.01 .04 .03]);
                % subplot('Position',[.95 1-marg-(z+1)/10+(1/10-.05) .04 1/10-.05]);
                myz=strmatch(celltype,{nrninput.tech},'exact');
                if isempty(myz)
                    myz=strmatch('cckcell',{nrninput.name},'exact');
                end
                if isempty(myz)
                    b(r) = text(0,.5,[num2str(round(0)) '^o']);
                    set(b(r),'HorizontalAlignment','right')
                    axis off
                    set(b(r),'Color','w','FontWeight','Bold','FontName','ArialMT')
                else
                    b(r) = text(0,.5,[num2str(round(nrninput(myz).phase)) '^o']);
                    set(b(r),'HorizontalAlignment','right')
                    axis off
                    set(b(r),'Color',colorvec(z,:),'FontWeight','Bold','FontName','ArialMT')
                end

                subplot('Position',[.05 1-(z+1)/10+.01 .9 .05])
            myim=imread([mypath sl 'KS08' sl celltype(1:end-4) '.bmp']);
            image(myim)
            %axis equal
            axis off
        end
        tt=MiniPhaseShift_Figure(nrninputmp,8,[]);
        ylim([-1.1-.8*(9-1) 1.1])
        bf = findall(tt,'Type','text');
        for b=1:length(bf)
            set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
        end
        bf = findall(tt,'Type','axis');
        for b=1:length(bf)
            set(bf(b),'FontName','ArialMT','FontWeight','bold','FontSize',14)
        end
        h=[ftmp tt];
        
function makeLaTeXtable(tbldata,headers,myname,shortcap,caption)
    global mypath disspath sl
    fid=fopen([disspath sl '..' sl 'Tables' sl 'Table_' myname '.tex'],'w');
    fprintf(fid,'\\begin{table}[position htb]\n');
    fprintf(fid,'\\centering\n');
    fprintf(fid,'\\begin{tabular}{|l%s|} \n',repmat('r',1,size(tbldata,2)-1));
    fprintf(fid,'\\hline\n');
    myheader=sprintf('\\textbf{%s} & ',headers{:});
    fprintf(fid,'%s \\\\ \n',myheader(1:end-3));
    fprintf(fid,'\\hline\n');
    if strcmp(lower(myname),'phases')
        for r=1:size(tbldata,1)
            fprintf(fid,'%s & %.0f & %.2f & %.0f & %.2f \\\\ \n',tbldata{r,1},tbldata{r,2},tbldata{r,3},tbldata{r,4},tbldata{r,5});
            fprintf(fid,'\\hline\n');
        end
    else
        for r=1:size(tbldata,1)
            myrow=sprintf('%s & ',tbldata{r,2:end});
            fprintf(fid,'%s & %s \\\\ \n',tbldata{r,1},myrow(1:end-3));
            fprintf(fid,'\\hline\n');
        end
    end
    fprintf(fid,'\\end{tabular}\n');
    fprintf(fid,'\\caption[%s]{%s}\n', shortcap, caption);
    fprintf(fid,'\\label{tab:%s}\n',lower(myname));
    fprintf(fid,'\\end{table}\n');
    fclose(fid);
        
        
        