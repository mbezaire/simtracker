function plotme(myname, mycolors, myplotvals, mysize,xL,yL,varargin)
global myFontSize myFontName myFontWeight disspath fid

alg=.5;
sc=.37;
hsc=1.5;
clipin=.5;

if isempty(varargin)
    myfreqs=[];
    freqstruct=[];
    mytitle='';
    myapp='';
    gy=figure('Color','w','Name',myname,'Units','inches','PaperUnits','inches','PaperSize',[alg+mysize(1)*sc mysize(2)],'Position',[.5 .5 alg+mysize(1)*sc mysize(2)],'PaperPosition',[0 0 alg+mysize(1)*sc mysize(2)]);
else
    myfreqs=varargin{1};
    freqstruct=varargin{2};
    mytitle=varargin{3};
    myapp=varargin{4};
    gy=figure('Color','w','Name',myname,'Units','inches','PaperUnits','inches','PaperSize',[alg+mysize(1)*sc mysize(2)*hsc],'Position',[.5 .5 alg+mysize(1)*sc mysize(2)*hsc],'PaperPosition',[0 0 alg+mysize(1)*sc mysize(2)*hsc]);
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

fprintf(fid,'\\multicolumn{3}{|l|}{\\textbf{%s}} \\\\ \n', strrep(strrep(strrep(mytitle,'&','\&'),'#','\#'),'GABA_B','GABA$_B$'));
fprintf(fid,'\\hline\n');

N = numel(myplotvals);
if isempty(myfreqs)
    bargraph=subplot('Position',[alg/(alg+sc*mysize(1)) .14 1-1.1*alg/(alg+sc*mysize(1)) .8]);
else
    bargraph=subplot('Position',[alg/(alg+sc*mysize(1)) 0.1120 1-1.1*alg/(alg+sc*mysize(1)) .35*.8]);
end
for i=1:N
    fprintf(fid,'%s & %.1f & %.1f \\\\ \n', strrep(strrep(strrep(xL{i},'&','\&'),'#','\#'),'GABA_B','GABA$_B$'), myfreqs(i,3), myplotvals(i));
    fprintf(fid,'\\hline\n');        
    h(i) = bar(i, myplotvals(i));
    if i == 1, hold on, end
    set(h(i), 'FaceColor', mycolors(i,:),'EdgeColor','none','BarWidth',.8) % get(h(i),'BarWidth')*.7
end   
set(gca, 'XTickLabel', '') 
yy=ylim;
set(gca,'ylim',[-yy(2)*.05 yy(2)])
for i=1:N
    h(i).BaseLine.BaseValue=-yy(2)*.05;
end
mrr=get(gca,'YTickLabel');
%mystr=length(strfind(num2str(mrr{2}),'0'));
for m=2:length(mrr)
    mystr=length(strfind(num2str(mrr{m}),'0'));
    mrr{m}=[mrr{m}(1:end-mystr) 'e' num2str(mystr)];
    if strcmp(mrr{m},'0')
        m
    end
end
set(gca,'YTickLabel',mrr)
btmp2=xlabel(mytitle);
set(btmp2,'Position',get(btmp2,'Position') - [0 diff(get(gca,'ylim'))/4.7 0])
mm=get(gca,'xlabel');
mp=get(mm,'Position');
set(mm,'Position',[mp(1) mp(2)-.2*mp(2) mp(3)])
ypos = -diff(ylim)/6;% -max(ylim)/10;
rotflag=0;
        hA='center';
for x=1:length(xL)
    if length(xL{x})>4
        ypos = -diff(ylim)/8;% -max(ylim)/10;
        rotflag=25;
        hA='right';
        set(mm,'Position',[mp(1) mp(2)+.4*mp(2) mp(3)])
        set(bargraph,'Position',[alg/(alg+sc*mysize(1)) 0.1120+.04 1-1.1*alg/(alg+sc*mysize(1)) .35*.8-.04]);
    end
