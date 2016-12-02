function mf=perfgraphs(timevec1,timevec2,yL,barformat)
global myFontSize myFontWeight myFontName disspath

memflag=0;
if length(timevec1)<5
    memflag=1;
end

mf=figure('Color','w','Name','ModelTypeTimes','Units','inches','Position',[.5 .5 3 3],'PaperPosition',[0 0 3 3],'PaperSize',[3 3]);
if memflag
    mh=bar([timevec1; timevec2],barformat,'EdgeColor','flat','BarWidth',0.9);
    xlim([.5 2.5])
else
    mh=bar(fliplr([timevec1; timevec2]),barformat,'EdgeColor','flat','BarWidth',0.35);
    xlim([.5 3.5])
    yy=ylim;
    ylim([yy(1) yy(2)*1.05])
end
set(gca,'XTickLabel',{'Full-Scale','Network Clamp'})
ylabel(yL)
activities={'Setup','Cell Creation','Connection','Simulation','Write Results'};
activities=activities(1:length(timevec1));
if memflag
    % legend(mh,activities,'Location','East')
    ColorOrder2=flipud([0 1 0; 1 0 0; 0 1 1; 0 0 1;]);
else
    legend(fliplr(mh),activities,'Location','East')
    ColorOrder2=[1 0 1; 0 1 0; 1 0 0; 0 1 1; 0 0 1;];
end
yy=ylim;
ylim([-50 yy(2)]);
for m=1:length(mh)
    mh(m).BaseLine.BaseValue=-50;
end

colormap(ColorOrder2)
box off
if memflag
    if max(timevec1)>1024
        text(1,max(timevec1),[sprintf('%0.1f',max(timevec1)/1024) ' TB'],'VerticalAlignment','Bottom','HorizontalAlignment','Center')
    else
        text(1,max(timevec1),[sprintf('%0.1f',max(timevec1)) ' GB'],'VerticalAlignment','Bottom','HorizontalAlignment','Center')
    end
    text(2,max(timevec2),[sprintf('%0.1f',max(timevec2)) ' GB'],'VerticalAlignment','Bottom','HorizontalAlignment','Center')
else
    text(1,sum(timevec1),[sprintf('%0.1f',sum(timevec1)/3600) ' hrs'],'VerticalAlignment','Bottom','HorizontalAlignment','Center')
    text(2,sum(timevec2),[sprintf('%0.1f',sum(timevec2)/3600) ' hrs'],'VerticalAlignment','Bottom','HorizontalAlignment','Center')
end

bf = findall(mf,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end