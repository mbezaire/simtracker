function h=Phases_Figure(cells,Hz,a1,varargin)

NiceAbbrev = {'Pyr.','O-LM','Bis.','Axo.','PV+ B.','CCK+ B.','S.C.-A.','Ivy','NGF.'};

% load exp data, only use a subset of it
if Hz<20
    nrninput = gettheta(-1);
else
    nrninput = getgamma(-1);
end

period = 125;
Hzval = 8;
trace.data=0:.025:(period*2);
trace.data=trace.data';

excell = -sin((Hzval*(2*pi))*trace.data(:,1)/1000 + pi/2);  % -13.8/125);  %  - handles.phasepref +   -  (0.25)*Hzval*2*pi

if isempty(a1)
if Hz<20
    h=figure('Color','w','Units','inches','Name','Theta LFP','PaperUnits','inches','PaperPosition',[0 0 8 3]); % ,'FontName','Verdana','FontWeight','Bold','FontSize',16
else
    h=figure('Color','w','Units','inches','Name','Gamma LFP','PaperUnits','inches','PaperPosition',[0 0 8 3]); % ,'FontName','Verdana','FontWeight','Bold','FontSize',16
end
pos = get(h,'Position');
set(h,'Position',[.7 2.3 8 3]);
set(h,'Units','Normalized');

a1=gca;
myflag=0;
else
    axes(a1);
    h=get(a1,'Parent');
    myflag=1;
end

plotstuff(a1,trace.data,excell,Hz);
matchnames.tech = {'pyramidalcell','pvbasketcell','cckcell','scacell','axoaxoniccell','bistratifiedcell','olmcell','ivycell','ngfcell'};
matchnames.nice = {'Pyramidal','PV+ Basket','CCK+ Basket','S.C.-Assoc.','Axo-axonic','Bistratified','O-LM','Ivy','Neurogliaform'};

if myflag==0
    
for n=1:length(cells)
    try
    cells(n).start = cells(n).phase/360*period;
    cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
    cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
    catch
        n
    end

    x = trace.data(cells(n).tidx);
    y = excell(cells(n).tidx);
    
    midx = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
    if ~isempty(midx) & (mod(180+cells(n).phase-nrninput(midx).phase,360)-180)~=0
        axes(a1)
        hold on
        if cells(n).phase<nrninput(midx).phase
            if nrninput(midx).phase-cells(n).phase<180
                arrowDir(n)=1;
                stIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
            else
                arrowDir(n)=-1;
                stIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=cells(n).phase/360*period+period,1,'first');
            end
        else
            if cells(n).phase-nrninput(midx).phase<180
                arrowDir(n)=-1;
                stIDX(n)=find(trace.data>=nrninput(midx).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
           else
                arrowDir(n)=1;
                stIDX(n)=find(trace.data>=cells(n).phase/360*period,1,'first');
                enIDX(n)=find(trace.data>=nrninput(midx).phase/360*period+period,1,'first');
            end
        end
        distIDX(n)=enIDX(n)-stIDX(n);
    end
end

anglelist=[-pi:pi/6:pi]-pi/6
mrklistEN={'v','<','>','^','v','<','^','>','v','<','^','>','v','<'};
mrklistST={'v','<','>','^','v','<','^','>','v','<','^','>','v','<'};

% [~, sortI] = sort(distIDX);
% leveler=zeros(size(trace.data));    
% for ntmp=1:length(distIDX)
%     n = sortI(ntmp);
%     if distIDX(n)==0
%         continue;
%     end
%     colvec = cells(n).color;
%     
%     maxlev=max(leveler(stIDX(n):enIDX(n)))+1;
%     leveler(stIDX(n):enIDX(n))=maxlev;
%     
%     plot(trace.data(stIDX(n):enIDX(n)),excell(stIDX(n):enIDX(n))-.1*maxlev,'LineWidth',1,'Marker','none','Color',colvec);
%     if arrowDir(n)==1
%         x=[trace.data(enIDX(n)-120) trace.data(enIDX(n))];
%         y=[excell(enIDX(n)-120) excell(enIDX(n))]-.1*maxlev;
%         [th, r]=cart2pol((x-x(2))/250,(y-y(2))/2);
%         lidx=find(anglelist<=th(2),1,'first');
%         mrkstr=mrklistEN{lidx};
%          plot(trace.data(enIDX(n)),excell(enIDX(n))-.1*maxlev,'Marker',mrkstr,'MarkerEdgeColor',colvec,'MarkerFaceColor',colvec,'MarkerSize',7);
%     else
%         x=[trace.data(stIDX(n)) trace.data(stIDX(n)+60)];
%         y=[excell(stIDX(n)) excell(stIDX(n)+60)]-.1*maxlev;
%         [th, r]=cart2pol((x-x(1))/250,(y-y(1))/2);
%         lidx=find(anglelist<=th(2),1,'first');
%         mrkstr=mrklistST{lidx};
%         plot(trace.data(stIDX(n)),excell(stIDX(n))-.1*maxlev,'Marker',mrkstr,'MarkerEdgeColor',colvec,'MarkerFaceColor',colvec,'MarkerSize',7);
%     end
% end   
% ylim([min(excell-leveler*.1)-.1   1.1]) 

for n=1:length(nrninput)
    nrninput(n).start = nrninput(n).phase/360*period;
    nrninput(n).tidx(1)=find(trace.data>=nrninput(n).start,1,'first');
    nrninput(n).tidx(2)=find(trace.data>=nrninput(n).start+period,1,'first');

    x = trace.data(nrninput(n).tidx);
    y = excell(nrninput(n).tidx);
    colvec = nrninput(n).color;
    extraflag='';
    if strcmp(nrninput(n).state,'an')==1
        extraflag='*';
    end
    mylabel = [num2str(nrninput(n).phase) '^o ' nrninput(n).name '^{' num2str(nrninput(n).ref) extraflag '}'];
    text_x = trace.data(nrninput(n).tidx(1))+nrninput(n).offset(1);
    text_y = excell(nrninput(n).tidx(1))+nrninput(n).offset(2);
    b(n,1)=rectmark(a1,x(1),y(1),colvec,0,1); % nrninput(n).marker
    b(n,2)=rectmark(a1,x(2),y(2),colvec,0,1); % nrninput(n).marker
end
end

for n=1:length(cells)
    colvec = cells(n).color;
%     if isempty(midx)
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)}];
%     elseif (mod(180+cells(n).phase-nrninput(midx).phase,360)-180)>0
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (+' num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) '^o)'];
%     else
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (' num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) '^o)'];
%     end
    try
    cells(n).start = cells(n).phase/360*period;
    cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
    cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
    catch
        n
    end

    x = trace.data(cells(n).tidx);
    y = excell(cells(n).tidx);
    myidx=strmatch(cells(n).name,{'pyramidalcell','olmcell','bistratifiedcell','axoaxoniccell','pvbasketcell','cckcell','scacell','ivycell','ngfcell'},'exact')
    mylabel=NiceAbbrev{myidx};
    text_x = trace.data(cells(n).tidx(1))+cells(n).offset(1);
    text_y = excell(cells(n).tidx(1))+cells(n).offset(2);
    if myflag==0
        c(n,1)=rectmark(a1,x(1),y(1),colvec,1,1,mylabel,[text_x text_y]); % nrninput(n).marker
        c(n,1)=rectmark(a1,x(1),y(1),colvec,1,2,mylabel,[text_x text_y]); % nrninput(n).marker
        c(n,2)=rectmark(a1,x(2),y(2),colvec,1,1); % nrninput(n).marker
    else
        axes(a1)
        hold on
        plot(x,y,'LineStyle','none','Marker','.','MarkerSize',15,'Color',colvec);
    end