end
gw=text(1:N,repmat(ypos,N,1),xL','horizontalalignment',hA,'Rotation',rotflag,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
formatter(gw)
set(gw,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)
btmp=ylabel(yL);
%btmp2 = get(gca,'XLabel');

formatter(btmp)
formatter(btmp2)
set(btmp,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)
set(btmp2,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)
formatter(gca)
try
    set(get(gy,'Children'),'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)
end
% ext=[];
% for i = 1:length(gw)
%   ext(i,:) = get(gw(i),'Extent');
% end
% LowYPoint = min(ext(:,2));
% xll = get(gca,'XLim');
% XMidPoint = xll(1)+abs(diff(xll))/2;
% tl = text(XMidPoint,LowYPoint,'X-Axis Label', ...
%           'VerticalAlignment','top', ...
%           'HorizontalAlignment','right');

if ~isempty(myfreqs)
    xrange=get(bargraph,'XLim');
    set(bargraph,'XLim',[clipin N+clipin]);
    xrange=get(bargraph,'XLim');

    thetagraph=subplot('Position',[alg/(alg+sc*mysize(1)) .43 1-1.1*alg/(alg+sc*mysize(1)) .44]);
    thetapos=get(thetagraph,'Position');
    %set(thetagraph,'XLim',get(bargraph,'XLim'),'YLim',[0 80])
    set(thetagraph,'XLim',get(bargraph,'XLim'),'YLim',[0 25])
    th=.02*diff(get(thetagraph,'YLim'))*(.2/thetapos(4));
    formatter(ylabel('Modul. Freq. of SDF (Hz)'),'VerticalAlignment','top')
    %formatter(ylabel({'Frequency of','Modulation of SDF (Hz)'}),'VerticalAlignment','top')
    set(get(gca,'ylabel'),'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)
    %formatter(ylabel('         Theta (Hz)'),'VerticalAlignment','top')
    patch([xrange(1) xrange(2) xrange(2) xrange(1) xrange(1)],[5 5 10 10 5],[.94 .94 .94],'EdgeColor','none')
    hold on
%     patch([xrange(1) xrange(2) xrange(2) xrange(1) xrange(1)],[25 25 80 80 25],[.94 .94 .94],'EdgeColor','none')
    for i=1:N
        ht=myfreqs(i,3);
        %ht=myfreqs(i,1);
        st=get(h(i),'XData')-get(h(i),'BarWidth')/2;
        en=get(h(i),'XData')+get(h(i),'BarWidth')/2;
        plot([st en],[ht ht],'Color',mycolors(i,:))
        hold on
%         for r=1:length(freqstruct(i).freqs)
%             hold on
%             plot([get(h(i),'XData')-get(h(i),'BarWidth')/2 get(h(i),'XData')+get(h(i),'BarWidth')/2],[freqstruct(i).freqs(r) freqstruct(i).freqs(r)],'Color',mycolors(i,:),'LineStyle','-.') %mycolors(i,:)
%         end
    end

    set(thetagraph, 'XTickLabel', '','XTick',[]) 
    
    formatter(thetagraph)
    try
    set(thetagraph,'XColor','none');
    end
    set(thetagraph,'Layer','top');
    set(thetagraph,'Clipping','Off','FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName)

    if strcmp(myname,'DiffExcLevel')==1 %strcmp(mytitle,'Tonic Excitation Level (Hz)')==1
        leggraph=subplot('Position',[alg/(alg+sc*mysize(1)) .88 1-1.1*alg/(alg+sc*mysize(1)) .12]);
        legpos=get(leggraph,'Position');
        set(leggraph,'XLim',get(bargraph,'XLim'),'YLim',[0 1])
        i=1;
        st=get(h(i),'XData')-get(h(i),'BarWidth')/2;
        en=get(h(i),'XData')+get(h(i),'BarWidth')/2;
        ht=.75; %.8;
        patch([st en en st st],[ht-.1 ht-.1 ht+.1 ht+.1 ht-.1],[.9 .9 .9],'EdgeColor','none')
        gq=text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,ht,'Theta Freq. Range');
        set(gq,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);
        hold on

        ht=ht-.3;%.55;
        plot([st en],[ht ht],'Color',mycolors(i,:))
        bg=text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,ht,'Dominant Freq. of Pyramidal SDF');
        set(bg,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);

%         ht=ht-.3; %.3;
%         plot([st en],[ht ht],'Color',mycolors(i,:),'LineStyle','-.')
%         gw(1)=text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,ht,'Dominant Gamma Freq. of Axo-axonic SDF');
%         % gw(2)=text(get(h(i),'XData')+get(h(i),'BarWidth')/4+.5,ht-.2,'Axo-axonic SDF');
%         set(gw,'FontSize',myFontSize,'FontWeight',myFontWeight,'FontName',myFontName);

        axis off
    elseif strcmp(myname,'DiffCellEphys')==0
        meme=get(gcf,'Children');
        for m=1:length(meme)
            set(meme(m),'Units','inches');
        end
        pp=get(gcf,'Position');
        set(gcf,'Position',[pp(1) pp(2) pp(3) pp(4)*.88],'PaperSize',[pp(3) pp(4)*.88],'PaperPosition',[0 0 pp(3) pp(4)*.88])
        set(get(gca,'XTickLabel'),'Rotation',0,'HorizontalAlignment','Right')
    end
end
bf = findall(gy,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(gy,'Type','axes');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end

printeps(gy,[disspath strrep(get(gy,'Name'),' ','')])


function formatter(ax,varargin)
global myFontSize myFontName myFontWeight
if isempty(varargin)
    set(ax,'LineWidth',1,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)  
elseif varargin{1}==0
    set(ax,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)  
else
    set(ax,'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)  
end
box off