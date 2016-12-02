function h=getperf(StreamlinedData)
global RunArray myFontSize sl colorvec disspath myFontWeight myFontName

oneflag=1;

Runs2Use=[];
mytimesum=[];
myprocs=[];
for r=1:length(StreamlinedData)
    if ~isempty(strfind(StreamlinedData(r).Name,'bench')) && StreamlinedData(r).NumProcessors>2000 && str2num(StreamlinedData(r).Name(end-1:end))<8 %|| ~isempty(strfind(StreamlinedData(r).Comments,'Control')) %~isempty(find(myfigs(r).figs==2))
        Runs2Use=[Runs2Use r];
        mytimesum = [mytimesum sum(StreamlinedData(r).timevec)];
        myprocs = [myprocs StreamlinedData(r).NumProcessors];
    end
end

[~, sorti]=sort(myprocs);
myprocs=myprocs(sorti);
mytimesum=mytimesum(sorti);

% good here to show parallelization worked
h=figure('Color','w','Name','TimeProcs','Units','inches','Position',[.5 .5 2.5 3],'PaperPosition',[0 0 2.5 3],'PaperSize',[2.5 3]);
plot(myprocs,mytimesum,'k.-','MarkerSize',15)
ylabel('Execution Time (seconds)')
xlabel('Processors Used')
box off

bf = findall(gca,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end

h(2)=figure('Color','w','Name','MachineTimes','Units','inches','Position',[.5 .5 4.5 3],'PaperPosition',[0 0 4.5 3],'PaperSize',[4.5 3]);

Runs2Use=[];
mytimes=[];
myprocs={};
for r=1:length(StreamlinedData)
    if ~isempty(strfind(StreamlinedData(r).Name,'bench')) && (StreamlinedData(r).NumProcessors==2048 || StreamlinedData(r).NumProcessors==1728)  %|| ~isempty(strfind(StreamlinedData(r).Comments,'Control')) %~isempty(find(myfigs(r).figs==2))
        Runs2Use=[Runs2Use r];
        mytimes = [mytimes; StreamlinedData(r).timevec];
        mymach='Stampede';
        if StreamlinedData(r).NumProcessors<2000
            mymach='Comet';
        end
        NSGflag='';
        if str2num(StreamlinedData(r).Name(end-1:end))>=8
            NSGflag = '-NSG';
        end
        if oneflag
            myprocs{length(myprocs)+1}={[mymach NSGflag],[ '('  num2str(StreamlinedData(r).NumProcessors) ' Procs)']};
        else
            myprocs{length(myprocs)+1}=[mymach NSGflag ' ('  num2str(StreamlinedData(r).NumProcessors) ' Procs)'];
        end
    end
end

[~, sorti]=sort([StreamlinedData(Runs2Use).NumProcessors]);
mytimes=mytimes(sorti,:);
myprocs=myprocs(sorti);

mh=bar(fliplr(mytimes),'stacked','EdgeColor','flat','BarWidth',0.3);
xlim([.5 length(Runs2Use)+0.5])
yy=ylim;
ylim([yy(1) yy(2)*1.05])


if oneflag
    N=length(myprocs);
    set(gca, 'XTickLabel', {})  
    xlabel(' ')
    ypos = min(get(gca,'ylim'))-diff(get(gca,'ylim'))/15;% -max(ylim)/10;
    text(1:N,repmat(ypos,N,1),myprocs','horizontalalignment','Center','FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
else
    set(gca,'XTickLabel',myprocs)
end
ylabel('Time (s)')
activities={'Setup','Cell Creation','Connection','Simulation','Write Results'};
%legend(fliplr(mh),activities,'Units','normalized','Position',[0.2793    0.6597    0.2685    0.2708])%'Location','East')
ColorOrder2=[1 0 1; 0 1 0; 1 0 0; 0 1 1; 0 0 1;];
% yy=ylim;
% ylim([-50 yy(2)]);
% for m=1:length(mh)
%     mh(m).BaseLine.BaseValue=-50;
% end

colormap(ColorOrder2)
bf = findall(gca,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
box off

for ht=1:length(h)
    setFonts(h(ht)) 
    printeps(h(ht),[disspath get(h(ht),'Name')])
end


function setFonts(tt) 
global myFontWeight myFontName myFontSize

bf = findall(tt,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontWeight',myFontWeight,'FontName',myFontName,'FontSize',myFontSize)
end
bf = findall(tt,'Type','axis');
for b=1:length(bf)
    set(bf(b),'FontWeight',myFontWeight,'FontName',myFontName,'FontSize',myFontSize)
end
bf = findall(tt,'Type','axes');
for b=1:length(bf)
    set(bf(b),'FontWeight',myFontWeight,'FontName',myFontName,'FontSize',myFontSize)
end
