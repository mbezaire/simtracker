function plotmebaronly(myname, mycolors, myplotvals, mysize,xL,yL,varargin)
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
% if isempty(myfreqs)
%     bargraph=subplot('Position',[alg/(alg+sc*mysize(1)) .14 1-1.1*alg/(alg+sc*mysize(1)) .8]);
% else
    bargraph=subplot('Position',[alg/(alg+sc*mysize(1)) 0.1120+.1 1-1.1*alg/(alg+sc*mysize(1)) .7]);
% end
for i=1:N
    fprintf(fid,'%s & %.1f & %.1f \\\\ \n', strrep(strrep(strrep(xL{i},'&','\&'),'#','\#'),'GABA_B','GABA$_B$'), myfreqs(i,3), myplotvals(i));
    fprintf(fid,'\\hline\n');        
    h(i) = bar(i, myplotvals(i));
    if i == 1, hold on, end
    set(h(i), 'FaceColor', mycolors(i,:),'EdgeColor','none','BarWidth',.8) % get(h(i),'BarWidth')*.7
end   
set(gca, 'XTickLabel', '') 
yy=ylim;
set(gca,'ylim',[-yy(2)*.02 yy(2)])
for i=1:N
    h(i).BaseLine.BaseValue=-yy(2)*.02;
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
%set(gca,'YTickLabel',mrr)
set(gca,'YTickLabelMode','auto')
btmp2=xlabel(mytitle);
%set(btmp2,'Position',get(btmp2,'Position')- [0 diff(get(gca,'ylim'))/20 0])
set(btmp2,'Position',get(btmp2,'Position')- [0 diff(get(gca,'ylim'))/10 0])
mm=get(gca,'xlabel');
 mp=get(mm,'Position');
% set(mm,'Position',[mp(1) mp(2)-.2*mp(2) mp(3)])
ypos = -diff(ylim)/13;% -max(ylim)/10;
rotflag=0;
        hA='center';
for x=1:length(xL)
    if length(xL{x})>4
        ypos = -diff(ylim)/16;% -max(ylim)/10;
        rotflag=25;
        hA='right';
        set(mm,'Position',[mp(1) mp(2)+.6*mp(2) mp(3)])
        set(bargraph,'Position',[alg/(alg+sc*mysize(1)) 0.1120+.04+.1 1-1.1*alg/(alg+sc*mysize(1)) .7-.04]);
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

bf = findall(gy,'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end
bf = findall(gy,'Type','axes');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize)
end

printeps(gy,[disspath strrep(get(gy,'Name'),' ','') 'BarOnly'])


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