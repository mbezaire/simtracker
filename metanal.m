function metanal(StreamlinedData)
global myFontName myFontWeight myFontSize disspath

h(1)=figure('Color','w','Name','Phase x Mod','Units','inches','Position',[.5 .5 2.5 2.8],'PaperPosition',[0 0 2.5 2.8],'PaperSize',[2.5 2.8]);
a1=gca;
hold(a1,'on')
h(2)=figure('Color','w','Name','Phase x Firing','Units','inches','Position',[.5 .5 2.5 2.8],'PaperPosition',[0 0 2.5 2.8],'PaperSize',[2.5 2.8]);
a2=gca;
hold(a2,'on')
h(3)=figure('Color','w','Name','Firing x Mod','Units','inches','Position',[.5 .5 2.5 2.8],'PaperPosition',[0 0 2.5 2.8],'PaperSize',[2.5 2.8]);
a3=gca;
hold(a3,'on')

FiringRates=[];
Phases=[];
Mods=[];
Ps=[];
for r=1:9
    FiringRates(r)=StreamlinedData(1).mydata(r).numactivities/StreamlinedData(1).mydata(r).numcells/4;
    Phases(r)=mod(StreamlinedData(1).All.Mod(r).Phase-100,360)+100;%StreamlinedData(1).All.Mod(r).Phase;
    Mods(r)=StreamlinedData(1).All.Mod(r).Mod;
    Ps(r)=StreamlinedData(1).All.Mod(r).Pval;
    
    plot(a1,Phases(r),Mods(r),'Color',StreamlinedData(1).mydata(r).color,'LineStyle','none','Marker','o','MarkerSize',7,'LineWidth',2)    
    plot(a2,Phases(r),FiringRates(r),'Color',StreamlinedData(1).mydata(r).color,'LineStyle','none','Marker','o','MarkerSize',7,'LineWidth',2)
    plot(a3,FiringRates(r),Mods(r),'Color',StreamlinedData(1).mydata(r).color,'LineStyle','none','Marker','o','MarkerSize',7,'LineWidth',2) 
end
xlabel(a1,'Preferred Firing Phase (^o)')
ylabel(a1,'Modulation')
xlabel(a2,'Preferred Firing Phase (^o)')
ylabel(a2,'Firing Rate (Hz)')
xlabel(a3,'Firing Rate (Hz)')
ylabel(a3,'Modulation')

p1 = polyfit(Phases,Mods,1);
p2 = polyfit(Phases,FiringRates,1);
p3 = polyfit(FiringRates,Mods,1);

yfit1 = polyval(p1,Phases);
yfit2 = polyval(p2,Phases);
yfit3 = polyval(p3,FiringRates);

yresid1 = Mods - yfit1;
yresid2 = FiringRates - yfit2;
yresid3 = Mods - yfit3;

SSresid1 = sum(yresid1.^2);
SSresid2 = sum(yresid2.^2);
SSresid3 = sum(yresid3.^2);

SStotal1 = (length(Mods)-1) * var(Mods);
SStotal2 = (length(FiringRates)-1) * var(FiringRates);
SStotal3 = (length(Mods)-1) * var(Mods);

rsq1 = 1 - SSresid1/SStotal1;
rsq2 = 1 - SSresid2/SStotal2;
rsq3 = 1 - SSresid3/SStotal3;

plot(a1,Phases,yfit1,'k-')
text(mean(get(a1,'xlim')),mean(get(a1,'ylim'))*1.2,sprintf('r^2 = %0.2f',rsq1),'Parent',a1)

plot(a2,Phases,yfit2,'k-')
text(mean(get(a2,'xlim')),mean(get(a2,'ylim'))*1.2,sprintf('r^2 = %0.2f',rsq2),'Parent',a2)

plot(a3,FiringRates,yfit3,'k-')
text(mean(get(a3,'xlim')),mean(get(a3,'ylim'))*1.2,sprintf('r^2 = %0.2f',rsq3),'Parent',a3)


for t=1:length(h)
bf = findall(h(t),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
printeps(h(t),[disspath strrep(get(h(t),'Name'),' ','')])
end

