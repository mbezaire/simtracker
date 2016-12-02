
myFontSize=8;
myFontWeight='normal';
myFontName = 'ArialMT';

load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
q=find([myrepos.current]==1);
wtmp=strfind(myrepos(q).dir,sl);
disspath=[myrepos(q).dir(1:wtmp(end)) 'figures' myrepos(q).dir(wtmp(end):end) sl];
if exist(disspath,'dir')==0
    mkdir(disspath)
end


hg=figure('GraphicsSmoothing','off', 'Renderer', 'painters','color','w','Name','GABAIPSC','units','inches','PaperUnits','inches','PaperSize',[3 2.5],'Position',[.5 .5 3 2.5],'PaperPosition',[0 0 3 2.5]);
bgak=gca;
%conds={'ctrl','a','w'};
%xL={'Control','No GABA_B',{'No GABA_B,','Equiv. CT'}};
xLline={'\textsf{Control}','\textsf{No GABA$_\textup{B}$}','\textsf{No GABA$_\textup{B}$, Equiv. CT}'};
%gabacolor={'k','r','g'};

hl=[]; 
load('myGABAabNEW.mat','synfigdata_1390','synfigdata_1396','synfigdata_1431')
hl(3)=plot(synfigdata_1431.fig.axis.data(11).x,synfigdata_1431.fig.axis.data(11).y*1000,'g','LineWidth',1.5); % strong
hold on
hl(1)=plot(synfigdata_1390.fig.axis.data(11).x,synfigdata_1390.fig.axis.data(11).y*1000,'k','LineWidth',1.5); % Control  
%plot(synfigdata_1396.fig.axis.data(11).x,synfigdata_1396.fig.axis.data(11).y*1000-2*(max(synfigdata_1396.fig.axis.data(11).y*1000)-min(synfigdata_1390.fig.axis.data(11).y*1000)),'r') % gabaa
hl(2)=plot(synfigdata_1396.fig.axis.data(11).x,synfigdata_1396.fig.axis.data(11).y*1000,'r','LineWidth',1.5); % gabaa
axis off
mxL=xlim;
myL=ylim;
plot(bgak,[mxL(2)-100 mxL(2)],[myL(2)-.3 myL(2)-.3],'k','LineWidth',2)
plot(bgak,[mxL(2) mxL(2)],[myL(2)-1-.3 myL(2)-.3],'k','LineWidth',2)
bl=legend(hl,xLline);
set(bl,'EdgeColor','w','Interpreter','Latex')

bf = findall(hg(1),'Type','text');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize+1)
end
bf = findall(hg(1),'Type','axes');
for b=1:length(bf)
    set(bf(b),'FontName',myFontName,'FontWeight',myFontWeight,'FontSize',myFontSize+1)
end

printeps(hg,[disspath strrep(get(hg,'Name'),' ','')]);
