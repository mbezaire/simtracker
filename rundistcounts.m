function h= rundistcounts(colorstruct)
global myFontSize myFontName myFontWeight mypath savepath sl

load distcounts.mat distcounts

precells=fieldnames(distcounts);

if isempty(savepath)
    load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
    q=find([myrepos.current]==1);
    wtmp=strfind(myrepos(q).dir,sl);
    pathway=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end)];
    if exist(pathway,'dir')==0
        mkdir(pathway)
    end
    disspath=pathway;
else
    disspath=[savepath sl];
end

ff=fieldnames(colorstruct);

h=figure('Color','w','Name','AxonDists','Units','inches','Position',[.5 .5 6 6],'PaperPosition',[0 0 6 6],'PaperSize',[6 6]);
for p=1:9 %length(precells)
    posts=fieldnames(distcounts.(precells{p}));
    mysyncount=distcounts.(precells{p}).(posts{1}).syncount;
    tmp=reshape(distcounts.(precells{p}).(posts{1}).syncount(1:500),[10 50]);
    mysyncount = [sum(tmp) distcounts.pyr.pvb.syncount(501)];
    for q=2:length(posts)
        tmp=reshape(distcounts.(precells{p}).(posts{q}).syncount(1:500),[10 50]);
        mysyncount=mysyncount+[sum(tmp) distcounts.(precells{p}).(posts{q}).syncount(501)];
    end
    subplot(3,3,p)
    bar(50+(0:100:5000),mysyncount,'EdgeColor',colorstruct.(ff{strmatch(precells{p},ff)}).color,'FaceColor',colorstruct.(ff{strmatch(precells{p},ff)}).color)
    %hist(mysyncount)
    xlim([0 1000])
    title([upper(ff{strmatch(precells{p},ff)}(1)) ff{strmatch(precells{p},ff)}(2:3) '.'])
    if p>6
        xlabel('Distance from soma (\mum)')
    end
    if mod(p-1,3)==0
        ylabel('# Boutons')
    end
    set(gca,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(h(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(h(1),'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
set(gca,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)

printeps(h,[disspath 'AxonalDists'])
return

for p=1:9 %length(precells)
    posts=fieldnames(distcounts.(precells{p}));
    figure('Color','w','Name',['Boutons from ' precells{p}])
    for q=1:9%length(posts)
        subplot(3,3,q)
        tmp=reshape(distcounts.(precells{p}).(posts{q}).syncount(1:500),[10 50]);
        bar(0:100:5000,[sum(tmp) distcounts.(precells{p}).(posts{q}).syncount(501)])
        title(posts{q})
        xlim([0 1000])
    end
end