end



% for n=1:length(cells)
%     try
%     cells(n).start = cells(n).phase/360*period;
%     cells(n).tidx(1)=find(trace.data>=cells(n).start,1,'first');
%     cells(n).tidx(2)=find(trace.data>=cells(n).start+period,1,'first');
%     catch
%         n
%     end
% 
%     x = trace.data(cells(n).tidx);
%     y = excell(cells(n).tidx);
%     colvec = cells(n).color;
%     
%     midx = strmatch(matchnames.nice{strmatch(cells(n).name,matchnames.tech)},{nrninput(:).name});
%     if isempty(midx)
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)}];
%     elseif (mod(180+cells(n).phase-nrninput(midx).phase,360)-180)>0
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (+' num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) '^o)'];
%     else
%         mylabel = [sprintf('%.0f',cells(n).phase) '^o ' matchnames.nice{strmatch(cells(n).name,matchnames.tech)} ' (' num2str(round(mod(180+cells(n).phase-nrninput(midx).phase,360)-180)) '^o)'];
%     end
%     text_x = trace.data(cells(n).tidx(1))+cells(n).offset(1);
%     text_y = excell(cells(n).tidx(1))+cells(n).offset(2);
%     tmp(n)=rectmark(a1,x(1),y(1),colvec,1,2,mylabel,[text_x text_y]); % nrninput(n).marker
% end
% uistack(tmp, 'top')

function plotstuff(a1,x,y,Hz)
axes(a1)
plot(x,y,'k','LineWidth',2)
ylim([-1.1 1.1])
xlim([0 max(x)])
%axis off
set(gca,'XTickLabel',{})
set(gca,'YTickLabel',{})
set(gca,'XColor','w')
set(gca,'YColor','w')

hold on



function b=rectmark(a1,x,y,colvec,fillflag,typeflag,varargin)
% scale plot point by axes to get into figure units
xrange = xlim;
yrange = ylim;

% in normalized axis terms:
x_axis = (x-xrange(1))/(xrange(2)-xrange(1));
y_axis = (y-yrange(1))/(yrange(2)-yrange(1));

% in normalized figure terms:
b=get(a1,'Position');
x_figure = x_axis*b(3)+b(1);
y_figure = y_axis*b(4)+b(2);

% center annotation marker over xy point
w = .01; %.006;
h = .03; % w*8;
x_marker = x_figure - w/2;
y_marker = y_figure - h/2;

% width in axes terms
w_axis = w*b(3);

if typeflag==1
    if fillflag
        b=annotation('ellipse',[x_marker y_marker w h]);
        set(b,'Color',colvec,'FaceColor',colvec,'LineWidth',3)
    else
        b=annotation('ellipse',[x_marker-w/4 y_marker-h/4 w*1.5 h*1.5]);
        set(b,'Color',colvec,'FaceColor','none','LineWidth',2)
    end
elseif typeflag==2
    if ~isempty(varargin)
        if length(varargin)>1
            textpos = varargin{2};
            cc=text(textpos(1)+3,textpos(2),varargin{1},'FontName','ArialMT','FontWeight','bold');
            set(cc,'Color',colvec);
            %ce=get(cc,'Extent');
            %c=annotation('line',[x_marker+.01 x_marker+ce(3)/320+.01],[y_marker-.007 y_marker-.007]);
        else
            cc=text(x+w_axis*2+3,y,varargin{1},'FontName','ArialMT','FontWeight','bold');
            set(cc,'Color',colvec);
           %ce=get(cc,'Extent');
            %c=annotation('line',[x_marker+.01 x_marker+ce(3)/320+.01],[y_marker-.007 y_marker-.007]);
        end
        %set(c,'Color',colvec)
    end
    b=cc;
end
